//
//  MessageViewModel.swift
//  FirebaseLearnProject
//
//  Created by sookim on 4/2/24.
//

import UIKit

struct MessageViewModel {
    
    private let message: Message
    
    var messageBackgroundColor: UIColor {
        return message.isFromCurrentUser ? .systemPurple : #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
    }
    
    var messageTextColor: UIColor {
        return message.isFromCurrentUser ? .white : .black
    }
    
    var rightAnchorActive: Bool {
        return message.isFromCurrentUser
    }
    
    var leftAnchorActive: Bool {
        return !message.isFromCurrentUser
    }
    
    var shouldHideProfileImage: Bool {
        return message.isFromCurrentUser
    }
    
    // prepare profileImage from database to show at ChatViewController
    var profileImageUrl: URL? {
        guard let user = message.user 
        else { return nil }

        return URL(string: user.profileImageUrl)
    }
    
    init(message: Message) {
        self.message = message
    }
    
}
