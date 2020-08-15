//
//  PollingController.swift
//  PollingController
//
//  Created by Lukas Würzburger on 8/13/20.
//  Copyright © 2020 Lukas Würzburger. All rights reserved.
//

import Foundation

public class PollingController {

    // MARK: - Variables

    var timer: Timer?
    var lastTimerTicked: Date?
    var handler: (@escaping () -> Void) -> Void
    var state: State = .idle

    /// The preferred interval for the timer to invoke the handler. Due to possible belated
    /// callback of the handler, which is controlled by the user, it cannot be ensured that
    /// the timer ticks according to the interval.
    public var preferredInterval: TimeInterval

    /// Indicates wether the polling is running.
    public var isRunning: Bool {
        state.isRunning
    }

    // MARK: - Initializer

    /**
     * Initializes the polling with a preferred interval for timing the invocation of the handler.
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
     * Invokes the handler and starts a timer with the interval provided by the `interval` property.
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
        timer = Timer.scheduledTimer(withTimeInterval: preferredInterval, repeats: true) { [weak self] _ in
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
        if state.isWaitingForHandlerToCallBack {
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
        guard state != .idle else { return }
        if state == .runningWithoutTimer {
            start()
        } else {
            state = .waitingForTimerTick
        }
    }
}

// MARK: - 

extension PollingController {

    enum State {

        /// Polling has not been started or it has been stopped.
        case idle

        /// Waiting for the handler to invoke the callback.
        case runningWithTimer

        /// Waiting for the handler to invoke the callback and the timer has exeeded its interval time.
        case runningWithoutTimer

        /// Handler did invoke the callback and still waiting for the timer to tick.
        case waitingForTimerTick
    }
}

extension PollingController.State {

    var canFireHandler: Bool {
        return [
            .idle,
            .waitingForTimerTick
        ].contains(self)
    }

    var isRunning: Bool {
        return self != .idle
    }

    var isWaitingForHandlerToCallBack: Bool {
        return [
            .runningWithTimer,
            .runningWithoutTimer
        ].contains(self)
    }
}
