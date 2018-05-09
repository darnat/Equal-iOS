//
//  Event.swift
//  Equal
//
//  Created by Alexis DARNAT on 4/17/18.
//  Copyright © 2018 Alexis DARNAT. All rights reserved.
//

import CoreData

@objc(Event)
public final class Event: Model {
    
    private enum CodingKeys: String, CodingKey {
        case id, title, body, guid, currencyId
        static let allValues = [id, title, body, guid, currencyId]
    }

    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        if let id = self.value(forKey: "id") as? Int, id != 0 {
            try container.encode(id, forKey: .id)
        }
        try container.encode(self.value(forKey: "guid") as? String, forKey: .guid)
        try container.encode(self.value(forKey: "title") as? String, forKey: .title)
        try container.encodeIfPresent(self.value(forKey: "body") as? String, forKey: .body)
        try container.encode(self.value(forKeyPath: "currency.id") as? Int, forKey: .currencyId)
    }
    
}

extension Event: CoreDataDecodable, FindOrCreatable, Synchronizable {
    public struct DTO: Decodable & HasPrimaryKey & Guidable {
        public var id: Int
        let title: String
        let body: String?
        let createdAt: Date
        let updatedAt: Date
        let joinToken: String
        let deleted: Bool
        let currency: Currency.DTO
        let participants: [Participant.DTO]
        let expenses: [Expense.DTO]?
        public var guid: String
    }

    public func update(from dto: DTO) throws {
        self.setValue(dto.id, forKey: "id")
        self.setValue(dto.title, forKey: "title")
        self.setValue(dto.body, forKey: "body")
        self.setValue(dto.createdAt, forKey: "created_at")
        self.setValue(dto.updatedAt, forKey: "updated_at")
        self.setValue(dto.joinToken, forKey: "join_token")
        self.setValue(dto.guid, forKey: "guid")
        self.setValue(0, forKey: "sync_status")
        guard let moc = managedObjectContext else { return }
        let currency = try Currency.findOrCreate(for: dto.currency, in: moc)
        self.setValue(currency, forKey: "currency")
        let participants = try Set(Participant.synchronize(withEntities: dto.participants, withPolicy: .SynchronizeAndDelete, in: moc, prediction: NSPredicate(format: "event == %@", self)))
        self.setValue(participants, forKey: "participants")
        if let expensesDTO = dto.expenses {
            let expenses = try Expense.synchronize(withEntities: expensesDTO, withPolicy: .SynchronizeWithDelete, in: moc, prediction: NSPredicate(format: "event == %@", self))
            self.mutableSetValue(forKey: "expenses").addObjects(from: expenses)
//            self.setValue(expenses, forKey: "expenses")
        }
    }
}
