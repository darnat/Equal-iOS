//
//  BaseRequestModel.swift
//  Equal
//
//  Created by Alexis DARNAT on 4/19/18.
//  Copyright © 2018 Alexis DARNAT. All rights reserved.
//

import CoreData

@objc(BaseRequestModel)
open class BaseRequestModel: NSObject, CoreDataDecodable {
    
    internal var _managedObjectContext : NSManagedObjectContext
    
    public struct DTO: Decodable {
        let me: User?
        let events: [Event.DTO]?
        let event: Event.DTO?
        let histories: [History.DTO]?
        let currencies: [Currency.DTO]?
    }

    public required init(context moc: NSManagedObjectContext) {
        self._managedObjectContext = moc
        super.init()
    }
    
    public func update(from dto: DTO) throws {
        fatalError("Do not Use this class directly")
    }
}
