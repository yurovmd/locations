//
//  LocationsListRouterTests.swift
//  LocationsListTests
//
//  Created by MAKSIM YUROV on 30/07/2024.
//

import Foundation
@testable import LocationsList
import CustomLocation
import XCTest

final class LocationsListRouterTests: XCTestCase {
    func testRouteToCustomCoordinatesScreen() {
        let router = LocationsListRouterImpl()
        let vc = MockUIViewControllerProtocol()
        let expectation = expectation(description: #function)
        vc.onPresentCalled = { viewController in
            if viewController is CustomCoordinatesViewController {
                expectation.fulfill()
            }
        }
        router.presentingController = vc
        let delegate = MockCustomCoordinatesViewControllerDelegate()
        router.route(to: .customCoordinatesScreen(delegate: delegate))
        wait(for: [expectation])
    }
}

final class MockCustomCoordinatesViewControllerDelegate: CustomCoordinatesViewControllerDelegate {
    func routeButtonTapped(latitude: Double, longitude: Double) {
        //NO-OP
    }
}
