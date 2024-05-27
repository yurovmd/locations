//
//  LocationsListViewController.swift
//  LocationsList
//
//  Created by MAKSIM YUROV on 27/05/2024.
//

import UIKit

public final class LocationsListViewController: UIViewController {
    // MARK: - Properties
    
    private let viewModel: LocationsListViewModel
    
    // MARK: - Initializers
    
    public init(viewModel: LocationsListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
