//
//  RoundedButton.swift
//  Equal
//
//  Created by Alexis DARNAT on 4/9/18.
//  Copyright © 2018 Alexis DARNAT. All rights reserved.
//

import UIKit

class RoundedButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    private func setupView() {
        self.tintColor = .white
        self.backgroundColor = Config.primaryColor
        self.layer.masksToBounds = false
        self.layer.cornerRadius = 30
        self.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 2)
        self.layer.shadowOpacity = 0.25
        self.layer.shadowRadius = 5
        self.contentEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
    }
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
