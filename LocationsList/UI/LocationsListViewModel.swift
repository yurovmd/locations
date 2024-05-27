//
//  LocationsListViewModel.swift
//  LocationsList
//
//  Created by MAKSIM YUROV on 27/05/2024.
//

import Combine
import Foundation
import LocationsCore
import LocationsCoreModels

public protocol LocationsListViewModel: AnyObject {
    var statePublisher: Published<LocationsListState>.Publisher { get }
    
    func initialFetch()
    func reload()
}

public enum LocationsListState: Equatable {
    case initial
    case loading(source: LocationsListLoadingSource)
    case fetched(locations: [Location])
    case error
}

public enum LocationsListLoadingSource {
    case initial
    case refresh
}

public final class LocationsListViewModelImpl: LocationsListViewModel {
    // MARK: - Properties
    
    private let repository: LocationsRepository
    @Published private var state: LocationsListState = .initial
    private var fetchCancellable: AnyCancellable?
    public var statePublisher: Published<LocationsListState>.Publisher { $state }
    
    // MARK: - Initializer
    
    public init(repository: LocationsRepository) {
        self.repository = repository
    }
    
    // MARK: - LocationsListViewModel
    
    public func initialFetch() {
        state = .loading(source: .initial)
        fetchLocations(policy: .cachedDataFirst)
    }
    
    public func reload() {
        state = .loading(source: .refresh)
        fetchLocations(policy: .ignoreCachedData)
    }
    
    // MARK: - Private Section
    
    private func fetchLocations(policy: LocationsRepositoryFetchPolicy) {
        fetchCancellable?.cancel()
        fetchCancellable = repository.fetchLocations(policy: policy)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    return
                case .failure:
                    self?.state = .error
                }
            } receiveValue: { [weak self] locations in
                guard let self else { return }
                let newState: LocationsListState = .fetched(
                    locations: locations
                )
                if newState != self.state {
                    self.state = newState
                }
            }
    }
}

enum LocationsListSection {
    case main
}
