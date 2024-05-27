//
//  Mocks.swift
//  LocationsCoreTests
//
//  Created by MAKSIM YUROV on 27/05/2024.
//

import Combine
import Foundation
@testable import LocationsCore
import LocationsCoreModels

final class MockAPIGateway: APIGateway {
    var result: Result<Data, Error>?
    
    func fetchData(from url: URL) -> AnyPublisher<Data, Error> {
        guard let result = result else {
            fatalError("Result not set")
        }
        
        return result.publisher.eraseToAnyPublisher()
    }
}

final class MockURLSession: URLSessionProtocol {
    var result: Result<(data: Data, response: URLResponse), URLError>?
    
    func abstractDataTaskPublisher(for url: URL) -> AnyPublisher<(data: Data, response: URLResponse), URLError> {
        guard let result = result else {
            fatalError("Result not set")
        }
        
        return result.publisher.eraseToAnyPublisher()
    }
}

final class MockUserDefaults: UserDefaultsProtocol {
    private var storage: [String: Any] = [:]
    
    func data(forKey defaultName: String) -> Data? {
        return storage[defaultName] as? Data
    }
    
    func set(_ value: Any?, forKey defaultName: String) {
        storage[defaultName] = value
    }
}

final class MockLocationsService: LocationsService {
    var result: Result<[Location], Error>?
    
    func fetchLocations() -> AnyPublisher<[Location], Error> {
        guard let result = result else {
            fatalError("Result not set")
        }
        
        return result.publisher.eraseToAnyPublisher()
    }
}

final class MockLocationsStorage: LocationsStorage {
    var storedLocations: [Location] = []
    
    func fetchLocations() -> [Location] {
        return storedLocations
    }
    
    func store(locations: [Location]) {
        storedLocations = locations
    }
}
