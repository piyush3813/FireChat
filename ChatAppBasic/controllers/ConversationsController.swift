//
//  ConversationsController.swift
//  ChatAppBasic
//
//  Created by piyush mishra on 16/08/22.
//

import UIKit
import Firebase

class ConversationsController: UIViewController{
    // mark: properties
    private let reuseidentifier =  "cellID"
    private let tableview = UITableView()
    private var Conversations = [Conversation]()
    private var conversationDictionary = [String: Conversation]()
    private let newMessageButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.backgroundColor = .systemPurple
        button.tintColor = .white
        button.imageView?.setDimensions(height: 24, width: 24)
        button.addTarget(self, action: #selector(showNewMessage), for: .touchUpInside)
        return button
    }()
    //mark: lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        AuthenticateUser()
        fetchconversations()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavBar()
    }
    
    //mark: selectoors
    @objc func showProfile(){
        let controller = ProfileController(style: .insetGrouped)
        controller.delegate = self
        let nav = UINavigationController(rootViewController: controller)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true)
    }
    
    @objc func showNewMessage(){
        let vc = NewMessageContoller()
        vc.delegate = self
        let nav = UINavigationController(rootViewController: vc)
        nav.modalPresentationStyle = .fullScreen
        present(nav, animated: true, completion: nil)
    }
    //MARK:API
    func fetchconversations(){
        showLoader(true)
        Service.fetchConversations { conversations in
            
            conversations.forEach { conversation in
                let message = conversation.message
                self.conversationDictionary[message.chatparnerId] = conversation
            }
            self.showLoader(false)
            self.Conversations = Array(self.conversationDictionary.values)
            self.tableview.reloadData()
        }
    }
    
    func AuthenticateUser()
    {
        if Auth.auth().currentUser?.uid == nil {
            presentLoginScreen()
            print("user is not logged in ")
        }
        
    }
    
    func logout(){
        do{
            try Auth.auth().signOut()
            presentLoginScreen()
        }catch {
            print("error in signing out")
        }
    }
    
    // mark : helpers
    
    func presentLoginScreen(){
        DispatchQueue.main.async {
            let controller = LoginController()
            controller.delegate = self
            let nav = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true, completion: nil)
        }
    }
    
    
    func configureUI(){
        view.backgroundColor = .white
      
        configuretableview()
        let image = UIImage(systemName: "person.circle.fill")
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .plain, target: self, action: #selector(showProfile))
        view.addSubview(newMessageButton)
        newMessageButton.setDimensions(height: 56, width: 56)
        newMessageButton.layer.cornerRadius = 56/2
        newMessageButton.anchor(bottom: view.safeAreaLayoutGuide.bottomAnchor, right: view.rightAnchor,paddingBottom: 16, paddingRight: 24 )
    }
    
    func configureNavBar(){
        configureNavigationBar(withTitle: "Messages", prefersLargeTitles: true)
    }
    
    func configuretableview(){
        tableview.backgroundColor = .white
        view.addSubview(tableview)
        tableview.frame = view.frame
        tableview.rowHeight = 80
        tableview.register(ConversationCell.self, forCellReuseIdentifier: reuseidentifier)
        tableview.separatorColor = .systemGray
        tableview.tableFooterView = UIView()
        tableview.delegate = self
        tableview.dataSource = self
    }
    
    func showChatController(forUser user: User){
        let controller = ChatController(user: user)
        navigationController?.pushViewController(controller, animated: true)
        
    }
}
extension ConversationsController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Conversations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell =  tableview.dequeueReusableCell(withIdentifier: reuseidentifier, for: indexPath) as! ConversationCell
        cell.conversation = Conversations[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = Conversations[indexPath.row].user
        showChatController(forUser: user)
    }
}
//MARK:NEWMWSSAGE CONTROLLER DELEGATE
extension ConversationsController: NewMessageControllerDelgate {
    func controller(_ controller: NewMessageContoller, wantsToChatWith user: User) {
        dismiss(animated: true, completion: nil)
showChatController(forUser: user)
    }
}
extension ConversationsController : profileControllerDelegate{
    func handleLogout() {
        logout()
    }
}
extension ConversationsController: authenticationDelegate{
    func authenticationcomplete() {
        dismiss(animated: true, completion: nil)
        configureUI()
        fetchconversations()
    }
}
