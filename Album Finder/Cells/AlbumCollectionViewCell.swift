//
//  AlbumCollectionViewCell.swift
//  Album Finder
//
//  Created by Emily Liang on 1/17/23.
//

import UIKit

class AlbumCollectionViewCell: UICollectionViewCell {

    var onFavoriteTapped: (() -> Void)?
    private let titleLabel = UILabel()
    private let favoriteButton = UIButton()

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    func configure(with album: Album) {
        titleLabel.text = album.title
        setupLayout()
    }

    func setupLayout() {
        addSubview(titleLabel)
        addSubview(favoriteButton)
        favoriteButton.setTitle("Favorite", for: .normal)
        favoriteButton.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
    }

    @objc func favoriteButtonTapped() {
        onFavoriteTapped?()
    }
    
}


