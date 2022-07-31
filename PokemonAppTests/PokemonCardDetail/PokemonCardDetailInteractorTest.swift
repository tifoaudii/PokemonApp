//
//  PokemonCardDetailInteractorTest.swift
//  PokemonAppTests
//
//  Created by Tifo Audi Alif Putra on 31/07/22.
//

@testable import PokemonApp
import XCTest

class PokemonCardDetailInteractorTest: XCTestCase {
    
    func testInteractor_shouldInitializeStateObserver() {
        let service = NetworkServiceSpy()
        let sut = PokemonCardDetailInteractorAdapter(service: service, pokemonData: PokemonResponse.mockData(), selection: { _ in })
        var stateObserverFired = false
        
        let stateObserver: ((PokemonCardListState) -> Void) = { state in
            stateObserverFired = true
            XCTAssertEqual(state, .loading)
        }
        
        sut.registerStateObserver(stateObserver)
        sut.state = .loading
        XCTAssertTrue(stateObserverFired)
    }
    
    func testInteractor_whenSuccessFetchPokemons() {
        let service = NetworkServiceSpy()
        let sut = PokemonCardDetailInteractorAdapter(service: service, pokemonData: PokemonResponse.mockData(), selection: { _ in })
        
        XCTAssertEqual(sut.state, .initial)
        sut.fetchPokemons { result in
            XCTAssertEqual(sut.state, .loading)
            switch result {
            case .success(let data):
                XCTAssertEqual(data.count, 1)
                XCTAssertEqual(sut.state, .populated)
            default:
                break
            }
        }
        
        service.requestCompletion?(.success(PokemonResponse.makeMock()))
        XCTAssertTrue(service.requestCalled)
    }
    
    func testInteractor_whenFailedFetchPokemons() {
        let service = NetworkServiceSpy()
        let sut = PokemonCardDetailInteractorAdapter(service: service, pokemonData: PokemonResponse.mockData(), selection: { _ in })
        
        XCTAssertEqual(sut.state, .initial)
        sut.fetchPokemons { result in
            XCTAssertEqual(sut.state, .loading)
            switch result {
            case .failure(let error):
                XCTAssertEqual(error as! ErrorResponse, ErrorResponse.invalidResponse)
                XCTAssertEqual(sut.state, .error)
            default:
                break
            }
        }
        
        service.requestCompletion?(.failure(ErrorResponse.invalidResponse))
        XCTAssertTrue(service.requestCalled)
    }
}
