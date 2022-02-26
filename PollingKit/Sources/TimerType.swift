//
//  TimerType.swift
//  PollingKit
//
//  Created by lwuerzburger on 25.02.22.
//  Copyright © 2022 Lukas Würzburger. All rights reserved.
//

import Foundation

protocol TimerType {
    // swiftlint:disable:next line_length
    static func scheduledTimer(withTimeInterval interval: TimeInterval, repeats: Bool, block: @escaping (Timer) -> Void) -> Timer
    func invalidate()
    var fireDate: Date { get }
}

extension Timer: TimerType {}
