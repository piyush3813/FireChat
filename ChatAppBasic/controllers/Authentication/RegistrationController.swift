//
//  RegistrationController.swift
//  ChatAppBasic
//
//  Created by piyush mishra on 17/08/22.
//


import UIKit
import Firebase

class RegistrationController : UIViewController {
    //MARK:PROPERTIES
    private var viewModel = RegistrationViewModel()
    private var profileImage: UIImage?
    weak var delegate: authenticationDelegate?
    private let photo: UIButton = {
        let pic = UIButton(type: .system)
        pic.setImage(UIImage(named: "adduser")?.withRenderingMode(.alwaysOriginal), for: .normal)
        pic.addTarget(self, action: #selector(handlePhotoSelection), for: .touchUpInside)
        pic.tintColor = .white
        pic.layer.borderWidth = 1
        pic.layer.masksToBounds = true
        pic.layer.cornerRadius = 100
        pic.imageView?.contentMode = .scaleToFill
        pic.layer.borderColor = UIColor.white.cgColor
        
        return pic
    }()
    
    private lazy var emailcontainer : InputContainerView = {
        return  InputContainerView(image: UIImage(systemName: "envelope"), textField: emailTextField)
    }()
    
    private lazy var fullNameContainer : InputContainerView = {
        return  InputContainerView(image: UIImage(systemName: "person"), textField: fullNameTextField)
    }()
    
    private lazy var UserNameContainer : InputContainerView = {
        return  InputContainerView(image: UIImage(systemName: "person"), textField: userNameTextField)
    }()
    
    private lazy var passwordcontainer : InputContainerView = {
        return InputContainerView(image: UIImage(systemName: "lock"), textField: passwordTextField)
    }()
    
    private let emailTextField = CustomTextField(placeholder: "Email Address..")
    private let fullNameTextField = CustomTextField(placeholder: "Full Name")
    private let userNameTextField = CustomTextField(placeholder: "User Name")
    
    
    private let passwordTextField : CustomTextField = {
        let tf = CustomTextField(placeholder: "Password")
        tf.isSecureTextEntry = true
        return tf
    }()
    
    private let signUpButton: UIButton = {
        let button =  UIButton(type: .system)
        button.setTitle("SignUp", for: .normal)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.backgroundColor = .systemPink
        button.setTitleColor(.white, for: .normal)
        button.setheights(height: 50)
        button.addTarget(self, action: #selector(handleRegistration), for: .touchUpInside)
        
        return button
    }()
    
    private let HaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedtitile = NSMutableAttributedString(string: "Don't have an account ", attributes: [.font: UIFont.boldSystemFont(ofSize: 16), .foregroundColor:UIColor.white])
        attributedtitile.append(NSAttributedString(string: "SignUP ", attributes: [.font: UIFont.boldSystemFont(ofSize: 16), .foregroundColor:UIColor.white]))
        
        button.setAttributedTitle(attributedtitile, for: .normal)
        button.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return button
    }()
    //MARK:LIFECYCLE
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    //MARK:SELECTORS
    @objc func handleLogin(){
        let controller = LoginController()
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func handleRegistration(){
        guard let email = emailTextField.text else {return}
        guard let password = passwordTextField.text else {return}
        guard let username = userNameTextField.text?.lowercased() else {return}
        guard let fullname = fullNameTextField.text else {return}
        guard let profileImage = profileImage else {return}
        
        let credentials = RegistrationCredentials(email: email, password: password, fullname: fullname, username: username, profileImage: profileImage)
        showLoader(true, withText: "Signing You Up")
        Authservice.shared.createUser(credentials: credentials) { error in
            if let error = error {
                self.showLoader(false)
                self.showErrorMessages(error.localizedDescription)
//                print("error found in registration \(error.localizedDescription)")
                
            }
            self.showLoader(false)
            self.delegate?.authenticationcomplete()
            
        }
    }
    
    @objc func handlePhotoSelection (){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    @objc func textDidChange(sender: UITextField){
        if sender == emailTextField{
            viewModel.email = sender.text
        }else if sender == passwordTextField{
            viewModel.password = sender.text
        } else if sender == fullNameTextField{
            viewModel.fullname = sender.text
        }else{
            viewModel.username = sender.text
        }
        
        checkFormStatus()
    }
    
    @objc func keyboardWillShow(){
        if view.frame.origin.y == 0{
            self.view.frame.origin.y -= 88
        }
        
    }
    
    @objc func keyboardWillHide(){
        if view.frame.origin.y != 0{
            self.view.frame.origin.y = 0
        }
    }
    
    
    //MARK:HELPERS
    func checkFormStatus() {
        if viewModel.formIsValid {
            signUpButton.isEnabled = true
            signUpButton.backgroundColor = .systemBlue
            
        }else{
            signUpButton.isEnabled = false
            signUpButton.backgroundColor = .systemPink
        }
    }
    
    func configureUI(){
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
        
        configureGradientLayer()
        
        view.addSubview(photo)
        photo.centerX(inView: view)
        photo.anchor(top: view.safeAreaLayoutGuide.topAnchor, paddingTop: 32)
        photo.setDimensions(height: 200, width: 200)
        
        let stack = UIStackView(arrangedSubviews: [emailcontainer,fullNameContainer,UserNameContainer,passwordcontainer,signUpButton])
        view.addSubview(stack)
        stack.axis = .vertical
        stack.spacing = 16
        stack.anchor(top:photo.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 32, paddingLeft: 32, paddingRight: 32)
        view.addSubview(HaveAccountButton)
        HaveAccountButton.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingLeft: 32,paddingBottom: 32, paddingRight: 32)
        
        emailTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        fullNameTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        userNameTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    
}
extension RegistrationController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.originalImage] as? UIImage
        profileImage = image
        photo.setImage(image?.withRenderingMode(.alwaysOriginal), for: .normal)
        photo.layer.borderColor = UIColor.white.cgColor
        photo.layer.borderWidth = 3.0
        photo.layer.cornerRadius = 100
        
        dismiss(animated: true, completion: nil)
    }
}
