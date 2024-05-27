//
//  UserDefaultsLocationsStorageTests.swift
//  LocationsCoreTests
//
//  Created by MAKSIM YUROV on 27/05/2024.
//

import Foundation
@testable import LocationsCore
import LocationsCoreModels
import XCTest

final class UserDefaultsLocationsStorageTests: XCTestCase {
    // MARK: - Properties
    
    private var mockUserDefaults: MockUserDefaults!
    private var storage: UserDefaultsLocationsStorage!
    
    // MARK: - Lifecycle
    
    override func setUp() {
        super.setUp()
        mockUserDefaults = MockUserDefaults()
        storage = UserDefaultsLocationsStorage(userDefaults: mockUserDefaults)
    }
    
    override func tearDown() {
        mockUserDefaults = nil
        storage = nil
        super.tearDown()
    }
    
    // MARK: - Tests
    
    func testFetchLocations_WhenNoData_ReturnsEmptyArray() {
        let locations = storage.fetchLocations()
        XCTAssertTrue(locations.isEmpty, "Expected empty array when no data is present")
    }
    
    func testFetchLocations_WhenDataIsPresent_ReturnsLocations() throws {
        let location = Location(name: "Test Location", lat: 1.0, long: 2.0)
        let locationsArray = [location]
        let data = try XCTUnwrap(JSONEncoder().encode(locationsArray))
        mockUserDefaults.set(data, forKey: UserDefaultsLocationsStorage.locationsKey)
        let locations = storage.fetchLocations()
        XCTAssertEqual(locations.count, 1, "Expected one location")
        XCTAssertEqual(locations.first?.name, location.name)
        XCTAssertEqual(locations.first?.lat, location.lat)
        XCTAssertEqual(locations.first?.long, location.long)
    }
    
    func testStoreLocations_WhenCalled_SavesData() throws {
        let location = Location(name: "Test Location", lat: 1.0, long: 2.0)
        let locationsArray = [location]
        storage.store(locations: locationsArray)
        let data = try XCTUnwrap(mockUserDefaults.data(forKey: UserDefaultsLocationsStorage.locationsKey))
        let savedLocations = try XCTUnwrap(JSONDecoder().decode([Location].self, from: data))
        XCTAssertEqual(savedLocations.count, 1, "Expected one location to be saved")
        XCTAssertEqual(savedLocations.first?.name, location.name)
        XCTAssertEqual(savedLocations.first?.lat, location.lat)
        XCTAssertEqual(savedLocations.first?.long, location.long)
    }
}
