//
//  HomeRequestModel.swift
//  Equal
//
//  Created by Alexis DARNAT on 4/19/18.
//  Copyright © 2018 Alexis DARNAT. All rights reserved.
//

import CoreData

@objc(HomeRequestModel)
public final class HomeRequestModel: BaseRequestModel {
    
    var me: User?
    var events: [Event]?
    var histories: [History]?
    
    override public func update(from dto: BaseRequestModel.DTO) throws {
        if let me = dto.me {
            self.me = me
        }
        if let events = dto.events {
//            self.events = try Event.synchronize(withEntities: events, withPolicy: .SynchronizeAndDelete, in: _managedObjectContext)
            self.events = try Event.synchronize(withEntities: events, withPolicy: .SynchronizeAndDelete, in: _managedObjectContext, prediction: NSPredicate(format: "sync_status == %d", 0))
        }
        if let histories = dto.histories {
            self.histories = try History.synchronize(withEntities: histories, withPolicy: .SynchronizeWithExisting, in: _managedObjectContext)
        }
    }
}
