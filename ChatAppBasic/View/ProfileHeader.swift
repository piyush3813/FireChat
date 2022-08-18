//
//  ProfileHeader.swift
//  ChatAppBasic
//
//  Created by piyush mishra on 18/08/22.
//


import UIKit
protocol ProfileHeaderdelegate: class {
    func dismissController()
}

class ProfileHeader: UIView{
    //MARK:PROPERTIES
    var user: User? {
        didSet{
            populateUserData()
            
        }
    }
    weak var delegate:  ProfileHeaderdelegate?
    
    private let dismissButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage((UIImage(systemName: "xmark")), for: .normal)
        button.addTarget(self, action: #selector(handleDismissal), for: .touchUpInside)
        button.tintColor = .red
        button.imageView?.setDimensions(height: 22, width: 22)
        
        return button
    }()
    
    private let profileImageView: UIImageView = {
        let iv = UIImageView()
        iv.clipsToBounds = true
        iv.contentMode = .scaleAspectFill
        iv.tintColor = .red
        iv.layer.borderColor = UIColor.white.cgColor
        iv.layer.borderColor = UIColor.red.cgColor
        
        iv.layer.borderWidth = 4.0
        return iv
    }()
    
    private let fullnameLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 20)
        label.textColor = .red
        label.text = "india"

        label.textAlignment = .center
        return label
    }()
    
    private let usernameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = .red
        label.text = "@hello"
        label.textAlignment = .center
        return label
    }()
    //mark:LIFECYCLE
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureUI()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    //helper
    func populateUserData(){
        guard let user = user else {
            return
        }
        fullnameLabel.text = user.fullName
        usernameLabel.text = "@" + user.username
        
        guard let url = URL(string: user.profileUrl) else {return}
        profileImageView.sd_setImage(with: url)
    }
    func configureUI(){
        configureGradient()
        profileImageView.setDimensions(height: 200, width: 200)
        profileImageView.layer.cornerRadius = 200 / 2
        addSubview(profileImageView)
        profileImageView.anchor(top: topAnchor , paddingTop: 96)
        profileImageView.centerX(inView: self)
        
        let stack = UIStackView(arrangedSubviews: [fullnameLabel, usernameLabel])
        stack.axis = .vertical
        stack.spacing = 4
        
        addSubview(stack)
        stack.centerX(inView: self)
        stack.anchor(top:profileImageView.bottomAnchor, paddingTop: 16)
        
        addSubview(dismissButton)
        dismissButton.anchor(top:topAnchor, left:leftAnchor, paddingTop: 44, paddingLeft: 12)
        dismissButton.setDimensions(height: 48, width: 48)
        
        
    }
    func configureGradient(){
        print("gradientcolor")
        let gradient = CAGradientLayer()
        gradient.colors = [ UIColor.systemPurple.cgColor, UIColor.systemMint.cgColor]
        gradient.locations = [0, 1]
        layer.addSublayer(gradient)
        gradient.frame = bounds
        
        
    }
    
    //mark:selectors
    @objc func handleDismissal (){
        delegate?.dismissController()
    }
}
