//
//  PokemonCardViewModel.swift
//  PokemonApp
//
//  Created by Tifo Audi Alif Putra on 30/07/22.
//

import Foundation

struct PokemonCardViewModel {
    
    private let imageUrlString: String
    
    let selection: () -> Void
    
    init(imageUrlString: String, selection: @escaping () -> Void) {
        self.imageUrlString = imageUrlString
        self.selection = selection
    }
    
    var imageUrl: URL? {
        URL(string: imageUrlString)
    }
}
