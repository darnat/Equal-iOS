//
//  EventSaveRequest.swift
//  Equal
//
//  Created by Alexis DARNAT on 4/17/18.
//  Copyright © 2018 Alexis DARNAT. All rights reserved.
//

import CoreData

class EventSaveRequest: BaseGraphQLRequest<EventRequestModel> {
    private var event: Event!
//    private var innerContext: NSManagedObjectContext
    
    init(container: NSPersistentContainer, authController: AuthController, objectID: NSManagedObjectID) {
//        self.innerContext = container.newBackgroundContext()
        super.init(container: container, authController: authController)
        guard let event = self.persistentContainer.viewContext.object(with: objectID) as? Event else {  fatalError("Must have a valid Event") }
        self.event = event
//        self.innerContext.performAndWait {
//            guard let event = self.innerContext.object(with: objectID) as? Event else { fatalError("Must have a valid Event") }
//            self.event = event
//        }
    }
    
    override func configureRequest(request: GraphQLRequest) {
        let jsonData = try? JSONEncoder().encode(self.event)
        let jsonFormated = NSString(data: jsonData!, encoding: String.Encoding.utf8.rawValue)! as String
        request.setVariables(variables: jsonFormated, variablesDeclaration: "$title: String!, $body: String = \"\", $id: Int, $guid: String!, $currencyId: Int!")
        request.setMutation(mutation: "event : upsertEvent(event: {id: $id, title: $title, body: $body, currency_id: $currencyId, guid: $guid}) { id title body created_at updated_at join_token guid deleted currency { id fullname symbol abreviation } participants { id nickname balance updated_at owner user { id name image } } }")
    }
//    var networkController : NetworkController?
//    private let context : NSManagedObjectContext
//    private let authController : AuthController
//    private let innerContext: NSManagedObjectContext // Nouveauté CoreData Codable
//    private let event: Event
//
//    private struct dataRequestDecodable : Decodable {
//        let data: EventRequestModel
//    }
//
//    init(context: NSManagedObjectContext, authController: AuthController, objectID: NSManagedObjectID) {
//        self.context = context
//        self.authController = authController
//        self.innerContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
//        self.innerContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
//        self.innerContext.parent = context
//        self.event = self.innerContext.object(with: objectID) as! Event
//        super.init()
//    }
//
//    override func start() {
//        super.start()
//
//        guard let headers = self.authController.getAuthHeaders() else {
//            self.isFinished = true
//            return
//        }
//
//        let graphQLRequest = GraphQLRequest()
//        graphQLRequest.addHeaders(headers: headers)
//        let jsonData = try? JSONEncoder().encode(self.event)
//        let jsonFormated = NSString(data: jsonData!, encoding: String.Encoding.utf8.rawValue)! as String
////        let id = event.id != nil ? "id: " + String(event.id!) + "," : ""
////        let title = "title: \"" + event.title + "\","
////        let desc = event.description != nil ? "body: \"" + event.description! + "\"," : ""
////        let currency_id = "currency_id: " + String(event.currency_id) + ""
//        graphQLRequest.setVariables(variables: jsonFormated, variablesDeclaration: "$title: String!, $body: String = \"\", $id: Int, $guid: String!")
//        graphQLRequest.setMutation(mutation: "event : upsertEvent(event: {id: $id, title: $title, body: $body, currency_id: 1, guid: $guid}) { id title body created_at updated_at join_token guid deleted currency { id fullname symbol abreviation } participants { id nickname balance updated_at } }")
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
//            } catch {
//                print("Error: ", error)
//            }
//        }
//        self.save()
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
