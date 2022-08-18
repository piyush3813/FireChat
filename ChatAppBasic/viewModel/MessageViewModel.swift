//
//  MessageViewModel.swift
//  ChatAppBasic
//
//  Created by piyush mishra on 18/08/22.
//

import Foundation
import UIKit

struct MessageViewModel{
    private let message : Message
    
    var messageBackGroundColor : UIColor{
        return message.isfromCurrentUser ? .lightGray : .systemPurple
    }
    
    var messageTextColo: UIColor{
        return message.isfromCurrentUser ? .black : .white
    }
    
    var rightAnchorActive: Bool{
        return message.isfromCurrentUser
    }
    
    var leftanchorActive: Bool {
        return !message.isfromCurrentUser
    }
    
    var shouldHideProfileImage :Bool{
        return message.isfromCurrentUser
    }
    
    var profileImageURL: URL? {
        guard let user = message.user else {return nil}
        return URL(string: user.profileUrl)
    }
    init(message: Message){
        self.message = message
    }
}
