//
//  Message.swift
//  FirebaseLearnProject
//
//  Created by sookim on 4/2/24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

struct Message {

    let text: String
    let toId: String
    let fromId: String
    var timeStamp: Timestamp!
    var user: User?
    
    let isFromCurrentUser: Bool
    
    var chatPartnerId: String {
        return isFromCurrentUser ? toId : fromId
    }
    
    init(dictionary: [String: Any]) {
        self.text = dictionary["text"] as? String ?? ""
        self.toId = dictionary["toId"] as? String ?? ""
        self.fromId = dictionary["fromId"] as? String ?? ""
        self.timeStamp = dictionary["timeStamp"] as? Timestamp ?? Timestamp(date: Date())
        
        self.isFromCurrentUser = fromId == Auth.auth().currentUser?.uid
    }
    
}

struct Conversation {
    let user: User
    let message: Message
}
