//
//  CoreDataContextWatcher.swift
//  Equal
//
//  Created by Alexis DARNAT on 4/8/18.
//  Copyright © 2018 Alexis DARNAT. All rights reserved.
//

import CoreData

protocol CoreDataContextWatcherDelegate {
    func contextUpdated(impact: [String: [NSManagedObject]])
}

class CoreDataContextWatcher: NSObject {
    let context: NSManagedObjectContext
    let persistentStoreCoordinator: NSPersistentStoreCoordinator
    var masterPredicate : NSPredicate?
    var delegate : CoreDataContextWatcherDelegate?
    
    public init(context: NSManagedObjectContext) {
        guard let psc = context.persistentStoreCoordinator else { fatalError("no PSC in Context") }
        self.context = context
        self.persistentStoreCoordinator = psc
        super.init()
        let center = NotificationCenter.default
        center.addObserver(self, selector: #selector(contextUpdated(notification:)), name: .NSManagedObjectContextObjectsDidChange, object: nil)
    }
    
    @objc private func contextUpdated(notification: Notification) {
        guard let predicate = self.masterPredicate else { return }
        guard let iContext = notification.object as? NSManagedObjectContext else { fatalError("Unexpected object in notification") }
        guard let iCoordinator = iContext.persistentStoreCoordinator else { fatalError("Incoming context has no PSC") }
        if iCoordinator != self.persistentStoreCoordinator { return }
        let info = notification.userInfo
        var results = [String:[NSManagedObject]]()
        var totalCount = 0
        
        if let insert = info?[NSInsertedObjectsKey] as? Set<NSManagedObject> {
            let filter = insert.filter { return predicate.evaluate(with: $0) }
            totalCount += filter.count
            results[NSInsertedObjectsKey] = Array(filter)
        }
        
        if let update = info?[NSUpdatedObjectsKey] as? Set<NSManagedObject> {
            let filter = update.filter { return predicate.evaluate(with: $0) }
            totalCount += filter.count
            results[NSUpdatedObjectsKey] = Array(filter)
        }
        
        if let delete = info?[NSDeletedObjectsKey] as? Set<NSManagedObject> {
            let filter = delete.filter { return predicate.evaluate(with: $0) }
            totalCount += filter.count
            results[NSDeletedObjectsKey] = Array(filter)
        }
        
        if totalCount == 0 { return }
        
        self.delegate?.contextUpdated(impact: results)
    }
    
    func addWatch(Entity name: String, predicate: NSPredicate) {
        let entityPredicate = NSPredicate(format: "entity.name == %@", name)
        var array = [entityPredicate, predicate]
        let final = NSCompoundPredicate(andPredicateWithSubpredicates: array)
        
        if let masterPredicate = self.masterPredicate {
            array = [masterPredicate, final]
            self.masterPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: array)
            return
        }
        
        self.masterPredicate = final
    }
    
    deinit {
        let center = NotificationCenter.default
        center.removeObserver(self)
        self.delegate = nil
    }
}
