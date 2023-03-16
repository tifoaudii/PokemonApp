//
//  Router.swift
//  PokemonApp
//
//  Created by Tifo Audi Alif Putra on 30/07/22.
//

import UIKit

protocol Router {
    func navigateToPokemonCardList(_ didSelectPokemonCard: @escaping (PokemonData) -> Void)
    func navigateToPokemonDetail(pokemonData: PokemonData, didSelectPokemonCard: @escaping (PokemonData) -> Void, didSelectPokemonImage: @escaping (UIImage, UIViewController) -> Void)
    func presentPokemonImage(with image: UIImage, from viewController: UIViewController)
}

struct PokemonRouter: Router {
    
    private let navigationController: UINavigationController
    private let factory: ViewControllerFactory
    
    init(navigationController: UINavigationController, factory: ViewControllerFactory) {
        self.navigationController = navigationController
        self.factory = factory
    }
    
    func navigateToPokemonCardList(_ didSelectPokemonCard: @escaping (PokemonData) -> Void) {
        let cardListViewController = factory.createPokemonCardListViewController(selection: didSelectPokemonCard)
        navigationController.pushViewController(cardListViewController, animated: true)
    }
    
    func navigateToPokemonDetail(pokemonData: PokemonData, didSelectPokemonCard: @escaping (PokemonData) -> Void, didSelectPokemonImage: @escaping (UIImage, UIViewController) -> Void) {
        let cardDetailViewController = factory.createPokemonCardDetailViewController(pokemonData: pokemonData, didSelectPokemonCard: didSelectPokemonCard, didSelectPokemonImage: didSelectPokemonImage)
        navigationController.pushViewController(cardDetailViewController, animated: true)
    }
    
    func presentPokemonImage(with image: UIImage, from viewController: UIViewController) {
        let imageViewController: PokemonImageViewController = PokemonImageViewController()
        imageViewController.imageView.image = image
        imageViewController.modalPresentationStyle = .overFullScreen
        viewController.present(imageViewController, animated: true)
    }
}
