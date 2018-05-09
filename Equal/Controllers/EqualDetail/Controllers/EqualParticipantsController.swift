//
//  EqualParticipantsController.swift
//  Equal
//
//  Created by Alexis DARNAT on 5/7/18.
//  Copyright © 2018 Alexis DARNAT. All rights reserved.
//

import UIKit
import CoreData

class EqualParticipantsController: UICollectionViewController {
    private struct keys {
        static let cellID = "cellID"
        static let inviteID = "inviteID"
    }
    private let networkController : NetworkController
    private let authController : AuthController
    private let eventID: NSManagedObjectID
    private let layout : UICollectionViewFlowLayout
    private let imageCache = NSCache<NSString, UIImage>()
    
    private lazy var fetchController : NSFetchedResultsController<Participant> = {
        let fetch : NSFetchRequest<Participant> = Participant.fetchRequest()
        fetch.sortDescriptors = [NSSortDescriptor(key: "owner", ascending: false), NSSortDescriptor(key: "nickname", ascending: true)]
        fetch.predicate = NSPredicate(format: "event == %@", self.eventID)
        let fetchController = NSFetchedResultsController(fetchRequest: fetch, managedObjectContext: self.networkController.container.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        return fetchController
    }()
    
    private lazy var collectionControllerDelegate : BaseFetchCollectionController = {
        return BaseFetchCollectionController(collectionView: self.collectionView!)
    }()

    init(networkController: NetworkController, authController: AuthController, eventID: NSManagedObjectID) {
        self.networkController = networkController
        self.authController = authController
        self.eventID = eventID
        self.layout = UICollectionViewFlowLayout()
        super.init(collectionViewLayout: self.layout)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupCollectionView()
        self.registerClass()
        self.setupFetchController()
        self.setupView()
    }
}

// CoreData Related
extension EqualParticipantsController {
    
    private func setupFetchController() {
        self.fetchController.delegate = self.collectionControllerDelegate
        self.collectionControllerDelegate.startItemIndex = 1
        do {
            try self.fetchController.performFetch()
        } catch {
            fatalError("Unable to fetch: \(error)")
        }
    }
    
}

// UICollectionView Config Related
extension EqualParticipantsController {
    
    private func registerClass() {
        self.collectionView?.register(ParticipantCell.self, forCellWithReuseIdentifier: keys.cellID)
        self.collectionView?.register(InviteParticipantCell.self, forCellWithReuseIdentifier: keys.inviteID)
    }
    
    private func setupCollectionView() {
        self.layout.scrollDirection = .horizontal
        self.layout.minimumLineSpacing = 0
        self.collectionView?.bounces = true
        self.collectionView?.isPagingEnabled = false
        self.collectionView?.showsHorizontalScrollIndicator = false
        self.collectionView?.showsVerticalScrollIndicator = false
        self.collectionView?.contentInset = UIEdgeInsets(top: 0.0, left: 10.0, bottom: 0.0, right: 10.0)
    }
    
}

// UI CollectionView Related
extension EqualParticipantsController {
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        guard let numbers = self.fetchController.sections?.count else { return 1 }
        return numbers
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let sectionInfo = self.fetchController.sections?[section] else { fatalError("Failed to resolve FRC") }
        return (sectionInfo.numberOfObjects + 1)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.item == 0 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: keys.inviteID, for: indexPath) as? InviteParticipantCell else { fatalError("Failed to get the cell") }
            return cell
        }
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: keys.cellID, for: indexPath) as? ParticipantCell else { fatalError("Failed to get the cell") }
        
        let nIndexPath = IndexPath(item: indexPath.item - 1, section: indexPath.section)
        let participant = self.fetchController.object(at: nIndexPath)
        if let imageURL = participant.value(forKey: "image") as? String {
            if let image = self.imageCache.object(forKey: imageURL as NSString) {
                cell.imageContainer.imageView.image = image
            } else {
                self.networkController.requestImage(imageURL: Config.baseURLPath + imageURL) { (data) in
                    if let image = UIImage(data: data) {
                        self.imageCache.setObject(image, forKey: imageURL as NSString)
                        DispatchQueue.main.async {
                            collectionView.reloadItems(at: [indexPath])
                        }
                    }
                }
            }
        }
        cell.updateCellWith(ManageObject: participant)
        return cell
    }
    
}

// UICollectionViewDelegateFlowLayout Related
extension EqualParticipantsController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 6
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 72.0, height: view.frame.height)
    }
    
}

// UI Related
extension EqualParticipantsController {
    
    private func setupView() {
        self.view.backgroundColor = .white
        self.collectionView?.backgroundColor = .white
    }
    
}
