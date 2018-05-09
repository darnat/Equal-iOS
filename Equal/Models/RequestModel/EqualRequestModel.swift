//
//  EqualRequestModel.swift
//  Equal
//
//  Created by Alexis DARNAT on 4/22/18.
//  Copyright © 2018 Alexis DARNAT. All rights reserved.
//

import CoreData

//@objc(EqualRequestModel)
public final class EqualRequestModel: BaseRequestModel {
    
    var events: [Event]?
    
    override public func update(from dto: BaseRequestModel.DTO) throws {
        if let events = dto.events {
            self.events = try Event.synchronize(withEntities: events, withPolicy: .SynchronizeAndDelete, in: _managedObjectContext, prediction: NSPredicate(format: "sync_status == %d", 0))
        }
    }
}
