//
//  PresentNavigationController.swift
//  Equal
//
//  Created by Alexis DARNAT on 4/17/18.
//  Copyright © 2018 Alexis DARNAT. All rights reserved.
//

import UIKit

class PresentNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavbar()
    }

    private func setupNavbar() {
        navigationBar.tintColor = Config.primaryColor
    }

}
