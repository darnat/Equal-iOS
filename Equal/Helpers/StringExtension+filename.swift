//
//  StringExtension+filename.swift
//  Equal
//
//  Created by Alexis DARNAT on 5/8/18.
//  Copyright © 2018 Alexis DARNAT. All rights reserved.
//

import Foundation

extension String {
    
    public func getFileName() -> String {
        return NSString(string: self).lastPathComponent
    }
    
    public func getFileNameWithoutExtension() -> String {
        let fileName = self.getFileName()
        return NSString(string: fileName).deletingPathExtension
    }
    
}
