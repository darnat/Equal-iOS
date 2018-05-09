//
//  DetailedTitleView.swift
//  Equal
//
//  Created by Alexis DARNAT on 4/25/18.
//  Copyright © 2018 Alexis DARNAT. All rights reserved.
//

import UIKit

class DetailedTitleButton: UIButton {
    
    lazy var smallTitleLabel : UILabel = {
        let label = UILabel()
        label.textColor = .black
        label.backgroundColor = .black
        return label
    }()
    
    lazy var moreLabel : UILabel = {
        let label = UILabel()
        label.text = ">"
        label.textColor = .gray
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// UI Related
extension DetailedTitleButton {
    
    private func setupView() {
        self.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        self.setTitleColor(.black, for: .normal)
        self.setTitleColor(.gray, for: .highlighted)
        self.addSubview(self.moreLabel)
        self.setupMoreLabel()
    }
    
    private func setupMoreLabel() {
        self.moreLabel.topAnchor.constraint(equalTo: topAnchor, constant: 8.0).isActive = true
        self.moreLabel.leftAnchor.constraint(equalTo: rightAnchor, constant: 4.0).isActive = true
    }
    
}
