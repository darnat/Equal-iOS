//
//  AuthController.swift
//  Equal
//
//  Created by Alexis DARNAT on 4/2/18.
//  Copyright © 2018 Alexis DARNAT. All rights reserved.
//

import UIKit
import KeychainSwift

// Comment the Code
class AuthController: NSObject {
    private struct keys {
        static let uidKey = "uid"
        static let clientKey = "client"
        static let accessTokenKey = "access-token"
    }
    
    @objc private(set) var authenticated : Bool = false
    
    private struct Auth {
        var uid : String
        var client : String
        var accessToken : String
    }
    
    private var auth : Auth?
    
    override init() {
        super.init()
        if let auth = self.getAuthKeychain() {
            self.setAuth(auth: auth)
        }
    }
    
    public func setAuth(With uid: String, client: String, accessToken: String) {
        let keychain = KeychainSwift()
        keychain.set(uid, forKey: keys.uidKey)
        keychain.set(client, forKey: keys.clientKey)
        keychain.set(accessToken, forKey: keys.accessTokenKey)
        self.setAuth(auth: Auth(uid: uid, client: client, accessToken: accessToken))
    }
    
    public func unAuth() {
        self.setAuth(auth: nil)
        self.removeKeyChain()
    }
    
    public func getAuthHeaders() -> [String: String]? {
        guard let auth = self.auth else { return nil }
        return [
            keys.uidKey: auth.uid,
            keys.clientKey: auth.client,
            keys.accessTokenKey: auth.accessToken
        ]
    }
    
    private func setAuth(auth: Auth?) {
        self.auth = auth
        self.setValue(auth != nil, forKey: "authenticated")
    }
    
    private func getAuthKeychain() -> Auth? {
        let keychain = KeychainSwift()
        if let uid = keychain.get(keys.uidKey),
            let client = keychain.get(keys.clientKey),
            let accessToken = keychain.get(keys.accessTokenKey) {
            return Auth(uid: uid, client: client, accessToken: accessToken)
        }
        return nil
    }
    
    private func removeKeyChain() {
        let keychain = KeychainSwift()
        keychain.delete(keys.uidKey)
        keychain.delete(keys.clientKey)
        keychain.delete(keys.accessTokenKey)
    }
}
