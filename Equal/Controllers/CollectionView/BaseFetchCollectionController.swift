//
//  BaseFetchCollectionController.swift
//  Equal
//
//  Created by Alexis DARNAT on 4/16/18.
//  Copyright © 2018 Alexis DARNAT. All rights reserved.
//

import UIKit
import CoreData


class BaseFetchCollectionController: NSObject, NSFetchedResultsControllerDelegate {
    
    public var startSessionIndex: Int = 0
    public var startItemIndex: Int = 0
    
    private let collectionView : UICollectionView!
    private var blockOperations = [BlockOperation]()
    
    init(collectionView: UICollectionView) {
        self.collectionView = collectionView
        super.init()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            self.blockOperations.append(BlockOperation(block: {
                self.collectionView.insertSections(NSIndexSet(index: sectionIndex + self.startSessionIndex) as IndexSet)
            }))
        case .delete:
            self.blockOperations.append(BlockOperation(block: {
                self.collectionView.deleteSections(NSIndexSet(index: sectionIndex + self.startSessionIndex) as IndexSet)
            }))
        case .update:
            self.blockOperations.append(BlockOperation(block: {
                self.collectionView.reloadSections(NSIndexSet(index: sectionIndex + self.startSessionIndex) as IndexSet)
            }))
        case .move: break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            self.blockOperations.append(BlockOperation(block: {
                guard var nip = newIndexPath else { fatalError("Impossible to get the newIndexPath") }
                nip.section += self.startSessionIndex
                nip.item += self.startItemIndex
                self.collectionView.insertItems(at: [nip])
            }))
        case .delete:
            self.blockOperations.append(BlockOperation(block: {
                guard var ip = indexPath else { fatalError("Impossible to get the indexPath") }
                ip.section += self.startSessionIndex
                ip.item += self.startItemIndex
                self.collectionView.deleteItems(at: [ip])
            }))
        case .move:
            self.blockOperations.append(BlockOperation(block: {
                guard var nip = newIndexPath else { fatalError("Impossible to get the newIndexPath") }
                guard var ip = indexPath else { fatalError("Impossible to get the indexPath") }
                nip.section += self.startSessionIndex
                nip.item += self.startItemIndex
                ip.section += self.startSessionIndex
                ip.item += self.startItemIndex
                self.collectionView.deleteItems(at: [ip])
                self.collectionView.insertItems(at: [nip])
            }))
        case .update:
            self.blockOperations.append(BlockOperation(block: {
                guard var ip = indexPath else { fatalError("Impossible to get the indexPath") }
                ip.section += self.startSessionIndex
                ip.item += self.startItemIndex
                self.collectionView.reloadItems(at: [ip])
            }))
        }
    }

    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.collectionView.performBatchUpdates({
            for operation in self.blockOperations {
                operation.start()
            }
        }, completion: nil)
    }
}
