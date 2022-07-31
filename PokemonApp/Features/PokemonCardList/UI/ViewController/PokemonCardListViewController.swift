//
//  ViewController.swift
//  PokemonApp
//
//  Created by Tifo Audi Alif Putra on 28/07/22.
//

import UIKit

final class PokemonCardListViewController: UIViewController {
    
    let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.sizeToFit()
        searchBar.barStyle = .default
        searchBar.searchBarStyle = .minimal
        searchBar.backgroundColor = .black
        searchBar.tintColor = .white
        searchBar.showsCancelButton = true
        searchBar.placeholder = "search pokemon cards"
        searchBar.enablesReturnKeyAutomatically = false
        return searchBar
    }()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        layout.scrollDirection = .vertical
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    let footerLoadingView: FooterLoadingView = FooterLoadingView()
    
    private var data: [PokemonCardViewModel] = []
    private var footerHeightConstraint: NSLayoutConstraint?
    private var collectionViewBottomConstraint: NSLayoutConstraint?
    
    private let interactor: PokemonCardListInteractor
    
    init(interactor: PokemonCardListInteractor) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("Should implement initializer")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureRootView()
        configureCollectionView()
        registerStateObserver()
        fetchPokemons()
    }
    
    func fetchPokemons() {
        interactor.fetchPokemons { [weak self] result in
            switch result {
            case .success(let data):
                self?.data = data
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func loadMorePokemons() {
        interactor.loadMorePokemons { [weak self] result in
            switch result {
            case .success(let newData):
                self?.data.append(contentsOf: newData)
                self?.collectionView.reloadData()
                self?.footerHeightConstraint?.constant = 0
                self?.collectionViewBottomConstraint?.constant = 0
                self?.footerLoadingView.stopAnimating()
            case .failure(_):
                self?.footerHeightConstraint?.constant = 0
                self?.collectionViewBottomConstraint?.constant = 0
                self?.footerLoadingView.stopAnimating()
            }
        }
    }
    
    func registerStateObserver() {
        interactor.registerStateObserver { [weak self] _ in
            self?.collectionView.reloadData()
        }
    }
    
    func searchPokemons(withQuery query: String) {
        interactor.searchPokemons(withQuery: query) { [weak self] result in
            switch result {
            case .success(let data):
                self?.data = data
            case .failure(let error):
                print(error)
            }
        }
    }
    
    private func configureRootView() {
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = .black
        navigationItem.titleView = searchBar
        
        let searchTextField = searchBar.value(forKey: "searchField") as? UITextField
        searchTextField?.textColor = .white
        searchBar.delegate = self
        
        view.backgroundColor = .black
        view.addSubview(collectionView)
        view.addSubview(footerLoadingView)
        
        footerHeightConstraint = footerLoadingView.heightAnchor.constraint(equalToConstant: 0)
        collectionViewBottomConstraint = collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0)
        
        footerHeightConstraint?.isActive = true
        collectionViewBottomConstraint?.isActive = true
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            
            footerLoadingView.topAnchor.constraint(equalTo: collectionView.bottomAnchor),
            footerLoadingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            footerLoadingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        ])
    }
    
    private func configureCollectionView() {
        collectionView.register(PokemonCardCell.self, forCellWithReuseIdentifier: PokemonCardCell.identifier)
        collectionView.register(PokemonSkeletonCell.self, forCellWithReuseIdentifier: PokemonSkeletonCell.identifier)
        collectionView.register(PokemonCardErrorCell.self, forCellWithReuseIdentifier: PokemonCardErrorCell.identifier)
        collectionView.register(PokemonEmptyCell.self, forCellWithReuseIdentifier: PokemonEmptyCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
}

extension PokemonCardListViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch interactor.state {
        case .loading:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PokemonSkeletonCell.identifier, for: indexPath) as? PokemonSkeletonCell else {
                return PokemonSkeletonCell()
            }
            cell.startShimmering()
            return cell
        case .error:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PokemonCardErrorCell.identifier, for: indexPath) as? PokemonCardErrorCell else {
                return PokemonCardErrorCell()
            }
            
            cell.didSelectReloadButton = { [weak self] in
                self?.fetchPokemons()
            }
            
            return cell
        case .empty:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PokemonEmptyCell.identifier, for: indexPath) as? PokemonEmptyCell else {
                return PokemonEmptyCell()
            }
            
            return cell
        case .populated:
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PokemonCardCell.identifier, for: indexPath) as? PokemonCardCell else {
                return PokemonCardCell()
            }
            
            cell.bindView(with: data[indexPath.row])
            return cell
        default:
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch interactor.state {
        case .error, .initial, .empty:
            return 1
        case .loading:
            return 10
        case .populated:
            return data.count
        }
    }
}

extension PokemonCardListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if interactor.state == .error || interactor.state == .empty {
            return .init(width: view.frame.width, height: view.frame.height)
        }
        
        return .init(width: view.frame.width / 2, height: view.frame.height / 2.3)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        data[indexPath.item].selection()
    }
}

extension PokemonCardListViewController {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > scrollView.contentSize.height - (scrollView.contentInset.bottom + scrollView.bounds.height) {
            footerHeightConstraint?.constant = 44
            collectionViewBottomConstraint?.constant = -44
            footerLoadingView.startAnimating()
            loadMorePokemons()
        }
    }
}

extension PokemonCardListViewController: UISearchBarDelegate {
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let query = searchBar.text else { return }
        searchBar.endEditing(true)
        searchPokemons(withQuery: query)
    }
}
