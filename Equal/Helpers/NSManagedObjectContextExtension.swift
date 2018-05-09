//
//  NSManagedObjectContextExtension.swift
//  Equal
//
//  Created by Alexis DARNAT on 4/6/18.
//  Copyright © 2018 Alexis DARNAT. All rights reserved.
//

import CoreData

// Add Context to Coding UserInfo
extension CodingUserInfoKey {
    static let context = CodingUserInfoKey(rawValue: "context")!
}

// CoreDataContext
enum CoreDataDecodingError: Error {
    case missingContext(codingPath: [CodingKey])
}

extension NSManagedObjectContext {
//    private static var _decodingContextList: [String: NSManagedObjectContext]?
//    private static var _decodingContext: NSManagedObjectContext?

//    static func decodingContext(at codingPath: [CodingKey] = []) throws -> NSManagedObjectContext {
//        if let context = _decodingContext { return context }
//        throw CoreDataDecodingError.missingContext(codingPath: codingPath)
//    }
    
//    public final func asDecodingContext(do work: () -> ()) {
//        NSManagedObjectContext._decodingContext = self
//        defer { NSManagedObjectContext._decodingContext = nil }
//        performAndWait { work() }
//    }
}

// Refactoring names
extension NSManagedObjectContext {
    public func since(forEntity entity: String, column: String = "updated_at") -> Date? {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        request.fetchLimit = 1
        request.resultType = .dictionaryResultType
        request.returnsDistinctResults = true
        request.propertiesToFetch = [column]
        request.sortDescriptors = [NSSortDescriptor(key: column, ascending: false)]
        var results : [[String: Date]]? = nil
        self.performAndWait {
            do {
                results = try self.fetch(request) as? [[String : Date]]
                assert(results!.count < 2)
            } catch {
                fatalError("Failed to perform fetch: \(error)")
            }
        }
        guard let model = results?.first else { return nil }
        return model[column]
    }
}
