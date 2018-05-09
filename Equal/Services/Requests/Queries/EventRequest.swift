//
//  EventRequest.swift
//  Equal
//
//  Created by Alexis DARNAT on 4/8/18.
//  Copyright © 2018 Alexis DARNAT. All rights reserved.
//

import CoreData

class EventRequest: BaseGraphQLRequest<EventRequestModel> {
//    private var innerContext : NSManagedObjectContext
    var networkController : NetworkController?
    private var eventID : Int!
    
    init(container: NSPersistentContainer, authController: AuthController, eventID: Int) {
//        self.innerContext = container.newBackgroundContext()
        super.init(container: container, authController: authController)
        self.eventID = eventID
    }
    
    override func configureRequest(request: GraphQLRequest) {
        var expenseS = ""
        if let since = self.persistentContainer.viewContext.since(forEntity: "Expense") {
            expenseS = "(since: " + String(since.timeIntervalSince1970) + ")"
        }
//        if let since = self.innerContext.since(forEntity: "Expense") {
//            expenseS = "(since: " + String(since.timeIntervalSince1970) + ")"
//        }
        request.addQuery(query: "event(id: " + String(self.eventID) + ") { id title body created_at updated_at join_token guid deleted participants { id nickname balance updated_at owner user { id name image } } currency { id fullname symbol abreviation } expenses" + expenseS + " { id name amount updated_at created_at lock_version guid deleted holders { id payer percentage participant_id } } }")
    }
    
}
