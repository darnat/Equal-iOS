//
//  EqualAddController.swift
//  Equal
//
//  Created by Alexis DARNAT on 4/25/18.
//  Copyright © 2018 Alexis DARNAT. All rights reserved.
//

import UIKit
import CoreData
import Eureka

class EqualAddController: FormViewController {
    private let networkController : NetworkController
    private let authController : AuthController
//    private let innerContext : NSManagedObjectContext
//    private var event : Event!
    private var eventID : NSManagedObjectID?
    
    init(networkController: NetworkController, authController: AuthController, objectID: NSManagedObjectID?) {
        self.networkController = networkController
        self.authController = authController
//        self.innerContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
//        self.innerContext.parent = networkController.container.viewContext
        super.init(style: .grouped)
        self.eventID = objectID
//        if let objectID = objectID {
//            guard let event = self.networkController.container.viewContext.object(with: objectID) as? Event else { fatalError("Must Find the event") }
//            self.event = event
//        } else {
//            self.event = Event(context: self.networkController.container.viewContext)
//            self.event.setValue(UUID().uuidString, forKey: "guid")
//        }
        
//        self.innerContext.performAndWait {
//            if let objectID = objectID {
//                guard let event = self.innerContext.object(with: objectID) as? Event else { fatalError("Must Find the event") }
//                self.event = event
//            } else {
//                guard let entity = NSEntityDescription.entity(forEntityName: "Event", in: self.innerContext) else { fatalError("Must create a new Event") }
//                self.event = Event(entity: entity, insertInto: self.innerContext)
//                self.event?.setValue(UUID().uuidString, forKey: "guid")
//            }
//        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupView()
        self.setupForm()
    }
    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        let row = self.form.rowBy(tag: "title") as! TextRow
//        row.cell.textField.becomeFirstResponder()
//    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let row = self.form.rowBy(tag: "title") as! TextRow
        row.cell.textField.becomeFirstResponder()
    }
    
//    override func viewWillLayoutSubviews() {
//        super.viewWillLayoutSubviews()
//        let row = self.form.rowBy(tag: "title") as! TextRow
//        row.cell.textField.becomeFirstResponder()
//    }
    
    @objc private func cancelButton() {
//        if self.event.objectID.isTemporaryID == false {
//            self.networkController.container.viewContext.refresh(self.event, mergeChanges: false)
//        }
//        if let tmpId = self.event?.objectID.isTemporaryID, tmpId == false {
//            self.innerContext.refresh(self.event!, mergeChanges: false)
//        }
        DispatchQueue.main.async {
            self.view.endEditing(true)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc private func saveButton() {
        if form.validate().isEmpty {
            
            self.networkController.container.performBackgroundTask { (context) in
                var eventTmp : Event? = nil
                if let eventID = self.eventID {
                    eventTmp = context.object(with: eventID) as? Event
                } else {
                    let event = Event(context: context)
                    event.setValue(UUID().uuidString, forKey: "guid")
                    eventTmp = event
                }
                
                guard let event = eventTmp else { fatalError("Event should exist") }
                
                for (key, value) in self.form.values() {
                    if let objectID = value as? NSManagedObjectID {
                        let object = context.object(with: objectID)
                        event.setValue(object, forKey: key)
                    } else {
                        event.setValue(value, forKey: key)
                    }
                }
                do {
                    try context.save()
                } catch {
                    fatalError("Failed to save child context: \(error)")
                }
                
                DispatchQueue.main.async {
                    self.networkController.requestSaveEvent(authController: self.authController, eventID: event.objectID, DidCompleteWithError: nil)
                }
            }
            
            
//            self.innerContext.performAndWait {
//                for (key, value) in form.values() {
//                    if let objectID = value as? NSManagedObjectID {
//                        let object = self.innerContext.object(with: objectID)
//                        self.event?.setValue(object, forKey: key)
//                    } else {
//                        self.event?.setValue(value, forKey: key)
//                    }
//                }
//            }
//            self.save()
//            self.networkController.requestSaveEvent(authController: authController, objectID: self.event!.objectID, DidCompleteWithError: nil)
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
//    private func save() {
//        self.innerContext.performAndWait {
//            do {
//                try self.innerContext.save()
//            } catch {
//                fatalError("Failed to save child context: \(error)")
//            }
//        }
//    }
    
    override func inputAccessoryView(for row: BaseRow) -> UIView? {
        return nil
    }

}

// Network Related
extension EqualAddController {
    
    
    
}

// UI Related
extension EqualAddController {
    
    private func setupView() {
        self.title = "Add a new Equal"
        self.view.backgroundColor = .white
        self.tableView.backgroundColor = .white
        self.setupBackButton()
        self.setupDoneButton()
    }
    
    private func setupBackButton() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(cancelButton))
    }
    
    private func setupDoneButton() {
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .save, target: self, action: #selector(saveButton))
    }
    
}

// Form Related
extension EqualAddController {
    
    private func setupForm() {
        var event : Event? = nil
        if let eventID = self.eventID {
            event = self.networkController.container.viewContext.object(with: eventID) as? Event
        }
        
        form +++ Section("Informations")
            <<< TextRow("title") { row in
                row.title = "Title"
                row.value = event?.value(forKey: "title") as? String ?? ""
                row.add(rule: RuleRequired())
                row.validationOptions = .validatesOnChange
                row.placeholder = "Title"
//                self.innerContext.performAndWait {
//                    row.value = self.event?.value(forKey: "title") as? String
//                }
            }.cellUpdate { (cell, row) in
                if !row.isValid {
                    cell.titleLabel?.textColor = .red
                }
            }
            <<< TextRow("body") { row in
                row.title = "Desc"
                row.value = event?.value(forKey: "body") as? String ?? ""
                row.placeholder = "Description"
//                self.innerContext.performAndWait {
//                    row.value = self.event?.value(forKey: "body") as? String
//                }
            }
            +++ Section("Currency")
            <<< CurrencyRow(tag: "currency", networkController: self.networkController, authController: self.authController) { row in
                row.title = "Currency"
                row.value = (event?.value(forKey: "currency") as? Currency)?.objectID ?? nil
                row.add(rule: RuleRequired())
                row.validationOptions = .validatesOnChange
                row.displayValueFor = { id in
                    guard let id = id else { return "" }
                    let currency = self.networkController.container.viewContext.object(with: id)
//                    let currency = self.innerContext.object(with: id)
                    return currency.value(forKey: "fullname") as? String
                }
            }.cellUpdate { (cell, row) in
                if !row.isValid {
                    cell.backgroundColor = .red
                }
            }
    }
    
}
