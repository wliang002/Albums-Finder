//
//  SearchViewController.swift
//  Album Finder
//
//  Created by Emily Liang on 1/15/23.
//

import UIKit

class SearchViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    let headerImage = UIImageView()
    let findActionButton = AlFButton(backgroundColor: .systemTeal, title: "Find Albums")
    let tableView = UITableView()
    var searchBar = UISearchBar()
    var users = [User]()
    var filteredUsers = [User]()
    var userId: Int!

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        configureHeaderImageView()
        configureSearchView()
        configerCallToActionButton()
    }
    
    @objc func navToAlbumListVC() {
        guard let id = userId else {
                // handle the case when the user's id is nil
                let alert = UIAlertController(title: "Error", message: "No user selected", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                present(alert, animated: true, completion: nil)
                return
            }
            let albumsViewController = AlbumsViewController()
            albumsViewController.userId = id
            print(id)
            navigationController?.pushViewController(albumsViewController, animated: true)
    }
    
    // set constraints for a header image
    func configureHeaderImageView() {
        view.addSubview(headerImage)
        headerImage.translatesAutoresizingMaskIntoConstraints = false
        headerImage.image = UIImage(named: "album-logo")!

        NSLayoutConstraint.activate([
            headerImage.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            headerImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            headerImage.heightAnchor.constraint(equalToConstant: 120),
            headerImage.widthAnchor.constraint(equalToConstant: 120)
        ])
    }
    
    // set constraints for search bar
    func configureSearchView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "TableCell")
        view.addSubview(tableView)
        tableView.isHidden = true
        tableView.frame = CGRect(x: 0, y: 44, width: view.frame.width, height: view.frame.height - 44)
        tableView.isScrollEnabled = true
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        
        searchBar.delegate = self
        searchBar.placeholder = "Search Artists"
        view.addSubview(searchBar)
        searchBar.translatesAutoresizingMaskIntoConstraints = false
    
        NSLayoutConstraint.activate([
            searchBar.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            searchBar.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 150),
            searchBar.widthAnchor.constraint(equalToConstant: 350),
            searchBar.heightAnchor.constraint(equalToConstant: 50)
        ])
        

        NSLayoutConstraint.activate([
            tableView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            tableView.topAnchor.constraint(equalTo: searchBar.bottomAnchor, constant: 5),
            tableView.widthAnchor.constraint(equalToConstant: 350),
            tableView.heightAnchor.constraint(equalToConstant: 400)
        ])

        fetchUsers()
    }
    
    // set constraints for the find button
    func configerCallToActionButton() {
        view.addSubview(findActionButton)
        // add a target
        findActionButton.addTarget(self, action: #selector(navToAlbumListVC), for: .touchUpInside)
        NSLayoutConstraint.activate([
            findActionButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50),
            findActionButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 100),
            findActionButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -100),
            findActionButton.heightAnchor.constraint(equalToConstant: 40),
        ])
    }
    
    func fetchUsers() {
        let url = URL(string: "https://jsonplaceholder.typicode.com/users")!
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                do {
                    let users = try JSONDecoder().decode([User].self, from: data)
                    self.users = users
                    self.filteredUsers = users
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                } catch let decodingError {
                    print(decodingError.localizedDescription)
                }
            }
        }
        task.resume()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell", for: indexPath)
        let user = filteredUsers[indexPath.row]
        cell.textLabel?.text = user.username
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return filteredUsers.count
        }
        @objc(tableView:didSelectRowAtIndexPath:) func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let selectedUser = filteredUsers[indexPath.row]
            userId = selectedUser.id
            print("Selected user ID: \(String(describing: userId))")
            // You can use userID variable here as per your requirement
            searchBar.text = selectedUser.username
            searchBar.endEditing(true)
            tableView.isHidden = true
        }
        
    @objc func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
            filteredUsers = users.filter { (user) -> Bool in
                return user.username.lowercased().contains(searchText.lowercased())
            }
            if searchText.isEmpty {
                tableView.isHidden = true
            } else {
                tableView.isHidden = false
            }
            tableView.reloadData()
        }

    }
