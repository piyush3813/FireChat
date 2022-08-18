//
//  ProfileViewModel.swift
//  ChatAppBasic
//
//  Created by piyush mishra on 18/08/22.
//

import Foundation
enum ProfileViewModel: Int, CaseIterable {
    case accountInfo
    case settings
    
    var description: String {
        switch self {
        case .accountInfo: return "Account Info"
        case .settings: return "Settings"
        }
    }
    
    var IconImageName: String {
        switch self{
        case .accountInfo: return "person.circle"
        case .settings: return "gear"
        }
    }
}
