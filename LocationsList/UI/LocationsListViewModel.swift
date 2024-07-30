//
//  LocationsListViewModel.swift
//  LocationsList
//
//  Created by MAKSIM YUROV on 27/05/2024.
//

import Combine
import CustomLocation
import Foundation
import LocationsCore
import LocationsCoreModels

public protocol LocationsListViewModel: AnyObject {
    var statePublisher: Published<LocationsListState>.Publisher { get }
    
    func initialFetch()
    func reload()
    func customLocationTapped()
    func selected(location: Location)
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
    private let router: LocationsListRouter
    private let externalRouter: LocationsExternalRouter
    @Published private var state: LocationsListState = .initial
    private var fetchCancellable: AnyCancellable?
    public var statePublisher: Published<LocationsListState>.Publisher { $state }
    
    // MARK: - Initializer
    
    public init(
        repository: LocationsRepository,
        router: LocationsListRouter,
        externalRouter: LocationsExternalRouter
    ) {
        self.repository = repository
        self.router = router
        self.externalRouter = externalRouter
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
    
    public func customLocationTapped() {
        router.route(to: .customCoordinatesScreen(delegate: self))
    }
    
    public func selected(location: Location) {
        externalRouter.route(to: location)
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

// MARK: - CustomCoordinatesViewControllerDelegate

extension LocationsListViewModelImpl: CustomCoordinatesViewControllerDelegate {
    public func routeButtonTapped(latitude: Double, longitude: Double) {
        externalRouter.route(to: Location(name: nil, lat: latitude, long: longitude))
    }
}
