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
    let supertype: String
    let hp: String
    let flavorText: String?
    let types: [String]
    let subtypes: [String]
    let images: PokemonImages
}

struct PokemonImages: Codable {
    let small: String
    let large: String
}
