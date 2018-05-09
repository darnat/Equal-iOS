//
//  EqualRequest.swift
//  Equal
//
//  Created by Alexis DARNAT on 4/6/18.
//  Copyright © 2018 Alexis DARNAT. All rights reserved.
//

import CoreData

// Comment Code
class EqualRequest: BaseGraphQLRequest<EqualRequestModel> {
    var networkController : NetworkController?
    
    override func configureRequest(request: GraphQLRequest) {
        request.addQuery(query: "events { id title body created_at updated_at join_token guid deleted participants { id nickname balance updated_at owner user { id name image } } currency { id fullname symbol abreviation } }")
    }
    
//    private var context : NSManagedObjectContext!
//    private var authController : AuthController!
//    private var innerContext: NSManagedObjectContext! // Nouveauté CoreData Codable
//
//    private struct dataRequestDecodable : Decodable {
//        let data: EqualRequestModel
//    }
//
//    init(context: NSManagedObjectContext, authController: AuthController) {
//        super.init()
//        self.context = context
//        self.authController = authController
//        self.innerContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType) // Nouveauté CoreData Codable
//        self.innerContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy // Nouveauté CoreData Codable
//        self.innerContext.parent = context // Nouveauté CoreData Codable
//    }
//
//    override func start() {
//        super.start()
//
//        guard let headers = self.authController.getAuthHeaders() else {
//            self.isFinished = true
//            return
//        }
//        let graphQLRequest = GraphQLRequest()
//        graphQLRequest.addHeaders(headers: headers)
//        graphQLRequest.addQuery(query: "events { id title body created_at updated_at join_token deleted participants { id nickname balance updated_at } }")
//
//        self.task = self.localURLSession.dataTask(with: graphQLRequest.compute())
//        self.task?.resume()
//    }
//
//    override func processData() throws {
//        try super.processData()
//        let decoder = JSONDecoder()
//        decoder.keyDecodingStrategy = .convertFromSnakeCase
//        decoder.dateDecodingStrategy = .iso8601
//
//        self.innerContext.asDecodingContext {
//            do {
//                _ = try decoder.decode(dataRequestDecodable.self, from: self.incomingData as Data)
//                self.save()
//            } catch {
//                print("Error: ", error)
//            }
//        }
//
//        self.didCompleteWithError?(nil)
//    }
//
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
