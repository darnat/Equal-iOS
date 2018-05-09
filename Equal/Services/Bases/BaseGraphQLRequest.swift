//
//  GraphQLRequest.swift
//  Equal
//
//  Created by Alexis DARNAT on 4/23/18.
//  Copyright © 2018 Alexis DARNAT. All rights reserved.
//

import CoreData

class BaseGraphQLRequest<T: BaseRequestModel>: NetworkRequest {
    private var graphQlRequest : GraphQLRequest!
    internal var persistentContainer: NSPersistentContainer!
    private var authController : AuthController!
    
    private struct dataRequestDecodable : Decodable {
        let data: T
    }
    
    init(container: NSPersistentContainer, authController: AuthController) {
        super.init()
        self.persistentContainer = container
        self.authController = authController
        self.graphQlRequest = GraphQLRequest()
    }
    
    override func start() {
        super.start()
        
        guard let headers = self.authController.getAuthHeaders() else {
            self.isFinished = true
            return
        }
        self.graphQlRequest.addHeaders(headers: headers)
        self.configureRequest(request: self.graphQlRequest)
        
        self.task = self.localURLSession.dataTask(with: self.graphQlRequest.compute())
        self.task?.resume()
    }
    
    func configureRequest(request: GraphQLRequest) {
        fatalError("Need to be override")
    }
    
    override func processData() throws {
        try super.processData()
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        decoder.dateDecodingStrategy = .iso8601
        
        self.persistentContainer.performBackgroundTask { (context) in
    
            decoder.userInfo[CodingUserInfoKey.context] = context

            do {
                _ = try decoder.decode(dataRequestDecodable.self, from: self.incomingData as Data)

                try context.save()
            } catch {
                fatalError("Failure to save context: \(error)")
            }
        }
        
//        self.innerContext.asDecodingContext {
//            do {
//                _ = try decoder.decode(dataRequestDecodable.self, from: self.incomingData as Data)
//                self.save()
//            } catch {
//                print("Error: ", error)
//            }
//        }
        
        self.didCompleteWithError?(nil)
    }
    
//    private func save() {
//        self.innerContext.performAndWait {
//            do {
//                try self.innerContext.save()
//            } catch {
//                fatalError("Failed to save child context: \(error)")
//            }
//        }
//    }
    
}
