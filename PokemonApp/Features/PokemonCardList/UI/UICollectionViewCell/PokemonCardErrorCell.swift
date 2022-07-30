//
//  PokemonCardErrorCell.swift
//  PokemonApp
//
//  Created by Tifo Audi Alif Putra on 29/07/22.
//

import UIKit

final class PokemonCardErrorCell: UICollectionViewCell {
    
    static let identifier: String = String(describing: PokemonCardErrorCell.self)
    
    let errorTitle: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        label.text = "Oops, Something went wrong"
        return label
    }()
    
    let errorDescLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .white
        label.textAlignment = .center
        label.text = "Please check your connection and try again later"
        return label
    }()
    
    let reloadButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Reload", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .black
        button.layer.borderWidth = 1.0
        button.layer.borderColor = UIColor.white.cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        button.layer.cornerRadius = 20
        return button
    }()
    
    var didSelectReloadButton: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureView()
    }
    
    private func configureView() {
        reloadButton.addTarget(self, action: #selector(reloadButtonAction), for: .touchUpInside)
        
        let stackView = UIStackView(arrangedSubviews: [errorTitle, errorDescLabel, reloadButton])
        stackView.axis = .vertical
        stackView.distribution = .fillProportionally
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.backgroundColor = .red
        stackView.spacing = 8
        
        contentView.addSubview(stackView)
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12)
        ])
    }
    
    @objc private func reloadButtonAction() {
        didSelectReloadButton?()
    }
}
