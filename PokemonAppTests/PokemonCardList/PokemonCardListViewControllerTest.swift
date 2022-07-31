//
//  PokemonCardListViewControllerTest.swift
//  PokemonAppTests
//
//  Created by Tifo Audi Alif Putra on 31/07/22.
//

@testable import PokemonApp
import XCTest

class PokemonCardListViewControllerTest: XCTestCase {
    
    func testViewController_whenViewDidLoad_shouldInitializeAllUI() {
        let interactor = PokemonCardListInteractorSpy()
        let sut = PokemonCardListViewController(interactor: interactor)
        
        sut.loadViewIfNeeded()
        
        XCTAssertNotNil(sut.searchBar)
        XCTAssertNotNil(sut.collectionView)
        XCTAssertNotNil(sut.footerLoadingView)
        XCTAssertNotNil(sut.navigationItem.titleView)
    }
    
    func testViewController_whenViewDidLoad_shouldRegisterStateObserver() {
        let interactor = PokemonCardListInteractorSpy()
        let sut = PokemonCardListViewController(interactor: interactor)
        
        sut.loadViewIfNeeded()
        XCTAssertTrue(interactor.registerStateObserverCalled)
        XCTAssertNotNil(interactor.stateObserver)
    }
    
    func testViewController_whenViewDidLoad_shouldFetchPokemons() {
        let interactor = PokemonCardListInteractorSpy()
        let sut = PokemonCardListViewController(interactor: interactor)
        
        sut.loadViewIfNeeded()
        XCTAssertTrue(interactor.fetchPokemonsCalled)
        XCTAssertNotNil(interactor.fetchPokemonsCompletion)
    }
    
    func testViewController_whenSucceedFetchPokemons_shouldRenderToCollectionView() {
        
        let interactor = PokemonCardListInteractorSpy()
        let sut = PokemonCardListViewController(interactor: interactor)
        
        sut.loadViewIfNeeded()
        interactor.fetchPokemonsCompletion?(.success(PokemonCardViewModel.makeMock()))
        
        XCTAssertEqual(sut.collectionView.numberOfItems(inSection: 0), 2)
        let cell = sut.collectionView.dataSource?.collectionView(sut.collectionView, cellForItemAt: .init(item: 0, section: 0)) as? PokemonCardCell
        XCTAssertNotNil(cell)
    }
    
    func testViewController_whenFailedFetchPokemons_shouldDisplayErrorState() {
        let interactor = PokemonCardListInteractorSpy()
        let sut = PokemonCardListViewController(interactor: interactor)
        
        sut.loadViewIfNeeded()
        interactor.fetchPokemonsCompletion?(.failure(ErrorResponse.invalidResponse))
        
        XCTAssertEqual(sut.collectionView.numberOfItems(inSection: 0), 1)
        let cell = sut.collectionView.dataSource?.collectionView(sut.collectionView, cellForItemAt: .init(item: 0, section: 0)) as? PokemonCardErrorCell
        XCTAssertNotNil(cell)

    }
    
    func testViewController_whenFetchingPokemons_shouldDisplaySkeletonView() {
        let interactor = PokemonCardListInteractorSpy()
        let sut = PokemonCardListViewController(interactor: interactor)
        
        sut.loadViewIfNeeded()
        
        XCTAssertEqual(sut.collectionView.numberOfItems(inSection: 0), 10)
        let cell = sut.collectionView.dataSource?.collectionView(sut.collectionView, cellForItemAt: .init(item: 0, section: 0)) as? PokemonSkeletonCell
        XCTAssertNotNil(cell)
    }
    
    func testViewController_whenSucceedLoadMorePokemons_shouldAppendNewData() {
        let interactor = PokemonCardListInteractorSpy()
        let sut = PokemonCardListViewController(interactor: interactor)
        
        sut.loadViewIfNeeded()
        interactor.fetchPokemonsCompletion?(.success(PokemonCardViewModel.makeMock()))
        
        XCTAssertEqual(sut.collectionView.numberOfItems(inSection: 0), 2)
        
        sut.loadMorePokemons()
        interactor.loadMorePokemonsCompletion?(.success(PokemonCardViewModel.makeMock()))
        
        XCTAssertTrue(interactor.loadMorePokemonsCalled)
        XCTAssertEqual(sut.collectionView.numberOfItems(inSection: 0), 4)
    }
    
