//
//  AlbumCell.swift
//  Album Finder
//
//  Created by Emily Liang on 1/17/23.
//

import UIKit

class AlbumCell: UITableViewCell {
    var album: Album!
    var onFavoriteTapped: (() -> Void)?

    private let titleLabel = UILabel()
    private let favoriteButton = UIButton(type: .system)

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with album: Album) {
        self.album = album
        titleLabel.text = album.title
    }

    private func setupView() {
        favoriteButton.setTitle("Favorite", for: .normal)
        favoriteButton.addTarget(self, action: #selector(favoriteTapped), for: .touchUpInside)

        contentView.addSubview(titleLabel)
        contentView.addSubview(favoriteButton)

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        favoriteButton.translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),

            favoriteButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            favoriteButton.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }

    @objc private func favoriteTapped() {
        onFavoriteTapped?()
    }
}
