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
        searchBar.placeholder = "search pokemon cards"
        return searchBar
    }()
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        layout.scrollDirection = .vertical
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    private var data: [PokemonData] = []
    
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
                self?.collectionView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func registerStateObserver() {
        interactor.registerStateObserver { [weak self] _ in
            self?.collectionView.reloadData()
        }
    }
    
    private func configureRootView() {
        navigationItem.titleView = searchBar
        let searchTextField = searchBar.value(forKey: "searchField") as? UITextField
        searchTextField?.textColor = .white
        
        view.backgroundColor = .black
        view.addSubview(collectionView)
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor, constant: 80),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func configureCollectionView() {
        collectionView.register(PokemonCardCell.self, forCellWithReuseIdentifier: PokemonCardCell.identifier)
        collectionView.register(PokemonSkeletonCell.self, forCellWithReuseIdentifier: PokemonSkeletonCell.identifier)
        collectionView.dataSource = self
        collectionView.delegate = self
    }
}

extension PokemonCardListViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if interactor.state == .loading {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PokemonSkeletonCell.identifier, for: indexPath) as? PokemonSkeletonCell else {
                return PokemonSkeletonCell()
            }
            cell.startShimmering()
            return cell
        }
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PokemonCardCell.identifier, for: indexPath) as? PokemonCardCell else {
            return PokemonCardCell()
        }
        
        cell.bindView(with: data[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        interactor.state == .populated ? data.count : 10
    }
}

extension PokemonCardListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width / 2, height: view.frame.height / 2)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
}
