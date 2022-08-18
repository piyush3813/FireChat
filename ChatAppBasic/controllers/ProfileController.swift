//
//  ProfileController.swift
//  ChatAppBasic
//
//  Created by piyush mishra on 18/08/22.
//

import Foundation
import Firebase
import UIKit
private let reuseIdentifieer = "profileCell"

protocol profileControllerDelegate: class{
    func handleLogout()
}
class ProfileController: UITableViewController{
    
    //mark:properties
    weak var delegate : profileControllerDelegate?
    private var user: User?{
        didSet{
            headerView.user = user
        }
    }
    private lazy var headerView = ProfileHeader(frame: .init(x: 0, y: 0,
                                                             width: view.frame.width,
                                                             height: 380))
    private let footerView = ProfilefooterView()
    
    //mark:lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        fetchUser()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
    }
    
    //mark:selectors
    
    
    
    
    //mark:api
    func fetchUser(){
        
        guard let uid = Auth.auth().currentUser?.uid else {return}
        showLoader(true)
        Service.fetchuser(withUID: uid) { user in
            self.showLoader(false)
            self.user = user
            print("DEBUG: user is \(user.username)")
        }
    }
    //mark:handlers
    
    func configureUI(){
        
        tableView.backgroundColor = .white
        tableView.tableHeaderView = headerView
        headerView.delegate = self
        tableView.register(ProfileCell.self, forCellReuseIdentifier: reuseIdentifieer)
        tableView.contentInsetAdjustmentBehavior = .never
        tableView.rowHeight = 64
        
        tableView.backgroundColor = .systemGroupedBackground
        footerView.delegate = self
        footerView.frame = .init(x: 0, y: 0, width: view.frame.width, height: 100)
        tableView.tableFooterView = footerView
        
    }
}
//tableviewdata
extension ProfileController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ProfileViewModel.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifieer, for: indexPath) as! ProfileCell
        let viewModel = ProfileViewModel(rawValue: indexPath.row)
        cell.accessoryType = .disclosureIndicator
        cell.viewModel = viewModel
        
        
        return cell
    }
    
    
}
extension ProfileController: ProfileHeaderdelegate{
    func dismissController() {
        dismiss(animated: true, completion: nil)
    }
}

extension ProfileController: ProfileFooterDelegate{
    func handleLogout() {
        let alert = UIAlertController(title: nil, message: "are you sure you want to logout", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Logout", style: .destructive, handler: { _ in
            self.dismiss(animated: true, completion: nil)
            self.delegate?.handleLogout()
        }))
        alert.addAction(UIAlertAction(title: "cancel", style: .cancel))
        present(alert, animated: true, completion: nil)
        
    }
}
extension ProfileController{
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let viewModel = ProfileViewModel(rawValue: indexPath.row) else {return}
        print("Debug handle action fro \(viewModel.description)")
    }
}
