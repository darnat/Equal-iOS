//
//  NetworkError.swift
//  Equal
//
//  Created by Alexis DARNAT on 4/4/18.
//  Copyright © 2018 Alexis DARNAT. All rights reserved.
//

import UIKit

// Comment the Code
public struct NetworkError: Error {
    
    enum errorKind : Int {
        case Unidentified = 1
        case Unauthorized = 401
        case Forbidden = 403
        case UnprocessableEntity = 422
    }
    
    let kind: errorKind
    let code: Int
    let errors: [String: Any]?
    
    static func computeError(with code: Int, errors: [String: Any]?) -> NetworkError {
        if let error = errorKind(rawValue: code) {
            return NetworkError(kind: error, code: code, errors: errors)
        }
        return NetworkError(kind: .Unidentified, code: code, errors: errors)
    }
    
}
