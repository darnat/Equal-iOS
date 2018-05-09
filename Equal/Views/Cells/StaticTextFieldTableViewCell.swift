//
//  StaticTextFieldTableViewCell.swift
//  Equal
//
//  Created by Alexis DARNAT on 4/17/18.
//  Copyright © 2018 Alexis DARNAT. All rights reserved.
//

import UIKit

class StaticTextFieldTableViewCell: StaticTableViewCell {
    
    lazy var divider : UIView = {
        let divider = UIView()
        divider.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)
        divider.translatesAutoresizingMaskIntoConstraints = false
        return divider
    }()
    
    // Code here
    lazy var textField : UITextField = {
        let textField = UITextField()
        textField.addSubview(divider)
        NSLayoutConstraint.activate([
            divider.bottomAnchor.constraint(equalTo: textField.bottomAnchor),
            divider.leftAnchor.constraint(equalTo: textField.leftAnchor),
            divider.rightAnchor.constraint(equalTo: textField.rightAnchor),
            divider.heightAnchor.constraint(equalToConstant: 1.0)
        ])
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.placeholder = "name"
        return textField
        }()
    
    override func setupView() {
        super.setupView()
        self.setupTextField()
    }
}

// UI Related
extension StaticTextFieldTableViewCell {
    
        private func setupTextField() {
            self.addSubview(self.textField)
            NSLayoutConstraint.activate([
                self.textField.leftAnchor.constraint(equalTo: self.titleLabel.rightAnchor, constant: 5),
                self.textField.rightAnchor.constraint(equalTo: self.rightAnchor, constant: -10),
                self.textField.topAnchor.constraint(equalTo: self.topAnchor),
                self.textField.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            ])
        }
}
