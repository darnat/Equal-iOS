//
//  LoginRequest.swift
//  Equal
//
//  Created by Alexis DARNAT on 3/31/18.
//  Copyright © 2018 Alexis DARNAT. All rights reserved.
//

import Foundation
import CoreData

// Comment the code
class LoginRequest: NetworkRequest {
    var authController : AuthController?
    
    private var email : String!
    private var password : String!

    init(credentials: (String, String)) {
        super.init()
        let (email, password) = credentials
        self.email = email
        self.password = password
        self.acceptableStatusCode = [401]
    }
    
    override func start() {
        super.start()
        
        let json = try! JSONSerialization.data(withJSONObject: ["email": self.email, "password": self.password], options: [])
        guard let url = URL(string: Config.baseURLPath + "/auth/sign_in") else { fatalError("Failed to build URL") }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.httpBody = json
        self.task = self.localURLSession.dataTask(with: request)
        self.task?.resume()
    }
    
    override func processData() throws {
        try super.processData()
        guard let headers = task?.response?.value(forKey: "allHeaderFields") as? [String: String] else { fatalError("Unable to get the headers") }
        guard let uid = headers["uid"], let client = headers["client"], let accessToken = headers["access-token"] else { fatalError("Unable get header values") }
        self.authController?.setAuth(With: uid, client: client, accessToken: accessToken)
    }
    
    override func computeDataToNotification() -> [String : Any]? {
        var userDefault : [String: Any]? = nil
        do {
            let errors = try JSONDecoder().decode(ErrorsJSON.self, from: self.incomingData as Data)
            userDefault = ["errors": errors.errors]
        } catch let jsonErr {
            print(jsonErr)
        }
        return userDefault
    }
}
