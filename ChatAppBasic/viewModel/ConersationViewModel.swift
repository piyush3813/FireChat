//
//  ConersationViewModel.swift
//  ChatAppBasic
//
//  Created by piyush mishra on 18/08/22.
//

import Foundation

struct ConversationViewModel{
    private let conversation: Conversation
    
    var profileImageUrl: URL? {
        return URL(string:conversation.user.profileUrl)
    }
    
    var timestamp: String{
        let date = conversation.message.timestamp.dateValue()
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "hh:mm a"
        return dateformatter.string(from: date)
    }
    
    init(conversation: Conversation){
        self.conversation = conversation
    }
}
