//
//  ConversationCell.swift
//  ChatAppBasic
//
//  Created by piyush mishra on 18/08/22.
//

import Foundation
import UIKit


class ConversationCell: UITableViewCell {
    
    //PROPERTIES
    var conversation:Conversation?
    {
        didSet{
            configureUI()
        }
    }
    
    let profileImageview: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        return iv
    }()
    
    let timestamp: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = .darkGray
        label.text = "2h"
        return label
    }()
    
    let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
        
    }()
    
    let messageTextLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        return label
        
    }()
    
    //LIFECYCLE
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(profileImageview)
        profileImageview.anchor(left:leftAnchor , paddingLeft: 12)
        profileImageview.setDimensions(height: 50, width: 50)
        profileImageview.layer.cornerRadius = 50/2
        profileImageview.centerY(inView: self)
        
        let stack = UIStackView(arrangedSubviews: [usernameLabel, messageTextLabel])
        stack.axis = .vertical
        stack.spacing = 4
        
        addSubview(stack)
        stack.centerY(inView: profileImageview)
        stack.anchor(left:profileImageview.rightAnchor, right: rightAnchor, paddingLeft: 12, paddingRight: 16)
        
        
        addSubview(timestamp)
        timestamp.anchor(top: topAnchor, right: rightAnchor, paddingTop: 20, paddingRight: 12)

        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureUI(){
        guard let conversation = conversation else {
            return
        }
        let viewModel = ConversationViewModel(conversation : conversation)
        usernameLabel.text = conversation.user.username
        messageTextLabel.text = conversation.message.text
        
        timestamp.text = viewModel.timestamp
        profileImageview.sd_setImage(with: viewModel.profileImageUrl)
    }
}
