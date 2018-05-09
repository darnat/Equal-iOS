//
//  Fetchable.swift
//  Equal
//
//  Created by Alexis DARNAT on 4/22/18.
//  Copyright © 2018 Alexis DARNAT. All rights reserved.
//

import CoreData

public protocol Fetchable: NSFetchRequestResult {
    static var entityName: String { get }
    
    static func fetchRequest() -> NSFetchRequest<Self>
}

public extension Fetchable {
    public static func fetchRequest() -> NSFetchRequest<Self> {
        return NSFetchRequest(entityName: entityName)
    }
}

public extension Fetchable where Self: NSManagedObject {
    public static var entityName: String {
        return String(describing: self)
    }
}
