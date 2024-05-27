//
//  LocationsListViewController.swift
//  LocationsList
//
//  Created by MAKSIM YUROV on 27/05/2024.
//

import Combine
import LocationsCoreModels
import UIKit

public final class LocationsListViewController: UIViewController {
    // MARK: - Properties
    
    private lazy var dataSource: LocationsListDiffableDataSource = {
        guard let locationsListView else {
            fatalError("View isn't set")
        }
        return LocationsListDiffableDataSource(
            tableView: locationsListView.tableView
        )
    }()
    private let viewModel: LocationsListViewModel
    private var locationsListView: LocationsListView? {
        view as? LocationsListView
    }
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: - Initializers
    
    public init(viewModel: LocationsListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override public func loadView() {
        super.loadView()
        view = LocationsListView()
    }
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupRefreshControl()
        setupErrorResultsView()
        bindViewModel()
        viewModel.initialFetch()
    }
    
    // MARK: - UI Setup
    
    private func setupNavigationBar() {
        navigationItem.title = "Locations"
    }
    
    func setupRefreshControl() {
        guard let locationsListView else { return }
        locationsListView.refreshControl.addTarget(
            self,
            action: #selector(refreshData),
            for: .valueChanged
        )
    }
    
    private func setupErrorResultsView() {
        guard let locationsListView else { return }
        locationsListView.errorResultsView.onRetryTap = { [weak self] in
            self?.viewModel.reload()
        }
    }
    
    private func bindViewModel() {
        viewModel
            .statePublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] state in
                self?.updateUI(with: state)
            }
            .store(in: &cancellables)
    }
    
    // MARK: - UI Updates
    
    private func updateUI(with newState: LocationsListState) {
        guard let view = locationsListView else { return }
        switch newState {
        case .initial:
            break
        case .loading(let source):
            switch source {
            case .initial:
                view.spinnerView.startAnimating()
                view.spinnerView.alpha = 1.0
                view.errorResultsView.isHidden = true
                view.tableView.isHidden = true
                view.emptyResultsView.isHidden = true
                dataSource.apply(
                    NSDiffableDataSourceSnapshot<LocationsListSection, Location>(),
                    animatingDifferences: true
                )
            case .refresh:
                break
            }
        case .fetched(let locations):
            view.spinnerView.stopAnimating()
            view.spinnerView.alpha = 0.0
            view.errorResultsView.isHidden = true
            view.tableView.isHidden = false
            view.emptyResultsView.isHidden = !(locations.isEmpty)
            var snapshot = NSDiffableDataSourceSnapshot<LocationsListSection, Location>()
            snapshot.appendSections([.main])
            snapshot.appendItems(locations, toSection: .main)
            dataSource.apply(snapshot, animatingDifferences: false) { [weak view] in
                view?.refreshControl.endRefreshing()
            }
        case .error:
            view.spinnerView.stopAnimating()
            view.refreshControl.endRefreshing()
            view.spinnerView.alpha = 0.0
            view.errorResultsView.isHidden = false
            view.tableView.isHidden = true
            view.emptyResultsView.isHidden = true
            dataSource.apply(
                NSDiffableDataSourceSnapshot<LocationsListSection, Location>(),
                animatingDifferences: true
            )
        }
    }
    
    // MARK: - Actions
    
    @objc
    private func refreshData() {
        viewModel.reload()
    }
}
