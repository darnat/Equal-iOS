//
//  EqualDetailHeaderView.swift
//  Equal
//
//  Created by Alexis DARNAT on 4/28/18.
//  Copyright © 2018 Alexis DARNAT. All rights reserved.
//

import UIKit

class EqualDetailHeaderView: UICollectionReusableView {
    
    private lazy var titleLabel : UILabel = {
        let label = UILabel()
        label.textColor = UIColor(red: 187/255, green: 193/255, blue: 206/255, alpha: 1.0)
        label.font = UIFont.systemFont(ofSize: 12, weight: .bold)
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
    
    func updateWith(Title title: String) {
        self.titleLabel.text = title
    }
    
    func updateWith(rawDate: String) {
        guard !rawDate.isEmpty else {
            self.titleLabel.text = "Not synchronized".uppercased()
            return
        }
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        if let date = formatter.date(from: rawDate) {
            self.titleLabel.text = date.timeAgo().uppercased()
        }
    }
    
}

// UI Related
extension EqualDetailHeaderView {
    
    private func setupView() {
        self.addSubview(self.titleLabel)
        self.setupTitleLabel()
    }
    
    private func setupTitleLabel() {
        self.titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5).isActive = true
        self.titleLabel.leftAnchor.constraint(equalTo: leftAnchor, constant: 28).isActive = true
    }
    
}

