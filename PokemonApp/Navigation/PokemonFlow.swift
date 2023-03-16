//
//  PokemonFlow.swift
//  PokemonApp
//
//  Created by Tifo Audi Alif Putra on 30/07/22.
//

import UIKit

struct PokemonFlow {
    
    private let router: Router
    
    init(router: Router) {
        self.router = router
    }
    
    func start() {
        router.navigateToPokemonCardList() { pokemon in
            navigateToPokemonDetail(withPokemon: pokemon)
        }
    }
    
    private func navigateToPokemonDetail(withPokemon pokemon: PokemonData) {
        router.navigateToPokemonDetail(pokemonData: pokemon) { pokemon in
            navigateToPokemonDetail(withPokemon: pokemon)
        } didSelectPokemonImage: { image, viewController in
            router.presentPokemonImage(with: image, from: viewController)
        }
    }
}

