//
//  LocationsRepositoryImplTests.swift
//  LocationsCoreTests
//
//  Created by MAKSIM YUROV on 27/05/2024.
//

import Combine
import Foundation
@testable import LocationsCore
import LocationsCoreModels
import XCTest

final class LocationsRepositoryImplTests: XCTestCase {
    // MARK: - Properties
    
    private var cancellables: Set<AnyCancellable>!
    private var mockLocationsService: MockLocationsService!
    private var mockLocationsStorage: MockLocationsStorage!
    private var locationsRepository: LocationsRepositoryImpl!
    
    // MARK: - Lifecycle
    
    override func setUp() {
        super.setUp()
        cancellables = []
        mockLocationsService = MockLocationsService()
        mockLocationsStorage = MockLocationsStorage()
        locationsRepository = LocationsRepositoryImpl(
            locationsService: mockLocationsService,
            locationsStorage: mockLocationsStorage
        )
    }
    
    override func tearDown() {
        cancellables = nil
        mockLocationsService = nil
        mockLocationsStorage = nil
        locationsRepository = nil
        super.tearDown()
    }
    
    // MARK: - Tests
    
    func testFetchLocationsWithCache() {
        let cachedLocations = [
            Location(name: "Cached Location 1", lat: 52.370216, long: 4.895168),
            Location(name: "Cached Location 2", lat: 48.856614, long: 2.352222)
        ]
        mockLocationsStorage.storedLocations = cachedLocations
        let fetchedLocations = [
            Location(name: "Fetched Location 1", lat: 37.774929, long: -122.419416),
            Location(name: "Fetched Location 2", lat: 34.052235, long: -118.243683)
        ]
        mockLocationsService.result = .success(fetchedLocations)
        let expectation = expectation(description: "fetchLocations completes")
        var receivedLocations: [[Location]] = []
        var receivedError: Error?
        locationsRepository.fetchLocations(policy: .cachedDataFirst)
            .sink(receiveCompletion: { completion in
                if case let .failure(error) = completion {
                    receivedError = error
                }
                expectation.fulfill()
            }, receiveValue: { locations in
                receivedLocations.append(locations)
            })
            .store(in: &cancellables)
        waitForExpectations(timeout: 1, handler: nil)
        XCTAssertEqual(receivedLocations.count, 2)
        XCTAssertEqual(receivedLocations[0], cachedLocations)
        XCTAssertEqual(receivedLocations[1], fetchedLocations)
        XCTAssertNil(receivedError)
    }
    
    func testFetchLocationsNoCache() {
        let fetchedLocations = [
            Location(name: "Fetched Location 1", lat: 37.774929, long: -122.419416),
            Location(name: "Fetched Location 2", lat: 34.052235, long: -118.243683)
        ]
        mockLocationsService.result = .success(fetchedLocations)
        let expectation = expectation(description: "fetchLocations completes")
        var receivedLocations: [Location]?
        var receivedError: Error?
        locationsRepository.fetchLocations(policy: .cachedDataFirst)
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
        XCTAssertEqual(receivedLocations, fetchedLocations)
        XCTAssertNil(receivedError)
    }
    
    func testFetchLocationsNetworkFailure() {
        let cachedLocations = [
            Location(name: "Cached Location 1", lat: 52.370216, long: 4.895168),
            Location(name: "Cached Location 2", lat: 48.856614, long: 2.352222)
        ]
        mockLocationsStorage.storedLocations = cachedLocations
        let error = URLError(.notConnectedToInternet)
        mockLocationsService.result = .failure(error)
        let expectation = expectation(description: "fetchLocations completes")
        var receivedLocations: [Location]?
        var receivedError: Error?
        locationsRepository.fetchLocations(policy: .ignoreCachedData)
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
    }
}