    func testViewController_whenFailedLoadMorePokemons_shouldNotAppendNewData() {
        let interactor = PokemonCardListInteractorSpy()
        let sut = PokemonCardListViewController(interactor: interactor)
        
        sut.loadViewIfNeeded()
        interactor.fetchPokemonsCompletion?(.success(PokemonCardViewModel.makeMock()))
        
        XCTAssertEqual(sut.collectionView.numberOfItems(inSection: 0), 2)
        
        sut.loadMorePokemons()
        interactor.loadMorePokemonsCompletion?(.failure(ErrorResponse.invalidResponse))
        
        XCTAssertTrue(interactor.loadMorePokemonsCalled)
        XCTAssertEqual(sut.collectionView.numberOfItems(inSection: 0), 2)
    }
    
    func testViewController_whenClickSearchButton_shouldSearchPokemons() {
        let interactor = PokemonCardListInteractorSpy()
        let sut = PokemonCardListViewController(interactor: interactor)
        
        sut.loadViewIfNeeded()
        sut.searchBarSearchButtonClicked(sut.searchBar)
        
        XCTAssertTrue(interactor.searchPokemonsCalled)
    }
    
    func testViewController_whenSearchPokemonIsFound_shouldDisplayCorrectData() {
        let interactor = PokemonCardListInteractorSpy()
        let sut = PokemonCardListViewController(interactor: interactor)
        
        sut.loadViewIfNeeded()
        sut.searchBarSearchButtonClicked(sut.searchBar)
        interactor.searchPokemonsCompletion?(.success(PokemonCardViewModel.makeMock()))
        
        XCTAssertEqual(sut.collectionView.numberOfItems(inSection: 0), 2)
        let cell = sut.collectionView.dataSource?.collectionView(sut.collectionView, cellForItemAt: .init(item: 0, section: 0)) as? PokemonCardCell
        XCTAssertNotNil(cell)
    }
    
    func testViewController_whenSearchPokemonIsNotFound_shouldDisplayEmptyState() {
        let interactor = PokemonCardListInteractorSpy()
        let sut = PokemonCardListViewController(interactor: interactor)
        
        sut.loadViewIfNeeded()
        sut.searchBarSearchButtonClicked(sut.searchBar)
        interactor.searchPokemonsCompletion?(.success([]))
        
        XCTAssertEqual(sut.collectionView.numberOfItems(inSection: 0), 1)
        let cell = sut.collectionView.dataSource?.collectionView(sut.collectionView, cellForItemAt: .init(item: 0, section: 0)) as? PokemonEmptyCell
        XCTAssertNotNil(cell)
    }
    
    func testViewController_whenStateIsPopulated_shouldHandleItemSelection() {
        let interactor = PokemonCardListInteractorSpy()
        let sut = PokemonCardListViewController(interactor: interactor)
        var selectionCalled = false
        
        sut.loadViewIfNeeded()
        interactor.fetchPokemonsCompletion?(.success([PokemonCardViewModel(imageUrlString: "", selection: {
            selectionCalled = true
        })]))
                                  
        sut.collectionView.selectItem(at: .init(item: 0, section: 0), animated: false, scrollPosition: .top)
        sut.collectionView.delegate?.collectionView?(sut.collectionView, didSelectItemAt: .init(item: 0, section: 0))
        
        XCTAssertTrue(selectionCalled)
    }
}

// MARK: Helper
private class PokemonCardListInteractorSpy: PokemonCardListInteractor {
    
    var fetchPokemonsCalled = false
    var registerStateObserverCalled = false
    var loadMorePokemonsCalled = false
    var searchPokemonsCalled = false
    
    var stateObserver: ((PokemonCardListState) -> Void)?
    var fetchPokemonsCompletion: ((Result<[PokemonCardViewModel], Error>) -> Void)?
    var loadMorePokemonsCompletion: ((Result<[PokemonCardViewModel], Error>) -> Void)?
    var searchPokemonsCompletion: ((Result<[PokemonCardViewModel], Error>) -> Void)?
    
    var state: PokemonCardListState = .initial {
        didSet {
            stateObserver?(state)
        }
    }
    
    func registerStateObserver(_ action: @escaping (PokemonCardListState) -> Void) {
        registerStateObserverCalled = true
        stateObserver = action
    }
    
    func fetchPokemons(completion: @escaping (Result<[PokemonCardViewModel], Error>) -> Void) {
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
    
    func loadMorePokemons(completion: @escaping (Result<[PokemonCardViewModel], Error>) -> Void) {
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
    
    func searchPokemons(withQuery query: String, completion: @escaping (Result<[PokemonCardViewModel], Error>) -> Void) {
        searchPokemonsCalled = true
        state = .loading
        searchPokemonsCompletion = { result in
            switch result {
            case .success(let data):
                self.state = data.isEmpty ? .empty : .populated
                completion(.success(data))
            case .failure(let error):
                self.state = .error
                completion(.failure(error))
            }
        }
    }
}
