//
//  Messagecell.swift
//  ChatAppBasic
//
//  Created by piyush mishra on 17/08/22.
//

import Foundation
import UIKit

class MessageCell: UICollectionViewCell{
    //MARK:Properties
    var message : Message? {
        didSet{
            configure()
        }
    }
    
    var bubbleLeftAnchor: NSLayoutConstraint!
    var bubbleRightAnchor: NSLayoutConstraint!
    
    private let profileImageview: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.backgroundColor = .lightGray
        return iv
    }()
    
    private let textview: UITextView = {
        let tv = UITextView()
        tv.backgroundColor = .clear
        tv.font = .systemFont(ofSize: 16)
        tv.isScrollEnabled = false
        tv.isEditable = false
        tv.textColor = .white
        
        return tv
    }()
    
    private let bubblecontainer : UIView = {
        let view = UIView()
        view.backgroundColor = .systemPurple
        return view
    }()
    //mark:Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(profileImageview)
        profileImageview.anchor(left: leftAnchor , bottom: bottomAnchor, paddingLeft: 8, paddingBottom: -4)
        profileImageview.setDimensions(height: 32, width: 32)
        profileImageview.layer.cornerRadius = 32/2
        
        addSubview(bubblecontainer)
        bubblecontainer.layer.cornerRadius = 12
        bubblecontainer.anchor(top: topAnchor, bottom: bottomAnchor)
        bubblecontainer.widthAnchor.constraint(lessThanOrEqualToConstant: 250).isActive = true
        
        bubbleLeftAnchor = bubblecontainer.leftAnchor.constraint(equalTo: profileImageview.rightAnchor, constant: 12)
        bubbleLeftAnchor.isActive = false
        
        bubbleRightAnchor = bubblecontainer.rightAnchor.constraint(equalTo: rightAnchor, constant: -12)
        bubbleRightAnchor.isActive = false
        
        
        bubblecontainer.addSubview(textview)
        textview.anchor(top: bubblecontainer.topAnchor, left: bubblecontainer.leftAnchor, bottom: bubblecontainer.bottomAnchor, right: bubblecontainer.rightAnchor, paddingTop: 4, paddingLeft: 12, paddingBottom: 4, paddingRight: 4)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
        //mark:helpers
    
    func configure(){
        guard let message =  message else {
            return
        }
        let viewmodel = MessageViewModel(message: message)
        
        bubblecontainer.backgroundColor = viewmodel.messageBackGroundColor
        textview.textColor = viewmodel.messageTextColo
        textview.text = message.text
        
        bubbleLeftAnchor.isActive = viewmodel.leftanchorActive
        bubbleRightAnchor.isActive = viewmodel.rightAnchorActive
        profileImageview.isHidden = viewmodel.shouldHideProfileImage
        profileImageview.sd_setImage(with: viewmodel.profileImageURL)
    }
}
