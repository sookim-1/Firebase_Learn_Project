//
//  NewMessageController.swift
//  FirebaseLearnProject
//
//  Created by sookim on 4/2/24.
//

import UIKit

protocol NewMessageControllerDelegate: AnyObject {
    func controller(_ controller: NewMessageController, wantsToStartChatWith user: User)
}

final class NewMessageController: UITableViewController {

    private var users = [User]()
    private var filteredUsers = [User]()
    
    weak var delegate: NewMessageControllerDelegate?
    private let searchController = UISearchController(searchResultsController: nil)
    
    private var isSearchMode: Bool {
        return searchController.isActive && !searchController.searchBar.text!.isEmpty
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        configureSearchController()
        fetchUsers()
    }

    @objc func handleDismiss() {
        dismiss(animated: true)
    }

    private func fetchUsers() {
         // showLoader(true)

        Service.fetchUsers { [weak self] (users) in
            guard let self 
            else { return }

            self.showLoader(false)
            self.users = users
            self.tableView.reloadData()
        }
    }

    private func configureUI() {
        configureNavigationBar(withTitle: "새로운 채팅", prefersLargeTitles: false)
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(handleDismiss))
        
        tableView.tableFooterView = UIView()
        tableView.register(UserCell.self, forCellReuseIdentifier: UserCell.reuseID)
        tableView.rowHeight = 80
    }
    
    private func configureSearchController() {
        searchController.searchResultsUpdater = self
        searchController.searchBar.showsCancelButton = false
        navigationItem.searchController = searchController
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "친구 찾기"

        definesPresentationContext = false
        
        if let textField = searchController.searchBar.value(forKey: "searchField") as? UITextField {
            textField.textColor = .systemPurple
            textField.backgroundColor = .black
        }
    }
}

    
//MARK: - UITableViewDataSource
extension NewMessageController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return isSearchMode ? filteredUsers.count : users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: UserCell.reuseID, for: indexPath) as! UserCell

        cell.user = isSearchMode ? filteredUsers[indexPath.row] : users[indexPath.row]
        
        return cell
    }
}

    
//MARK: - UITableViewDelegate
extension NewMessageController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = isSearchMode ? filteredUsers[indexPath.row] : users[indexPath.row]
        
        delegate?.controller(self, wantsToStartChatWith: user)
        tableView.deselectRow(at: indexPath, animated: true)
    }

}

// MARK: - UISearchResultsUpdating
extension NewMessageController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text?.lowercased() 
        else { return }

        filteredUsers = users.filter({ (user) -> Bool in
            return user.username.contains(searchText) || user.fullname.contains(searchText)
        })
        
        self.tableView.reloadData()
    }

}
