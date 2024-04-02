//
//  ProfileController.swift
//  FirebaseLearnProject
//
//  Created by sookim on 4/2/24.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore

// use delegate chaining
protocol ProfileControllerDelegate: AnyObject {
    func handleLogout()
}

final class ProfileController: UITableViewController {

    private var user: User? {
        didSet { headerView.user = user }
    }
    
    // use delegate chaining
    weak var delegate: ProfileControllerDelegate?
    
    private lazy var headerView = ProfileHeaderView(frame: .init(x: 0, y: 0,
                                                                 width: view.frame.width,
                                                                 height: 380))
    private let footerView = ProfileFooterView()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        fetchUser()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
    }
    
    //MARK: - API
    
    private func fetchUser() {
         // showLoader(true)
        
        guard let currentUID = Auth.auth().currentUser?.uid 
        else { return }

        Service.fetchUser(withUID: currentUID) { [weak self] (user) in
            guard let self
            else { return }

            self.showLoader(false)
            self.user = user
        }
    }
    
    //MARK: - Helpers
    
    private func configureUI() {
        tableView.backgroundColor = .white
        
        headerView.delegate = self
        tableView.tableHeaderView = headerView
        tableView.register(ProfileCell.self, forCellReuseIdentifier: ProfileCell.reuseID)
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.rowHeight = 64
        tableView.backgroundColor = .systemGroupedBackground
        
        // use delegate chaining
        footerView.delegate = self
        footerView.frame = .init(x: 0, y: 0, width: view.frame.width, height: 100)
        tableView.tableFooterView = footerView
        
    }
}

    
//MARK: - TableViewDataSource
extension ProfileController {

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ProfileViewModel.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: ProfileCell.reuseID, for: indexPath) as! ProfileCell

        let viewModel = ProfileViewModel(rawValue: indexPath.row)
        
        cell.viewModel = viewModel
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
}
    
//MARK: - UITableViewDelegate
extension ProfileController {
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let viewModel = ProfileViewModel(rawValue: indexPath.row) 
        else { return }

        switch viewModel {
        case .accountInfo:
            print("DEBUG: Show account info controller")
        case .settings:
            print("DEBUG: Show settings controller")
        }
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        // add some padding on top
        return UIView()
    }
}
    
//MARK: - ProfileHeaderViewDelegate
extension ProfileController: ProfileHeaderViewDelegate {
    
    func dismissController() {
        dismiss(animated: true)
    }
}

//MARK: - ProfileFooterViewDelegate
extension ProfileController: ProfileFooterViewDelegate {
    // use delegate chaining
    func handleLogout() {
        let alertController = UIAlertController(title: nil, message: "Are you sure you want to logout?", preferredStyle: .actionSheet)

        alertController.addAction(UIAlertAction(title: "Log out", style: .destructive, handler: { (_) in
            self.dismiss(animated: true) {
                self.delegate?.handleLogout()
            }
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        
        present(alertController, animated: true)
    }
}
