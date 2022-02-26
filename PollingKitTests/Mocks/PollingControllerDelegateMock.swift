//
//  PollingControllerDelegateMock.swift
//  PollingKitTests
//
//  Created by lwuerzburger on 25.02.22.
//  Copyright © 2022 Lukas Würzburger. All rights reserved.
//

@testable import PollingKit

class PollingControllerDelegateMock: PollingControllerDelegate {

    // MARK: - Variables

    var stateChangeHistory: [PollingState] = []

    // MARK: - Polling Controller Delegate

    func pollingController(_ pollingController: PollingController, didChangeState state: PollingState) {
        stateChangeHistory.append(state)
    }
}
