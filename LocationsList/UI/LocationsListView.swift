//
//  LocationsListView.swift
//  LocationsList
//
//  Created by MAKSIM YUROV on 27/05/2024.
//

import LocationsUIComponents
import UIKit

final class LocationsListView: UIView {
    // MARK: - Properties
    
    let tableView = UITableView()
    var spinnerView: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    let emptyResultsView = EmptyResultsView()
    let refreshControl = UIRefreshControl()
    let errorResultsView = ErrorResultsView()
    let customRouteButton = UIButton()
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup UI
    
    private func setupUI() {
        backgroundColor = .white
        addSubview(errorResultsView)
        errorResultsView.translatesAutoresizingMaskIntoConstraints = false
        errorResultsView.isHidden = true
        addSubview(emptyResultsView)
        emptyResultsView.translatesAutoresizingMaskIntoConstraints = false
        emptyResultsView.isHidden = true
        setupTableView()
        setupSpinner()
        setupCustomRouteButton()
        setupLayout()
    }
    
    private func setupTableView() {
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.backgroundColor = .white
        tableView.register(
            LocationCell.self,
            forCellReuseIdentifier: LocationCell.reuseIdentifier
        )
        addSubview(tableView)
        tableView.refreshControl = refreshControl
    }
    
    private func setupSpinner() {
        insertSubview(spinnerView, at: 0)
        NSLayoutConstraint.activate([
            spinnerView.centerXAnchor.constraint(equalTo: centerXAnchor),
            spinnerView.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    private func setupCustomRouteButton() {
        customRouteButton.translatesAutoresizingMaskIntoConstraints = false
        customRouteButton.setTitle("Custom Location", for: .normal)
        customRouteButton.backgroundColor = .blue
        customRouteButton.setTitleColor(.white, for: .normal)
        customRouteButton.layer.masksToBounds = true
        customRouteButton.layer.cornerRadius = 16.0
        addSubview(customRouteButton)
        NSLayoutConstraint.activate([
            customRouteButton.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -20),
            customRouteButton.heightAnchor.constraint(equalToConstant: 32.0),
            customRouteButton.widthAnchor.constraint(equalToConstant: 200.0),
            customRouteButton.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            tableView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            emptyResultsView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            emptyResultsView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            emptyResultsView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            emptyResultsView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
            errorResultsView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor),
            errorResultsView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            errorResultsView.leadingAnchor.constraint(equalTo: safeAreaLayoutGuide.leadingAnchor),
            errorResultsView.trailingAnchor.constraint(equalTo: safeAreaLayoutGuide.trailingAnchor),
        ])
    }
}
