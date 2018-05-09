//
//  ParticipantCell.swift
//  Equal
//
//  Created by Alexis DARNAT on 5/7/18.
//  Copyright © 2018 Alexis DARNAT. All rights reserved.
//

import UIKit

class ParticipantCell: UICollectionViewCell {
 
    lazy var imageContainer : UserImageContainer = {
        let view = UserImageContainer()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 142/255, green: 142/255, blue: 147/255, alpha: 0.8)
        view.layer.cornerRadius = 26.0
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
extension ParticipantCell {
    
    private func setupView() {
        self.setupImageContainer()
        self.setupLabel()
    }
    
    private func setupLabel() {
        self.addSubview(self.label)
        self.label.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        self.label.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true;
    }
    
    private func setupImageContainer() {
        self.addSubview(self.imageContainer)
        self.imageContainer.topAnchor.constraint(equalTo: topAnchor, constant: 5.0).isActive = true
        self.imageContainer.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        self.imageContainer.widthAnchor.constraint(equalToConstant: 54.0).isActive = true
        self.imageContainer.heightAnchor.constraint(equalTo: self.imageContainer.widthAnchor).isActive = true
    }
    
    func inviteCell() {
        self.label.text = "Invite"
        self.imageContainer.label.text = "Invite"
        self.imageContainer.imageView.image = UIImage(named: "User")
    }
    
    func updateCellWith(ManageObject object: Participant) {
        let balance = object.value(forKey: "balance") as? Double ?? 0.0
        self.label.text = String(format: "%@%@%.2f", balance < 0.0 ? "-" : "", object.value(forKeyPath: "event.currency.symbol") as? String ?? "", abs(balance))
        let nickname = object.value(forKey: "nickname") as? String ?? ""
        self.imageContainer.label.text = nickname.prefix(4) + "."
        
        if let owner = object.value(forKey: "owner") as? Bool, owner == true {
            self.imageContainer.ownerView.isHidden = false
        }
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageContainer.imageView.image = nil
        self.imageContainer.ownerView.isHidden = true
    }
    
}
