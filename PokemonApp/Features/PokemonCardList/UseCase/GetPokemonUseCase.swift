//
//  GetPokemonUseCase.swift
//  PokemonApp
//
//  Created by Tifo Audi Alif Putra on 28/07/22.
//

import Foundation

struct GetPokemonUseCase: UseCase {
    
    private let page: Int
    private let pageSize: Int
    
    init(page: Int, pageSize: Int) {
        self.page = page
        self.pageSize = pageSize
    }
    
    var url: String {
        "https://api.pokemontcg.io/v2/cards"
    }
    
    var method: HTTPMethod {
        .get
    }
    
    var queryItems: [String : String] {
        [
            "page": "\(page)",
            "pageSize": "\(pageSize)"
        ]
    }
    
    func map(_ data: Data) throws -> PokemonResponse {
        let decoder = JSONDecoder()
        return try decoder.decode(PokemonResponse.self, from: data)
    }
}
