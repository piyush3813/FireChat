//
//  Authservice.swift
//  ChatAppBasic
//
//  Created by piyush mishra on 17/08/22.
//

import Firebase
import UIKit
struct RegistrationCredentials {
    let email: String
    let password: String
    let fullname: String
    let username: String
    let profileImage: UIImage
}

struct Authservice {
    static let shared  = Authservice()
    
    func loguserIn(with email: String, password: String , completion: @escaping((AuthDataResult? , Error?) -> Void)){
        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
        
    }
    
    
    func createUser(credentials: RegistrationCredentials , completion:@escaping ((Error?) -> Void)){
        guard let imageData = credentials.profileImage.jpegData(compressionQuality: 0.3) else {return}
        
        let filename = NSUUID().uuidString
        let  ref =  Storage.storage().reference(withPath: "/profile_image/\(filename)")
        
        ref.putData(imageData, metadata: nil) { (meta, error) in
            if let error = error {
                completion(error)
                return
            }
            
            ref.downloadURL { url, error in
                guard let profileImageURL = url?.absoluteString else {return}
                
                Auth.auth().createUser(withEmail: credentials.email, password: credentials.password) { (result, error) in
                    if let error = error {
                        completion(error)

                        return
                    }
                    guard let uid = result?.user.uid else{return}
                    
                    let data = ["email": credentials.email, "fullname": credentials.fullname, "username": credentials.username, "profileImageURL": profileImageURL, "uid": uid] as [String: Any]
                    
                    Firestore.firestore().collection("users").document(uid).setData(data, completion: completion)
                   
                }
            }
        }
        
    }
    
}
