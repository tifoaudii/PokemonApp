//
//  GetPokemonUseCase.swift
//  PokemonApp
//
//  Created by Tifo Audi Alif Putra on 28/07/22.
//

import Foundation

struct GetPokemonUseCase: UseCase {
    
    var url: String {
        "https://api.pokemontcg.io/v2/cards"
    }
    
    var method: HTTPMethod {
        .get
    }
    
    var queryItems: [String : String] {
        [
            "page": "1",
            "pageSize": "20"
        ]
    }
    
    func map(_ data: Data) throws -> PokemonResponse {
        let decoder = JSONDecoder()
        return try decoder.decode(PokemonResponse.self, from: data)
    }
}
