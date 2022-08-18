//
//  RegistrationViewmodel.swift
//  ChatAppBasic
//
//  Created by piyush mishra on 17/08/22.
//

import Foundation
import UIKit

struct RegistrationViewModel {
    var email : String?
    var password : String?
    var username : String?
    var fullname : String?
    
    
    
    var formIsValid: Bool {
        return email?.isEmpty == false
        && password?.isEmpty == false && username?.isEmpty == false && fullname?.isEmpty == false
    }
}
