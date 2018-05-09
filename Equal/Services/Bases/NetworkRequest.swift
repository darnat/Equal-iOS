//
//  NetworkRequest.swift
//  Equal
//
//  Created by Alexis DARNAT on 3/31/18.
//  Copyright © 2018 Alexis DARNAT. All rights reserved.
//

import Foundation

// Comment the Code + Refactoring needed
class NetworkRequest: OperationRequest, URLSessionDataDelegate {
    var error: Error?
    var startTimeInterval: TimeInterval?
    var operationRuntime: TimeInterval?
    var didCompleteWithError : ((Error?) -> Void)?
    
    internal var task: URLSessionTask?
    internal var incomingData = NSMutableData()
    
    internal var localConfig : URLSessionConfiguration {
        return URLSessionConfiguration.default
    }
    internal var localURLSession: URLSession {
        return URLSession(configuration: localConfig, delegate: self, delegateQueue: nil)
    }
    
    internal var acceptableStatusCode : [Int] = []
    internal var successStatusCode = [200]
    
    override func start() {
        super.start()
        startTimeInterval = NSDate.timeIntervalSinceReferenceDate
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive response: URLResponse, completionHandler: @escaping (URLSession.ResponseDisposition) -> Void) {
        if isCancelled {
            isFinished = true
            self.task?.cancel()
            return
        }
        // Check Response code
        guard let statusCode = response.value(forKey: "statusCode") as? Int else { fatalError("impossible to get the statusCode") }
        if successStatusCode.contains(statusCode) || acceptableStatusCode.contains(statusCode) {
            completionHandler(.allow)
        } else {
            let error = NetworkError.computeError(with: statusCode, errors: nil)
            NotificationCenter.default.post(name: Notification.Name.Network.didCompleteWithError, object: self, userInfo: ["error": error])
            self.didCompleteWithError?(error)
            completionHandler(.cancel)
        }
    }
    
    func urlSession(_ session: URLSession, dataTask: URLSessionDataTask, didReceive data: Data) {
        if isCancelled {
            isFinished = true
            self.task?.cancel()
            return
        }
        incomingData.append(data)
    }
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        if isCancelled {
            isFinished = true
            self.task?.cancel()
            return
        }
        if let error = error as NSError? {
            self.error = error
            if error.code != NSURLErrorCancelled {
                print("Network Error: \(error)")
                NotificationCenter.default.post(name: Notification.Name.Network.didCompleteWithError, object: self, userInfo: ["error": error])
                self.didCompleteWithError?(error)
            }
            isFinished = true
            return
        }
        
        guard let statusCode = task.response?.value(forKey: "statusCode") as? Int else { fatalError("impossible to get the statusCode") }
        if acceptableStatusCode.contains(statusCode) {
            let error = NetworkError.computeError(with: statusCode, errors: computeDataToNotification())
            NotificationCenter.default.post(name: Notification.Name.Network.didCompleteWithError, object: self, userInfo: ["error": error])
            self.didCompleteWithError?(error)
            isFinished = true
            return
        }
        
        
        do {
           try processData()
        } catch {
            print("Error processing data: \(error)")
            self.didCompleteWithError?(error)
        }
        isFinished = true
        let end = NSDate.timeIntervalSinceReferenceDate
        if let startTimeInterval = startTimeInterval {
            self.operationRuntime = end - startTimeInterval
        }
    }
    
    func computeDataToNotification() -> [String: Any]? { return nil }
    
    func processData() throws {
        if incomingData.length == 0 {
            print("No data received")
            return
        }
    }
    
}
