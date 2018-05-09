//
//  HostedCollectionViewCell.swift
//  Equal
//
//  Created by Alexis DARNAT on 5/7/18.
//  Copyright © 2018 Alexis DARNAT. All rights reserved.
//

import UIKit

class HostedCollectionViewCell: UICollectionViewCell {
    
    var hostedView: UIView? {
        didSet {
            if let hostedView: UIView = hostedView {
                self.contentView.addSubview(hostedView)
                hostedView.translatesAutoresizingMaskIntoConstraints = false
                hostedView.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
                hostedView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
                hostedView.leftAnchor.constraint(equalTo: self.contentView.leftAnchor).isActive = true
                hostedView.rightAnchor.constraint(equalTo: self.contentView.rightAnchor).isActive = true
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.hostedView?.removeFromSuperview()
        self.hostedView = nil
    }
    
}
