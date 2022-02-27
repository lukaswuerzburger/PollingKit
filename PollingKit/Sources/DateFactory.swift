//
//  DateFactory.swift
//  PollingKit
//
//  Created by lwuerzburger on 25.02.22.
//  Copyright © 2022 Lukas Würzburger. All rights reserved.
//

import Foundation

protocol DateFactoryType {
    func now() -> Date
}

final class DateFactory: DateFactoryType {

    // MARK: - DateFactoryType

    func now() -> Date {
        Date()
    }
}
