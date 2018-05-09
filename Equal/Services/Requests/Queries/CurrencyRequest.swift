//
//  CurrencyRequest.swift
//  Equal
//
//  Created by Alexis DARNAT on 4/17/18.
//  Copyright © 2018 Alexis DARNAT. All rights reserved.
//

import CoreData

class CurrencyRequest: BaseGraphQLRequest<CurrencyRequestModel> {
    private var pattern : String?
    
    override func configureRequest(request: GraphQLRequest) {
        var pattern = ""
        if let patternC = self.pattern {
            pattern = "(pattern: \"" + patternC + "\")"
        }
        request.addQuery(query: "currencies" + pattern + " { id fullname abreviation symbol }")
    }
    
    init(container: NSPersistentContainer, authController: AuthController, pattern: String? = nil) {
        super.init(container: container, authController: authController)
        self.pattern = pattern
    }
    
    
//    var networkController : NetworkController?
//    private var context : NSManagedObjectContext!
//    private var authController : AuthController!
//    private var pattern : String?
//
//    private struct dataRequestDecodable : Decodable {
//        let data: CurrencyRequestDecodable
//    }
//
//    private struct CurrencyRequestDecodable : Decodable {
//        let currencies: [CurrencyCodable]
//    }
//
//    init(context: NSManagedObjectContext, authController: AuthController, pattern: String? = nil) {
//        super.init()
//        self.context = context
//        self.authController = authController
//        self.pattern = pattern
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
//        var pattern = ""
//
//        if let patternC = self.pattern {
//            pattern = "(pattern: \"" + patternC + "\")"
//        }
//        let graphQLRequest = GraphQLRequest()
//        graphQLRequest.addHeaders(headers: headers)
//        graphQLRequest.addQuery(query: "currencies" + pattern + " { id fullname abreviation symbol }")
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
//        let currencyRequest = try decoder.decode(dataRequestDecodable.self, from: self.incomingData as Data)
//
//        self.didCompleteWithError?(nil)
//    }
}
