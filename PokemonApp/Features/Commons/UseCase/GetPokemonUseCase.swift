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
    private let type: String?
    private let query: String?
    
    init(page: Int, pageSize: Int, type: String? = nil, query: String? = nil) {
        self.page = page
        self.pageSize = pageSize
        self.type = type
        self.query = query
    }
    
    var url: String {
        "https://api.pokemontcg.io/v2/cards"
    }
    
    var method: HTTPMethod {
        .get
    }
    
    var queryItems: [String : String] {
        var baseQuery: [String : String] = [
            "page": "\(page)",
            "pageSize": "\(pageSize)"
        ]
        
        if let type = type {
            baseQuery["q"] = "types:\(type)"
        }
        
        if let query = query {
            baseQuery["q"] = "name:\(query)"
        }
        
        return baseQuery
    }
    
    func map(_ data: Data) throws -> PokemonResponse {
        let decoder = JSONDecoder()
        return try decoder.decode(PokemonResponse.self, from: data)
    }
}
