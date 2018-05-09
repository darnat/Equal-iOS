//
//  ExpenseAddController.swift
//  Equal
//
//  Created by Alexis DARNAT on 4/27/18.
//  Copyright © 2018 Alexis DARNAT. All rights reserved.
//

import CoreData
import Eureka

class ExpenseAddController: FormViewController {
    private let networkController : NetworkController
    private let authController : AuthController
//    private let innerContext : NSManagedObjectContext
//    private var expense : Expense?
    private var expenseID: NSManagedObjectID?
    private var eventID: NSManagedObjectID
    
    init(networkController: NetworkController, authController: AuthController, expenseID: NSManagedObjectID?, eventID: NSManagedObjectID) {
        self.networkController = networkController
        self.authController = authController
        self.eventID = eventID
        self.expenseID = expenseID
//        self.innerContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
//        self.innerContext.parent = networkController.container.viewContext
        super.init(style: .grouped)
        
        
        
//        self.innerContext.performAndWait {
//            guard let event = self.innerContext.object(with: eventID) as? Event else { fatalError("It must be an Event") }
//            self.eventID = event.value(forKeyPath: "id") as? Int
//            if let objectID = objectID {
//                guard let expense = try? self.innerContext.existingObject(with: objectID) as? Expense else { fatalError("Expense must exist") }
//                self.expense = expense
//            } else {
//                guard let entity = NSEntityDescription.entity(forEntityName: "Expense", in: self.innerContext) else { fatalError("Must create an Expense") }
//                self.expense = Expense(entity: entity, insertInto: self.innerContext)
//                self.expense?.setValue(UUID().uuidString, forKey: "guid")
//                self.expense?.setValue(event, forKey: "event")
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
    
    @objc private func cancelButton() {
//        if let tmpId = self.event?.objectID.isTemporaryID, tmpId == false {
//            self.innerContext.refresh(self.event!, mergeChanges: false)
//        }
        DispatchQueue.main.async {
            self.view.endEditing(true)
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    @objc private func saveButton() {
        var holders : [Holder] = []
        
        
        
        self.networkController.container.performBackgroundTask { (context) in
            guard let eventFetch = try? context.existingObject(with: self.eventID), let event = eventFetch as? Event else { fatalError("Event must exist") }
            var expenseTmp : Expense? = nil
            if let expenseID = self.expenseID {
                expenseTmp = context.object(with: expenseID) as? Expense
            } else {
                let expense = Expense(context: context)
                expense.setValue(UUID().uuidString, forKey: "guid")
                expense.setValue(event, forKey: "event")
                expenseTmp = expense
            }
            guard let expense = expenseTmp else { fatalError("Expense should exist") }
            
            
            for (key, value) in self.form.values() {
                if let splitValue = value as? SplitRowValue<NSManagedObjectID, Double> {
                    
                    let entity = Holder.entity()
                    let holder = Holder(entity: entity, insertInto: context)
//                    let entity = NSEntityDescription.entity(forEntityName: "Holder", in: self.innerContext)
//                    let holder = Holder(entity: entity!, insertInto: self.innerContext)
//                    let holder = Holder(context: context)
                    holder.setValue(key.starts(with: "buyers"), forKey: "payer")
                    holder.setValue(context.object(with: splitValue.left!), forKey: "participant")
                    holder.setValue(splitValue.right, forKey: "percentage")
                    holders.append(holder)
                } else {
                    expense.setValue(value, forKey: key)
                }
            }
            expense.setValue(Set(holders), forKey: "holders")
            expense.setValue(1, forKey: "sync_status")
            do {
                try context.save()
            } catch {
                fatalError("Failed to save child context: \(error)")
            }
            DispatchQueue.main.async {
                self.networkController.requestSaveExpense(authController: self.authController, objectID: expense.objectID, DidCompleteWithError: nil)
            }
        }
        
        
        
//        self.innerContext.performAndWait {
//            for (key, value) in form.values() {
//                if let splitValue = value as? SplitRowValue<NSManagedObjectID, Double> {
//                    let entity = NSEntityDescription.entity(forEntityName: "Holder", in: self.innerContext)
//                    let holder = Holder(entity: entity!, insertInto: self.innerContext)
//                    holder.setValue(key.starts(with: "buyers"), forKey: "payer")
//                    holder.setValue(self.innerContext.object(with: splitValue.left!), forKey: "participant")
//                    holder.setValue(splitValue.right, forKey: "percentage")
//                    holders.append(holder)
//                } else {
//                    self.expense?.setValue(value, forKey: key)
//                }
//            }
//            self.expense?.setValue(Set(holders), forKey: "holders")
//            self.expense?.setValue(1, forKey: "sync_status")
//        }
//        self.save()
//        self.networkController.requestSaveExpense(authController: authController, objectID: self.expense!.objectID, DidCompleteWithError: nil)
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
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
}

// UI Related
extension ExpenseAddController {
    
    private func setupView() {
        self.title = "Add a new Expense"
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
extension ExpenseAddController {
    
    private func setupForm() {
        guard let eventFetch = try? networkController.container.viewContext.existingObject(with: eventID), let event = eventFetch as? Event else { fatalError("Event must Exist") }
        var expense : Expense? = nil
        if let expenseID = self.expenseID {
            expense = self.networkController.container.viewContext.object(with: expenseID) as? Expense
        }
        
        form +++ Section("Informations")
            <<< TextRow("name") { row in
                row.title = "Title"
                row.value = expense?.value(forKey: "name") as? String ?? ""
                row.add(rule: RuleRequired())
                row.validationOptions = .validatesOnChange
                row.placeholder = "Title"
            }.cellUpdate { (cell, row) in
                if !row.isValid {
                    cell.titleLabel?.textColor = .red
                }
            }
            <<< DecimalRow("amount") { row in
                row.title = "Amount"
                row.placeholder = "10.0"
                row.value = expense?.value(forKey: "amount") as? Double ?? nil
                row.add(rule: RuleRequired())
                row.add(rule: RuleGreaterThan(min: 0.0))
                row.validationOptions = .validatesOnChange
            }.cellUpdate { (cell, row) in
                if !row.isValid {
                    cell.titleLabel?.textColor = .red
                }
            }
            +++ MultivaluedSection(multivaluedOptions: [.Insert, .Delete],
                                   header: "Paid By",
                                   footer: ".Insert adds a 'Add Item' (Add New Tag) button row as last cell.") { row in
                                    row.addButtonProvider =  { section in
                                        return ButtonRow() {
                                            $0.title = "Add New Tag"
                                        }
                                    }
                                    row.multivaluedRowToInsertAt = { index in
                                        return SplitRow<PushRow<NSManagedObjectID>, DecimalRow>("buyers\(index)") {
                                            $0.rowLeft = PushRow<NSManagedObjectID>() {
                                                $0.selectorTitle = "Paid by"
                                                guard let participants = event.value(forKeyPath: "participants") as? Set<Participant> else { return }
                                                let value = participants.map { $0.objectID }
                                                $0.options = value
                                            }
                                            
                                            $0.rowRight = DecimalRow() {
                                                $0.placeholder = "Percentage"
                                            }
                                        }
                                    }
                                    var i = 0
                                    expense?.getHolders(payer: true).forEach({ (holder) in
                                        row <<< SplitRow<PushRow<NSManagedObjectID>, DecimalRow>("buyers\(i)") {
                                            $0.rowLeft = PushRow<NSManagedObjectID>() {
                                                $0.selectorTitle = "Paid By"
                                                guard let participants = event.value(forKeyPath: "participants") as? Set<Participant> else { return }
                                                let value = participants.map { $0.objectID }
                                                $0.options = value
                                                $0.value = (holder.value(forKey: "participant") as? Participant)?.objectID ?? nil
                                            }
                                            
                                            $0.rowRight = DecimalRow() {
                                                $0.placeholder = "Percentage"
                                                $0.value = holder.value(forKey: "percentage") as? Double ?? nil
                                            }
                                        }
                                        i += 1
                                    })
//                                    $0 <<< SliderRow() {
//                                        $0.title = "Payed"
//                                        $0.value = 5.0
//                                    }
                                }
            +++ MultivaluedSection(multivaluedOptions: [.Insert, .Delete],
                                   header: "For",
                                   footer: ".Insert adds a 'Add Item' (Add New Tag) button row as last cell.") { row in
                                    row.addButtonProvider =  { section in
                                        return ButtonRow() {
                                            $0.title = "Add New Tag"
                                        }
                                    }
                                    row.multivaluedRowToInsertAt = { index in
                                        return SplitRow<PushRow<NSManagedObjectID>, DecimalRow>("sellers\(index)") {
                                            $0.rowLeft = PushRow<NSManagedObjectID>() {
                                                $0.selectorTitle = "E-mail"
                                                guard let participants = event.value(forKeyPath: "participants") as? Set<Participant> else { return }
                                                let value = participants.map { $0.objectID }
                                                $0.options = value
                                            }
                                            
                                            $0.rowRight = DecimalRow() {
                                                $0.placeholder = "Percentage"
                                            }
                                        }
                                    }
                                    var i = 0
                                    expense?.getHolders(payer: false).forEach({ (holder) in
                                        row <<< SplitRow<PushRow<NSManagedObjectID>, DecimalRow>("sellers\(i)") {
                                            $0.rowLeft = PushRow<NSManagedObjectID>() {
                                                $0.selectorTitle = "Paid By"
                                                guard let participants = event.value(forKeyPath: "participants") as? Set<Participant> else { return }
                                                let value = participants.map { $0.objectID }
                                                $0.options = value
                                                $0.value = (holder.value(forKey: "participant") as? Participant)?.objectID ?? nil
                                            }
                                            
                                            $0.rowRight = DecimalRow() {
                                                $0.placeholder = "Percentage"
                                                $0.value = holder.value(forKey: "percentage") as? Double ?? nil
                                            }
                                        }
                                        i += 1
                                    })
        }
    }
    
}
