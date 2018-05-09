//
//  ExpenseCollectionViewCell.swift
//  Equal
//
//  Created by Alexis DARNAT on 4/9/18.
//  Copyright © 2018 Alexis DARNAT. All rights reserved.
//

import UIKit
import CoreData

class ExpenseCollectionViewCell: UICollectionViewCell {
    
    private lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 80/255, green: 92/255, blue: 108/255, alpha: 1.0)
        label.font = UIFont.systemFont(ofSize: 15, weight: .bold)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var metaLabel : UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 115/255, green: 133/255, blue: 154/255, alpha: 1.0)
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var amountLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textColor = Config.primaryColor
        label.font = UIFont.boldSystemFont(ofSize: 16)
        label.textAlignment = .right
        return label
    }()
    
    private lazy var separator : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 0.8)
        return view
    }()
 
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateCellWith(ManageObject object: Expense) {
        let holders = object.getHolders(payer: true)
        let names : [String] = holders.map { $0.value(forKeyPath: "participant.nickname") as? String ?? "" }
        self.metaLabel.text = "Paid by " + names.joined(separator: ", ")
        self.titleLabel.text = object.value(forKey: "name") as? String
        
        if let amount = object.value(forKeyPath: "amount") as? Double,
            let currency = object.value(forKeyPath: "event.currency") as? Currency {
            self.updateCurrency(amount: amount, currency: currency)
        }
        
        
        if let sync_status = object.value(forKeyPath: "sync_status") as? Int, sync_status == 1 {
            self.contentView.backgroundColor = Config.primaryColor
            self.titleLabel.textColor = .white
            self.metaLabel.textColor = .white
            self.amountLabel.textColor = .white
        } else {
            self.contentView.backgroundColor = .white
            self.titleLabel.textColor = UIColor(red: 80/255, green: 92/255, blue: 108/255, alpha: 1.0)
            self.metaLabel.textColor = UIColor(red: 115/255, green: 133/255, blue: 154/255, alpha: 1.0)
            self.amountLabel.textColor = Config.primaryColor
        }
    }
    
}

// UI Related
extension ExpenseCollectionViewCell {
    
    private func updateCurrency(amount: Double, currency: Currency) {
        guard let symbol = currency.value(forKeyPath: "symbol") as? String else { return }
        self.amountLabel.text = "\(symbol)\(String(format: "%.2f", amount))"
    }
    
    private func setupView() {
        self.contentView.layer.cornerRadius = 15
        self.contentView.layer.masksToBounds = true
        self.contentView.backgroundColor = .white
        
        
        self.layer.shadowColor = UIColor(red: 106/255, green: 109/255, blue: 129/255, alpha: 1.0).cgColor
        self.layer.shadowOffset = .zero
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 1.5
        self.layer.cornerRadius = 15
        self.layer.masksToBounds = false
//        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: self.contentView.layer.cornerRadius).cgPath
        self.backgroundColor = .white
        
        self.contentView.addSubview(self.titleLabel)
        self.contentView.addSubview(self.amountLabel)
        self.contentView.addSubview(self.metaLabel)
        
//        self.addSubview(self.titleLabel)
////        self.addSubview(self.separator)
//        self.addSubview(self.amountLabel)
//        self.addSubview(self.metaLabel)
        self.setupTitleLabel()
//        self.setupSeparator()
        self.setupAmountLabel()
        self.setupMetaLabel()
    }
    
    private func setupSeparator() {
        self.separator.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        self.separator.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        self.separator.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
        self.separator.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    private func setupTitleLabel() {
        self.titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 20).isActive = true
        self.titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 12).isActive = true
    }
    
    private func setupMetaLabel() {
        self.metaLabel.leftAnchor.constraint(equalTo: self.titleLabel.leftAnchor).isActive = true
        self.metaLabel.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 5).isActive = true
    }
    
    private func setupAmountLabel() {
        self.amountLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
        self.amountLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
}
