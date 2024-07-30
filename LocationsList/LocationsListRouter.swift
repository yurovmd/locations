//
//  LocationsListRouter.swift
//  LocationsList
//
//  Created by MAKSIM YUROV on 30/07/2024.
//

import Foundation
import LocationsCore
import CustomLocation

public enum Destination {
    case customCoordinatesScreen(delegate: CustomCoordinatesViewControllerDelegate)
}

public protocol LocationsListRouter {
    var presentingController: UIViewControllerProtocol? { get set }
    
    func route(to destination: Destination)
}

public final class LocationsListRouterImpl: LocationsListRouter {
    // MARK: - Properties
    
    public var presentingController: UIViewControllerProtocol?
    
    // MARK: - Initializer
    
    public init() {}
    
    // MARK: - LocationsListRouter
    
    public func route(to destination: Destination) {
        switch destination {
        case .customCoordinatesScreen(let delegate):
            guard let presentingController else { return }
            let vc = CustomCoordinatesViewController()
            vc.delegate = delegate
            presentingController.present(vc, animated: true, completion: nil)
        }
    }
}
