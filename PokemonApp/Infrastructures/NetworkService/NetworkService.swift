//
//  NetworkService.swift
//  PokemonApp
//
//  Created by Tifo Audi Alif Putra on 28/07/22.
//

import Foundation

enum HTTPMethod: String {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

enum ErrorResponse: Error {
    case invalidEndpoint
    case invalidResponse
    case noData
    case serializationError
}

protocol NetworkService {
    func request<U: UseCase>(_ usecase: U, completion: @escaping (Result<U.Response, Error>) -> Void)
}

final class URLSessionNetworkService: NetworkService {
    
    private let session: URLSession
    
    init(session: URLSession = .init(configuration: .default)) {
        self.session = session
    }
    
    func request<U: UseCase>(_ usecase: U, completion: @escaping (Result<U.Response, Error>) -> Void) {
        
        guard let urlRequest = makeURLRequest(usecase) else {
            return completion(.failure(ErrorResponse.invalidEndpoint))
        }
        
        session.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                return completion(.failure(error))
            }
            
            guard let response = response as? HTTPURLResponse, 200..<300 ~= response.statusCode else {
                return completion(.failure(ErrorResponse.invalidResponse))
            }
            
            guard let data = data else {
                return completion(.failure(ErrorResponse.noData))
            }

            do {
                let response = try usecase.map(data)
                completion(.success(response))
            } catch {
                completion(.failure(ErrorResponse.serializationError))
            }
        }
        .resume()
    }
    
    private func makeURLRequest<U: UseCase>(_ usecase: U) -> URLRequest? {
        guard var urlComponent = URLComponents(string: usecase.url) else {
            return nil
        }
        
        var queryItems: [URLQueryItem] = []
        
        usecase.queryItems.forEach {
            let urlQueryItem = URLQueryItem(name: $0.key, value: $0.value)
            urlComponent.queryItems?.append(urlQueryItem)
            queryItems.append(urlQueryItem)
        }
        
        urlComponent.queryItems = queryItems
        
        guard let url = urlComponent.url else {
            return nil
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = usecase.method.rawValue
        urlRequest.allHTTPHeaderFields = usecase.headers
        return urlRequest
    }
}
