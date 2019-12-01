//
//  NetworkTask.swift
//  trakt
//
//  Created by roni shender on 11/30/19.
//  Copyright © 2019 Technious. All rights reserved.
//

import UIKit

protocol NetworkTask: class {
    
    var taskIdentifier: Int { set get }
    func cancel()
}

class NativeNetworkTask: NetworkTask {
    
    var taskIdentifier: Int = 0
    
    private var task: URLSessionTask?
    private var cancelled = false
    private let queue = DispatchQueue(label: "com.trakt.NetworkTask", qos: .utility)
    
    func cancel() {
        queue.sync {
            cancelled = true
            // If we already have a task cancel it
            if let task = task {
                task.cancel()
            }
        }
    }
    
    func set(_ task: URLSessionTask) {
        queue.sync {
            self.task = task
            self.taskIdentifier = task.taskIdentifier
            // If we've cancelled the request before the task was set, let's cancel now
            if cancelled {
                task.cancel()
            }
        }
    }
}
