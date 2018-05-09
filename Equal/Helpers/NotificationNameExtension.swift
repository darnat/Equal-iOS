//
//  NotificationNameExtension.swift
//  Equal
//
//  Created by Alexis DARNAT on 3/31/18.
//  Copyright © 2018 Alexis DARNAT. All rights reserved.
//

import Foundation

// Comment the Code
extension Notification.Name {
    static let networkError = Notification.Name("networkError")
    static let didReceiveLoginResponse = Notification.Name("didReceiveLoginResponse")
    
    public struct Network {
        public static let didCompleteWithError = Notification.Name("io.equal.notification.network.didCompleteWithError")
    }
}
