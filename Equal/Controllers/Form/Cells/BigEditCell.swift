//
//  BigEditCell.swift
//  Equal
//
//  Created by Alexis DARNAT on 5/4/18.
//  Copyright © 2018 Alexis DARNAT. All rights reserved.
//

import Foundation
import Eureka

final class BigTextRow: Row<BigCell>, RowType {
    required public init(tag: String?) {
        super.init(tag: tag)
    }
}

final class BigCell: Cell<String>, CellType {
    
    override func setup() {
        super.setup()
        
        self.setupTextLabel()
        
        height = { return 76.0 }
    }
    
    override func update() {
        super.update()
    }
    
    private func setupTextLabel() {
        
    }
    
}
