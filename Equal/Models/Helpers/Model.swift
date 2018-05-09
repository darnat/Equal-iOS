//
//  Model.swift
//  Equal
//
//  Created by Alexis DARNAT on 4/17/18.
//  Copyright © 2018 Alexis DARNAT. All rights reserved.
//

import CoreData

@objc(Model)
open class Model: NSManagedObject, Encodable {

    private enum CodingKeys: String, CodingKey {
        case id
        static let allValues = [id]
    }

    public func encode(to encoder: Encoder) throws {
        for codingKey in CodingKeys.allValues {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(self.value(forKey: codingKey.rawValue) as? String, forKey: codingKey)
        }
    }
}
