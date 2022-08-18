//
//  UserCell.swift
//  ChatAppBasic
//
//  Created by piyush mishra on 17/08/22.
//

import UIKit
import SDWebImage

class UserCell : UITableViewCell{
    
    //mark:properties
    var user: User?{
        didSet{
            configure()
        }
    }
    
    private let profileImageView : UIImageView = {
        let image = UIImageView()
        image.backgroundColor = .systemPurple
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
        
    }()
    
    private let usernameLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        label.text = "andhera kayam rahe"

        return label
    }()
    
    private let detailLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        label.text = "gangadhar is shatiman"

        
        return label
    }()
    
    //mark:lifecycle
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(profileImageView)
        profileImageView.centerY(inView: self, leftAnchor: leftAnchor, paddingLeft: 12)
        profileImageView.setDimensions(height: 56, width: 56)
        profileImageView.layer.cornerRadius = 56 / 2
        
        let stack = UIStackView(arrangedSubviews: [usernameLabel, detailLabel])
        stack.axis = .vertical
        stack.spacing = 2
        
        addSubview(stack)
        stack.centerY(inView: profileImageView, leftAnchor: profileImageView.rightAnchor, paddingLeft: 12)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

func configure(){
    guard let user = user else {return}
    usernameLabel.text = user.username
    detailLabel.text = user.fullName
    guard let url = URL(string: user.profileUrl) else {return}
    profileImageView.sd_setImage(with: url)
}
}
