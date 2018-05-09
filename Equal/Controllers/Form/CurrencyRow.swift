//
//  CurrencyPushRow.swift
//  Equal
//
//  Created by Alexis DARNAT on 4/25/18.
//  Copyright © 2018 Alexis DARNAT. All rights reserved.
//

import UIKit
import CoreData
import Eureka

final class CurrencyRow: OptionsRow<PushSelectorCell<NSManagedObjectID>>, PresenterRowType, RowType {
    private var networkController : NetworkController?
    private var authController : AuthController?
    
    typealias PresenterRow = AddCurrencyViewController
    open var presentationMode: PresentationMode<PresenterRow>?
    open var onPresentCallback: ((FormViewController, PresenterRow) -> Void)?

    convenience init(tag: String?, networkController: NetworkController, authController: AuthController, _ initializer: (CurrencyRow) -> Swift.Void) {
        self.init(tag, initializer)
        self.networkController = networkController
        self.authController = authController
        presentationMode = .show(controllerProvider: ControllerProvider.callback { return AddCurrencyViewController(networkController: self.networkController, authController: self.authController){ _ in } }, onDismiss: { vc in _ = vc.navigationController?.popViewController(animated: true) })
    }
    
    required init(tag: String?) {
        super.init(tag: tag)
    }
    
    open override func customDidSelect() {
        super.customDidSelect()
        guard let presentationMode = presentationMode, !isDisabled else { return }
        if let controller = presentationMode.makeController() {
            controller.row = self
            controller.title = selectorTitle ?? controller.title
            onPresentCallback?(cell.formViewController()!, controller)
            presentationMode.present(controller, row: self, presentingController: self.cell.formViewController()!)
        } else {
            presentationMode.present(nil, row: self, presentingController: self.cell.formViewController()!)
        }
    }
    
    open override func prepare(for segue: UIStoryboardSegue) {
        super.prepare(for: segue)
        guard let rowVC = segue.destination as? PresenterRow else { return }
        rowVC.title = selectorTitle ?? rowVC.title
        rowVC.onDismissCallback = presentationMode?.onDismissCallback ?? rowVC.onDismissCallback
        onPresentCallback?(cell.formViewController()!, rowVC)
        rowVC.row = self
    }

}

// Controller
class AddCurrencyViewController: UITableViewController, TypedRowControllerType {
    private struct keys {
        static let cellID = "cellID"
    }
    private var networkController : NetworkController?
    private var authController : AuthController?
    
    var row: RowOf<NSManagedObjectID>!
    typealias RowValue = NSManagedObjectID
    var onDismissCallback: ((UIViewController) -> ())?
    
    private var fetchController : NSFetchedResultsController<Currency>?
    private var operation : Operation?
    
    private lazy var searchController : UISearchController = {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search currencies"
        searchController.searchResultsUpdater = self
        searchController.definesPresentationContext = true
        return searchController
    }()

    convenience init(networkController: NetworkController?, authController: AuthController?, _ callback: ((UIViewController) -> ())?) {
        self.init(nibName: nil, bundle: nil)
        self.networkController = networkController
        self.authController = authController
        onDismissCallback = callback
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.searchController = self.searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
        self.registerClass()
        self.setupView()
        
        self.fetchController = self.networkController!.requestCurrencies(authController: self.authController!)
        self.fetchController?.delegate = self
        do {
            try self.fetchController?.performFetch()
        } catch {
            fatalError("Unable to fetch: \(error)")
        }
    }

}

// UITableView Related
extension AddCurrencyViewController {
    
    private func registerClass() {
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: keys.cellID)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: keys.cellID, for: indexPath)
        guard let frc = self.fetchController else { fatalError("Object does not exist") }
        let object = frc.object(at: indexPath)
        cell.textLabel?.text = object.value(forKey: "fullname") as? String
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let sectionInfo = self.fetchController?.sections?[section] else {
            fatalError("Failed to resolve FRC")
        }
        return sectionInfo.numberOfObjects
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        guard let count = self.fetchController?.sections?.count else {
            fatalError("Failed to resolve FRC")
        }
        return count
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let frc = self.fetchController else { fatalError("Object does not exist") }
        let object = frc.object(at: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
        row.value = object.objectID
        onDismissCallback?(self)
    }
    
}

// NSFetchedResultsControllerDelegate Related
extension AddCurrencyViewController: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.tableView.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            tableView.insertSections(NSIndexSet(index: sectionIndex) as IndexSet, with: .fade)
        case .delete:
            tableView.deleteSections(NSIndexSet(index: sectionIndex) as IndexSet, with: .fade)
        case .move: break
        case .update: break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            guard let nip = newIndexPath else { fatalError("How?") }
            tableView.insertRows(at: [nip], with: .fade)
        case .delete:
            guard let ip = indexPath else { fatalError("How?") }
            tableView.deleteRows(at: [ip], with: .fade)
        case .move:
            guard let ip = indexPath else { fatalError("How?") }
            guard let nip = newIndexPath else { fatalError("How?") }
            tableView.deleteRows(at: [ip], with: .fade)
            tableView.insertRows(at: [nip], with: .fade)
        case .update:
            guard let ip = indexPath else { fatalError("How?") }
            tableView.reloadRows(at: [ip], with: .fade)
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, sectionIndexTitleForSectionName sectionName: String) -> String? {
        return "[\(sectionName)]"
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
}

// UI Related
extension AddCurrencyViewController {
    
    private func setupView() {
        self.view.backgroundColor = .white
    }
    
}

// Network Related
extension AddCurrencyViewController {
    
    private func resultSearch(error: Error?) {
        self.performFetchedResultController()
    }
    
    @objc private func searchFor() {
        guard let pattern = self.searchController.searchBar.text else { return }
        if pattern.trimmingCharacters(in: .whitespaces).isEmpty {
            self.resultSearch(error: nil)
            return
        }
        self.performFetchedResultController(withPredicate: NSPredicate(format: "(fullname CONTAINS[cd] %@) OR (symbol CONTAINS[cd] %@)", pattern, pattern))
        self.operation = self.networkController!.requestCurrencies(authController: authController!, pattern: pattern, DidComplete: nil)
    }
    
    private func performFetchedResultController(withPredicate predicate: NSPredicate? = nil) {
        self.fetchController?.fetchRequest.predicate = predicate
        self.fetchController?.delegate = self
        do {
            try self.fetchController?.performFetch()
        } catch {
            fatalError("Unable to fetch: \(error)")
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
}

// Search Controller Result Related
extension AddCurrencyViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        if let operation = self.operation {
            operation.cancel()
        }
        NSObject.cancelPreviousPerformRequests(withTarget: self, selector: #selector(searchFor), object: nil)
        self.perform(#selector(searchFor), with: nil, afterDelay: 0.5)
    }
    
}
