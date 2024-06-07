//
//  ConversationsController.swift
//  FirebaseLearnProject
//
//  Created by sookim on 4/2/24.
//

import UIKit
import FirebaseCore
import FirebaseAuth
import SnapKit
import Then

final class ConversationsController: UIViewController {

    lazy private var tableView = UITableView().then {
        $0.backgroundColor = .white
        $0.rowHeight = 80
        $0.register(ConversationCell.self, forCellReuseIdentifier: ConversationCell.reuseID)
        $0.tableFooterView = UIView()
        $0.delegate = self
        $0.dataSource = self
    }

    private var conversations = [Conversation]()
    private var conversationsDictionary = [String: Conversation]()
    
    private let newMessageButton = UIButton(type: .system).then {
        $0.setImage(UIImage(systemName: "plus"), for: .normal)
        $0.backgroundColor = .systemPurple
        $0.tintColor = .white
        $0.layer.cornerRadius = 25
        $0.addTarget(self, action: #selector(showNewMessage), for: .touchUpInside)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        addSubviews()
        setupConstraints()
        configureUI()
        authenticateUser()
        fetchConversations()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        configureNavigationBar(withTitle: "채팅", prefersLargeTitles: true)
    }

    @objc func showProfile() {
        let profileController = ProfileController(style: .insetGrouped)
        profileController.delegate = self

        let nav = UINavigationController(rootViewController: profileController)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)
    }
    
    @objc func showNewMessage() {
        let newMessageController = NewMessageController()
        newMessageController.delegate = self
        let navController = UINavigationController(rootViewController: newMessageController)
        navController.modalPresentationStyle = .fullScreen
        present(navController, animated: true)
    }

    private func fetchConversations() {
         // showLoader(true)
        
        Service.fetchConversations { [weak self] (conversations) in
            guard let self
            else { return }

            conversations.forEach({ conversation in
                let message = conversation.message
                self.conversationsDictionary[message.chatPartnerId] = conversation
            })
            
            self.showLoader(false)
            self.conversations = Array(self.conversationsDictionary.values)
            self.tableView.reloadData()
        }
    }
    
    private func authenticateUser() {
        if Auth.auth().currentUser?.uid == nil {
            presentLoginScreen()
            print("DEBUG: User is not logged in")
        } else {
            print("DEBUG: User is logged in \(Auth.auth().currentUser?.uid)")
        }
    }
    
    private func logout() {
        do {
            try Auth.auth().signOut()
            presentLoginScreen()
        } catch let error {
            print("DEBUG: Error signing out...", error.localizedDescription)
        }
    }

    private func presentLoginScreen() {
        DispatchQueue.main.async {
            let controller = LoginController()
            controller.delegate = self
            let navVC = UINavigationController(rootViewController: controller)
            navVC.modalPresentationStyle = .fullScreen
            self.present(navVC, animated: true)
        }
    }
    
    private func addSubviews() {
        [newMessageButton,
         tableView].forEach {
            self.view.addSubview($0)
        }
    }
    
    private func setupConstraints() {
        tableView.frame = self.view.frame
        
        newMessageButton.snp.makeConstraints { make in
            make.bottom.equalTo(view.safeAreaLayoutGuide).offset(-16)
            make.trailing.equalToSuperview().offset(-24)
            make.width.equalTo(50)
            make.height.equalTo(50)
        }
        
        self.view.bringSubviewToFront(self.newMessageButton)
    }
    
    private func configureUI() {
        view.backgroundColor = .white

        let image = UIImage(systemName: "person.circle.fill")
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image,
                                                           style: .plain,
                                                           target: self,
                                                           action: #selector(showProfile))
    }
    
    private func showChatController(forUser user: User) {
        let chatController = ChatController(user: user)
        navigationController?.pushViewController(chatController, animated: true)
    }
}

//MARK: - UITableViewDelegate
extension ConversationsController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = conversations[indexPath.row].user
        showChatController(forUser: user)
        tableView.deselectRow(at: indexPath, animated: true)
    }

}

//MARK: - UITableViewDataSource
extension ConversationsController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ConversationCell.reuseID, for: indexPath) as! ConversationCell

        let conversation = conversations[indexPath.row]
    
        cell.conversation = conversation
        
        return cell
    }
    
}

//MARK: - NewMessageControllerDelegate
extension ConversationsController: NewMessageControllerDelegate {
    
    func controller(_ controller: NewMessageController, wantsToStartChatWith user: User) {
        dismiss(animated: true)
        showChatController(forUser: user)
    }

}

//MARK: - ProfileControllerDelegate
extension ConversationsController: ProfileControllerDelegate {

    func handleLogout() {
        logout()
    }
}

//MARK: - AuthenticationDelegate
extension ConversationsController: AuthenticationDelegate {

    func authenticationComplete() {
        dismiss(animated: true)
        configureUI()
        fetchConversations()
    }

}
