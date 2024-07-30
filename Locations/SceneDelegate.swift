//
//  SceneDelegate.swift
//  Locations
//
//  Created by MAKSIM YUROV on 27/05/2024.
//

import LocationsCore
import LocationsList
import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: windowScene)
        let nav = UINavigationController(rootViewController: createListViewController())
        window.rootViewController = nav
        window.makeKeyAndVisible()
        self.window = window
    }
    
    private func createListViewController() -> UIViewController {
        let repository = LocationsRepositoryFactory.create()
        let router = LocationsListRouterImpl()
        let viewModel = LocationsListViewModelImpl(
            repository: repository,
            router: router,
            externalRouter: LocationsExternalRouterImpl(application: UIApplication.shared)
        )
        let vc = LocationsListViewController(viewModel: viewModel)
        router.presentingController = vc
        return vc
    }
}

