//
//  LocationsRouter.swift
//  LocationsCore
//
//  Created by MAKSIM YUROV on 30/07/2024.
//

import Foundation
import LocationsCoreModels

public protocol LocationsExternalRouter {
    func route(to location: Location)
}

public final class LocationsExternalRouterImpl: LocationsExternalRouter {
    // MARK: - Properties
    
    private let application: UIApplicationProtocol
    
    // MARK: - Initializer
    
    public init(application: UIApplicationProtocol) {
        self.application = application
    }
    
    // MARK: - LocationsRouter
    
    public func route(to location: Location) {
        let urlString = "wikipedia://location?latitude=\(location.lat)&longitude=\(location.long)"
        guard let url = URL(string: urlString) else  { return }
        application.open(url, options: [:], completionHandler: nil)
    }
}
