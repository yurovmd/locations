//
//  LocationsServiceImplTests.swift
//  LocationsCoreTests
//
//  Created by MAKSIM YUROV on 27/05/2024.
//

import Foundation
import Combine
@testable import LocationsCore
import LocationsCoreModels
import XCTest

final class LocationsServiceImplTests: XCTestCase {
    // MARK: - Properties
    
    var cancellables: Set<AnyCancellable>!
    var mockAPIGateway: MockAPIGateway!
    var locationsService: LocationsServiceImpl!
    
    // MARK: - Lifecycle
    
    override func setUp() {
        super.setUp()
        cancellables = []
        mockAPIGateway = MockAPIGateway()
        locationsService = LocationsServiceImpl(apiGateway: mockAPIGateway)
    }
    
    override func tearDown() {
        cancellables = nil
        mockAPIGateway = nil
        locationsService = nil
        super.tearDown()
    }
    
    // MARK: - Tests
    
    func testFetchLocationsSuccess() throws {
        let locations = [
            Location(name: "Location 1", lat: 52.370216, long: 4.895168),
            Location(name: "Location 2", lat: 48.856614, long: 2.352222)
        ]
        let fetchLocationsResponse = FetchLocationsResponse(locations: locations)
        let data = try XCTUnwrap(JSONEncoder().encode(fetchLocationsResponse))
        mockAPIGateway.result = .success(data)
        let expectation = self.expectation(description: "fetchLocations completes")
        var receivedLocations: [Location]?
        var receivedError: Error?
        locationsService.fetchLocations()
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    receivedError = error
                }
                expectation.fulfill()
            }, receiveValue: { locations in
                receivedLocations = locations
            })
            .store(in: &cancellables)
        waitForExpectations(timeout: 1, handler: nil)
        XCTAssertNotNil(receivedLocations)
        XCTAssertNil(receivedError)
        XCTAssertEqual(receivedLocations, locations)
    }
    
    func testFetchLocationsFailure() {
        let error = URLError(.notConnectedToInternet)
        mockAPIGateway.result = .failure(error)
        let expectation = self.expectation(description: "fetchLocations completes")
        var receivedLocations: [Location]?
        var receivedError: Error?
        locationsService.fetchLocations()
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    receivedError = error
                }
                expectation.fulfill()
            }, receiveValue: { locations in
                receivedLocations = locations
            })
            .store(in: &cancellables)
        waitForExpectations(timeout: 1, handler: nil)
        XCTAssertNil(receivedLocations)
        XCTAssertNotNil(receivedError)
        XCTAssertEqual((receivedError as? URLError)?.code, error.code)
    }
}
