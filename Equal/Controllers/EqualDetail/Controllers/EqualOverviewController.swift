//
//  EqualOverviewController.swift
//  Equal
//
//  Created by Alexis DARNAT on 5/6/18.
//  Copyright © 2018 Alexis DARNAT. All rights reserved.
//

import UIKit
import CoreData

class EqualOverviewController: UICollectionViewController {
    private struct keys {
        static let cellID = "cellID"
        static let participantsCellID = "participantsCellID"
        static let headerID = "headerID"
    }
    
    private let networkController : NetworkController
    private let authController : AuthController
    private let eventID: NSManagedObjectID
    private let layout : UICollectionViewFlowLayout
    
    private var fetchController : NSFetchedResultsController<Expense>?
    private lazy var collectionControllerDelegate : BaseFetchCollectionController = {
        return BaseFetchCollectionController(collectionView: self.collectionView!)
    }()
    
    private lazy var refreshView : UIRefreshControl = {
        let refreshView = UIRefreshControl()
        refreshView.addTarget(self, action: #selector(loadData), for: .valueChanged)
        return refreshView
    }()
    
    private lazy var participantsController: EqualParticipantsController = {
        let controller = EqualParticipantsController(networkController: self.networkController, authController: self.authController, eventID: self.eventID)
        self.addChildViewController(controller)
        controller.didMove(toParentViewController: controller)
        return controller
    }()
    
    init(networkController: NetworkController, authController: AuthController, eventID: NSManagedObjectID) {
        self.networkController = networkController
        self.authController = authController
        self.eventID = eventID
        self.layout = UICollectionViewFlowLayout()
        super.init(collectionViewLayout: self.layout)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.registerClass()
        self.setupFetchController()
        self.setupCollectionView()
        self.setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// Network related
extension EqualOverviewController {
    
    private func setupFetchController() {
        self.fetchController = self.networkController.requestEvent(authController: authController, eventID: self.eventID)
        self.fetchController?.delegate = self.collectionControllerDelegate
        self.collectionControllerDelegate.startSessionIndex = 1
        do {
            try self.fetchController?.performFetch()
        } catch {
            fatalError("Unable to fetch: \(error)")
        }
    }
    
    @objc private func loadData() {
        self.networkController.requestEvent(authController: authController, eventID: eventID) { (error: Error?) in
            DispatchQueue.main.async {
                self.refreshView.endRefreshing()
            }
        }
    }
    
}

// UICollectionView Config Related
extension EqualOverviewController {
    
    private func registerClass() {
        self.collectionView?.register(EqualDetailHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: keys.headerID)
        self.collectionView?.register(ExpenseCollectionViewCell.self, forCellWithReuseIdentifier: keys.cellID)
        self.collectionView?.register(ParticipantsCell.self, forCellWithReuseIdentifier: keys.participantsCellID)
    }
    
    private func setupCollectionView() {
        collectionView?.contentInset = UIEdgeInsets(top: 60.0, left: 0, bottom: 140.0, right: 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: 60.0, left: 0, bottom: 60.0, right: 0)
        collectionView?.contentInsetAdjustmentBehavior = .always
        collectionView?.alwaysBounceVertical = true
        collectionView?.refreshControl = self.refreshView
    }
    
}

// UICollectionView Related
extension EqualOverviewController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard section > 0 else { return 1 }
        guard let sectionInfo = self.fetchController?.sections?[section - 1] else { fatalError("Failed to resolve FRC") }
        return sectionInfo.numberOfObjects
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        guard let numbers = self.fetchController?.sections?.count else { return 1 }
        return (numbers + 1)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if indexPath.section == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: keys.participantsCellID, for: indexPath) as? ParticipantsCell else { fatalError("Failed to get the cell") }
//            cell.updateCellWith(ManageObject: expense)
            cell.hostedView = self.participantsController.view
            
            return cell
        }
        let nIndexPath = IndexPath(item: indexPath.item, section: indexPath.section - 1)
        guard let expense = self.fetchController?.object(at: nIndexPath) else { fatalError("Failed to resolve FRC") }
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: keys.cellID, for: indexPath) as? ExpenseCollectionViewCell else { fatalError("Failed to get the cell") }
        cell.updateCellWith(ManageObject: expense)
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let view = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionElementKindSectionHeader, withReuseIdentifier: keys.headerID, for: indexPath) as? EqualDetailHeaderView else { fatalError("can not get the header view") }
        if indexPath.section == 0 {
            view.updateWith(Title: "PARTICIPANTS")
            return view
        }
        
        guard let sectionInfo = self.fetchController?.sections?[indexPath.section - 1] else { fatalError("can not object") }
        let rawDate = sectionInfo.name
        view.updateWith(rawDate: rawDate)
        return view
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.section > 0 else { return }
        let nIndexPath = IndexPath(item: indexPath.item, section: indexPath.section - 1)
        guard let expense = self.fetchController?.object(at: nIndexPath), let parent = self.parent else { fatalError("Failed to resolve FRC") }
        let vc = ExpenseAddController(networkController: networkController, authController: authController, expenseID: expense.objectID, eventID: self.eventID)
        let navigationController = PresentNavigationController(rootViewController: vc)
        parent.present(navigationController, animated: true, completion: nil)
    }
    
}

// UICollectionViewLayout Related
extension EqualOverviewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return CGSize(width: view.frame.width, height: 45.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.section == 0 {
            return CGSize(width: view.frame.width, height: 90.0)
        }
        return CGSize(width: view.frame.width - 40.0, height: 60.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 12
    }
    
}


// UI Related
extension EqualOverviewController {
    
    private func setupView() {
        self.view.backgroundColor = .white
        collectionView?.backgroundColor = .white
        self.setupCollectionViewAnchors()
    }
    
    private func setupCollectionViewAnchors() {
        self.collectionView?.translatesAutoresizingMaskIntoConstraints = false
        self.collectionView?.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40.0).isActive = true
        self.collectionView?.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        self.collectionView?.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        self.collectionView?.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
    }
    
}
