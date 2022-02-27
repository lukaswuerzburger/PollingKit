//
//  DateFactoryMock.swift
//  PollingKitTests
//
//  Created by lwuerzburger on 25.02.22.
//  Copyright © 2022 Lukas Würzburger. All rights reserved.
//

@testable import PollingKit

class DateFactoryMock: DateFactoryType {

    enum Call: Equatable {
        case now
    }

    var calls: [Call] = []

    var nowReturnValue: Date = Date()
    func now() -> Date {
        nowReturnValue
    }
}
