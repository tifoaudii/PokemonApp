//
//  PokemonCardDetailViewModel.swift
//  PokemonApp
//
//  Created by Tifo Audi Alif Putra on 30/07/22.
//

import Foundation

struct PokemonCardDetailViewModel {
    
    private let imageUrlString: String
    private let hp: String
    private let name: String
    private let supertype: String
    private let subtype: String?
    private let type: String?
    private let flavor: String?
    
    init(imageUrlString: String, hp: String, name: String, supertype: String, type: String?, flavor: String?, subtype: String?) {
        self.imageUrlString = imageUrlString
        self.hp = hp
        self.name = name
        self.type = type
        self.supertype = supertype
        self.flavor = flavor
        self.subtype = subtype
    }
    
    var presentableName: String {
        name
    }
    
    var presentableType: String {
        if let type = type {
            return "\(type) Hp: \(hp)"
        }
        
        return "Hp: \(hp)"
    }
    
    var presentableFlavor: String {
        flavor ?? "-"
    }
    
    var imageUrl: URL? {
        URL(string: imageUrlString)
    }
    
    var presentableSubtype: String {
        if let subtype = subtype {
            return "\(supertype) - \(subtype)"
        }
        
        return supertype
    }
}
