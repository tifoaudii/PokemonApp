//
//  PokemonCardDetailInteractor.swift
//  PokemonApp
//
//  Created by Tifo Audi Alif Putra on 30/07/22.
//

import Foundation

protocol PokemonCardDetailInteractor {
    var state: PokemonCardListState { get }
    var pokemonDetailViewModel: PokemonCardDetailViewModel { get }
    
    func registerStateObserver(_ action: @escaping (PokemonCardListState) -> Void)
    func fetchPokemons(completion: @escaping ((Result<[PokemonCardViewModel], Error>) -> Void))
    func loadMorePokemons(completion: @escaping ((Result<[PokemonCardViewModel], Error>) -> Void))
}

final class PokemonCardDetailInteractorAdapter: PokemonCardDetailInteractor {
    
    private let service: NetworkService
    private let pokemonData: PokemonData
    private let selection: (PokemonData) -> Void
    
    private var didChangeState: ((PokemonCardListState) -> Void)?
    private var page: Int = 1
    private var isLoadMorePokemons = false
    
    init(service: NetworkService, pokemonData: PokemonData, selection: @escaping (PokemonData) -> Void) {
        self.service = service
        self.pokemonData = pokemonData
        self.selection = selection
    }
    
    var pokemonDetailViewModel: PokemonCardDetailViewModel {
        PokemonCardDetailViewModel(
            imageUrlString: pokemonData.images.large,
            hp: pokemonData.hp,
            name: pokemonData.name,
            supertype: pokemonData.supertype,
            type: pokemonData.types.first,
            flavor: pokemonData.flavorText,
            subtype: pokemonData.subtypes.first
        )
    }
    
    var state: PokemonCardListState = .initial {
        didSet {
            didChangeState?(state)
        }
    }
    
    func registerStateObserver(_ action: @escaping (PokemonCardListState) -> Void) {
        didChangeState = action
    }
    
    func fetchPokemons(completion: @escaping ((Result<[PokemonCardViewModel], Error>) -> Void)) {
        if let type = pokemonData.types.first {
            state = .loading
            let usecase = GetPokemonUseCase(page: 1, pageSize: 20, type: type)
            
            service.request(usecase) { [weak self] result in
                guard let self = self else { return }
                
                switch result {
                case .success(let response):
                    DispatchQueue.main.async {
                        self.state = .populated
                        completion(.success(self.makePokemonCardViewModels(response.data)))
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        self.state = .error
                        completion(.failure(error))
                    }
                }
            }
        }
    }
    
    func loadMorePokemons(completion: @escaping ((Result<[PokemonCardViewModel], Error>) -> Void)) {
        if let type = pokemonData.types.first {
            guard !isLoadMorePokemons else { return }
            
            isLoadMorePokemons = true
            page += 1
            
            let usecase = GetPokemonUseCase(page: page, pageSize: 20, type: type)
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
                
                self.isLoadMorePokemons = false
            }
        }
    }
    
    private func makePokemonCardViewModels(_ pokemon: [PokemonData]) -> [PokemonCardViewModel] {
        pokemon.filter {
            $0.id != pokemonData.id
        } .map { pokemon in
            PokemonCardViewModel(imageUrlString: pokemon.images.small) { [weak self] in
                self?.selection(pokemon)
            }
        }
    }
}
