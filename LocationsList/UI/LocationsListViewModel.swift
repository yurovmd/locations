//
//  LocationsListViewModel.swift
//  LocationsList
//
//  Created by MAKSIM YUROV on 27/05/2024.
//

import Combine
import Foundation
import LocationsCore

public protocol LocationsListViewModel {
    // TODO: - implementation
}

public final class LocationsListViewModelImpl: LocationsListViewModel {
    // MARK: - Properties
    
    private let repository: LocationsRepository
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - Initializer
    
    public init(repository: LocationsRepository) {
        self.repository = repository
        
        repository.fetchLocations()
            .sink { _ in
                
            } receiveValue: { locations in
                print(locations)
            }
            .store(in: &cancellables)
    }
}
