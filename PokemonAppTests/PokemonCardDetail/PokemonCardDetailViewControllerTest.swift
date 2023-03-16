//
//  PokemonCardDetailViewControllerTest.swift
//  PokemonAppTests
//
//  Created by Tifo Audi Alif Putra on 31/07/22.
//

@testable import PokemonApp
import XCTest

class PokemonCardDetailViewControllerTest: XCTestCase {
    
    func testViewController_whenViewDidLoad_shouldLoadUI() {
        let interactor = PokemonCardDetailInteractorSpy(pokemonData: PokemonResponse.mockData())
        let sut = PokemonCardDetailViewController(interactor: interactor, didSelectPokemonImage: {_,_ in })
        
        sut.loadViewIfNeeded()
        XCTAssertNotNil(sut.collectionView)
        XCTAssertNotNil(sut.footerLoadingView)
    }
    
    func testViewController_whenViewDidLoad_shouldRenderCardDetailCell() {
        let interactor = PokemonCardDetailInteractorSpy(pokemonData: PokemonResponse.mockData())
        let sut = PokemonCardDetailViewController(interactor: interactor, didSelectPokemonImage: {_,_ in })
        
        sut.loadViewIfNeeded()
        XCTAssertEqual(sut.collectionView.numberOfItems(inSection: 0), 1)
        let cell = sut.collectionView.dataSource?.collectionView(sut.collectionView, cellForItemAt: .init(item: 0, section: 0)) as? PokemonCardDetailCell
        XCTAssertNotNil(cell)
        XCTAssertEqual(cell?.pokemonNameLabel.text, interactor.pokemonDetailViewModel.presentableName)
        XCTAssertEqual(cell?.pokemonDescLabel.text, interactor.pokemonDetailViewModel.presentableType)
        XCTAssertEqual(cell?.pokemonTypeLabel.text, interactor.pokemonDetailViewModel.presentableSubtype)
        XCTAssertEqual(cell?.pokemonFlavorLabel.text, interactor.pokemonDetailViewModel.presentableFlavor)
        
        var tapImageCalled = false
        cell?.pokemonImageView.image = .init()
        cell?.didTapImage = { _ in
            tapImageCalled = true
        }
        
        cell?.didTapImage?((cell?.pokemonImageView.image!)!)
        XCTAssertTrue(tapImageCalled)
    }
    
    func testViewController_whenViewDidLoad_shouldRegisterStateObserver() {
        let interactor = PokemonCardDetailInteractorSpy(pokemonData: PokemonResponse.mockData())
        let sut = PokemonCardDetailViewController(interactor: interactor, didSelectPokemonImage: {_,_ in })
        
        sut.loadViewIfNeeded()
        XCTAssertTrue(interactor.registerStateObserverCalled)
        XCTAssertNotNil(interactor.stateObserver)
    }
    
    func testViewController_whenViewDidLoad_shouldFetchPokemons() {
        let interactor = PokemonCardDetailInteractorSpy(pokemonData: PokemonResponse.mockData())
        let sut = PokemonCardDetailViewController(interactor: interactor, didSelectPokemonImage: {_,_ in })
        
        sut.loadViewIfNeeded()
        XCTAssertTrue(interactor.fetchPokemonsCalled)
        XCTAssertNotNil(interactor.fetchPokemonsCompletion)
    }
    
    func testViewController_whenSucceedFetchPokemons_shouldDisplayToCollectionView() {
        let interactor = PokemonCardDetailInteractorSpy(pokemonData: PokemonResponse.mockData())
        let sut = PokemonCardDetailViewController(interactor: interactor, didSelectPokemonImage: {_,_ in })
        
        sut.loadViewIfNeeded()
        interactor.fetchPokemonsCompletion?(.success(PokemonCardViewModel.makeMock()))
        XCTAssertEqual(sut.collectionView.numberOfItems(inSection: 1), 2)
        let cell = sut.collectionView.dataSource?.collectionView(sut.collectionView, cellForItemAt: .init(item: 0, section: 1)) as? PokemonCardCell
        XCTAssertNotNil(cell)
    }
    
