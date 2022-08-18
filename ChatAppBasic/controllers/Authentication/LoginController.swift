//
//  LoginController.swift
//  ChatAppBasic
//
//  Created by piyush mishra on 16/08/22.
//

import UIKit
import Firebase
import JGProgressHUD

protocol authenticationDelegate: class {
    func authenticationcomplete()
}

class LoginController : UIViewController{
    //MARK:Propertier
    
    private var viewModel = LoginViewModel()
    weak var delegate : authenticationDelegate?
    private let iconImage : UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "bubble.right")
        image.tintColor = .white
        return image
    }()
    
    private lazy var emailcontainer : InputContainerView = {
        return  InputContainerView(image: UIImage(systemName: "envelope"), textField: emailTextField)
    }()
    
    private lazy var passwordcontainer : InputContainerView = {
       return InputContainerView(image: UIImage(systemName: "lock"), textField: passwordTextField)
    }()
    
    private let emailTextField = CustomTextField(placeholder: "Email Address..")
       
    
    private let passwordTextField : CustomTextField = {
        let tf = CustomTextField(placeholder: "Password")
        tf.isSecureTextEntry = true
        return tf
    }()
    private let loginButton: UIButton = {
        let button =  UIButton(type: .system)
        button.setTitle("Login", for: .normal)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.backgroundColor = .systemPink
        button.setTitleColor(.white, for: .normal)
        button.setheights(height: 50)
        button.isEnabled = false
        button.addTarget(self, action: #selector(handleLoginButton), for: .touchUpInside)
        
        return button
    }()
    
    private let dontHaveAccountButton: UIButton = {
        let button = UIButton(type: .system)
        let attributedtitile = NSMutableAttributedString(string: "Don't have an account ", attributes: [.font: UIFont.boldSystemFont(ofSize: 16), .foregroundColor:UIColor.white])
        attributedtitile.append(NSAttributedString(string: "SignUP ", attributes: [.font: UIFont.boldSystemFont(ofSize: 16), .foregroundColor:UIColor.white]))
        
        button.setAttributedTitle(attributedtitile, for: .normal)
        button.addTarget(self, action: #selector(handleSignUp), for: .touchUpInside)
        return button
    }()
    //MARK:Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
    }
    //HELP:SELECTORS
    @objc func handleSignUp(){
        let controller = RegistrationController()
        controller.delegate = delegate
        navigationController?.pushViewController(controller, animated: true)
    }
    
    @objc func textDidChange(sender: UITextField){
        if sender == emailTextField{
            viewModel.email = sender.text
        }else{
            viewModel.password = sender.text
        }
        
        checkFormStatus()
    }
    
    @objc func handleLoginButton(){
        guard let email = emailTextField.text else {return}
        guard let password = passwordTextField.text else {return}
        
      showLoader(true, withText: "Logging In")
        Authservice.shared.loguserIn(with: email, password: password) { result, error in
            if let error = error {
                self.showLoader(false)
                self.showErrorMessages(error.localizedDescription)
                

                return
            }
            self.showLoader(false)
            self.delegate?.authenticationcomplete()
        }
    }
    
    //MARK:HELPER
    
    func checkFormStatus() {
        if viewModel.formIsValid {
            loginButton.isEnabled = true
            loginButton.backgroundColor = .systemBlue
            
            
        }else{
            loginButton.isEnabled = false
            loginButton.backgroundColor = .systemPink
        }
        
        
    }
    
    func configureUI(){
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barStyle = .black
        
        configureGradientLayer()
        view.addSubview(iconImage)
        iconImage.centerX(inView: view)
        iconImage.anchor(top:view.safeAreaLayoutGuide.topAnchor, paddingTop: 32)
        iconImage.setDimensions(height: 120, width: 120)
        let stack = UIStackView(arrangedSubviews: [emailcontainer,passwordcontainer,loginButton])
        view.addSubview(stack)
        stack.axis = .vertical
        stack.spacing = 16
        stack.anchor(top:iconImage.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 32, paddingLeft: 32, paddingRight: 32)
        view.addSubview(dontHaveAccountButton)
        dontHaveAccountButton.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingLeft: 32,paddingBottom: 32, paddingRight: 32)
        
        emailTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)
        passwordTextField.addTarget(self, action: #selector(textDidChange), for: .editingChanged)


    }
    
    
}

