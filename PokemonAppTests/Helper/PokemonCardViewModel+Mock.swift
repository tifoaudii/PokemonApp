//
//  PokemonCardViewModel+Mock.swift
//  PokemonAppTests
//
//  Created by Tifo Audi Alif Putra on 31/07/22.
//

@testable import PokemonApp

extension PokemonCardViewModel {
    
    static func makeMock() -> [PokemonCardViewModel] {
        [
            .init(imageUrlString: "https://images.pokemontcg.io/pl3/1.png", selection: {}),
            .init(imageUrlString: "https://images.pokemontcg.io/ex12/1.png", selection: {})
        ]
    }
}
