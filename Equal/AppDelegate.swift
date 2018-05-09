//
//  AppDelegate.swift
//  Equal
//
//  Created by Alexis DARNAT on 3/31/18.
//  Copyright © 2018 Alexis DARNAT. All rights reserved.
//

import UIKit
import CoreData

// Comment the Code
@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    @objc private let authController = AuthController()
    private let dataController = DataController()
    private lazy var networkController : NetworkController = {
        return NetworkController(container: self.dataController.persistentContainer)
    }()
    private var kAuthentificationObserver = "kAuthentificationObserver"


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
//        networkController.mainContext = dataController.persistentContainer.viewContext // Refactoring -> Deleted
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.rootViewController = self.getRootViewControllerDepending(On: authController.authenticated)
        // Override point for customization after application launch.
        addObserver(self, forKeyPath: #keyPath(authController.authenticated), options: [.old, .new], context: &kAuthentificationObserver)
        NotificationCenter.default.addObserver(self, selector: #selector(handleErrors(notification:)), name: Notification.Name.Network.didCompleteWithError, object: nil)
        return true
    }
    
    // Observe Value changes, track if the user logged In or Logged Out
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if context != &kAuthentificationObserver {
            return super.observeValue(forKeyPath: keyPath, of: object, change: change, context: context)
        }
        if let change = change,
            let oldValue = change[.oldKey] as? Bool,
            let newValue = change[.newKey] as? Bool,
            oldValue != newValue {
            DispatchQueue.main.async {
                self.window?.rootViewController = self.getRootViewControllerDepending(On: newValue)
            }
        }
    }
    
    // Return the proper ViewController Depending on if the user is Logged In or Not
    private func getRootViewControllerDepending(On loggedIn: Bool) -> UIViewController {
        if loggedIn {
            return HomeNavigationController(rootViewController: HomeViewController(networkController: networkController, authController: authController))
        }
        return LoginController(networkController: networkController, authController: authController)
    }
    
    @objc func handleErrors(notification: Notification) {
        guard let userInfo = notification.userInfo, let error = userInfo["error"] as? NetworkError else { return }
        if error.code == 401 {
            self.authController.unAuth()
        }
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
//        dataController.saveContext()
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        dataController.saveContext()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        dataController.saveContext()
    }
}

