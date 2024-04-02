//
//  ChatController.swift
//  FirebaseLearnProject
//
//  Created by sookim on 4/2/24.
//

import UIKit
import SnapKit
import Then

final class ChatController: UICollectionViewController {

    private let user: User
    private var messages = [Message]()
    var fromCurrentUser = false
    
    private lazy var customInputView = CustomInputAccessoryView(frame: CGRect(origin: .zero, size: CGSize(width: view.frame.width, height: 50))).then {
        $0.delegate = self
    }

    init(user: User) {
        self.user = user
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureUI()
        fetchMessages()
    }
    
    override var inputAccessoryView: UIView? {
        get { return customInputView }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }

    private func fetchMessages() {
         // showLoader(true)
        
        Service.fetchMessages(forUser: user) { [weak self] (messages) in
            guard let self 
            else { return }

            self.showLoader(false)
            
            self.messages = messages
            self.collectionView.reloadData()
            // scroll down at the bottom of collectionView every time when fetchMessages
            self.collectionView.scrollToItem(at: [0, self.messages.count - 1],
                                             at: .bottom, animated: true)
        }
    }

    private func configureUI() {
        collectionView.backgroundColor = .white
        configureNavigationBar(withTitle: user.username, prefersLargeTitles: false)
        
        collectionView.register(MessageCell.self, forCellWithReuseIdentifier: MessageCell.reuseID)
        collectionView.alwaysBounceVertical = true
        // dismiss keyboard when scroll collectionView
        collectionView.keyboardDismissMode = .interactive
    }
}

extension ChatController {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MessageCell.reuseID, for: indexPath) as! MessageCell

        let message = messages[indexPath.row]
        
        cell.message = message
        
        // grab user to start message
        cell.message?.user = user
        
        return cell
    }
}

//MARK: - UICollectionViewDelegateFlowLayout
extension ChatController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 16, left: 0, bottom: 16, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        // fixed dynamic cells height
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        let estimatedSizeCell = MessageCell(frame: frame)
        estimatedSizeCell.message = messages[indexPath.row]
        estimatedSizeCell.layoutIfNeeded()
        
        let targetSize = CGSize(width: view.frame.width, height: 1000)
        let estimatedSize = estimatedSizeCell.systemLayoutSizeFitting(targetSize)
        
        return .init(width: view.frame.width, height: estimatedSize.height)
    }

}


// MARK: - CustomInputAccessoryViewDelegate
extension ChatController: CustomInputAccessoryViewDelegate {
    
    func inputView(_ inputView: CustomInputAccessoryView, wantsToSend message: String) {
        Service.uploadMessage(message, to: user) { (error) in
            if let error = error {
                print("DEBUG: Failed to upload message with error", error.localizedDescription)
                return
            }
            
            inputView.clearMessageText()
        }
    }
}
