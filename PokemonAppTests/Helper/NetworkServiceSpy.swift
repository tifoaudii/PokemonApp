//
//  NetworkServiceSpy.swift
//  PokemonAppTests
//
//  Created by Tifo Audi Alif Putra on 31/07/22.
//

@testable import PokemonApp

class NetworkServiceSpy: NetworkService {
    
    
    func request<U>(_ usecase: U, completion: @escaping (Result<U.Response, Error>) -> Void) where U : UseCase {
        
    }
    
}
