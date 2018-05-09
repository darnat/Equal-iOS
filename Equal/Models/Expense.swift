//
//  Expense.swift
//  Equal
//
//  Created by Alexis DARNAT on 4/22/18.
//  Copyright © 2018 Alexis DARNAT. All rights reserved.
//

import CoreData

@objc(Expense)
public final class Expense: Model {
    
    @objc var sectionIdentifier: String? {
        self.willAccessValue(forKey: "sectionIdentifier")
        var si = self.primitiveValue(forKey: "sectionIdentifier")
        self.didAccessValue(forKey: "sectionIdentifier")
        if self.value(forKey: "sync_status") == nil {
            self.willChangeValue(forKey: "sectionIdentifier")
            self.setPrimitiveValue(nil, forKey: "sectionIdentifier")
            self.didChangeValue(forKey: "sectionIdentifier")
            return nil
        }
        if si == nil {
            guard let date = self.value(forKey: "created_at") as? Date else { return nil }
            var comp = Calendar.current.dateComponents([.year, .month, .day], from: date)
            comp.timeZone = TimeZone(abbreviation: "UTC")
            let truncated = Calendar.current.date(from: comp)!
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            si = formatter.string(from: truncated)
            self.willChangeValue(forKey: "sectionIdentifier")
            self.setPrimitiveValue(si, forKey: "sectionIdentifier")
            self.didChangeValue(forKey: "sectionIdentifier")
//            try? self.managedObjectContext?.save()
        }
        return si as? String
        // Make it 7 lasts days / 4 lasts weeks / 12 lasts months / Years
    }
    
    private enum CodingKeys: String, CodingKey {
        case id, name, guid, amount, lock_version, holders_attributes, event_id
        static let allValues = [id, name, amount, lock_version, holders_attributes, event_id]
    }
    
    public override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        
        if let id = self.value(forKey: "id") as? Int, id != 0 {
            try container.encode(id, forKey: .id)
        }
        try container.encode(self.value(forKeyPath: "event.id") as? Int, forKey: .event_id)
        try container.encode(self.value(forKey: "name") as? String, forKey: .name)
        try container.encode(self.value(forKey: "amount") as? Double, forKey: .amount)
        try container.encode(self.value(forKey: "lock_version") as? Int, forKey: .lock_version)
        try container.encode(self.value(forKey: "guid") as? String, forKey: .guid)
        if let holders = self.value(forKey: "holders") as? Set<Holder> {
            try container.encode(Array(holders), forKey: .holders_attributes)
        }
//        try container.encode(self.value(forKey: "title") as? String, forKey: .title)
//        try container.encodeIfPresent(self.value(forKey: "body") as? String, forKey: .body)
//        try container.encode(self.value(forKeyPath: "currency.id") as? Int, forKey: .currencyId)
    }
    
}

extension Expense: CoreDataDecodable, FindOrCreatable, Synchronizable {
    public struct DTO: Decodable & HasPrimaryKey & Deletable & Guidable {
        public var id: Int
        let name: String
        let amount: Double
        let updatedAt: Date
        let createdAt: Date
        let lockVersion: Int
        public var deleted: Bool
        public var guid: String
        let holders: [Holder.DTO]
    }
    
    public func update(from dto: DTO) throws {
        self.setValue(dto.id, forKey: "id")
        self.setValue(dto.name, forKey: "name")
        self.setValue(dto.amount, forKey: "amount")
        self.setValue(dto.createdAt, forKey: "created_at")
        self.setValue(dto.updatedAt, forKey: "updated_at")
        self.setValue(dto.lockVersion, forKey: "lock_version")
        self.setValue(0, forKey: "sync_status")
        self.setValue(dto.guid, forKey: "guid")
        guard let moc = managedObjectContext else { return }
        let holders = try Holder.synchronize(withEntities: dto.holders, withPolicy: .SynchronizeAndDelete, in: moc, prediction: NSPredicate(format: "expense == %@", self))
        self.mutableSetValue(forKey: "holders").addObjects(from: holders)
    }
}

// Methods add
extension Expense {
    
    public func getHolders(payer: Bool) -> [Holder] {
        var holders : [Holder] = []
        guard let actualHolders = self.value(forKey: "holders") as? Set<Holder> else { return holders }
        holders = actualHolders.filter { ($0.value(forKey: "payer") as! Bool) == payer }
        return holders
    }
    
}
