//
//  GraphQLRequest.swift
//  Equal
//
//  Created by Alexis DARNAT on 4/15/18.
//  Copyright © 2018 Alexis DARNAT. All rights reserved.
//

import UIKit

class GraphQLRequest: NSObject {
    
//    private struct queryComponent<T: Decodable> {
//        let queryKey : String
//        let queryParams : String
//        let queryType : T.Type
//        let response : (T) -> Void
//    } // Test
    
    private var request : URLRequest
//    private var complexQueries = [queryComponent]() // Test
    private var queries = [String]()
    private var mutation : String?
    private var variablesDeclaration : String?
    private var variables: String?
    
    override init() {
        guard let url = URL(string: Config.baseURLPath + Config.graphQLPath) else { fatalError("Failed to build URL") }
        self.request = URLRequest(url: url)
        super.init()
        self.request.httpMethod = "POST"
        self.request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        self.request.addValue("application/json", forHTTPHeaderField: "Accept")
    }
    
    func addHeaders(headers: [String: String]) {
        for (headerKey, headerName) in headers {
            self.request.addValue(headerName, forHTTPHeaderField: headerKey)
        }
    }
    
    func addQuery(query: String) {
        self.queries.append(query)
    }
    
    func setMutation(mutation: String) {
        self.mutation = mutation
    }
    
    func setVariables(variables: String, variablesDeclaration: String) {
        self.variables = variables
        self.variablesDeclaration = variablesDeclaration
    }
//    func addQuery<T: Decodable>(withKey key: String, params: String, type: T.Type, complete: @escaping (Decodable) -> Void) {
//        let query = queryComponent(queryKey: key, queryParams: params, queryType: type, response: complete)
//        self.complexQueries.append(query)
//    } // Test
    
    func compute() -> URLRequest {
        var queryString = ""
        if let mutation = self.mutation {
            let declaration = self.variablesDeclaration != nil ? "(" + self.variablesDeclaration! + ")" : ""
            queryString = "mutation"+declaration+" { " + mutation + " }"
        } else {
            queryString += "{ "
            for query in self.queries {
                queryString += " " + query
            }
            queryString += " }"
        }
        
        let json = try! JSONSerialization.data(withJSONObject: ["query": queryString, "variables": self.variables ?? ""], options: [])
        self.request.httpBody = json
        return self.request
    }
    
//    func compute(data: Data) throws {
//        let decoder = JSONDecoder()
//        decoder.keyDecodingStrategy = .convertFromSnakeCase
//        decoder.dateDecodingStrategy = .iso8601
//        guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] else { fatalError("impossible to parse the JSON") }
//        guard let data = json["data"] as? [String: Any] else {
//            print("problem")
//            return
//        }
//        for query in self.complexQueries {
//            if let result = data[query.queryKey] as? Data {
//                let modelDecoded = decoder.decode(query.queryType as! Decodable.Type, from: result)
//                query.response(modelDecoded)
//            }
//        }
//    } // Test

}
