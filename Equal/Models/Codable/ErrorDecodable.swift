//
//  ErrorDecodable.swift
//  Equal
//
//  Created by Alexis DARNAT on 4/5/18.
//  Copyright © 2018 Alexis DARNAT. All rights reserved.
//

import Foundation

// Comment the Code
struct ErrorsJSON : Decodable {
    let success: Bool
    let errors: [String]
}
