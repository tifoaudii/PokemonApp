//
//  PokemonSkeletonCell.swift
//  PokemonApp
//
//  Created by Tifo Audi Alif Putra on 28/07/22.
//

import UIKit

final class PokemonSkeletonCell: UICollectionViewCell {
    
    static let identifier: String = String(describing: PokemonSkeletonCell.self)
    
    private let view: UIView = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureView()
    }
    
    private func configureView() {
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .lightGray.withAlphaComponent(0.3)
        contentView.addSubview(view)
        
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            view.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 6),
            view.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -6),
            view.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6)
        ])
    }
    
    func startShimmer() {
        view.startShimmering()
    }
}
