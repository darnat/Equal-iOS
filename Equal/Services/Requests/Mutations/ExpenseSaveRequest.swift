//
//  ExpenseSaveRequest.swift
//  Equal
//
//  Created by Alexis DARNAT on 4/30/18.
//  Copyright © 2018 Alexis DARNAT. All rights reserved.
//

import CoreData

class ExpenseSaveRequest: BaseGraphQLRequest<EventRequestModel> {
    private var expense: Expense!
//    private var innerContext: NSManagedObjectContext
    
    init(container: NSPersistentContainer, authController: AuthController, objectID: NSManagedObjectID) {
//        self.innerContext = container.newBackgroundContext()
        super.init(container: container, authController: authController)
        guard let expense = self.persistentContainer.viewContext.object(with: objectID) as? Expense else { fatalError("Should Be an Expense") }
        self.expense = expense
//        self.innerContext.performAndWait {
//            guard let expense = self.innerContext.object(with: objectID) as? Expense else { fatalError("Should Be an Expense") }
//            self.expense = expense
//        }
//        guard let expense = container.viewContext.object(with: objectID) as? Expense else { fatalError("Should Be an Expense") }
//        self.expense = expense
//        self.innerContext.performAndWait {
////            guard let expense = try? self.innerContext.existingObject(with: objectID) as? Expense else { fatalError("Expense Must exist") }
//            self.expense = self.innerContext.object(with: objectID) as? Expense
//        }
    }
    
    override func configureRequest(request: GraphQLRequest) {
        var expenseS = ""
        if let since = self.persistentContainer.viewContext.since(forEntity: "Expense") {
            expenseS = "(since: " + String(since.timeIntervalSince1970) + ")"
        }
//        if let since = self.innerContext.since(forEntity: "Expense") {
//            expenseS = "(since: " + String(since.timeIntervalSince1970) + ")"
//        }
        
        let jsonData = try? JSONEncoder().encode(self.expense)
        let jsonFormated = NSString(data: jsonData!, encoding: String.Encoding.utf8.rawValue)! as String
        request.setVariables(variables: jsonFormated, variablesDeclaration: "$event_id: Int!, $name: String!, $amount: Float!, $holders_attributes: [HolderAttributes!]!, $guid: String!, $lock_version: Int!, $id: Int")
        request.setMutation(mutation: "event : upsertExpense(event_id: $event_id, expense: {id: $id, name: $name, amount: $amount, holders_attributes: $holders_attributes, guid: $guid, lock_version: $lock_version}) { id title body created_at updated_at join_token guid deleted currency { id fullname symbol abreviation } participants { id nickname balance updated_at owner user { id name image } } expenses" + expenseS + " { id name amount updated_at created_at lock_version guid deleted holders { id payer percentage participant_id } } }")
        
    }
}
