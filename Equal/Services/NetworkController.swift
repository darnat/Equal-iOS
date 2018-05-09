//
//  NetworkController.swift
//  Equal
//
//  Created by Alexis DARNAT on 3/31/18.
//  Copyright © 2018 Alexis DARNAT. All rights reserved.
//

import Foundation
import CoreData

// Comment the Code
class NetworkController: NSObject {
    let queue = OperationQueue()
    let container : NSPersistentContainer
    
    required init(container: NSPersistentContainer) {
        self.container = container
        super.init()
    }
    
    
    /*****************************************************************
                              Login Request
     ******************************************************************/
    func login(credentials: (String, String), authController: AuthController) {
        let operation = LoginRequest(credentials: credentials)
        operation.authController = authController
        operation.queuePriority = .veryHigh
        operation.completionBlock = {
            let length = operation.incomingData.length
            if let duration = operation.operationRuntime {
                self.aggregateNetworkCall(length: length, duration: duration)
            }
        }
        queue.addOperation(operation)
    }
    
    /*****************************************************************
                                Home Request
     ******************************************************************/
    func requestHome(authController: AuthController) -> NSFetchedResultsController<Event> {
        // Operation
        let operation = HomeRequest(container: self.container, authController: authController)
        operation.queuePriority = .high
        operation.networkController = self
        self.aggregationCompliant(operation: operation)
        queue.addOperation(operation)
        // End Operation
        let fetch : NSFetchRequest<Event> = Event.fetchRequest()
        fetch.sortDescriptors = [NSSortDescriptor(key: "sync_status", ascending: false), NSSortDescriptor(key: "created_at", ascending: false)]
        let fetchController = NSFetchedResultsController(fetchRequest: fetch, managedObjectContext: self.container.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        return fetchController
    }
    
    /*****************************************************************
                            Equal Request
     ******************************************************************/
    func requestEquals(authController: AuthController, DidCompleteWithError completion: ((Error?) -> Void)?) {
        let operation = EqualRequest(container: self.container, authController: authController)
        operation.queuePriority = .veryHigh
        operation.didCompleteWithError = completion
        operation.networkController = self
        self.aggregationCompliant(operation: operation)
        queue.addOperation(operation)
    }
    
    /*****************************************************************
                                Event Request
     ******************************************************************/
    func requestEvent(authController: AuthController, eventID: NSManagedObjectID) -> NSFetchedResultsController<Expense> {
        // Operation
        self.requestEvent(authController: authController, eventID: eventID, DidCompleteWithError: nil)
        // End Operation
        let fetch : NSFetchRequest<Expense> = Expense.fetchRequest()
        fetch.sortDescriptors = [/*NSSortDescriptor(key: "sync_status", ascending: false),*/ NSSortDescriptor(key: "created_at", ascending: false)]
        fetch.predicate = NSPredicate(format: "event == %@", eventID)
        let fetchController = NSFetchedResultsController(fetchRequest: fetch, managedObjectContext: self.container.viewContext, sectionNameKeyPath: "sectionIdentifier", cacheName: nil)
        return fetchController
    }
    
    func requestEvent(authController: AuthController, eventID: NSManagedObjectID, DidCompleteWithError completion: ((Error?) -> Void)?) {
        guard let event = try? self.container.viewContext.existingObject(with: eventID) else { fatalError("Event must Exist") }
        let operation = EventRequest(container: self.container, authController: authController, eventID: event.value(forKey: "id") as! Int)
        operation.queuePriority = .high
        operation.didCompleteWithError = completion
        operation.networkController = self
        self.aggregationCompliant(operation: operation)
        queue.addOperation(operation)
    }
    
    /*****************************************************************
                            Histories Request
     ******************************************************************/
    func requestHistories(authController: AuthController) -> NSFetchedResultsController<History> {
        // Operation
        self.requestHistories(authController: authController, DidCompleteWithError: nil)
        // End Operation
        let fetch : NSFetchRequest<History> = History.fetchRequest()
        fetch.sortDescriptors = [NSSortDescriptor(key: "created_at", ascending: false)]
        let fetchController = NSFetchedResultsController(fetchRequest: fetch, managedObjectContext: self.container.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        return fetchController
    }
    
    func requestHistories(authController: AuthController, DidCompleteWithError completion: ((Error?) -> Void)?) {
        let operation = HistoryRequest(container: self.container, authController: authController)
        operation.queuePriority = .high
        operation.didCompleteWithError = completion
        operation.networkController = self
        self.aggregationCompliant(operation: operation)
        queue.addOperation(operation)
    }
    
    /*****************************************************************
                            Currencies Request
     ******************************************************************/
    func requestCurrencies(authController: AuthController) -> NSFetchedResultsController<Currency> {
        let fetch : NSFetchRequest<Currency> = Currency.fetchRequest()
        fetch.sortDescriptors = [NSSortDescriptor(key: "fullname", ascending: true)]
        let fetchController = NSFetchedResultsController(fetchRequest: fetch, managedObjectContext: self.container.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        return fetchController
    }
    
    func requestCurrencies(authController: AuthController, pattern: String?, DidComplete completion: ((Error?) -> Void)?) -> Operation {
        let operation = CurrencyRequest(container: self.container, authController: authController, pattern: pattern)
        operation.queuePriority = .high
        operation.didCompleteWithError = completion
        self.aggregationCompliant(operation: operation)
        queue.addOperation(operation)
        return operation
    }
    
    /*****************************************************************
                            Save Event
     ******************************************************************/
    func requestSaveEvent(authController: AuthController, eventID: NSManagedObjectID, DidCompleteWithError completion: ((Error?) -> Void)?) {
        let operation = EventSaveRequest(container: self.container, authController: authController, objectID: eventID)
        operation.queuePriority = .veryHigh
        operation.didCompleteWithError = completion
        self.aggregationCompliant(operation: operation)
        queue.addOperation(operation)
    }
    
    /*****************************************************************
                            Save Expense
     ******************************************************************/
    func requestSaveExpense(authController: AuthController, objectID: NSManagedObjectID, DidCompleteWithError completion: ((Error?) -> Void)?) {
        let operation = ExpenseSaveRequest(container: self.container, authController: authController, objectID: objectID)
        operation.queuePriority = .veryHigh
        operation.didCompleteWithError = completion
        self.aggregationCompliant(operation: operation)
        queue.addOperation(operation)
    }
    
    /*****************************************************************
                            Download User Image
     ******************************************************************/
    func requestImage(imageURL: String, DidCompleteWithError completion: ((Data) -> Void)?) {
        let operation = ImageDownloadRequest(url: imageURL)
        operation.queuePriority = .veryLow
        operation.didComplete = completion
        self.aggregationCompliant(operation: operation)
        queue.addOperation(operation)
    }
    
    /*****************************************************************
                             Non-Synchronize
     ******************************************************************/
    func syncNonSynchronizedEvent(authController: AuthController) {
        let request : NSFetchRequest<NSManagedObjectID> = NSFetchRequest(entityName: "Event")
        request.predicate = NSPredicate(format: "sync_status == %d", 1)
        request.resultType = .managedObjectIDResultType
        
        self.container.performBackgroundTask { (context) in
            var results : [NSManagedObjectID]? = nil
            do {
                results = try context.fetch(request)
            } catch {
                fatalError("Error : \(error)")
            }
            guard let events = results, events.count > 0 else { return }
            for event in events {
                let operation = EventSaveRequest(container: self.container, authController: authController, objectID: event)
                operation.queuePriority = .high
                self.aggregationCompliant(operation: operation)
                self.queue.addOperation(operation)
            }
            
        }
    }
    
    func syncNonSynchronizedExpense(authController: AuthController) {
        let request : NSFetchRequest<NSManagedObjectID> = NSFetchRequest(entityName: "Expense")
        request.predicate = NSPredicate(format: "sync_status == %d", 1)
        request.resultType = .managedObjectIDResultType
        
        self.container.performBackgroundTask { (context) in
            var results : [NSManagedObjectID]? = nil
            do {
                results = try context.fetch(request)
            } catch {
                fatalError("Error : \(error)")
            }
            guard let expenses = results, expenses.count > 0 else { return }
            for expense in expenses {
                let operation = ExpenseSaveRequest(container: self.container, authController: authController, objectID: expense)
                operation.queuePriority = .high
                self.aggregationCompliant(operation: operation)
                self.queue.addOperation(operation)
            }
        }
    }
    
    /** Network aggregation **/
    private func aggregationCompliant(operation: NetworkRequest) {
        operation.completionBlock = {
            let length = operation.incomingData.length
            if let duration = operation.operationRuntime {
                self.aggregateNetworkCall(length: length, duration: duration)
            }
        }
    }
    
    private func aggregateNetworkCall(length: Int, duration: TimeInterval) {}
}
