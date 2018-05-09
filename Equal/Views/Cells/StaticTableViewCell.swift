//
//  StaticTableViewCell.swift
//  Equal
//
//  Created by Alexis DARNAT on 4/17/18.
//  Copyright © 2018 Alexis DARNAT. All rights reserved.
//

import UIKit

class StaticTableViewCell: UITableViewCell {
    
    var title : String? {
        get {
            return self.titleLabel.text
        }
        set(newValue) {
            self.titleLabel.text = newValue
        }
    }
    
    internal lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.tintColor = .gray
        return label
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupView()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    internal func setupView() {
        self.backgroundColor = .white
        self.setupTitleLabel()
    }
    
}

// UI related
extension StaticTableViewCell {
    
    private func setupTitleLabel() {
        self.addSubview(self.titleLabel)
        NSLayoutConstraint.activate([
            self.titleLabel.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 15),
            self.titleLabel.topAnchor.constraint(equalTo: self.topAnchor),
            self.titleLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            self.titleLabel.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.20)
        ])
    }
    
}
