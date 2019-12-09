//
//  FetchImageOperation.swift
//  Random Users
//
//  Created by Brandi on 12/8/19.
//  Copyright © 2019 Erica Sadun. All rights reserved.
//

import Foundation
import UIKit

class FetchImageOperation: ConcurrentOperation {
    
    var user: User
    private(set) var imageData: Data?
    private let session: URLSession
    private var dataTask: URLSessionDataTask?
    
    init(user: User, session: URLSession = URLSession.shared) {
        self.user = user
        self.session = session
        super.init()
    }
    
    override func start() {
        
        state = .isExecuting
        
        let imageURL = user.image
        let task = session.dataTask(with: imageURL) { (data, _, error) in
            defer { self.state = .isFinished }
            if self.isCancelled { return }
            if error != nil {
                print("There was an error in \(#function), on line \(#line), in \(#file).")
            }
            
            guard let data = data else { return }
            self.imageData = data
        }
        task.resume()
        dataTask = task
    }
    
    override func cancel() {
        dataTask?.cancel()
        super.cancel()
    }
}
