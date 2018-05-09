//
//  EventRequestModel.swift
//  Equal
//
//  Created by Alexis DARNAT on 4/22/18.
//  Copyright © 2018 Alexis DARNAT. All rights reserved.
//

import CoreData

@objc(EventRequestModel)
public final class EventRequestModel: BaseRequestModel {
    
    var event: Event?
    
    override public func update(from dto: BaseRequestModel.DTO) throws {
        if let event = dto.event {
            self.event = try Event.findOrCreate(for: event, in: _managedObjectContext)
        }
    }
}
