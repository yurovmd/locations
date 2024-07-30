//
//  UIViewController+UIViewControllerProtocol.swift
//  LocationsCore
//
//  Created by MAKSIM YUROV on 30/07/2024.
//

import UIKit

public protocol UIViewControllerProtocol: AnyObject {
    func present(_ viewControllerToPresent: UIViewController, animated: Bool, completion: (() -> Void)?)
}

extension UIViewController: UIViewControllerProtocol {}
