//
//  ViewControllerFactory.swift
//  PokemonApp
//
//  Created by Tifo Audi Alif Putra on 30/07/22.
//

import UIKit

protocol ViewControllerFactory {
    func createPokemonCardListViewController(selection: @escaping (PokemonData) -> Void) -> UIViewController
    func createPokemonCardDetailViewController(pokemonData: PokemonData, selection: @escaping (PokemonData) -> Void) -> UIViewController
}

final class PokemonViewControllerFactory: ViewControllerFactory {
    
    
    func createPokemonCardListViewController(selection: @escaping (PokemonData) -> Void) -> UIViewController {
        let service = URLSessionNetworkService()
        let interactor = PokemonCardListInteractorAdapter(service: service, selection: selection)
        return PokemonCardListViewController(interactor: interactor)
    }
    
    func createPokemonCardDetailViewController(pokemonData: PokemonData, selection: @escaping (PokemonData) -> Void) -> UIViewController {
        let service = URLSessionNetworkService()
        let interactor = PokemonCardDetailInteractorAdapter(service: service, pokemonData: pokemonData, selection: selection)
        return PokemonCardDetailViewController(interactor: interactor)
    }
}
