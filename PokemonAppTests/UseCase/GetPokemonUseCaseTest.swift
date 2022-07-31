//
//  GetPokemonUseCase.swift
//  PokemonAppTests
//
//  Created by Tifo Audi Alif Putra on 31/07/22.
//

@testable import PokemonApp
import XCTest

class GetPokemonUseCaseTest: XCTestCase {
    
    func testGetPokemonUseCase_whenInitializedWithPageAndPageSize() {
        let sut = GetPokemonUseCase(page: 1, pageSize: 20)
        XCTAssertEqual(sut.url, "https://api.pokemontcg.io/v2/cards")
        XCTAssertEqual(sut.method, .get)
        XCTAssertEqual(sut.queryItems, ["page": "1", "pageSize":"20"])
    }
    
    func testGetPokemonUseCase_whenInitializedWithTypeParam() {
        let sut = GetPokemonUseCase(page: 1, pageSize: 20, type: "SomeType")
        XCTAssertEqual(sut.queryItems, ["page": "1", "pageSize":"20", "q": "types:SomeType"])
    }
    
    func testGetPokemonUseCase_whenInitializedWithQueryParam() {
        let sut = GetPokemonUseCase(page: 1, pageSize: 20, query: "SomeQuery")
        XCTAssertEqual(sut.queryItems, ["page": "1", "pageSize":"20", "q": "name:SomeQuery"])
    }
    
    func testGetPokemonUseCase_mapToPokemonResponse() {
        let sut = GetPokemonUseCase(page: 1, pageSize: 20)

        let data = Data(PokemonResponse.fakeJSON().utf8)
        let response = try? sut.map(data)
        XCTAssertNotNil(response)
    }
}
