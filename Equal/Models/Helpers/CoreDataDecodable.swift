//
//  CoreDataDecodable.swift
//  Equal
//
//  Created by Alexis DARNAT on 4/18/18.
//  Copyright © 2018 Alexis DARNAT. All rights reserved.
//

import CoreData

// CoreDataDecodable Protocol
public protocol CoreDataDecodable: Decodable {
    associatedtype DTO: Decodable
    
    init(with dto: DTO, in context: NSManagedObjectContext) throws
    
    mutating func update(from dto: DTO) throws
}

// Extension Generic CoreDataDecodable
public extension CoreDataDecodable {
    public init(from decoder: Decoder) throws {
        guard let context = decoder.userInfo[.context] as? NSManagedObjectContext else { fatalError("You must provide the Context") }
        try self.init(with: DTO(from: decoder), in: context)
//        try self.init(with: DTO(from: decoder), in: .decodingContext(at: decoder.codingPath))
    }
}

// Extension For CoreDataDecodable type of BaseRequestModel
public extension CoreDataDecodable where Self: BaseRequestModel {

    init(with dto: DTO, in context: NSManagedObjectContext) throws {
        self.init(context: context)
        try update(from: dto)
    }

}

// Extension For CoreDataDecodable type of NSManagedObject
public extension CoreDataDecodable where Self: NSManagedObject { // Replace Fetchable by NSManagedObject
    static var className: String {
        return String(describing: self)
    }
    
    init(with dto: DTO, in context: NSManagedObjectContext) throws {
        self.init(context: context)
        try update(from: dto)
    }
}

// Extension For CoreDataDecodable type of FindOrCreatable
public extension CoreDataDecodable where Self: FindOrCreatable {
    @discardableResult
    public static func findOrCreate(for dto: DTO, in context: NSManagedObjectContext) throws -> Self {
        var predicate : NSPredicate? = nil
        if let guidDecodable = dto as? Guidable {
            predicate = NSPredicate(format: "guid == %@", guidDecodable.guid)
        } else if let primaryKeyDecodable = dto as? HasPrimaryKey {
            predicate = NSPredicate(format: "id == %d", primaryKeyDecodable.id)
        }
        var object = try FindOrCreate(in: context, with: predicate)
        try object.update(from: dto)
        return object
    }
}
