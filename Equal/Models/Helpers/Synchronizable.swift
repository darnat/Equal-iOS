//
//  Synchronizable.swift
//  Equal
//
//  Created by Alexis DARNAT on 4/22/18.
//  Copyright © 2018 Alexis DARNAT. All rights reserved.
//

import CoreData

// CoreDataDecodable Synchronize Policy
public enum CoreDataDecodableSynchronizePolicy {
    case SynchronizeWithDelete
    case SynchronizeWithExisting
    case SynchronizeAndDelete
}

public protocol Synchronizable: Fetchable {

    static func synchronize(withEntities entities: [Decodable], withPolicy policy: CoreDataDecodableSynchronizePolicy, in context: NSManagedObjectContext) throws -> [Self]
    
    static func synchronize(withEntities entities: [Decodable], withPolicy policy: CoreDataDecodableSynchronizePolicy, in context: NSManagedObjectContext, prediction: NSPredicate?) throws -> [Self]

    static func synchronizeElem(withEntities entities: [Self], models: [Decodable], withPolicy policy: CoreDataDecodableSynchronizePolicy, in context: NSManagedObjectContext) throws -> [Self]
}

public extension Synchronizable where Self: NSManagedObject, Self: CoreDataDecodable {

    static func synchronize(withEntities entities: [Decodable], withPolicy policy: CoreDataDecodableSynchronizePolicy, in context: NSManagedObjectContext) throws -> [Self] {
        return try synchronize(withEntities: entities, withPolicy: policy, in: context, prediction: nil)
    }

    static func computePredictions(withEntities entities: [Decodable], policy: CoreDataDecodableSynchronizePolicy, request: NSFetchRequest<Self>) -> [NSPredicate] {
        var predictions : [NSPredicate] = []
        if policy == .SynchronizeWithExisting || policy == .SynchronizeWithDelete {
            if let entitiesPK = entities as? [Guidable] {
                let guids = entitiesPK.map { $0.guid }
                predictions.append(NSPredicate(format: "guid IN %@", guids))
                request.fetchLimit = entitiesPK.count
            } else if let entitiesPK = entities as? [HasPrimaryKey] {
                let ids = entitiesPK.map { $0.id }
                predictions.append(NSPredicate(format: "id IN %@", ids))
                request.fetchLimit = entitiesPK.count
            }
        }
        return predictions
    }
    
    static func synchronize(withEntities entities: [Decodable], withPolicy policy: CoreDataDecodableSynchronizePolicy, in context: NSManagedObjectContext, prediction: NSPredicate?) throws -> [Self] {
        let request = NSFetchRequest<Self>(entityName: entityName)
        var predictions = computePredictions(withEntities: entities, policy: policy, request: request)
        if let prediction = prediction { predictions.append(prediction) }
        request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predictions)
        var results : [Self]?
        context.performAndWait {
            do {
                results = try context.fetch(request)
            } catch {
                fatalError("Failed to perform fetch: \(error)")
            }
        }
        guard let resultEntities = results else { fatalError("Unable to proceed the result") }
        return try synchronizeElem(withEntities: resultEntities, models: entities, withPolicy: policy, in: context)
    }
    
    static func synchronizeElem(withEntities entities: [Self], models: [Decodable], withPolicy policy: CoreDataDecodableSynchronizePolicy, in context: NSManagedObjectContext) throws -> [Self] {
        var synchronized : [Self] = []
        var object : Self? = nil
        var entities = entities
//        guard let modelsKeys = models as? [HasPrimaryKey] else { return [] }
        for model in models {
            if let index = entities.index(where: { (elem: Self) -> Bool in
                if let model = model as? Guidable {
                    return elem.value(forKey: "guid") as! String == model.guid
                } else if let model = model as? HasPrimaryKey {
                    return elem.value(forKey: "id") as! Int == model.id
                }
                return false
            }) {
                object = entities[index] as Self
                if let deletable = model as? Deletable {
                    if policy == .SynchronizeWithDelete && deletable.deleted == true {
                        context.delete(object!)
                        object = nil
                    }
                }
                if policy == .SynchronizeAndDelete {
                    entities.remove(at: index)
                }
            } else {
                guard let entity = NSEntityDescription.entity(forEntityName: entityName, in: context) else { fatalError("impossible to create entity") }
                object = self.init(entity: entity, insertInto: context)
            }
            if var object = object {
                try object.update(from: model as! DTO)
                synchronized.append(object)
            }
        }
        if policy == .SynchronizeAndDelete {
            for entity in entities {
                context.delete(entity)
            }
        }
        return synchronized
    }

}
