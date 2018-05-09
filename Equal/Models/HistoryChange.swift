//
//  HistoryChange.swift
//  Equal
//
//  Created by Alexis DARNAT on 4/22/18.
//  Copyright © 2018 Alexis DARNAT. All rights reserved.
//

import CoreData

@objc(HistoryChange)
public final class HistoryChange: Model {
    
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

extension HistoryChange: CoreDataDecodable {
    public struct DTO: Decodable & HasPrimaryKey {
        public var id: Int
        let verb: Int16
        let expenseId: Int
    }
    
    public func update(from dto: DTO) throws {
        self.setValue(dto.id, forKey: "id")
        self.setValue(dto.verb, forKey: "verb")
        guard let moc = managedObjectContext else { return }
        let expense = try Expense.FindFirst(in: moc, with: NSPredicate(format: "id == %d", dto.expenseId))
        self.setValue(expense, forKey: "expense")
    }
}
