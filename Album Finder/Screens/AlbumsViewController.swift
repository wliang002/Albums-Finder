//
//  AlbumsViewController.swift
//  Album Finder
//
//  Created by Emily Liang on 1/17/23.
//

import UIKit

class AlbumsViewController: UIViewController {

    var userId: Int!
    var onError: ((Error) -> Void)?
    var albums = [Album]()
    let tableView = UITableView()
    private var favoriteAlbums = [Int: Album]()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        tableView.register(AlbumCell.self, forCellReuseIdentifier: "AlbumCell")
        configureTableView()
        fetchAlbums()
    }

    func configureTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TableCell")

        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    func fetchAlbums() {
        guard let id = userId else {
                // handle the case when the user's id is nil
                let error = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : "No user selected"])
                onError?(error)
                return
            }
            let urlString = "https://jsonplaceholder.typicode.com/users/\(id)/albums"
            guard let url = URL(string: urlString) else { return }
            print(url)
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let error = error {
                    self.onError?(error)
                    return
                }

                guard let data = data else { return }

                do {
                    self.albums = try JSONDecoder().decode([Album].self, from: data)
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                } catch let jsonError {
                    self.onError?(jsonError)
                }
            }.resume()
    }
}

extension AlbumsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albums.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "AlbumCell", for: indexPath) as! AlbumCell
        let album = albums[indexPath.row]
        cell.configure(with: album)
        cell.onFavoriteTapped = { [weak self] in
            self?.favoriteAlbum(album)
        }
        return cell
    }
    func favoriteAlbum(_ album: Album) {
        favoriteAlbums[album.id] = album
        print(favoriteAlbums)
        UserDefaults.standard.set(Array(favoriteAlbums.values), forKey: "favoriteAlbums")

    }
}

extension AlbumsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    }
}
