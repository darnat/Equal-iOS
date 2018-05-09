//
//  FindOrCreate.swift
//  Equal
//
//  Created by Alexis DARNAT on 4/22/18.
//  Copyright © 2018 Alexis DARNAT. All rights reserved.
//

import CoreData

public protocol FindOrCreatable: Fetchable {
    
    static func create(in context: NSManagedObjectContext) throws -> Self
    static func FindOrCreate(in context: NSManagedObjectContext, with predicate: NSPredicate?) throws -> Self
    static func FindFirst(in context: NSManagedObjectContext) throws -> Self?
    static func FindFirst(in context: NSManagedObjectContext, with predicate: NSPredicate?) throws -> Self?
    static func FindFirst(in context: NSManagedObjectContext, with predicate: NSPredicate?, sortedBy sortDescriptors: [NSSortDescriptor]) throws -> Self?
}

public extension FindOrCreatable {
    
    static func FindFirst(in context: NSManagedObjectContext) throws -> Self? {
        return try FindFirst(in: context, with: nil)
    }
    
    static func FindFirst(in context: NSManagedObjectContext, with predicate: NSPredicate?) throws -> Self? {
        return try FindFirst(in: context, with: predicate, sortedBy: [])
    }
    
    static func FindFirst(in context: NSManagedObjectContext, with predicate: NSPredicate?, sortedBy sortDescriptors: [NSSortDescriptor]) throws -> Self? {
        let request = fetchRequest()
        request.predicate = predicate
        request.sortDescriptors = sortDescriptors
        request.fetchLimit = 1
        return try context.fetch(request).first
    }
}

public extension FindOrCreatable where Self: NSManagedObject {
    
    static func create(in context: NSManagedObjectContext) throws -> Self {
        let obj = self.init(entity: NSEntityDescription.entity(forEntityName: entityName, in: context)!, insertInto: context)
        return obj
    }
    
    static func FindOrCreate(in context: NSManagedObjectContext, with predicate: NSPredicate?) throws -> Self {
        return try FindFirst(in: context, with: predicate) ?? create(in: context)
    }
    
}
