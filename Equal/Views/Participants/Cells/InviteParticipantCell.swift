//
//  InviteParticipantCell.swift
//  Equal
//
//  Created by Alexis DARNAT on 5/8/18.
//  Copyright © 2018 Alexis DARNAT. All rights reserved.
//

import UIKit

class InviteParticipantCell: UICollectionViewCell {
    
    lazy var imageContainer : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 199/255, green: 199/255, blue: 201/255, alpha: 0.8)
        view.layer.cornerRadius = 26.0
        return view
    }()
    
    lazy var imageView : UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.image = UIImage(named: "User")
        view.contentMode = .scaleAspectFill
        return view
    }()
    
    lazy var addImageView: UIImageView = {
        let view = UIImageView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        view.contentMode = .center
        view.image = UIImage(named: "Add")
        view.layer.borderColor = UIColor.white.cgColor
        view.layer.borderWidth = 3.0
        view.layer.cornerRadius = 8
        return view
    }()
    
    private lazy var label: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 11, weight: .semibold)
        label.textColor = UIColor(red: 80/255, green: 92/255, blue: 108/255, alpha: 0.85)
        label.text = "Invite"
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
extension InviteParticipantCell {
    
    private func setupView() {
        self.setupImageContainer()
        self.setupImageView()
        self.setupLabel()
        self.setupAddImageView()
    }
    
    private func setupAddImageView() {
        self.imageContainer.addSubview(self.addImageView)
        self.addImageView.widthAnchor.constraint(equalToConstant: 16.0).isActive = true
        self.addImageView.heightAnchor.constraint(equalTo: self.addImageView.widthAnchor).isActive = true
        self.addImageView.bottomAnchor.constraint(equalTo: self.imageContainer.bottomAnchor, constant: 1).isActive = true
        self.addImageView.rightAnchor.constraint(equalTo: self.imageContainer.rightAnchor, constant: 1).isActive = true
    }
    
    private func setupImageContainer() {
        self.addSubview(self.imageContainer)
        self.imageContainer.topAnchor.constraint(equalTo: topAnchor, constant: 5.0).isActive = true
        self.imageContainer.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        self.imageContainer.widthAnchor.constraint(equalToConstant: 54.0).isActive = true
        self.imageContainer.heightAnchor.constraint(equalTo: self.imageContainer.widthAnchor).isActive = true
    }
    
    private func setupImageView() {
        self.imageContainer.addSubview(self.imageView)
        self.imageView.widthAnchor.constraint(equalToConstant: 20.0).isActive = true
        self.imageView.heightAnchor.constraint(equalTo: self.imageView.widthAnchor).isActive = true
        self.imageView.centerXAnchor.constraint(equalTo: self.imageContainer.centerXAnchor).isActive = true
        self.imageView.centerYAnchor.constraint(equalTo: self.imageContainer.centerYAnchor).isActive = true
    }
    
    private func setupLabel() {
        self.addSubview(self.label)
        self.label.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        self.label.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true;
    }
}
