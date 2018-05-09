//
//  ParticipantAmountRow.swift
//  Equal
//
//  Created by Alexis DARNAT on 4/27/18.
//  Copyright © 2018 Alexis DARNAT. All rights reserved.
//

import Foundation
import CoreData
import Eureka

//public struct participantAmount: Hashable  {
//    let participantObjectId: NSManagedObjectID
//    let percentage: Double
//}
//
//final class ParticipantAmountRow: GenericMultipleSelectorRow<String, PushSelectorCell<Set<String>>>, RowType {
//
////    typealias PresenterRow = ParticipantAmountController
////    typealias presentationMode = PresentationMode<PresenterRow>?
//
//    required init(tag: String?) {
//        super.init(tag: tag)
//
//        displayValueFor = { row in
//            return "hello"
//        }
//        presentationMode = .show(controllerProvider: ControllerProvider.callback {
//            return ParticipantAmountController()
//            }, onDismiss: { vc in
//                let _ = vc.navigationController?.popViewController(animated: true)
//        })
//    }
//
////    open override func customDidSelect() {
////        super.customDidSelect()
////        guard let presentationMode = presentationMode, !isDisabled else { return }
////        if let controller = presentationMode.makeController() {
////            controller.row = self
////            controller.title = selectorTitle ?? controller.title
////            onPresentCallback?(cell.formViewController()!, controller)
////            presentationMode.present(controller, row: self, presentingController: self.cell.formViewController()!)
////        } else {
////            presentationMode.present(nil, row: self, presentingController: self.cell.formViewController()!)
////        }
////    }
////
////    open override func prepare(for segue: UIStoryboardSegue) {
////        super.prepare(for: segue)
////        guard let rowVC = segue.destination as? PresenterRow else { return }
////        rowVC.title = selectorTitle ?? rowVC.title
////        rowVC.onDismissCallback = presentationMode?.onDismissCallback ?? rowVC.onDismissCallback
////        onPresentCallback?(cell.formViewController()!, rowVC)
////        rowVC.row = self
////    }
//
//}

//final class ParticipantAmountController: FormViewController, TypedRowControllerType {
//    var row: RowOf<Set<String>>!
//    typealias RowValue = Set<String>
//
//    var onDismissCallback: ((UIViewController) -> Void)?
//
////    convenience public init(_ callback: ((UIViewController) -> Void)?) {
////        self.init(nibName: nil, bundle: nil)
////        onDismissCallback = callback
////    }
//
//}

//final class participantAmountRow: OptionsRow<PushSelectorCell<[NSManagedObjectID: Double]>>, PresenterRowType, RowType {
//    var presentationMode: PresentationMode<AddParticipantAmountViewController>?
//    var onPresentCallback: ((FormViewController, AddParticipantAmountViewController) -> Void)?
////    typealias PresentedControllerType = AddParticipantAmountViewController
//    typealias PresenterRow = AddParticipantAmountViewController
//
//    required init(tag: String?) {
//        super.init(tag: tag)
//        presentationMode = .show(controllerProvider: ControllerProvider.callback { return AddParticipantAmountViewController(){ _ in } }, onDismiss: { vc in _ = vc.navigationController?.popViewController(animated: true) })
//    }
//
//    open override func customDidSelect() {
//        super.customDidSelect()
//        guard let presentationMode = presentationMode, !isDisabled else { return }
//        if let controller = presentationMode.makeController() {
//            controller.row = self
//            controller.title = selectorTitle ?? controller.title
//            onPresentCallback?(cell.formViewController()!, controller)
//            presentationMode.present(controller, row: self, presentingController: self.cell.formViewController()!)
//        } else {
//            presentationMode.present(nil, row: self, presentingController: self.cell.formViewController()!)
//        }
//    }
//
//    open override func prepare(for segue: UIStoryboardSegue) {
//        super.prepare(for: segue)
//        guard let rowVC = segue.destination as? PresenterRow else { return }
//        rowVC.title = selectorTitle ?? rowVC.title
//        rowVC.onDismissCallback = presentationMode?.onDismissCallback ?? rowVC.onDismissCallback
//        onPresentCallback?(cell.formViewController()!, rowVC)
//        rowVC.row = self
//    }
//
//
//}
//
//class AddParticipantAmountViewController: UITableViewController, TypedRowControllerType {
//
//    var row: RowOf<[NSManagedObjectID : Double]>!
//    typealias RowValue = [NSManagedObjectID: Double]
//
//    var onDismissCallback: ((UIViewController) -> Void)?
//
//    convenience init(_ callback: ((UIViewController) -> ())?) {
//        self.init(nibName: nil, bundle: nil)
//        onDismissCallback = callback
//    }
//}
