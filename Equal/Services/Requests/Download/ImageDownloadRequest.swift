//
//  ImageDownloadRequest.swift
//  Equal
//
//  Created by Alexis DARNAT on 5/7/18.
//  Copyright © 2018 Alexis DARNAT. All rights reserved.
//

import Foundation
import UIKit

class ImageDownloadRequest: NetworkRequest {
    private let imageUrl: String
    var didComplete : ((Data) -> Void)?
    
    init(url: String) {
        self.imageUrl = url
        super.init()
    }
    
    override func start() {
        super.start()
        
        guard let url = URL(string: self.imageUrl) else { fatalError("Failed to build URL") }
        let request = URLRequest(url: url)
        self.task = self.localURLSession.dataTask(with: request)
        self.task?.resume()
    }
    
    override func processData() throws {
        try super.processData()
        
        self.didComplete?(self.incomingData as Data)
    }
    
}
