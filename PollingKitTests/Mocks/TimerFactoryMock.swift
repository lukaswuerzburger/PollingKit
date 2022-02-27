//
//  TimerFactoryMock.swift
//  PollingKitTests
//
//  Created by lwuerzburger on 25.02.22.
//  Copyright © 2022 Lukas Würzburger. All rights reserved.
//

@testable import PollingKit

class TimerFactoryMock: TimerFactoryType {

    enum Call: Equatable {
        case timer(interval: TimeInterval, repeats: Bool)
    }

    var calls: [Call] = []

    var timerReturnValue: TimerType = TimerMock()
    func timer(interval: TimeInterval, repeats: Bool, block: @escaping (TimerType) -> Void) -> TimerType {
        calls.append(.timer(interval: interval, repeats: repeats))
        return timerReturnValue
    }
}