    func testViewController_whenFailedFetchPokemons_shouldDisplayToCollectionView() {
        let interactor = PokemonCardDetailInteractorSpy(pokemonData: PokemonResponse.mockData())
        let sut = PokemonCardDetailViewController(interactor: interactor, didSelectPokemonImage: {_,_ in })
        
        sut.loadViewIfNeeded()
        interactor.fetchPokemonsCompletion?(.failure(ErrorResponse.invalidResponse))
        
        XCTAssertEqual(sut.collectionView.numberOfItems(inSection: 1), 1)
        let cell = sut.collectionView.dataSource?.collectionView(sut.collectionView, cellForItemAt: .init(item: 0, section: 1)) as? PokemonCardErrorCell
        XCTAssertNotNil(cell)
    }
    
    func testViewController_whenFetchingPokemons_shouldDisplaySkeletonView() {
        let interactor = PokemonCardDetailInteractorSpy(pokemonData: PokemonResponse.mockData())
        let sut = PokemonCardDetailViewController(interactor: interactor, didSelectPokemonImage: {_,_ in })
        
        sut.loadViewIfNeeded()
        
        XCTAssertEqual(sut.collectionView.numberOfItems(inSection: 1), 10)
        let cell = sut.collectionView.dataSource?.collectionView(sut.collectionView, cellForItemAt: .init(item: 0, section: 1)) as? PokemonSkeletonCell
        XCTAssertNotNil(cell)
    }
    
    func testViewController_whenSucceedLoadMorePokemons_shouldAppendNewData() {
        let interactor = PokemonCardDetailInteractorSpy(pokemonData: PokemonResponse.mockData())
        let sut = PokemonCardDetailViewController(interactor: interactor, didSelectPokemonImage: {_,_ in })
        
        sut.loadViewIfNeeded()
        interactor.fetchPokemonsCompletion?(.success(PokemonCardViewModel.makeMock()))
        
        XCTAssertEqual(sut.collectionView.numberOfItems(inSection: 1), 2)
        
        sut.loadMorePokemons()
        interactor.loadMorePokemonsCompletion?(.success(PokemonCardViewModel.makeMock()))
        
        XCTAssertTrue(interactor.loadMorePokemonsCalled)
        XCTAssertEqual(sut.collectionView.numberOfItems(inSection: 1), 4)
    }
    
    func testViewController_whenFailedLoadMorePokemons_shouldAppendNewData() {
        let interactor = PokemonCardDetailInteractorSpy(pokemonData: PokemonResponse.mockData())
        let sut = PokemonCardDetailViewController(interactor: interactor, didSelectPokemonImage: {_,_ in })
        
        sut.loadViewIfNeeded()
        interactor.fetchPokemonsCompletion?(.success(PokemonCardViewModel.makeMock()))
        
        XCTAssertEqual(sut.collectionView.numberOfItems(inSection: 1), 2)
        
        sut.loadMorePokemons()
        interactor.loadMorePokemonsCompletion?(.failure(ErrorResponse.invalidResponse))
        
        XCTAssertTrue(interactor.loadMorePokemonsCalled)
        XCTAssertEqual(sut.collectionView.numberOfItems(inSection: 1), 2)
    }
}

// MARK: Helper
private class PokemonCardDetailInteractorSpy: PokemonCardDetailInteractor {
    
    let pokemonData: PokemonData
    
    var registerStateObserverCalled = false
    var fetchPokemonsCalled = false
    var loadMorePokemonsCalled = false
    
    var stateObserver: ((PokemonCardListState) -> Void)?
    var fetchPokemonsCompletion: ((Result<[PokemonCardViewModel], Error>) -> Void)?
    var loadMorePokemonsCompletion: ((Result<[PokemonCardViewModel], Error>) -> Void)?
    
    init(pokemonData: PokemonData) {
        self.pokemonData = pokemonData
    }
    
    var state: PokemonCardListState = .initial
    
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
    
    func registerStateObserver(_ action: @escaping (PokemonCardListState) -> Void) {
        registerStateObserverCalled = true
        stateObserver = action
    }
    
    func fetchPokemons(completion: @escaping ((Result<[PokemonCardViewModel], Error>) -> Void)) {
        fetchPokemonsCalled = true
        state = .loading
        fetchPokemonsCompletion = { result in
            switch result {
            case .success(let data):
                self.state = .populated
                completion(.success(data))
            case .failure(let error):
                self.state = .error
                completion(.failure(error))
            }
        }
    }
    
    func loadMorePokemons(completion: @escaping ((Result<[PokemonCardViewModel], Error>) -> Void)) {
        loadMorePokemonsCalled = true
        loadMorePokemonsCompletion = { result in
            switch result {
            case .success(let data):
                completion(.success(data))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
