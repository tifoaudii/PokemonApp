//
//  AppDelegate.swift
//  PokemonApp
//
//  Created by Tifo Audi Alif Putra on 28/07/22.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow()
        let navigationController: UINavigationController = UINavigationController()
        let viewControllerFactory = PokemonViewControllerFactory()
        let router = PokemonRouter(navigationController: navigationController, factory: viewControllerFactory)
        let appFlow = PokemonFlow(router: router)
        window?.rootViewController = navigationController
        window?.makeKeyAndVisible()
        appFlow.start()
        return true
    }
}

