//
//  UserViewController.swift
//  Equal
//
//  Created by Alexis DARNAT on 5/3/18.
//  Copyright © 2018 Alexis DARNAT. All rights reserved.
//

import UIKit
import Eureka

class UserViewController: FormViewController {
    private let networkController : NetworkController
    private let authController : AuthController

    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Profil"
        self.setupView()
        self.setupForm()
    }
    
    init(networkController: NetworkController, authController: AuthController) {
        self.networkController = networkController
        self.authController = authController
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// UI Related
extension UserViewController {
    
    private func setupView() {
        navigationItem.largeTitleDisplayMode = .always
        self.view.backgroundColor = .white
        self.tableView.backgroundColor = .white
    }
    
}

// Form Related
extension UserViewController {
    
    private func setupForm() {
        form +++ Section("Image")
            <<< BigTextRow() { row in
                row.title = "Name"
//                row.placeholder = "Full Name"
            }
            <<< TextRow() { row in
                row.title = "Email"
                row.placeholder = "Email Address"
            }
            <<< TextRow() { row in
                row.title = "Phone"
                row.placeholder = "Phone Number"
            }
    }
    
}
