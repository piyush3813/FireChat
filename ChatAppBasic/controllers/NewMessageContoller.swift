//
//  NewMessageContoller.swift
//  ChatAppBasic
//
//  Created by piyush mishra on 17/08/22.
//

import Foundation
import UIKit
private let reuseIdentifier = "UserCell"

protocol NewMessageControllerDelgate : class {
    func controller(_ controller: NewMessageContoller, wantsToChatWith User: User)
}
class NewMessageContoller: UITableViewController {
    //MARK:PROPERTIES
    private var users = [User]()
    private var filteredUsers = [User]()
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    private var insearchMode: Bool {
        return searchController.isActive &&
        !searchController.searchBar.text!.isEmpty
    }
    @objc func handleDismissal(){
        dismiss(animated: true, completion: nil)
    }
    
    weak var delegate: NewMessageControllerDelgate?
    
    //MARK:LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUi()
        configureSearchController()
        fetchUser()
    }
    //MARK:API
    
    func fetchUser(){
        showLoader(true)
        Service.fethUsers { users in
            self.users = users
            self.showLoader(false)
            self.tableView.reloadData()
            print("debug: users in new message container\(users)")
        }
    }
    
    
    
    //MARK:HELPRERS
    
    func configureUi(){
        view.backgroundColor = .white
        configureNavigationBar(withTitle: "New Messages", prefersLargeTitles: false)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleDismissal))
        
        
        tableView.tableFooterView = UIView()
        tableView.register(UserCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = 80
        
        
    }
    
    func configureSearchController(){
        searchController.searchResultsUpdater = self
        searchController.searchBar.showsCancelButton = false
        navigationItem.searchController = searchController
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "search for Users"
        definesPresentationContext = false
        
        if let textField = searchController.searchBar.value(forKey: "searchField") as? UITextField {
            textField.textColor = .systemPurple
            textField.backgroundColor = .white
        }
    }
    
}

//MARK:UITABLEVIEWDATA SOURCE
extension NewMessageContoller {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("\(users.count)")
        return insearchMode ? filteredUsers.count : users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! UserCell
        cell.user = insearchMode ? filteredUsers[indexPath.row] : users[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = insearchMode ? filteredUsers[indexPath.row] : users[indexPath.row]
        delegate?.controller(self, wantsToChatWith: user)
    }
}
extension NewMessageContoller: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchtext = searchController.searchBar.text?.lowercased() else {return}
        filteredUsers = users.filter({ user -> Bool in
            return user.username.contains(searchtext) || user.fullName.contains(searchtext)
        })
        self.tableView.reloadData()

        
        print("Debug: filtered users \(filteredUsers)")
    }
    
    
}
