//
//  Models.swift
//  LocationsCoreModels
//
//  Created by MAKSIM YUROV on 27/05/2024.
//

import Foundation

public struct Location: Codable, Equatable {
    public let name: String?
    public let lat: Double
    public let long: Double
    
    public init(name: String?, lat: Double, long: Double) {
        self.name = name
        self.lat = lat
        self.long = long
    }
}
