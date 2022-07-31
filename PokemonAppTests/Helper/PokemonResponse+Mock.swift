//
//  PokemonResponse+Mock.swift
//  PokemonAppTests
//
//  Created by Tifo Audi Alif Putra on 31/07/22.
//

@testable import PokemonApp
import Foundation

extension PokemonResponse {
    
    static func mockJSON() -> String {
                 """
                     {
                         "data": [
                             {
                                 "id": "1",
                                 "name": "Pikachu",
                                 "supertype": "Pokemon",
                                 "hp": "80",
                                 "flavorText": "SomeFlavor",
                                 "types": ["Basic"],
                                 "subtypes": [],
                                 "images": {
                                     "small": "small-image.png",
                                     "large": "large-image.png"
                                 }
                             }
                         ]
                     }
                 """
    }
    
    static func makeMock() -> PokemonResponse {
        let data = Data(PokemonResponse.mockJSON().utf8)
        return try! JSONDecoder().decode(PokemonResponse.self, from: data)
    }
    
    static func mockData() -> PokemonData {
        return makeMock().data.first!
    }
}
