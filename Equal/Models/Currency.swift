//
//  Currency.swift
//  Equal
//
//  Created by Alexis DARNAT on 4/23/18.
//  Copyright © 2018 Alexis DARNAT. All rights reserved.
//

import CoreData

@objc(Currency)
public final class Currency: Model {
    
    private enum CodingKeys: String, CodingKey {
        case id
        static let allValues = [id]
    }
    
    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        for codingKey in CodingKeys.allValues {
            try container.encode(self.value(forKey: codingKey.rawValue) as? String, forKey: codingKey)
        }
    }
}

extension Currency: CoreDataDecodable, FindOrCreatable, Synchronizable {
    public struct DTO: Decodable & HasPrimaryKey {
        public var id: Int
        let fullname: String
        let abreviation: String
        let symbol: String
    }
    
    public func update(from dto: DTO) throws {
        self.setValue(dto.id, forKey: "id")
        self.setValue(dto.fullname, forKey: "fullname")
        self.setValue(dto.abreviation, forKey: "abreviation")
        self.setValue(dto.symbol, forKey: "symbol")
    }
}
