//
//  CurrencyCollectionViewCell.swift
//  Equal
//
//  Created by Alexis DARNAT on 4/24/18.
//  Copyright © 2018 Alexis DARNAT. All rights reserved.
//

import UIKit

class CurrencyCollectionViewCell: UICollectionViewCell {
    
    let titleLabel : UILabel = {
        let label = UILabel()
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
    
    func updateCellWith(ManageObject object: Currency) {
        self.titleLabel.text = object.value(forKey: "fullname") as? String
    }
    
}

// UI Related
extension CurrencyCollectionViewCell {
    
    private func setupView() {
        self.backgroundColor = .white
        self.addSubview(self.titleLabel)
        self.setupTitleLabel()
    }
    
    private func setupTitleLabel() {
        self.titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
        self.titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        self.titleLabel.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
    }
    
}
