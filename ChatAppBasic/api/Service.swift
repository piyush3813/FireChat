//
//  Service.swift
//  ChatAppBasic
//
//  Created by piyush mishra on 17/08/22.
//

import Firebase


struct Service{
    static func fethUsers(completion:@escaping([User]) -> Void){
       COLLECTION_USER.getDocuments { snapshot, error in
           guard var user = snapshot?.documents.map({User(dictionary: $0.data()) })
           else {return}
           
           if let i = user.firstIndex(where: {$0.uid == Auth.auth().currentUser?.uid}){
               user.remove(at: i)
           }
           
           completion(user)
                    
        }
    }
    
    static func fetchuser(withUID uid: String, completion:@escaping(User) -> Void){
        COLLECTION_USER.document(uid).getDocument { snapshot, error in
            guard let dictionary = snapshot?.data() else {return}
            let user = User(dictionary: dictionary)
            completion(user)
        }
    }
    
    static func fetchConversations(completion: @escaping([Conversation]) -> Void){
        var conversations = [Conversation]()
        
        guard let uid = Auth.auth().currentUser?.uid else {return}
        
        let query = COLLECTION_MESSAGES.document(uid).collection("recent-messages").order(by: "timestamp")
        
        query.addSnapshotListener { snapshot, error in
            snapshot?.documentChanges.forEach({ change in
                let dictionary = change.document.data()
                let message = Message(dictionary: dictionary)
                self.fetchuser(withUID: message.chatparnerId) { user in
                    let conversation = Conversation(user: user, message: message)
                    conversations.append(conversation)
                    completion(conversations)
                }
                
            })
        }
    }
    
    static func fetchMessages(foruser user: User, completion: @escaping([Message]) -> Void){
        var messages = [Message]()
        
        guard let currentUID = Auth.auth().currentUser?.uid else {return}
        
        let query = COLLECTION_MESSAGES.document(currentUID).collection(user.uid).order(by: "timestamp")
        
        query.addSnapshotListener { snapshot, error in
            snapshot?.documentChanges.forEach({ change in
                if change.type == .added {
                    let dictionary = change.document.data()
                    messages.append(Message(dictionary: dictionary))
                    completion(messages)
                }
            })
        }
        
    }
    
    
    
    static func uploadMessage(_ message: String, to user: User, completion:((Error?) -> Void)?) {
        guard let currentUID = Auth.auth().currentUser?.uid else {return}
        
        let data = ["text": message,
                    "fromId": currentUID,
                    "toId": user.uid,
                    "timestamp": Timestamp(date: Date())] as [String: Any]
        
        COLLECTION_MESSAGES.document(currentUID).collection(user.uid).addDocument(data: data, completion: { _ in
            COLLECTION_MESSAGES.document(user.uid).collection(currentUID).addDocument(data: data, completion: completion)
        })
        
        COLLECTION_MESSAGES.document(currentUID).collection("recent-messages").document(user.uid).setData(data)
       
        COLLECTION_MESSAGES.document(user.uid).collection("recent-messages").document(currentUID).setData(data)

    }
}
