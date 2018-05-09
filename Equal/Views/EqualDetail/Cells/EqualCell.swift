//
//  EqualCell.swift
//  Equal
//
//  Created by Alexis DARNAT on 5/5/18.
//  Copyright © 2018 Alexis DARNAT. All rights reserved.
//

import UIKit
import CoreData

class EqualCell: HostedCollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// UI Related
extension EqualCell {
    
    private func setupView() {
        self.backgroundColor = .green
    }
    
}
