//
//  FavoritesViewController.swift
//  Album Finder
//
//  Created by Emily Liang on 1/15/23.
//

import UIKit

class FavoritesViewController: UIViewController {

    var favoriteAlbums = [Album]()
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        configureCollectionView()
        fetchFavorites()
        collectionView.register(AlbumCollectionViewCell.self, forCellWithReuseIdentifier: "AlbumCollectionViewCell")

    }

    func configureCollectionView() {
        collectionView.backgroundColor = .systemBackground
        collectionView.register(AlbumCollectionViewCell.self, forCellWithReuseIdentifier: "AlbumCollectionViewCell")
        collectionView.dataSource = self
        collectionView.delegate = self
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    func fetchFavorites() {
        if let savedFavorites = UserDefaults.standard.data(forKey: "favoriteAlbums"), let albums = try? JSONDecoder().decode([Album].self, from: savedFavorites) {
               favoriteAlbums = albums
               collectionView.reloadData()
           }
    }


}

extension FavoritesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return favoriteAlbums.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "AlbumCollectionViewCell", for: indexPath) as! AlbumCollectionViewCell
        let album = favoriteAlbums[indexPath.row]
        cell.configure(with: album)
        cell.onFavoriteTapped = { [weak self] in
            self?.unfavoriteAlbum(album)
        }
        return cell
    }

    func unfavoriteAlbum(_ album: Album) {
        favoriteAlbums.removeAll(where: { $0.id == album.id })
        if let encoded = try? JSONEncoder().encode(favoriteAlbums) {
            UserDefaults.standard.set(encoded, forKey: "favoriteAlbums")
        }
        collectionView.reloadData()
    }

}

extension FavoritesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (view.frame.width - 40) / 2, height: 200)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedAlbum = favoriteAlbums[indexPath.row]
    
    }
}
