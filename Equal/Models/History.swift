//
//  History.swift
//  Equal
//
//  Created by Alexis DARNAT on 4/21/18.
//  Copyright © 2018 Alexis DARNAT. All rights reserved.
//

import CoreData

@objc(History)
public final class History: Model {
    
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

extension History: CoreDataDecodable, Synchronizable {
    public struct DTO: Decodable & HasPrimaryKey {
        public var id: Int
        let createdAt: Date
        let participantId: Int
        let eventId: Int
        let historyChange: HistoryChange
    }
    
    public func update(from dto: DTO) throws {
        self.setValue(dto.id, forKey: "id")
        self.setValue(dto.createdAt, forKey: "created_at")
        guard let moc = managedObjectContext else { return }
        let participant = try Participant.FindFirst(in: moc, with: NSPredicate(format: "id == %d", dto.participantId))
        self.setValue(participant, forKey: "participant")
        let event = try Event.FindFirst(in: moc, with: NSPredicate(format: "id == %d", dto.eventId))
        self.setValue(event, forKey: "event")
    }
}
