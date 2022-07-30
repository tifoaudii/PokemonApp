//
//  Router.swift
//  PokemonApp
//
//  Created by Tifo Audi Alif Putra on 30/07/22.
//

import UIKit

protocol Router {
    func navigateToPokemonCardList(_ didSelectPokemon: @escaping (PokemonData) -> Void)
    func navigateToPokemonDetail(pokemonData: PokemonData, _ didSelectPokemon: @escaping (PokemonData) -> Void)
}

struct PokemonRouter: Router {
    
    private let navigationController: UINavigationController
    private let factory: ViewControllerFactory
    
    init(navigationController: UINavigationController, factory: ViewControllerFactory) {
        self.navigationController = navigationController
        self.factory = factory
    }
    
    func navigateToPokemonCardList(_ didSelectPokemon: @escaping (PokemonData) -> Void) {
        let cardListViewController = factory.createPokemonCardListViewController(selection: didSelectPokemon)
        navigationController.pushViewController(cardListViewController, animated: true)
    }
    
    func navigateToPokemonDetail(pokemonData: PokemonData, _ didSelectPokemon: @escaping (PokemonData) -> Void) {
        let cardDetailViewController = factory.createPokemonCardDetailViewController(pokemonData: pokemonData, selection: didSelectPokemon)
        navigationController.pushViewController(cardDetailViewController, animated: true)
    }
}
