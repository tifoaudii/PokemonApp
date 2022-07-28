//
//  PokemonResponse.swift
//  PokemonApp
//
//  Created by Tifo Audi Alif Putra on 28/07/22.
//

import Foundation

struct PokemonResponse: Codable {
    let data: [PokemonData]
}

struct PokemonData: Codable {
    let id: String
    let name: String
    let images: PokemonImages
}

struct PokemonImages: Codable {
    let small: String
    let large: String
}
