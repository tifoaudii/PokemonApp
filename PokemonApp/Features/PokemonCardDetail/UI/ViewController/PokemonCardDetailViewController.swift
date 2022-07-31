//
//  PokemonCardDetailViewController.swift
//  PokemonApp
//
//  Created by Tifo Audi Alif Putra on 30/07/22.
//

import UIKit

final class PokemonCardDetailViewController: UIViewController {
    
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
    
    private let interactor: PokemonCardDetailInteractor
    
    init(interactor: PokemonCardDetailInteractor) {
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
    
    private func configureRootView() {
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.barTintColor = .black
        
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
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(PokemonCardDetailCell.self, forCellWithReuseIdentifier: PokemonCardDetailCell.identifier)
        collectionView.register(PokemonCardCell.self, forCellWithReuseIdentifier: PokemonCardCell.identifier)
        collectionView.register(PokemonSkeletonCell.self, forCellWithReuseIdentifier: PokemonSkeletonCell.identifier)
        collectionView.register(PokemonCardErrorCell.self, forCellWithReuseIdentifier: PokemonCardErrorCell.identifier)
    }
}

extension PokemonCardDetailViewController: UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        
        switch interactor.state {
        case .populated:
            return data.count
        case .error, .initial, .empty:
            return 1
        case .loading:
            return 10
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: PokemonCardDetailCell.identifier, for: indexPath) as? PokemonCardDetailCell else {
                return PokemonCardDetailCell()
            }
            
            cell.bindView(data: interactor.pokemonDetailViewModel)
            cell.didTapImage = { [weak self] image in
                let imageViewController: PokemonImageViewController = PokemonImageViewController()
                imageViewController.imageView.image = image
                imageViewController.modalPresentationStyle = .overFullScreen
                self?.present(imageViewController, animated: true)
            }
            return cell
        }
        
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
}

extension PokemonCardDetailViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return .init(width: view.frame.width, height: view.frame.height * 0.75)
        }
        
        return interactor.state == .error ? .init(width: view.frame.width, height: view.frame.height) : .init(width: view.frame.width / 2, height: view.frame.height / 2.3)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        data[indexPath.item].selection()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        10
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y > scrollView.contentSize.height - (scrollView.contentInset.bottom + scrollView.bounds.height) {
            footerHeightConstraint?.constant = 44
            collectionViewBottomConstraint?.constant = -44
            footerLoadingView.startAnimating()
            loadMorePokemons()
        }
    }
}
