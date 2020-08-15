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

    public var interval: TimeInterval
    public var isRunning: Bool {
        state.isRunning
    }

    // MARK: - Initializer

    public init(interval: TimeInterval = 5, handler: @escaping (@escaping () -> Void) -> Void) {
        self.interval = interval
        self.handler = handler
    }

    // MARK: - Engine

    public func start() {
        startTimerIfNecessary()
        fireHandler()
    }

    public func stop() {
        stopTimer()
        lastTimerTicked = nil
        state = .idle
    }

    func startTimerIfNecessary() {
        guard timer == nil else { return }
        timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { [weak self] _ in
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
        if state.isWaitingForHandlerCallingBack {
            state = .waitingWithInactiveTimerForHandlerCallingBack
        }
    }

    func fireHandler() {
        state = .waitingWithActiveTimerForHandlerCallingBack
        handler() { [weak self] in
            self?.handleHandlerDidCallBack()
        }
    }

    func handleHandlerDidCallBack() {
        guard state != .idle else { return }
        if state == .waitingWithInactiveTimerForHandlerCallingBack {
            start()
        } else {
            state = .waitingForTimerTick
        }
    }
}

// MARK: - 

extension PollingController {

    enum State {
        case idle
        case waitingWithActiveTimerForHandlerCallingBack
        case waitingWithInactiveTimerForHandlerCallingBack
        case waitingForTimerTick
    }
}

extension PollingController.State {

    var canFireHandler: Bool {
        return [.idle, .waitingForTimerTick].contains(self)
    }

    var isRunning: Bool {
        return self != .idle
    }

    var isWaitingForHandlerCallingBack: Bool {
        return [.waitingWithActiveTimerForHandlerCallingBack, .waitingWithInactiveTimerForHandlerCallingBack].contains(self)
    }
}
