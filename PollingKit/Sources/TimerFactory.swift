//
//  TimerFactory.swift
//  PollingKit
//
//  Created by lwuerzburger on 25.02.22.
//  Copyright © 2022 Lukas Würzburger. All rights reserved.
//

import Foundation

protocol TimerFactoryType {
    func timer(interval: TimeInterval, repeats: Bool, block: @escaping (Timer) -> Void) -> TimerType
}

final class TimerFactory: TimerFactoryType {

    // MARK: - TimerFactoryType

    func timer(interval: TimeInterval, repeats: Bool, block: @escaping (Timer) -> Void) -> TimerType {
        Timer.scheduledTimer(withTimeInterval: interval, repeats: repeats, block: block)
    }
}
