//
//  DataController.swift
//  Equal
//
//  Created by Alexis DARNAT on 4/6/18.
//  Copyright © 2018 Alexis DARNAT. All rights reserved.
//

import CoreData

class DataController: NSObject {
    
    /**
        New iOS 10 implementation
     **/
    public private(set) lazy var persistentContainer: NSPersistentContainer =  {
        let container = NSPersistentContainer(name: "Equal")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
        return container
    }()
    
    public func saveContext() {
        let context = self.persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    /**
        End New implementation
    **/
    
//    var mainContext: NSManagedObjectContext?
//    var writerContext: NSManagedObjectContext?
//
//    override init() {
//        super.init()
//        initializeCoreDataStack()
//    }
//
//
//    func initializeCoreDataStack() {
//        guard let modelURL = Bundle.main.url(forResource: "Equal", withExtension: "momd") else { fatalError("Failed to locate DataModel.momd in app bundle")}
//
//        guard let mom = NSManagedObjectModel(contentsOf: modelURL) else { fatalError("Failed to initialize MOM") }
//
//        let psc = NSPersistentStoreCoordinator(managedObjectModel: mom)
//
//
//        var type = NSManagedObjectContextConcurrencyType.privateQueueConcurrencyType
//        writerContext = NSManagedObjectContext(concurrencyType: type)
//        writerContext?.persistentStoreCoordinator = psc
//
//        type = NSManagedObjectContextConcurrencyType.mainQueueConcurrencyType
//        mainContext = NSManagedObjectContext(concurrencyType: type)
//        mainContext?.parent = writerContext
//
//        let queue = DispatchQueue.global(qos: .background)
//        queue.async {
//            let fileManager = FileManager.default
//            guard let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else { fatalError("Failed to resolve documents directory") }
//            let storeURL = documentsURL.appendingPathComponent("Equal.sqlite")
//
//            do {
//                try psc.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: nil)
//            } catch {
//                fatalError("Failed to initialize PSC: \(error)")
//            }
//        }
//    }
//
//    func saveContext() {
//        print("Context Saved")
//        guard let moc = mainContext else { fatalError("save called before mainContext is initialized") }
//        moc.performAndWait {
//            if moc.hasChanges {
//                do {
//                    try moc.save()
//                } catch {
//                    fatalError("Failed to save mainContext: \(error)")
//                }
//            }
//
//            guard let writer = self.writerContext else {
//                print("Writer context is nil, skipping")
//                return
//            }
//
//            writer.perform {
//                if !writer.hasChanges { return}
//                do {
//                    try writer.save()
//                } catch {
//                    fatalError("Failed to save writerContext: \(error)")
//                }
//            }
//        }
//    }
}
