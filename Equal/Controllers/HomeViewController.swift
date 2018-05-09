//
//  HomeViewController.swift
//  Equal
//
//  Created by Alexis DARNAT on 4/5/18.
//  Copyright © 2018 Alexis DARNAT. All rights reserved.
//

import UIKit
import CoreData

// Comment the Code
class HomeViewController: UICollectionViewController {
    private struct keys {
        static let cellID = "cellID"
    }
    
    private let networkController : NetworkController
    private let authController : AuthController
    private let layout : UICollectionViewFlowLayout
    private var fetchController : NSFetchedResultsController<Event>?
    private lazy var collectionControllerDelegate : BaseFetchCollectionController = {
        return BaseFetchCollectionController(collectionView: self.collectionView!)
    }()
//    private var blockOperations = [BlockOperation]()
    
    private lazy var refreshView : UIRefreshControl = {
        let refreshView = UIRefreshControl()
        refreshView.addTarget(self, action: #selector(loadData), for: .valueChanged)
        return refreshView
    }()
    
    private lazy var addButton : RoundedButton = {
        let button = RoundedButton()
        button.setTitle("Add a new Equal", for: .normal)
        button.setImage(UIImage(named: "AddIcon"), for: .normal)
        button.addTarget(self, action: #selector(addEqualButtonAction), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private lazy var notificationButton : UIButton = {
        let button = UIButton()
        button.setImage(UIImage(named: "Bell")?.withRenderingMode(.alwaysTemplate), for: .normal)
        button.addTarget(self, action: #selector(notificationButtonAction), for: .touchUpInside)
        button.imageView?.contentMode = .scaleAspectFit
        button.tintColor = .lightGray
        return button
    }()
    
    lazy var rightLargeTitleView : UIButton = {
        let button = UIButton()
        button.setTitle("Join an Equal", for: .normal)
        button.setTitleColor(UIColor(red: 0.278, green: 0.620, blue: 0.941, alpha: 1.0), for: .normal)
        button.setImage(UIImage(named: "AddIcon"), for: .normal)
        button.imageEdgeInsets = UIEdgeInsets(top: 7, left: 0, bottom: 7, right: 0)
        button.imageView?.contentMode = .scaleAspectFit
        button.titleLabel?.font = UIFont.systemFont(ofSize: 12, weight: .regular)
//        button.addTarget(self, action: #selector(addEqualButtonAction), for: .touchUpInside)
        return button
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
        
        self.title = "Equal"
        self.registerClass()
        self.setupView()
        
        // NSFetchController
        self.fetchController = self.networkController.requestHome(authController: authController)
        self.fetchController?.delegate = self.collectionControllerDelegate
        do {
            try self.fetchController?.performFetch()
        } catch {
            fatalError("Unable to fetch: \(error)")
        }
        self.networkController.syncNonSynchronizedEvent(authController: authController)
        self.networkController.syncNonSynchronizedExpense(authController: authController)
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        NotificationCenter.default.addObserver(self, selector: #selector(networkError(notification:)), name: Notification.Name.Network.didCompleteWithError, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)
    }
    
    // Button Action
    @objc private func addEqualButtonAction() {
//        let vc = AddEqualViewController(networkController: networkController, authController: authController, objectID: nil)
        let vc = EqualAddController(networkController: networkController, authController: authController, objectID: nil)
        let navigationController = PresentNavigationController(rootViewController: vc)
        DispatchQueue.main.async {
            self.present(navigationController, animated: true, completion: nil)
        }
    }
    
    @objc func notificationButtonAction() {
        let notificationViewController = NotificationsViewController(networkController: self.networkController, authController: self.authController)
        self.navigationController?.pushViewController(notificationViewController, animated: true)
    }
    
    @objc private func UserButtonAction() {
        let userViewController = UserViewController(networkController: self.networkController, authController: self.authController)
        self.navigationController?.pushViewController(userViewController, animated: true)
    }
}

// UICollectionView related
extension HomeViewController {
    private func registerClass() {
        collectionView?.register(EqualCollectionViewCell.self, forCellWithReuseIdentifier: keys.cellID)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let sectionInfo = self.fetchController?.sections?[section] else { fatalError("Failed to resolve FRC") }
        return sectionInfo.numberOfObjects
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let event = self.fetchController?.object(at: indexPath) else { fatalError("Failed to resolve FRC") }
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: keys.cellID, for: indexPath) as? EqualCollectionViewCell else { fatalError("Failed to get the cell") }
        cell.updateCellWith(ManageObject: event)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 20, left: 20, bottom: 120, right: 20)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.networkController.queue.cancelAllOperations()
        guard let event = self.fetchController?.object(at: indexPath) else { fatalError("Failed to resolve FRC") }
        let equalDetailView = EqualDetailController(networkController: self.networkController, authController: self.authController, eventID: event.objectID)
        self.navigationController?.pushViewController(equalDetailView, animated: true)
    }
}

// UICollectionViewDelegateFlowLayout
extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width - 40, height: 100)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 25
    }
}

// Network related
extension HomeViewController {
    @objc func networkError(notification: Notification) {
        if let userInfo = notification.userInfo,
            let error = userInfo["error"] {
            switch error {
            case let error as NetworkError:
                print(error.code)
                if error.code == 401 {
                    authController.unAuth()
                }
                print(error.errors ?? "nil")
                break
            default:
                break
            }
        }
    }
    
    @objc func loadData() {
        self.networkController.queue.cancelAllOperations()
        self.networkController.requestEquals(authController: authController) { (error: Error?) in
            DispatchQueue.main.async {
                self.refreshView.endRefreshing()
            }
        }
    }
}

// UI related
extension HomeViewController {
    private func setupView() {
        self.view.backgroundColor = .white
        collectionView?.contentInsetAdjustmentBehavior = .always
        collectionView?.backgroundColor = .white
        collectionView?.refreshControl = self.refreshView
        collectionView?.alwaysBounceVertical = true
        self.setupAddButton()
        self.setupNavigationBarItems()
    }
    
    private func setupAddButton() {
        self.view.addSubview(self.addButton)
        self.addButton.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor, constant: -25).isActive = true
//        self.addButton.leftAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor, constant: 40).isActive = true
//        self.addButton.rightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor, constant: -40).isActive = true
        self.addButton.centerXAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        self.addButton.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    
    private func setupNavigationBarItems() {
        let fixedSpace = UIBarButtonItem(barButtonSystemItem: .fixedSpace, target: nil, action: nil)
        fixedSpace.width = 16
        navigationItem.leftBarButtonItems = [UIBarButtonItem(customView: self.notificationButton), fixedSpace]
        
        let imageButton = UIButton()
        imageButton.setImage(UIImage(named: "Test"), for: .normal)
        imageButton.layer.masksToBounds = true
        imageButton.layer.cornerRadius = 16
        imageButton.addTarget(self, action: #selector(UserButtonAction), for: .touchUpInside)
        navigationItem.rightBarButtonItem = UIBarButtonItem(customView: imageButton)
        
        let searchBar = UISearchController(searchResultsController: nil)
        navigationItem.searchController = searchBar
    }
}
