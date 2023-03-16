//
//  ViewControllerFactory.swift
//  PokemonApp
//
//  Created by Tifo Audi Alif Putra on 30/07/22.
//

import UIKit

protocol ViewControllerFactory {
    func createPokemonCardListViewController(selection: @escaping (PokemonData) -> Void) -> UIViewController
    func createPokemonCardDetailViewController(pokemonData: PokemonData, didSelectPokemonCard: @escaping (PokemonData) -> Void, didSelectPokemonImage: @escaping (UIImage, UIViewController) -> Void) -> UIViewController
}

final class PokemonViewControllerFactory: ViewControllerFactory {
    
    
    func createPokemonCardListViewController(selection: @escaping (PokemonData) -> Void) -> UIViewController {
        let service = URLSessionNetworkService()
        let interactor = PokemonCardListInteractorAdapter(service: service, selection: selection)
        return PokemonCardListViewController(interactor: interactor)
    }
    
    func createPokemonCardDetailViewController(pokemonData: PokemonData, didSelectPokemonCard: @escaping (PokemonData) -> Void, didSelectPokemonImage: @escaping (UIImage, UIViewController) -> Void) -> UIViewController {
        let service = URLSessionNetworkService()
        let interactor = PokemonCardDetailInteractorAdapter(service: service, pokemonData: pokemonData, didSelectPokemonCard: didSelectPokemonCard)
        return PokemonCardDetailViewController(interactor: interactor, didSelectPokemonImage: didSelectPokemonImage)
    }
}
