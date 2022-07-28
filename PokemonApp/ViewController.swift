//
//  ViewController.swift
//  PokemonApp
//
//  Created by Tifo Audi Alif Putra on 28/07/22.
//

import UIKit

struct PokemonResponse: Codable {
    let data: [PokemonData]
}

struct PokemonData: Codable {
    
    let id: String
    let name: String
}

struct PokemonUseCase: UseCase {
    
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

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        
        let usecase = PokemonUseCase()
        let networkService = URLSessionNetworkService()
        networkService.request(usecase) { result in
            switch result {
            case .success(let data):
                print(data)
            case .failure(let error):
                print(error)
            }
        }
    }
}

