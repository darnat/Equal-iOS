//
//  HomeNavigationController.swift
//  Equal
//
//  Created by Alexis DARNAT on 4/5/18.
//  Copyright © 2018 Alexis DARNAT. All rights reserved.
//

import UIKit

// Comment the Code
class HomeNavigationController: UINavigationController {
    
    private var rightLargeTitleView: UIView?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.delegate = self
        self.setupNavbar()
    }
    
    private func setupNavbar() {
        navigationBar.prefersLargeTitles = true
        navigationBar.tintColor = Config.primaryColor
        navigationBar.shadowImage = UIImage()
        navigationBar.barTintColor = Config.navigationBarColor
        navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor(red: 0.102, green: 0.102, blue: 0.102, alpha: 1.0)]
    }

}

extension HomeNavigationController: UINavigationControllerDelegate {
    
    func getLargeTitleView() -> UIView? {
        for subview in self.navigationBar.subviews {
            if NSStringFromClass(subview.classForCoder) == "_UINavigationBarLargeTitleView" {
                return subview
            }
        }
        return nil
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        self.rightLargeTitleView?.removeFromSuperview()
        self.rightLargeTitleView = nil
        if let vc = viewController as? HomeViewController {
            let rightView = vc.rightLargeTitleView
            guard let largeTitleView = self.getLargeTitleView() else { return }
            self.rightLargeTitleView = rightView
            rightView.translatesAutoresizingMaskIntoConstraints = false
            largeTitleView.addSubview(rightView)
            NSLayoutConstraint.activate([
                rightView.bottomAnchor.constraint(equalTo: navigationBar.bottomAnchor, constant: -6),
                rightView.rightAnchor.constraint(equalTo: navigationBar.rightAnchor, constant: -16)
            ])
        }
    }
    
}
