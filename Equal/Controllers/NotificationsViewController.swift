//
//  NotificationsViewController.swift
//  Equal
//
//  Created by Alexis DARNAT on 4/16/18.
//  Copyright © 2018 Alexis DARNAT. All rights reserved.
//

import UIKit
import CoreData

class NotificationsViewController: UICollectionViewController {
    private struct keys {
        static let cellID = "cellID"
    }
    
    private let networkController : NetworkController
    private let authController : AuthController
    private let layout : UICollectionViewFlowLayout
    private var fetchController : NSFetchedResultsController<History>?
    private lazy var collectionControllerDelegate : BaseFetchCollectionController = {
        return BaseFetchCollectionController(collectionView: self.collectionView!)
    }()
    
    private lazy var refreshView : UIRefreshControl = {
        let refreshView = UIRefreshControl()
        refreshView.addTarget(self, action: #selector(loadData), for: .valueChanged)
        return refreshView
    }()
    
    init(networkController: NetworkController, authController: AuthController) {
        self.networkController = networkController
        self.authController = authController
        self.layout = UICollectionViewFlowLayout()
        super.init(collectionViewLayout: self.layout)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.title = "Notifications"
        self.registerClass()
        self.setupView()
        
        self.fetchController = self.networkController.requestHistories(authController: self.authController)
        self.fetchController?.delegate = self.collectionControllerDelegate
        do {
            try self.fetchController?.performFetch()
        } catch {
            fatalError("Unable to fetch: \(error)")
        }

    }
}

// UI Related
extension NotificationsViewController {
    private func setupView() {
        navigationItem.largeTitleDisplayMode = .never
        self.view.backgroundColor = .white
        collectionView?.contentInsetAdjustmentBehavior = .always
        collectionView?.backgroundColor = .white
        collectionView?.refreshControl = self.refreshView
        collectionView?.alwaysBounceVertical = true
    }
}

extension NotificationsViewController {
    @objc func loadData() {
        self.networkController.queue.cancelAllOperations()
        self.networkController.requestHistories(authController: authController) { (error: Error?) in
            DispatchQueue.main.async {
                self.refreshView.endRefreshing()
            }
        }
//        self.networkController.requestEvent(authController: authController, eventID: self.event.value(forKey: "id") as! Int) { (error: Error?) in
//            DispatchQueue.main.async {
//                self.refreshView.endRefreshing()
//            }
//        }
    }
}

// UICollectionView related
extension NotificationsViewController {
    private func registerClass() {
        self.collectionView?.register(HistoryCollectionViewCell.self, forCellWithReuseIdentifier: keys.cellID)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let sectionInfo = self.fetchController?.sections?[section] else { fatalError("Failed to resolve FRC") }
        return sectionInfo.numberOfObjects
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: keys.cellID, for: indexPath) as? HistoryCollectionViewCell else { fatalError("Failed to get the cell") }
        return cell
    }
}

extension NotificationsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 60)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
}
