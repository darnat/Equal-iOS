//
//  UserImageContainer.swift
//  Equal
//
//  Created by Alexis DARNAT on 5/7/18.
//  Copyright © 2018 Alexis DARNAT. All rights reserved.
//

import UIKit

class UserImageContainer: UIView {
    
    lazy var label : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 14, weight: .bold)
        label.textColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.85)
        label.text = "Alex."
        return label
    }()
    
    lazy var ownerView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.cornerRadius = 8
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.borderWidth = 3.0
        view.layer.masksToBounds = true
        var gradientLayer = CAGradientLayer()
        gradientLayer.frame = CGRect(x: 3, y: 3, width: 10.0, height: 10.0)
        gradientLayer.colors = [UIColor(red: 0, green: 127/255, blue: 1.0, alpha: 1.0).cgColor,
                                UIColor(red: 92/255, green: 2/255, blue: 1.0, alpha: 1.0).cgColor]
        view.layer.addSublayer(gradientLayer)
        view.isHidden = true
        return view
    }()
    
    lazy var imageView : UIImageView = {
        let view = UIImageView()
        view.contentMode = .scaleAspectFill
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 26.0
        return view
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
extension UserImageContainer {
    
    private func setupView() {
        self.backgroundColor = .purple
        self.setupLabel()
        self.setupImageView()
        self.setupOwnerView()
    }
    
    private func setupOwnerView() {
        self.addSubview(self.ownerView)
        self.ownerView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 1).isActive = true
        self.ownerView.rightAnchor.constraint(equalTo: rightAnchor, constant: 1).isActive = true
        self.ownerView.widthAnchor.constraint(equalToConstant: 16.0).isActive = true
        self.ownerView.heightAnchor.constraint(equalTo: self.ownerView.widthAnchor).isActive = true
    }
    
    private func setupLabel() {
        self.addSubview(self.label)
        self.label.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        self.label.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    private func setupImageView() {
        self.addSubview(self.imageView)
        self.imageView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        self.imageView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        self.imageView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        self.imageView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
    }
    
}
