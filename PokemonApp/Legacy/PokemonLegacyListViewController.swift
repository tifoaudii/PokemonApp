//
//  PokemonLegacyListViewController.swift
//  PokemonApp
//
//  Created by Tifo Audi Alif Putra on 22/10/22.
//

import UIKit

class PokemonLegacyListViewController: UIViewController {
    
    enum State {
        case initial
        case success
        case failure
    }
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        layout.scrollDirection = .vertical
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .clear
        return collectionView
    }()
    
    var data: [PokemonCardViewModel] = []
    
    var state: State = .initial {
        didSet {
            self.collectionView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureRootView()
        configureCollectionView()
        
        PokemonLegacyService.shared.fetchPokemons { [weak self] result in
            guard let self = self else { return }
            switch result {
            case .success(let data):
                self.data = data
                self.state = .success
            case .failure(_):
                self.state = .failure
            }
        }
    }
    
    private func configureRootView() {
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = .black
        
        view.backgroundColor = .black
        view.addSubview(collectionView)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
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

extension PokemonLegacyListViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if state == .success {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PokemonCardCell.identifier, for: indexPath) as? PokemonCardCell else {
                return PokemonCardCell()
            }
            
            cell.bindView(with: data[indexPath.row])
            return cell
        } else if state == .failure {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PokemonCardErrorCell.identifier, for: indexPath) as? PokemonCardErrorCell else {
                return PokemonCardErrorCell()
            }
            
            return cell
        }
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PokemonSkeletonCell.identifier, for: indexPath) as? PokemonSkeletonCell else {
            return PokemonSkeletonCell()
        }
        cell.startShimmering()
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if state == .success {
            return data.count
        } else if state == .failure {
            return 1
        }
        
        return 5
    }
}

extension PokemonLegacyListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if state == .success || state == .initial {
            return .init(width: view.frame.width / 2, height: view.frame.height / 2.3)
        }
        
        return .init(width: view.frame.width, height: view.frame.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
}
