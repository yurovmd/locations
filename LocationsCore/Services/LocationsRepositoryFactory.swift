//
//  LocationsRepositoryFactory.swift
//  LocationsCore
//
//  Created by MAKSIM YUROV on 27/05/2024.
//

import Foundation

public enum LocationsRepositoryFactory {
    public static func create() -> LocationsRepository {
        let userDefaultsStorage = UserDefaultsLocationsStorage(
            userDefaults: UserDefaults.standard
        )
        let locationsService = LocationsServiceImpl(
            apiGateway: URLSessionAPIGateway(urlSession: URLSession.shared)
        )
        return LocationsRepositoryImpl(
            locationsService: locationsService,
            locationsStorage: userDefaultsStorage
        )
    }
}
