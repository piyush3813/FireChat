//
//  LoginViewModel.swift
//  ChatAppBasic
//
//  Created by piyush mishra on 17/08/22.
//

import Foundation

struct LoginViewModel {
    var email : String?
    var password : String?
    
    
    var formIsValid: Bool {
        return email?.isEmpty == false
        && password?.isEmpty == false
    }
}
