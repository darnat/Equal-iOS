//
//  CurrencyRequestModel.swift
//  Equal
//
//  Created by Alexis DARNAT on 4/24/18.
//  Copyright © 2018 Alexis DARNAT. All rights reserved.
//

import CoreData

@objc(CurrencyRequestModel)
public final class CurrencyRequestModel: BaseRequestModel {
    
    var currencies: [Currency]?
    
    override public func update(from dto: BaseRequestModel.DTO) throws {
        if let currencies = dto.currencies {
            self.currencies = try Currency.synchronize(withEntities: currencies, withPolicy: .SynchronizeWithExisting, in: _managedObjectContext)
        }
    }
}
