//
//  ChatController.swift
//  ChatAppBasic
//
//  Created by piyush mishra on 17/08/22.
//

import Foundation
import UIKit
private let reuseIdentifier = "messageCell"
class ChatController: UICollectionViewController{
    //PROPERTIES:
    private var messages = [Message]()
    var fromCurrentUser = false
    
    private lazy var custominputView: CustomInputAccessoryView = {
        let iv = CustomInputAccessoryView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 50))
        iv.delegate = self
        return iv
    }()
    
    private let user: User
    //LIFICYCLE
    
    init(user: User){
        self.user = user
        super.init(collectionViewLayout: UICollectionViewFlowLayout())
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        configureNavigationBar(withTitle: user.username, prefersLargeTitles: false)
        fetchMessages()

        print("in chat controller")
    }
    
    override var inputAccessoryView: UIView?{
        get {return custominputView}
    }
    
    override var canBecomeFirstResponder: Bool{
        return true
    }
    //API:
    func fetchMessages(){
        showLoader(true)
        Service.fetchMessages(foruser: user) { messages in
            self.showLoader(false)
            self.messages = messages
            self.collectionView.reloadData()
            self.collectionView.scrollToItem(at: [0, self.messages.count - 1], at: .bottom, animated: true)
        }
    }
    
    //HELPERS
    func configureUI(){
        view.backgroundColor = .lightGray
        collectionView.register(MessageCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.alwaysBounceVertical = true
        collectionView.keyboardDismissMode = .interactive
    }
    
    
}
extension ChatController  {
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell  = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! MessageCell
        cell.message = messages[indexPath.row]
        cell.message?.user = user
        return cell
    }
}

extension ChatController : UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 16, left: 0, bottom: 16, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        let estimatedSizeCell = MessageCell(frame: frame)
         estimatedSizeCell.message = messages[indexPath.row]
        estimatedSizeCell.layoutIfNeeded()
        
        let targetSize = CGSize(width: view.frame.width, height: 1000)
        let estimatedSize = estimatedSizeCell.systemLayoutSizeFitting(targetSize)
        
        return .init(width: view.frame.width, height: estimatedSize.height)
    }
    
}
extension ChatController : CustomInputAccessorydelegate {
    func inputView(_ inputView: CustomInputAccessoryView, wantsToSend message: String) {
       
        Service.uploadMessage(message, to: user) { error in
            if let error  = error {
                print("failed to upload messages to firestore \(error.localizedDescription)")
                return
            }
            inputView.clearMessageText()
        }
    }
    
    
}
