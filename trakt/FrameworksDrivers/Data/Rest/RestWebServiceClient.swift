//
//  RestWebService.swift
//  ColturViajes
//
//  Created by roni shender on 11/10/19.
//  Copyright © 2019 ENFASYS Consultores e Ingenieros. All rights reserved.
//

import Foundation

typealias ServiceIdentifier = Int

protocol RestWebServiceClient: class {
    
    func get(request: RestWebServiceRequest, completion: @escaping (Result<Data?, CustomError>) -> Void) -> NetworkTask
    
    func post(request: RestWebServiceRequest, completion: @escaping (Result<Data?, CustomError>) -> Void) -> NetworkTask
    
    func put(request: RestWebServiceRequest, completion: @escaping (Result<Data?, CustomError>) -> Void) -> NetworkTask
    
    func patch(request: RestWebServiceRequest, completion: @escaping (Result<Data?, CustomError>) -> Void) -> NetworkTask
    
    func cancel(task: NetworkTask)
    
    func appendNetworkTask(element: NetworkTask)
    
    var allNetworkTask: [NetworkTask] { get }
    
    var lastNetworkTask: NetworkTask? { get }
}
