//
//  PollingState.swift
//  PollingKit
//
//  Created by lwuerzburger on 25.02.22.
//  Copyright © 2022 Lukas Würzburger. All rights reserved.
//

import Foundation

public enum PollingState {

    /// Polling has not been started or it has been stopped.
    case idle

    /// Waiting for the handler to invoke the callback.
    case runningWithTimer

    /// Waiting for the handler to invoke the callback and the timer has exeeded its
    /// interval time.
    case runningWithoutTimer

    /// Handler did invoke the callback and still waiting for the timer to tick.
    case waitingForTimerTick
}
