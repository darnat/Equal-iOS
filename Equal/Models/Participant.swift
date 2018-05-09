//
//  Participant.swift
//  Equal
//
//  Created by Alexis DARNAT on 4/17/18.
//  Copyright © 2018 Alexis DARNAT. All rights reserved.
//

import CoreData

@objc(Participant)
public final class Participant: Model {
    
    private enum CodingKeys: String, CodingKey {
        case id, nickname
        static let allValues = [id, nickname]
    }

    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        for codingKey in CodingKeys.allValues {
            try container.encode(self.value(forKey: codingKey.rawValue) as? String, forKey: codingKey)
        }
    }
    
}

extension Participant: CoreDataDecodable, FindOrCreatable, Synchronizable {
    public struct DTO: Decodable & HasPrimaryKey {
        public var id: Int
        let nickname: String?
        let balance: Double
        let updatedAt: Date
        let owner: Bool
        let user: User.DTO?
    }

    public func update(from dto: DTO) throws {
        self.setValue(dto.id, forKey: "id")
        
        if let username = dto.nickname, username.isEmpty == false {
            self.setValue(dto.nickname, forKey: "nickname")
        } else {
            self.setValue(dto.user?.name, forKey: "nickname")
        }
        self.setValue(dto.balance, forKey: "balance")
        self.setValue(dto.updatedAt, forKey: "updated_at")
        self.setValue(dto.owner, forKey: "owner")
        self.setValue(dto.user?.image, forKey: "image")
    }
}
