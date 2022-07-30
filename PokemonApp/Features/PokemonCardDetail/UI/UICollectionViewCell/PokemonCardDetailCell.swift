//
//  PokemonCardDetailCell.swift
//  PokemonApp
//
//  Created by Tifo Audi Alif Putra on 30/07/22.
//

import UIKit

final class PokemonCardDetailCell: UICollectionViewCell {
    
    static let identifier: String = String(describing: PokemonCardDetailCell.self)
    
    let pokemonImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        imageView.setContentCompressionResistancePriority(.defaultLow, for: .vertical)
        return imageView
    }()
    
    let pokemonNameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    
    let pokemonDescLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    let pokemonTypeLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    let pokemonFlavorTitleLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "Flavor"
        label.font = .systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    
    let pokemonFlavorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.numberOfLines = 0
        return label
    }()
    
    let otherCardsLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.numberOfLines = 0
        label.text = "Other Cards"
        return label
    }()
    
    var didTapImage: ((UIImage) -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
        configureTapGesture()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureView()
        configureTapGesture()
    }
    
    func bindView(data: PokemonCardDetailViewModel) {
        pokemonImageView.kf.setImage(with: data.imageUrl)
        pokemonNameLabel.text = data.presentableName
        pokemonDescLabel.text = data.presentableType
        pokemonTypeLabel.text = data.presentableSubtype
        pokemonFlavorLabel.text = data.presentableFlavor
    }
    
    private func configureTapGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapImageAction))
        pokemonImageView.addGestureRecognizer(tapGesture)
    }
    
    private func configureView() {
        let pokemonInfoStackView: UIStackView = UIStackView(arrangedSubviews: [
            pokemonNameLabel,
            pokemonDescLabel,
            pokemonTypeLabel
        ])
        
        pokemonInfoStackView.axis = .vertical
        pokemonInfoStackView.distribution = .equalSpacing
        
        let pokemonFlavorStackView: UIStackView = UIStackView(arrangedSubviews: [
            pokemonFlavorTitleLabel,
            pokemonFlavorLabel
        ])
        
        pokemonFlavorStackView.axis = .vertical
        pokemonInfoStackView.distribution = .fillProportionally
        
        let container: UIStackView = UIStackView(arrangedSubviews: [
            pokemonImageView,
            pokemonInfoStackView,
            pokemonFlavorStackView,
            otherCardsLabel
        ])
        
        container.axis = .vertical
        container.distribution = .fill
        container.spacing = 16
        
        container.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(container)
        
        NSLayoutConstraint.activate([
            container.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            container.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            container.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            container.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
        ])
    }
    
    @objc private func didTapImageAction() {
        guard let image = pokemonImageView.image else {
            return
        }
        
        didTapImage?(image)
    }
}
