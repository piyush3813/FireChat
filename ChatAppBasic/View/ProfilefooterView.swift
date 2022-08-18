//
//  ProfilefooterView.swift
//  ChatAppBasic
//
//  Created by piyush mishra on 18/08/22.
//

import Foundation
import UIKit
protocol ProfileFooterDelegate: class {
    func handleLogout()
}
class ProfilefooterView : UIView{
    //MARK: prperties
    weak var delegate : ProfileFooterDelegate?
    private  lazy var  logoutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Logout", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.backgroundColor = .systemPink
        button.addTarget(self, action: #selector(handleLogout), for: .touchUpInside)
        return button
    }()
    
    //MArk:lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(logoutButton)
        logoutButton.anchor(left:leftAnchor, right: rightAnchor, paddingLeft: 32, paddingRight: 32)
        logoutButton.centerY(inView: self)
        logoutButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        logoutButton.layer.cornerRadius = 10
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // selectores
    
    @objc func handleLogout(){
        delegate?.handleLogout()
    }
}
