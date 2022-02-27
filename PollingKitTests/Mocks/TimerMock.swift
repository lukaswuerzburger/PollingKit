//
//  TimerMock.swift
//  PollingKitTests
//
//  Created by Lukas Würzburger on 2/27/22.
//  Copyright © 2022 Lukas Würzburger. All rights reserved.
//

import Foundation
@testable import PollingKit

class TimerMock: TimerType {

    enum Call: Equatable {
        case invalidate
        case scheduledTimer(interval: TimeInterval, repeats: Bool)
    }

    var calls: [Call] = []

    var fireDate: Date = Date()

    func invalidate() {
        calls.append(.invalidate)
    }

    var scheduledTimerBlocks: [(TimerType) -> Void] = []
    var scheduledTimerReturnValue: TimerType = Timer()
    func scheduledTimer(withTimeInterval interval: TimeInterval, repeats: Bool, block: @escaping (TimerType) -> Void) -> TimerType {
        calls.append(.scheduledTimer(interval: interval, repeats: repeats))
        scheduledTimerBlocks.append(block)
        return scheduledTimerReturnValue
    }
}
