//
//  CustomCoordinatesViewController.swift
//  CustomLocation
//
//  Created by MAKSIM YUROV on 30/07/2024.
//

import UIKit

public protocol CustomCoordinatesViewControllerDelegate: AnyObject {
    func routeButtonTapped(latitude: Double, longitude: Double)
}

public final class CustomCoordinatesViewController: UIViewController {
    // MARK: - Properties
    
    private let latitudeTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16)
        label.numberOfLines = 1
        label.textAlignment = .left
        label.textColor = .black
        label.text = "Latitude"
        return label
    }()
    
    private let longitudeTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16)
        label.numberOfLines = 1
        label.textAlignment = .left
        label.textColor = .black
        label.text = "Longitude"
        return label
    }()
    
    private let latitudeTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter something..."
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let longitudeTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter something..."
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let button: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle("Route", for: .normal)
        button.backgroundColor = .blue
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    public weak var delegate: CustomCoordinatesViewControllerDelegate?
    
    // MARK: - Initializers
    
    public init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    public override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        button.layer.masksToBounds = true
        button.layer.cornerRadius = 16.0
    }
    
    // MARK: = UI Setup
    
    private func setupUI() {
        view.backgroundColor = .white
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 20.0
        stackView.distribution = .fill
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.addArrangedSubview(latitudeTitle)
        stackView.addArrangedSubview(latitudeTextField)
        stackView.addArrangedSubview(longitudeTitle)
        stackView.addArrangedSubview(longitudeTextField)
        stackView.addArrangedSubview(button)
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20.0),
            stackView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            latitudeTextField.heightAnchor.constraint(equalToConstant: 20),
            longitudeTextField.heightAnchor.constraint(equalToConstant: 20),
            button.heightAnchor.constraint(equalToConstant: 32.0),
            button.widthAnchor.constraint(equalToConstant: 150.0)
        ])
    }
    
    // MARK: - Actions
    
    @objc
    private func buttonTapped() {
        guard let latitudeText = latitudeTextField.text else {
            inputErrorTriggered(.emptyLatitude)
            return
        }
        guard let longitudeText = longitudeTextField.text else {
            inputErrorTriggered(.emptyLongitude)
            return
        }
        guard let latitude = Double(latitudeText),
              latitude < 90,
              latitude > -90 else {
            inputErrorTriggered(.wrongLatitude)
            return
        }
        guard let longitude = Double(longitudeText),
              longitude < 180,
              longitude > -180 else {
            inputErrorTriggered(.wrongLongitude)
            return
        }
        dismiss(animated: true) {
            self.delegate?.routeButtonTapped(latitude: latitude, longitude: longitude)
        }
    }
    
    private func inputErrorTriggered(_ error: CustomCoordinatesError) {
        let okAction = UIAlertAction(title: "OK", style: .default)
        let vc = UIAlertController(
            title: "Wrong Input",
            message: error.rawValue,
            preferredStyle: .alert
        )
        vc.addAction(okAction)
        present(vc, animated: true)
    }
}

enum CustomCoordinatesError: String {
    case emptyLatitude = "Latitude is Empty"
    case emptyLongitude = "Longitude is Empty"
    case wrongLatitude = "Latitude is in wrong format or not -89/89"
    case wrongLongitude = "Longitude is in wrong format or not -179/179"
}
