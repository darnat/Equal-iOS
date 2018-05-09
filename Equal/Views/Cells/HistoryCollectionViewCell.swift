//
//  HistoryCollectionViewCell.swift
//  Equal
//
//  Created by Alexis DARNAT on 4/16/18.
//  Copyright © 2018 Alexis DARNAT. All rights reserved.
//

import UIKit
import CoreData

class HistoryCollectionViewCell: UICollectionViewCell {
    
    private lazy var separatorView : UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 0.9, green: 0.9, blue: 0.9, alpha: 0.8)
        return view
    }()
    
    private lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Test"
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
extension HistoryCollectionViewCell {
    
    private func setupView() {
        self.backgroundColor = .white
        self.addSubview(self.separatorView)
        self.addSubview(self.titleLabel)
        self.setupSeparator()
        self.setupLabel()
    }
    
    private func setupLabel() {
        self.titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 5).isActive = true
        self.titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
    }
    
    private func setupSeparator() {
        self.separatorView.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true
        self.separatorView.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        self.separatorView.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
        self.separatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
}
