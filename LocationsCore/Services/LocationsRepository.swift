//
//  LocationsRepository.swift
//  LocationsCore
//
//  Created by MAKSIM YUROV on 27/05/2024.
//

import Foundation
import Combine
import LocationsCoreModels

public protocol LocationsRepository {
    func fetchLocations(policy: LocationsRepositoryFetchPolicy) -> AnyPublisher<[Location], Error>
}

public enum LocationsRepositoryFetchPolicy {
    case cachedDataFirst
    case ignoreCachedData
}

final class LocationsRepositoryImpl: LocationsRepository {
    // MARK: - Properties
    
    private let locationsService: LocationsService
    private let locationsStorage: LocationsStorage
    
    // MARK: - Initializer
    
    init(
        locationsService: LocationsService,
        locationsStorage: LocationsStorage
    ) {
        self.locationsService = locationsService
        self.locationsStorage = locationsStorage
    }
    
    // MARK: - LocationsRepository
    
    func fetchLocations(policy: LocationsRepositoryFetchPolicy) -> AnyPublisher<[Location], Error> {
        let networkPublisher = locationsService
            .fetchLocations()
            .handleEvents(receiveOutput: { [weak locationsStorage] locations in
                locationsStorage?.store(locations: locations)
            })
            .eraseToAnyPublisher()
        
        let storedLocations = locationsStorage.fetchLocations()
        
        switch policy {
        case .cachedDataFirst:
            if !storedLocations.isEmpty {
                let storagePublisher = Just(storedLocations)
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
                
                return storagePublisher
                    .append(networkPublisher)
                    .catch { _ -> AnyPublisher<[Location], Error> in
                        // In case we have a network error, we should only send a cached value
                        return Empty<[Location], Error>().eraseToAnyPublisher()
                    }
                    .eraseToAnyPublisher()
            } else {
                return networkPublisher
            }
        case .ignoreCachedData:
            return networkPublisher
        }
    }
}
