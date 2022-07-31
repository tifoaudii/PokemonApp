//
//  NetworkServiceSpy.swift
//  PokemonAppTests
//
//  Created by Tifo Audi Alif Putra on 31/07/22.
//

@testable import PokemonApp

class NetworkServiceSpy: NetworkService {
    
    var requestCalled = false
    var requestCompletion: ((Result<PokemonResponse, Error>) -> Void)?
    
    func request<U>(_ usecase: U, completion: @escaping (Result<U.Response, Error>) -> Void) where U : UseCase {
        requestCalled = true
        requestCompletion = { result in
            switch result {
            case .success(let response):
                completion(.success(response as! U.Response))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
}
