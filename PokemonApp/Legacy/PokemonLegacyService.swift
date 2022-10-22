//
//  PokemonLegacyService.swift
//  PokemonApp
//
//  Created by Tifo Audi Alif Putra on 22/10/22.
//

import Foundation

class PokemonLegacyService {
    
    static let shared: PokemonLegacyService = PokemonLegacyService()
    
    private let service: URLSessionNetworkService = URLSessionNetworkService()
    
    func fetchPokemons(completion: @escaping (Result<[PokemonCardViewModel], Error>) -> Void) {
        let usecase = GetPokemonUseCase(page: 1, pageSize: 20)
        service.request(usecase) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    completion(.success(self.makePokemonCardViewModels(response.data)))
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }
    }
    
    private func makePokemonCardViewModels(_ pokemon: [PokemonData]) -> [PokemonCardViewModel] {
        pokemon.map { data in
            PokemonCardViewModel(imageUrlString: data.images.small) {}
        }
    }
}
