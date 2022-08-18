//
//  Message.swift
//  ChatAppBasic
//
//  Created by piyush mishra on 18/08/22.
//

import Foundation
import Firebase

struct Message {
    let text: String
    let toId: String
    let fromId: String
    var timestamp: Timestamp!
    var user: User?
    
    let isfromCurrentUser: Bool
    
    var chatparnerId: String {
        if Auth.auth().currentUser?.uid == fromId {
            return toId
        }else{
            return fromId
        }
    }
    
    init(dictionary:[String:Any]){
        self.text = dictionary["text"] as? String ?? ""
        self.toId = dictionary["toId"] as? String ?? ""
        self.fromId = dictionary["fromId"] as? String ?? ""
        self.timestamp = dictionary["timestamp"] as? Timestamp ?? Timestamp(date: Date())
        self.isfromCurrentUser = fromId == Auth.auth().currentUser?.uid
        
        
    }
    
    
    
}

struct Conversation {
    let user: User
    let message: Message
}
