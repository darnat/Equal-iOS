//
//  MenuTabBarCell.swift
//  Equal
//
//  Created by Alexis DARNAT on 5/6/18.
//  Copyright © 2018 Alexis DARNAT. All rights reserved.
//

import UIKit

class MenuTabBarCell: UICollectionViewCell {
    
    private(set) lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .semibold)
//        label.textColor = UIColor(red: 80/255, green: 92/255, blue: 108/255, alpha: 0.85)
        label.textColor = UIColor(red: 187/255, green: 193/255, blue: 206/255, alpha: 1.0)
        label.text = "Overview"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override var isHighlighted: Bool {
        didSet {
            self.selectedState(state: isHighlighted)
        }
    }
    
    override var isSelected: Bool {
        didSet {
            self.selectedState(state: isSelected)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// UI Related
extension MenuTabBarCell {
    
    private func setupView() {
        self.setupTitleLable()
    }
    
    private func setupTitleLable() {
        self.addSubview(self.titleLabel)
        self.titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        self.titleLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    private func selectedState(state: Bool) {
        self.titleLabel.textColor = state ? UIColor(red: 80/255, green: 92/255, blue: 108/255, alpha: 0.85) : UIColor(red: 187/255, green: 193/255, blue: 206/255, alpha: 1.0)
    }
    
}
