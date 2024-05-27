//
//  LocationsStorage.swift
//  LocationsCore
//
//  Created by MAKSIM YUROV on 27/05/2024.
//

import LocationsCoreModels
import Foundation

protocol LocationsStorage: AnyObject {
    func fetchLocations() -> [Location]
    func store(locations: [Location])
}

final class UserDefaultsLocationsStorage: LocationsStorage {
    // MARK: - Properties
    
    static let locationsKey = "kLocationsKey"
    
    private let userDefaults: UserDefaultsProtocol
    
    // MARK: - Initializer
    
    init(userDefaults: UserDefaultsProtocol) {
        self.userDefaults = userDefaults
    }
    
    // MARK: - LocationsStorage
    
    func fetchLocations() -> [Location] {
        guard let data = userDefaults.data(forKey: Self.locationsKey),
              let savedLocations = try? JSONDecoder().decode([Location].self, from: data) else {
                    return []
        }
        return savedLocations
    }
    
    func store(locations: [Location]) {
        guard let data = try? JSONEncoder().encode(locations) else { return }
        userDefaults.set(data, forKey: Self.locationsKey)
    }
}

protocol UserDefaultsProtocol {
    func data(forKey defaultName: String) -> Data?
    func set(_ value: Any?, forKey defaultName: String)
}

extension UserDefaults: UserDefaultsProtocol {
    
}
