//
//  PokemonCardCell.swift
//  PokemonApp
//
//  Created by Tifo Audi Alif Putra on 28/07/22.
//

import UIKit
import Kingfisher

final class PokemonCardCell: UICollectionViewCell {
    
    static let identifier: String = String(describing: PokemonCardCell.self)
    
    let pokemonImageView: UIImageView = UIImageView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureView()
    }
    
    private func configureView() {
        pokemonImageView.translatesAutoresizingMaskIntoConstraints = false
        pokemonImageView.backgroundColor = .lightGray.withAlphaComponent(0.4)
        contentView.addSubview(pokemonImageView)
        NSLayoutConstraint.activate([
            pokemonImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            pokemonImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 6),
            pokemonImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -6),
            pokemonImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6)
        ])
    }
    
    func bindView(with data: PokemonCardViewModel) {
        pokemonImageView.kf.setImage(with: data.imageUrl)
    }
}
