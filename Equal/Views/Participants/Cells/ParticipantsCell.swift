//
//  ParticipantsCell.swift
//  Equal
//
//  Created by Alexis DARNAT on 5/7/18.
//  Copyright © 2018 Alexis DARNAT. All rights reserved.
//

import UIKit

class ParticipantsCell: HostedCollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// UI Related
extension ParticipantsCell {
    
    private func setupView() {
        self.backgroundColor = .white
    }
    
}
