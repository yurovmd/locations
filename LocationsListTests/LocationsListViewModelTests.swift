//
//  LocationsListViewModelTests.swift
//  LocationsListTests
//
//  Created by MAKSIM YUROV on 27/05/2024.
//

import Combine
@testable import LocationsList
import LocationsCore
import LocationsCoreModels
import XCTest

final class LocationsListViewModelImplTests: XCTestCase {
    // MARK: - Properties
    
    private var viewModel: LocationsListViewModelImpl!
    private var repository: MockLocationsRepository!
    private var router: MockLocationsListRouter!
    private var externalRouter: MockLocationsExternalRouter!
    private var cancellables: Set<AnyCancellable>!
    
    // MARK: - Lifecycle
    
    override func setUp() {
        super.setUp()
        repository = MockLocationsRepository()
        router = MockLocationsListRouter()
        externalRouter = MockLocationsExternalRouter()
        viewModel = LocationsListViewModelImpl(
            repository: repository,
            router: router,
            externalRouter: externalRouter
        )
        cancellables = []
    }
    
    override func tearDown() {
        viewModel = nil
        repository = nil
        router = nil
        externalRouter = nil
        cancellables = nil
        super.tearDown()
    }
    
    // MARK: - Tests
    
    func testInitialFetchSuccess() {
        let locations = [
            Location(name: "Location1", lat: 37.7749, long: -122.4194),
            Location(name: "Location2", lat: 34.0522, long: -118.2437)
        ]
        repository.fetchLocationsResult = .success(locations)
        let loadingExpectation = expectation(description: "loadingExpectation")
        let fetchedExpectation = expectation(description: "fetchedExpectation")
        viewModel.statePublisher
            .dropFirst()
            .sink { state in
                switch state {
                case .initial:
                    break
                case .loading:
                    loadingExpectation.fulfill()
                case .fetched(let fetchedLocations):
                    XCTAssertEqual(fetchedLocations, locations)
                    fetchedExpectation.fulfill()
                case .error:
                    XCTFail("No error should be returned")
                }
            }
            .store(in: &cancellables)
        viewModel.initialFetch()
        wait(for: [loadingExpectation, fetchedExpectation], timeout: 1.0)
    }
    
    func testInitialFetchFailure() {
        repository.fetchLocationsResult = .failure(NSError(domain: "", code: -1, userInfo: nil))
        let loadingExpectation = expectation(description: "loadingExpectation")
        let errorExpectation = expectation(description: "errorExpectation")
        viewModel.statePublisher
            .dropFirst()
            .sink { state in
                switch state {
                case .initial:
                    break
                case .loading:
                    loadingExpectation.fulfill()
                case .fetched:
                    XCTFail("No error should be returned")
                case .error:
                    errorExpectation.fulfill()
                    
                }
            }
            .store(in: &cancellables)
        viewModel.initialFetch()
        wait(for: [loadingExpectation, errorExpectation], timeout: 1.0)
    }
    
    func testReloadSuccess() {
        let locations = [
            Location(name: "Location1", lat: 37.7749, long: -122.4194),
            Location(name: "Location2", lat: 34.0522, long: -118.2437)
        ]
        repository.fetchLocationsResult = .success(locations)
        let expectation = expectation(description: "State changes to fetched with locations after reload")
        viewModel.statePublisher
            .dropFirst(2)
            .sink { state in
                switch state {
                case .fetched(let fetchedLocations):
                    XCTAssertEqual(fetchedLocations, locations)
                    expectation.fulfill()
                default:
                    XCTFail("Expected state to be .fetched")
                }
            }
            .store(in: &cancellables)
        viewModel.reload()
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testReloadFailure() {
        repository.fetchLocationsResult = .failure(NSError(domain: "", code: -1, userInfo: nil))
        let expectation = expectation(description: "State changes to error after reload")
        viewModel.statePublisher
            .dropFirst(2)
            .sink { state in
                if case .error = state {
                    expectation.fulfill()
                } else {
                    XCTFail("Expected state to be .error")
                }
            }
            .store(in: &cancellables)
        viewModel.reload()
        wait(for: [expectation], timeout: 1.0)
    }
    
    func testSelectedLocation() {
        let expectation = expectation(description: #function)
        let location = Location(name: nil, lat: 10, long: 10)
        externalRouter.onRouteCalled = { routedLocation in
            if location == routedLocation {
                expectation.fulfill()
            }
        }
        viewModel.selected(location: location)
        wait(for: [expectation])
    }
    
    func testCustomLocationTapped() {
        let vc = MockUIViewControllerProtocol()
        let expectation = expectation(description: #function)
        vc.onPresentCalled = { _ in
            expectation.fulfill()
        }
        router.presentingController = vc
        viewModel.customLocationTapped()
        wait(for: [expectation])
    }
}

final class MockLocationsRepository: LocationsRepository {
    var fetchLocationsResult: Result<[Location], Error>?
    
    func fetchLocations(policy: LocationsRepositoryFetchPolicy) -> AnyPublisher<[Location], Error> {
        guard let result = fetchLocationsResult else {
            return Fail(error: NSError(domain: "", code: -1, userInfo: nil)).eraseToAnyPublisher()
        }
        return result.publisher.eraseToAnyPublisher()
    }
}

final class MockLocationsListRouter: LocationsListRouter {
    var presentingController: UIViewControllerProtocol?
    
    func route(to destination: Destination) {
        presentingController?.present(UIViewController(), animated: false, completion: nil)
    }
}

final class MockLocationsExternalRouter: LocationsExternalRouter {
    // MARK: - Properties
    
    var onRouteCalled: ((Location) -> Void)?
    
    func route(to location: Location) {
        onRouteCalled?(location)
    }
}

final class MockUIViewControllerProtocol: UIViewControllerProtocol {
    // MARK: - Properties
    
    var onPresentCalled: ((UIViewController) -> Void)?
    
    // MARK: - UIViewControllerProtocol
    
    func present(_ viewControllerToPresent: UIViewController, animated: Bool, completion: (() -> Void)?) {
        onPresentCalled?(viewControllerToPresent)
    }
}
