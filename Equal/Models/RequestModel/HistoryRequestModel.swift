//
//  HistoryRequestModel.swift
//  Equal
//
//  Created by Alexis DARNAT on 4/23/18.
//  Copyright © 2018 Alexis DARNAT. All rights reserved.
//

import CoreData

@objc(HistoryRequestModel)
public final class HistoryRequestModel: BaseRequestModel {
    
    var histories: [History]?
    
    override public func update(from dto: BaseRequestModel.DTO) throws {
        if let histories = dto.histories {
            self.histories = try History.synchronize(withEntities: histories, withPolicy: .SynchronizeWithExisting, in: _managedObjectContext)
        }
    }
}
