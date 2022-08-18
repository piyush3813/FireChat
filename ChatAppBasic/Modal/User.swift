//
//  User.swift
//  ChatAppBasic
//
//  Created by piyush mishra on 17/08/22.
//

import Foundation

struct User{
    let email : String
    let username: String
    let uid : String
    let profileUrl : String
    let fullName : String
    
    init(dictionary : [String: Any]){
        self.uid = dictionary["uid"] as? String ?? ""
        self.profileUrl = dictionary["profileImageURL"] as? String ?? ""
        self.username = dictionary["username"] as? String ?? ""
        self.fullName = dictionary["fullname"] as? String ?? ""
        self.email = dictionary["email"] as? String ?? ""
        
        
    }
    
}

