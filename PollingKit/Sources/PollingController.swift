//
//  PollingController.swift
//  PollingKit
//
//  Created by Lukas Würzburger on 8/13/20.
//  Copyright © 2020 Lukas Würzburger. All rights reserved.
//

import Foundation

public protocol PollingControllerDelegate: AnyObject {
    func pollingController(_ pollingController: PollingController, didChangeState state: PollingState)
}

final public class PollingController {

    // MARK: - Dependencies

    internal var timerFactory: TimerFactoryType = TimerFactory()
    internal var dateFactory: DateFactoryType = DateFactory()

    // MARK: - Variables

    internal var timer: TimerType?
    internal var lastTimerTicked: Date?
    internal var handler: (@escaping () -> Void) -> Void

    /// A delegate object to communicate state changes to.
    public weak var delegate: PollingControllerDelegate?

    /// The current state of the mechanics, covering waiting for callbacks and timer state.
    public private(set) var state: PollingState = .idle {
        didSet {
            delegate?.pollingController(self, didChangeState: state)
        }
    }

    /// The preferred interval for the timer to invoke the handler. Due to possible belated
    /// callback of the handler, which is controlled by the user, it cannot be ensured that
    /// the timer ticks according to the interval.
    public private(set) var preferredInterval: TimeInterval

    /// Indicates wether the polling is running. Use `state` for a more detailed state.
    public var isRunning: Bool {
        return state.isRunning
    }

    // MARK: - Initializer

    /**
     * Initializes the polling with a preferred interval for timing the periodical
     * invocation of the handler.
     *
     * - Parameter preferredInterval: The interval for invoking the handler
     *
     * - Parameter handler: The block being called in intervals timed by `preferredInterval`
     */
    public init(preferredInterval: TimeInterval = 5, handler: @escaping (@escaping () -> Void) -> Void) {
        self.preferredInterval = preferredInterval
        self.handler = handler
    }

    // MARK: - Engine

    /**
     * Invokes the handler and starts a timer with the interval provided by the `interval`
     * property.
     */
    public func start() {
        startTimerIfNecessary()
        fireHandler()
    }

    /**
     * Stops the timer and prevents the handler's callback to be recognized.
     */
    public func stop() {
        stopTimer()
        lastTimerTicked = nil
        state = .idle
    }

    func startTimerIfNecessary() {
        guard timer == nil else { return }
        timer = timerFactory.timer(interval: preferredInterval, repeats: true) { [weak self] _ in
            self?.handleTimerTick()
        }
        state = .waitingForTimerTick
    }

    func stopTimer() {
        timer?.invalidate()
        timer = nil
    }

    func handleTimerTick() {
        lastTimerTicked = Date()
        if state.canFireHandler {
            fireHandler()
        } else {
            stopTimer()
            updateStateAfterTimerHasStopped()
        }
    }

    func updateStateAfterTimerHasStopped() {
        if state == .runningWithTimer {
            state = .runningWithoutTimer
        }
    }

    func fireHandler() {
        state = .runningWithTimer
        handler { [weak self] in
            self?.handleHandlerDidCallBack()
        }
    }

    func handleHandlerDidCallBack() {
        switch state {
        case .runningWithTimer:
            state = .waitingForTimerTick
        case .runningWithoutTimer:
            start()
        default:
            break
        }
    }
}

// MARK: -

private extension PollingState {

    var canFireHandler: Bool {
        switch self {
        case .idle, .waitingForTimerTick:
            return true
        default:
            return false
        }
    }

    var isRunning: Bool {
        return self != .idle
    }
}
