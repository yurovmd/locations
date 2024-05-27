//
//  ErrorResultsView.swift
//  LocationsUIComponents
//
//  Created by MAKSIM YUROV on 27/05/2024.
//

import UIKit

public final class ErrorResultsView: UIView {
    // MARK: - Properties
    
    private let titleLabel = UILabel()
    private let retryButton = UIButton()
    public var onRetryTap: (() -> Void)?
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - UI Setup
    
    private func setupUI() {
        addSubview(titleLabel)
        titleLabel.font = .systemFont(ofSize: 16, weight: .bold)
        titleLabel.numberOfLines = 1
        titleLabel.text = "Something went wrong"
        titleLabel.textAlignment = .center
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(retryButton)
        retryButton.addTarget(
            self,
            action: #selector(retryTapped),
            for: .touchUpInside
        )
        retryButton.setTitle("Retry", for: .normal)
        retryButton.backgroundColor = .blue
        retryButton.layer.masksToBounds = true
        retryButton.layer.cornerRadius = 20.0
        retryButton.translatesAutoresizingMaskIntoConstraints = false
        
        setupLayout()
    }
    
    private func setupLayout() {
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            titleLabel.heightAnchor.constraint(equalToConstant: 20),
            retryButton.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16.0),
            retryButton.heightAnchor.constraint(equalToConstant: 40),
            retryButton.widthAnchor.constraint(equalToConstant: 100),
            retryButton.centerXAnchor.constraint(equalTo: titleLabel.centerXAnchor),
        ])
    }
    
    // MARK: - Actions
    
    @objc
    private func retryTapped() {
        onRetryTap?()
    }
}
