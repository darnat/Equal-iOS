//
//  ViewController.swift
//  Equal
//
//  Created by Alexis DARNAT on 3/31/18.
//  Copyright © 2018 Alexis DARNAT. All rights reserved.
//

import UIKit

// Comment the Code
class LoginController: UIViewController {
    private let networkController : NetworkController
    private let authController : AuthController
    
    /**
        UI Element
     **/
    let loginButon : UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(red: 61/255, green: 91/255, blue: 151/255, alpha: 1.0)
        button.tintColor = .white
        button.setTitle("Login", for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(loginButtonAction(button:)), for: .touchUpInside)
        return button
    }()
    let emailTextfield : UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Email"
        textfield.keyboardType = .emailAddress
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()
    let passwordTextfield : UITextField = {
        let textfield = UITextField()
        textfield.placeholder = "Password"
        textfield.isSecureTextEntry = true
        textfield.translatesAutoresizingMaskIntoConstraints = false
        return textfield
    }()
    
    
    init(networkController: NetworkController, authController: AuthController) {
        self.networkController = networkController
        self.authController = authController
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    private func setupView() {
        self.view.backgroundColor = .white
        view.addSubview(self.emailTextfield)
        self.emailTextfield.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        self.emailTextfield.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -100).isActive = true
        self.emailTextfield.heightAnchor.constraint(equalToConstant: 40).isActive = true
        self.emailTextfield.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        view.addSubview(self.passwordTextfield)
        self.passwordTextfield.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        self.passwordTextfield.topAnchor.constraint(equalTo: self.emailTextfield.bottomAnchor, constant: 10).isActive = true
        self.passwordTextfield.heightAnchor.constraint(equalToConstant: 40).isActive = true
        self.passwordTextfield.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        view.addSubview(self.loginButon)
        self.loginButon.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        self.loginButon.topAnchor.constraint(equalTo: self.passwordTextfield.bottomAnchor, constant: 10.0).isActive = true
        self.loginButon.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        self.loginButon.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(networkError(notification:)), name: Notification.Name.Network.didCompleteWithError, object: nil)
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func loginButtonAction(button: UIButton) {
        guard let email = emailTextfield.text, let password = passwordTextfield.text else { fatalError("Unable to get credentials") }
        self.networkController.login(credentials: (email, password), authController: authController)
    }
}

// Network related
extension LoginController {
    @objc func networkError(notification: Notification) {
        if let userInfo = notification.userInfo,
            let error = userInfo["error"] {
            switch error {
            case let error as NetworkError:
                print(error.code)
                print(error.errors ?? "nil")
                break
            default:
                break
            }
        }
    }
}

// UI related
extension LoginController {
    
}
