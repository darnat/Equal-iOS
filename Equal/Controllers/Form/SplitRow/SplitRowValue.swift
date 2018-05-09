//
//  SplitRowValue.swift
//  Equal
//
//  Created by Alexis DARNAT on 4/29/18.
//  Copyright © 2018 Alexis DARNAT. All rights reserved.
//

import Eureka

public struct SplitRowValue<L: Equatable, R: Equatable>{
    public var left: L?
    public var right: R?
    
    public init(left: L?, right: R?){
        self.left = left
        self.right = right
    }
    
    public init(){}
}

extension SplitRowValue: Equatable{
    public static func == (lhs: SplitRowValue, rhs: SplitRowValue) -> Bool{
        return lhs.left == rhs.left && lhs.right == rhs.right
    }
}
