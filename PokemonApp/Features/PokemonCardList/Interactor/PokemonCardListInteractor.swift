//
//  PokemonCardListInteractor.swift
//  PokemonApp
//
//  Created by Tifo Audi Alif Putra on 28/07/22.
//

import Foundation

enum PokemonCardListState {
    case initial
    case empty
    case loading
    case error
    case populated
}

protocol PokemonCardListInteractor {
    var state: PokemonCardListState { get }
    
    func registerStateObserver(_ action: @escaping (PokemonCardListState) -> Void)
    func fetchPokemons(completion: @escaping (Result<[PokemonCardViewModel], Error>) -> Void)
    func loadMorePokemons(completion: @escaping (Result<[PokemonCardViewModel], Error>) -> Void)
    func searchPokemons(withQuery query: String, completion: @escaping (Result<[PokemonCardViewModel], Error>) -> Void)
}

final class PokemonCardListInteractorAdapter: PokemonCardListInteractor {
    
    private let service: NetworkService
    private let selection: (PokemonData) -> Void
    
    init(service: NetworkService, selection: @escaping (PokemonData) -> Void) {
        self.service = service
        self.selection = selection
    }
    
    private var didChangeState: ((PokemonCardListState) -> Void)?
    private var searchQuery: String?
    
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
    
    func fetchPokemons(completion: @escaping (Result<[PokemonCardViewModel], Error>) -> Void) {
        state = .loading
        
        let usecase = GetPokemonUseCase(page: 1, pageSize: 20)
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
    
    func searchPokemons(withQuery query: String, completion: @escaping (Result<[PokemonCardViewModel], Error>) -> Void) {
        searchQuery = query.isEmpty ? nil : query
        state = .loading
        
        let usecase = GetPokemonUseCase(page: 1, pageSize: 20, query: searchQuery)
        service.request(usecase) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self.state = response.data.isEmpty ? .empty : .populated
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
    
    func loadMorePokemons(completion: @escaping (Result<[PokemonCardViewModel], Error>) -> Void) {
        guard !isLoadMorePokemons else { return }
        
        isLoadMorePokemons = true
        page += 1
        
        let usecase = GetPokemonUseCase(page: page, pageSize: 20, query: searchQuery)
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
    
    private func makePokemonCardViewModels(_ pokemon: [PokemonData]) -> [PokemonCardViewModel] {
        pokemon.map { data in
            PokemonCardViewModel(imageUrlString: data.images.small) { [weak self] in
                self?.selection(data)
            }
        }
    }
}
