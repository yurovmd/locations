//
//  UIApplication+UIApplicationProtocol.swift
//  LocationsCore
//
//  Created by MAKSIM YUROV on 30/07/2024.
//

import UIKit

public protocol UIApplicationProtocol {
    func open(
        _ url: URL,
        options: [UIApplication.OpenExternalURLOptionsKey : Any],
        completionHandler completion: ((Bool) -> Void)?
    )
}

extension UIApplication: UIApplicationProtocol {}
