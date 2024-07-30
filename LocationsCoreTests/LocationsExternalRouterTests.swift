//
//  LocationsExternalRouterTests.swift
//  LocationsCoreTests
//
//  Created by MAKSIM YUROV on 30/07/2024.
//

import Foundation
import LocationsCoreModels
@testable import LocationsCore
import XCTest

final class LocationsExternalRouterTests: XCTestCase {
    func testRouteToLocation() {
        let mockApplication = MockUIApplication()
        let router = LocationsExternalRouterImpl(application: mockApplication)
        let location = Location(name: "Test Location", lat: 37.7749, long: -122.4194) // Example coordinates
        router.route(to: location)
        XCTAssertTrue(mockApplication.openCalled, "The open method should be called")
        XCTAssertEqual(
            mockApplication.openedURL?.absoluteString,
            "wikipedia://location?latitude=37.7749&longitude=-122.4194",
            "The URL should be correctly formatted"
        )
    }
    
    func testRouteToInvalidLocation() {
        let mockApplication = MockUIApplication()
        let router = LocationsExternalRouterImpl(application: mockApplication)
        let invalidLocation = Location(name: "Invalid Location", lat: 0.0, long: 0.0) // Coordinates that might be considered invalid
        router.route(to: invalidLocation)
        XCTAssertTrue(mockApplication.openCalled, "The open method should be called")
        XCTAssertEqual(
            mockApplication.openedURL?.absoluteString,
            "wikipedia://location?latitude=0.0&longitude=0.0",
            "The URL should be correctly formatted for invalid location"
        )
    }
    
    func testRouteToLocationWithNilName() {
        let mockApplication = MockUIApplication()
        let router = LocationsExternalRouterImpl(application: mockApplication)
        let location = Location(name: nil, lat: 48.8566, long: 2.3522) // Example coordinates for Paris
        router.route(to: location)
        XCTAssertTrue(mockApplication.openCalled, "The open method should be called")
        XCTAssertEqual(
            mockApplication.openedURL?.absoluteString,
            "wikipedia://location?latitude=48.8566&longitude=2.3522",
            "The URL should be correctly formatted even if the name is nil"
        )
    }
}

final class MockUIApplication: UIApplicationProtocol {
    var openCalled = false
    var openedURL: URL?
    
    func open(
        _ url: URL,
        options: [UIApplication.OpenExternalURLOptionsKey : Any],
        completionHandler completion: ((Bool) -> Void)?
    ) {
        openCalled = true
        openedURL = url
        completion?(true)
    }
}
