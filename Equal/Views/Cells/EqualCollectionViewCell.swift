//
//  EqualCollectionViewCell.swift
//  Equal
//
//  Created by Alexis DARNAT on 4/5/18.
//  Copyright © 2018 Alexis DARNAT. All rights reserved.
//

import UIKit
import CoreData

// Comment Code
class EqualCollectionViewCell: UICollectionViewCell {
    
    let participantLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.backgroundColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1.0)
        label.textColor = .white
//        label.font = UIFont.systemFont(ofSize: 40, weight: .bold)
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.layer.cornerRadius = 9
        label.layer.masksToBounds = true
        label.textAlignment = .center
        return label
    }()
    
    let illustrationView : UIImageView = {
        let array = ["Mountains", "River", "Beach", "Castle", "Tent"]
        let randomIndex = Int(arc4random_uniform(UInt32(array.count)))
        let image = UIImage(named: array[randomIndex])
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let currencyLabel : UILabel = {
        let label = UILabel()
        label.backgroundColor = Config.primaryColor
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = .white
        label.layer.cornerRadius = 12
        label.layer.masksToBounds = true
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        return label
    }()
    
    let titleLabel : UILabel = {
        let label = UILabel()
//        label.backgroundColor = .purple
        label.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let metaLabel : UILabel = {
        let label = UILabel()
//        label.backgroundColor = .red
        label.textColor = .gray
        label.font = UIFont.systemFont(ofSize: 16, weight: .thin)
        label.numberOfLines = 1
        label.lineBreakMode = .byTruncatingTail
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let synchronizeActivityIndicator : UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.hidesWhenStopped = true
//        activityIndicator.backgroundColor = .green
        return activityIndicator
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateCellWith(ManageObject object: NSManagedObject) {
        self.synchronizeActivityIndicator.stopAnimating()
        guard let participants = object.value(forKey: "participants") as? NSSet else { fatalError("Unable to access to the participants") }
        self.titleLabel.text = object.value(forKey: "title") as? String
        self.metaLabel.text = object.value(forKey: "body") as? String
        self.participantLabel.text = " \(participants.count) participant(s)   "
        self.currencyLabel.text = object.value(forKeyPath: "currency.symbol") as? String
        if let syncing = object.value(forKey: "syncing") as? Bool, syncing == true,
            let sync_status = object.value(forKey: "sync_status") as? Int, sync_status > 0 {
            self.synchronizeActivityIndicator.startAnimating()
        }
        if let sync_status = object.value(forKey: "sync_status") as? Int, sync_status > 0 {
            self.participantLabel.backgroundColor = Config.primaryColor
        }
    }
    
}

// UI Related
extension EqualCollectionViewCell {
    private func setupView() {
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = .zero
        self.layer.shadowOpacity = 0.15
        self.layer.shadowRadius = 10
        self.layer.cornerRadius = 10
        backgroundColor = .white
        
        addSubview(self.participantLabel)
        addSubview(self.titleLabel)
        addSubview(self.metaLabel)
        addSubview(self.synchronizeActivityIndicator)
        addSubview(self.currencyLabel)
        addSubview(self.illustrationView)
        
        self.illustrationView.topAnchor.constraint(equalTo: topAnchor, constant: 15).isActive = true
        self.illustrationView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15).isActive = true
        self.illustrationView.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        self.illustrationView.widthAnchor.constraint(equalTo: self.illustrationView.heightAnchor).isActive = true
        
        
        self.titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 28).isActive = true
        self.titleLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
        self.titleLabel.leftAnchor.constraint(equalTo: self.illustrationView.rightAnchor, constant: 15).isActive = true
        
        self.setupActivityIndicator()
        self.setupCurrencyLabel()
        self.setupParticipantLabel()
        
        self.metaLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 5).isActive = true
        self.metaLabel.rightAnchor.constraint(equalTo: self.synchronizeActivityIndicator.leftAnchor, constant: -5).isActive = true
        self.metaLabel.leftAnchor.constraint(equalTo: self.titleLabel.leftAnchor).isActive = true
//        self.metaLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    private func setupParticipantLabel() {
//        self.participantLabel.topAnchor.constraint(equalTo: topAnchor, constant: -6).isActive = true
        self.participantLabel.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
        self.participantLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -5).isActive = true
        //        self.participantLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20).isActive = true
        //        self.participantLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        self.participantLabel.heightAnchor.constraint(equalToConstant: 18).isActive = true
//        self.participantLabel.widthAnchor.constraint(equalTo: self.participantLabel.heightAnchor).isActive = true
    }
    
    private func setupCurrencyLabel() {
        self.currencyLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 6).isActive = true
        self.currencyLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: 6).isActive = true
        self.currencyLabel.heightAnchor.constraint(equalToConstant: 24).isActive = true
        self.currencyLabel.widthAnchor.constraint(equalToConstant: 24).isActive = true
    }
    
    private func setupActivityIndicator() {
        self.synchronizeActivityIndicator.topAnchor.constraint(equalTo: self.metaLabel.topAnchor).isActive = true
        self.synchronizeActivityIndicator.rightAnchor.constraint(equalTo: self.titleLabel.rightAnchor).isActive = true
        self.synchronizeActivityIndicator.heightAnchor.constraint(equalToConstant: 20).isActive = true
        self.synchronizeActivityIndicator.widthAnchor.constraint(equalToConstant: 20).isActive = true
    }
}
