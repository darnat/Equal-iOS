//
//  OperationRequest.swift
//  Equal
//
//  Created by Alexis DARNAT on 3/31/18.
//  Copyright © 2018 Alexis DARNAT. All rights reserved.
//

import Foundation

// Comment the Code
class OperationRequest: Operation {
    
    var internalFinished: Bool = false
    override var isFinished: Bool {
        get {
            return internalFinished
        }
        set (newValue){
            willChangeValue(forKey: "isFinished")
            internalFinished = newValue
            didChangeValue(forKey: "isFinished")
        }
    }
    
    override func start() {
        if isCancelled {
            isFinished = true
            return
        }
    }

}
