//
//  LocationsService.swift
//  LocationsCore
//
//  Created by MAKSIM YUROV on 27/05/2024.
//

import Combine
import Foundation
import LocationsCoreModels

protocol LocationsService {
    func fetchLocations() -> AnyPublisher<[Location], Error>
}

final class LocationsServiceImpl: LocationsService {
    // MARK: - Properties
    
    private let apiGateway: APIGateway
    
    // MARK: - Initializer
    
    init(apiGateway: APIGateway) {
        self.apiGateway = apiGateway
    }
    
    // MARK: - LocationsService
    
    func fetchLocations() -> AnyPublisher<[Location], Error> {
        guard let url = URL(string: LocationsEndpoint.urlString) else {
            return Fail(error: LocationsServiceError.badUrl).eraseToAnyPublisher()
        }
        
        return apiGateway.fetchData(from: url)
            .decode(type: FetchLocationsResponse.self, decoder: JSONDecoder())
            .map { $0.locations }
            .eraseToAnyPublisher()
    }
}


enum LocationsEndpoint {
    static let urlString = "https://raw.githubusercontent.com/abnamrocoesd/assignment-ios/main/locations.json"
}

enum LocationsServiceError: Error {
    case badUrl
}

struct FetchLocationsResponse: Codable {
    let locations: [Location]
}
