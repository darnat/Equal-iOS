//
//  EqualDetailController.swift
//  Equal
//
//  Created by Alexis DARNAT on 5/5/18.
//  Copyright © 2018 Alexis DARNAT. All rights reserved.
//

import UIKit
import CoreData

class EqualDetailController: UICollectionViewController {
    private struct keys {
        static let cellID = "cellID"
    }
    private let networkController : NetworkController
    private let authController : AuthController
    private let layout : UICollectionViewFlowLayout
    private let eventID: NSManagedObjectID
    private let event: Event
    private var contextWatcher : CoreDataContextWatcher?
    
    private lazy var overview: EqualOverviewController = {
        let controller = EqualOverviewController(networkController: self.networkController, authController: self.authController, eventID: self.eventID)
        self.addChildViewController(controller)
        controller.didMove(toParentViewController: controller)
        return controller
    }()
    
    private lazy var balance: EqualBalanceController = {
        let controller = EqualBalanceController()
        self.addChildViewController(controller)
        controller.didMove(toParentViewController: controller)
        return controller
    }()
    
    private lazy var controllers: [UIViewController] = {
        return [self.overview, self.balance]
    }()
    
    /** Tab Bar **/
    private lazy var menuTabBar: MenuTabBar = {
        let view = MenuTabBar()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = Config.navigationBarColor
        view.delegate = self
        return view
    }()
    /** End Tab Bar **/
    
    /** Add Button **/
    private lazy var addButton : RoundedButton = {
        let button = RoundedButton()
        button.setTitle("＋", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 40, weight: .bold)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(addButtonAction), for: .touchUpInside)
        button.contentEdgeInsets = .zero
        return button
    }()
    /** End Add Button **/
    
    init(networkController: NetworkController, authController: AuthController, eventID: NSManagedObjectID) {
        self.networkController = networkController
        self.authController = authController
        self.eventID = eventID
        guard let eventFetch = try? networkController.container.viewContext.existingObject(with: eventID), let event = eventFetch as? Event else { fatalError("Event Must Exist") }
        self.event = event
        self.layout = UICollectionViewFlowLayout()
        super.init(collectionViewLayout: self.layout)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupConfig()
        self.setupCollectionView()
        self.registerClass()
        self.setupContextWatcher()
        self.setupView()
    }
    
    private func setupConfig() {
        self.title = "Equal"
        self.navigationItem.largeTitleDisplayMode = .never
    }
    
    private func scrollToMenu(Index index: Int) {
        let indexPath = IndexPath(item: index, section: 0)
        self.collectionView?.scrollToItem(at: indexPath, at: .left, animated: true)
    }
}

// UIButton Action Related
extension EqualDetailController {
    
    @objc private func addButtonAction() {
        let vc = ExpenseAddController(networkController: networkController, authController: authController, expenseID: nil, eventID: self.eventID)
        let navigationController = PresentNavigationController(rootViewController: vc)
        self.present(navigationController, animated: true, completion: nil)
    }
    
}

// ContextWatcher Related
extension EqualDetailController: CoreDataContextWatcherDelegate {
    func contextUpdated(impact: [String : [NSManagedObject]]) {
        if impact[NSDeletedObjectsKey]?.first != nil {
            DispatchQueue.main.async {
                self.navigationController?.dismiss(animated: true, completion: nil)
            }
        }
        if let updated = impact[NSUpdatedObjectsKey]?.first as? Event {
            DispatchQueue.main.async {
                self.updateUI(forEvent: updated)
            }
        }
    }
    
    
    private func setupContextWatcher() {
        self.contextWatcher = CoreDataContextWatcher(context: self.networkController.container.viewContext)
        self.contextWatcher?.delegate = self
        let predicate = NSPredicate(format: "self == %d", self.eventID)
        self.contextWatcher?.addWatch(Entity: "Event", predicate: predicate)
    }
    
}

// UICollectionView Config Related
extension EqualDetailController {
    
    private func registerClass() {
        self.collectionView?.register(EqualCell.self, forCellWithReuseIdentifier: keys.cellID)
    }
    
    private func setupCollectionView() {
        self.layout.scrollDirection = .horizontal
        self.layout.minimumLineSpacing = 0
        self.collectionView?.bounces = false
        self.collectionView?.isPagingEnabled = true
        self.collectionView?.showsHorizontalScrollIndicator = false
        self.collectionView?.showsVerticalScrollIndicator = false
    }
    
}

// UICollectionView Delegate related
extension EqualDetailController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.controllers.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: keys.cellID, for: indexPath) as? EqualCell else { fatalError("EqualCell should exist") }
        cell.hostedView = self.controllers[indexPath.item].view
        return cell
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.menuTabBar.updateScroll(value: scrollView.contentOffset.x)
    }
    
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        let index = targetContentOffset.pointee.x / view.frame.width
        let indexPath = IndexPath(item: Int(index), section: 0)
        self.menuTabBar.selectItemAt(Index: indexPath)
    }
    
}

// UICollectionView Delegate Flow layout
extension EqualDetailController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: collectionView.frame.height)
    }
    
}

// UI Related
extension EqualDetailController {
    
    private func setupView() {
        self.view.backgroundColor = .white
        self.updateUI(forEvent: self.event)
        self.setupCollectionViewUI()
        self.setupTabBar()
        self.setupAddButton()
    }
    
    private func setupCollectionViewUI() {
        self.collectionView?.backgroundColor = .white
//        self.collectionView?.translatesAutoresizingMaskIntoConstraints = false
//        self.collectionView?.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor, constant: 40).isActive = true
//        self.collectionView?.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
//        self.collectionView?.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
//        self.collectionView?.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
    }
    
    private func setupAddButton() {
        self.view.addSubview(self.addButton)
        self.addButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -25).isActive = true
        self.addButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
        self.addButton.widthAnchor.constraint(equalToConstant: 60).isActive = true
        self.addButton.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: -40).isActive = true
    }
    
    private func setupTabBar() {
        self.view.addSubview(self.menuTabBar)
        self.menuTabBar.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        self.menuTabBar.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        self.menuTabBar.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        self.menuTabBar.heightAnchor.constraint(equalToConstant: 40.0).isActive = true
    }
    
    private func updateUI(forEvent event: Event) {
        if let title = event.value(forKey: "title") as? String {
            self.title = title
        }
    }
    
}

// MenuTabBar Delegate related

extension EqualDetailController: MenuTabBarDelegate {
    
    func didSelectItemAt(Index index: Int) {
        self.scrollToMenu(Index: index)
    }
    
}
