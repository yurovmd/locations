//
//  LocationCell.swift
//  LocationsList
//
//  Created by MAKSIM YUROV on 27/05/2024.
//

import LocationsCoreModels
import UIKit

final class LocationCell: UITableViewCell {
    static let reuseIdentifier = "LocationCell"
    
    // MARK: - Properties
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16, weight: .bold)
        return label
    }()
    
    private let coordinatesLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    // MARK: - Lifecycle
    
    override func prepareForReuse() {
        super.prepareForReuse()
        coordinatesLabel.text = nil
        titleLabel.text = nil
    }
    
    // MARK: - Initializers
    
    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
        isUserInteractionEnabled = false
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private section
    
    private func setupViews() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(coordinatesLabel)
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            coordinatesLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 5),
            coordinatesLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            coordinatesLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            coordinatesLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10)
        ])
    }
    
    // MARK: - API
    
    func configure(
        with location: Location
    ) {
        titleLabel.text = location.name ?? "Unknown Coordinate"
        coordinatesLabel.text = "Long: \(location.long), Lat: \(location.lat)"
    }
}
