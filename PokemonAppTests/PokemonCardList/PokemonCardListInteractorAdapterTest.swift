//
//  PokemonCardListInteractorAdapterTest.swift
//  PokemonAppTests
//
//  Created by Tifo Audi Alif Putra on 31/07/22.
//

@testable import PokemonApp
import XCTest

class PokemonCardListInteractorAdapterTest: XCTestCase {
    
    func testInteractor_initializeStateObserver() {
        let service = NetworkServiceSpy()
        let sut = PokemonCardListInteractorAdapter(service: service) { _ in }
        var stateObserverFired = false
        
        let stateObserver: ((PokemonCardListState) -> Void) = { state in
            stateObserverFired = true
            XCTAssertEqual(state, .loading)
        }
        
        sut.registerStateObserver(stateObserver)
        sut.state = .loading
        XCTAssertTrue(stateObserverFired)
    }
}

