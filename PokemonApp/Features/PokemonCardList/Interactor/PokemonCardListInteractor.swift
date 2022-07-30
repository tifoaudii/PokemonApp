//
//  PokemonCardListInteractor.swift
//  PokemonApp
//
//  Created by Tifo Audi Alif Putra on 28/07/22.
//

import Foundation

enum PokemonCardListState {
    case initial
    case loading
    case error
    case populated
}

protocol PokemonCardListInteractor {
    var state: PokemonCardListState { get }
    
    func registerStateObserver(_ action: @escaping (PokemonCardListState) -> Void)
    func fetchPokemons(completion: @escaping (Result<[PokemonData], Error>) -> Void)
    func loadMorePokemons(completion: @escaping (Result<[PokemonData], Error>) -> Void)
}

final class PokemonCardListInteractorAdapter: PokemonCardListInteractor {
    
    private let service: NetworkService
    
    init(service: NetworkService) {
        self.service = service
    }
    
    private var didChangeState: ((PokemonCardListState) -> Void)?
    private var page: Int = 1
    private var isLoadMorePokemons = false
    
    var state: PokemonCardListState = .initial {
        didSet {
            didChangeState?(state)
        }
    }
    
    func registerStateObserver(_ action: @escaping (PokemonCardListState) -> Void) {
        didChangeState = action
    }
    
    func fetchPokemons(completion: @escaping (Result<[PokemonData], Error>) -> Void) {
        state = .loading
        
        let usecase = GetPokemonUseCase(page: 1, pageSize: 20)
        service.request(usecase) { [weak self] result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self?.state = .populated
                    completion(.success(response.data))
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    self?.state = .error
                    completion(.failure(error))
                }
            }
        }
    }
    
    func loadMorePokemons(completion: @escaping (Result<[PokemonData], Error>) -> Void) {
        guard !isLoadMorePokemons else { return }
        
        isLoadMorePokemons = true
        page += 1
        
        let usecase = GetPokemonUseCase(page: page, pageSize: 20)
        service.request(usecase) { [weak self] result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    completion(.success(response.data))
                }
            case .failure(let error):
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
            
            self?.isLoadMorePokemons = false
        }
    }
}
