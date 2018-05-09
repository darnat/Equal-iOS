//
//  User.swift
//  Equal
//
//  Created by Alexis DARNAT on 4/21/18.
//  Copyright © 2018 Alexis DARNAT. All rights reserved.
//

import CoreData

@objc(User)
public final class User: Model {
    
    private enum CodingKeys: String, CodingKey {
        case id, email, name, image
        static let allValues = [id, email, name, image]
    }
    
    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        for codingKey in CodingKeys.allValues {
            try container.encode(self.value(forKey: codingKey.rawValue) as? String, forKey: codingKey)
        }
    }
}

extension User: CoreDataDecodable {
    public struct DTO: Decodable & HasPrimaryKey {
        public var id: Int
        let email: String?
        let name: String?
        let image: String?
    }
    
    public func update(from dto: DTO) throws {
        self.setValue(dto.id, forKey: "id")
        self.setValue(dto.email, forKey: "email")
        self.setValue(dto.name, forKey: "name")
        self.setValue(dto.image, forKey: "image")
    }
}
