//
//  PokemonCardViewModel.swift
//  PokemonApp
//
//  Created by Tifo Audi Alif Putra on 30/07/22.
//

import Foundation

struct PokemonCardViewModel {
    
    private let imageUrlString: String
    let data: PokemonData
    
    init(imageUrlString: String, data: PokemonData) {
        self.imageUrlString = imageUrlString
        self.data = data
    }
    
    var imageUrl: URL? {
        URL(string: imageUrlString)
    }
}
