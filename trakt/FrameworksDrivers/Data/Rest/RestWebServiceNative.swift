//
//  RestWebServiceAlamofireClient.swift
//  ColturViajes
//
//  Created by roni shender on 11/10/19.
//  Copyright © 2019 ENFASYS Consultores e Ingenieros. All rights reserved.
//

import UIKit
//import Alamofire

extension RestWebServiceNativeClient: URLSessionTaskDelegate {
    
    func urlSession(_ session: URLSession, task: URLSessionTask, didCompleteWithError error: Error?) {
        
        if let error = error {
            
            NSLog("error : \(error)")
        }
    }
}

class RestWebServiceNativeClient: NSObject {
    
    private let concurrenQueue = DispatchQueue(label: "com.trakt.RestWebServiceNativeClient", qos: .utility, attributes: .concurrent)
    
    private lazy var session: URLSession = {
        
        return URLSession(configuration: .default, delegate: self, delegateQueue: nil)
    }()
    
    private var networkTasks: [NetworkTask] = []
    
    func appendNetworkTask(element: NetworkTask) {
        
        self.concurrenQueue.async(flags: .barrier) {
           
            self.networkTasks.append(element)
        }
    }
    
    var allNetworkTask: [NetworkTask] {
        
        var result = [NetworkTask]()
        
        self.concurrenQueue.sync {
            
            result = self.networkTasks
        }
        
        return result
    }
    
    var lastNetworkTask: NetworkTask? {
        
        var result: NetworkTask?
        
        self.concurrenQueue.sync {
            
            result = self.networkTasks.last
        }
        
        return result
    }
    
    deinit {
        
        self.networkTasks.removeAll()
    }
}

extension RestWebServiceNativeClient: RestWebServiceClient {
    
    func cancel(task: NetworkTask) {
        
        task.cancel()
    }
    
    private func REQUEST(request: RestWebServiceRequest, completion: @escaping (Result<Data?, CustomError>) -> Void) -> NetworkTask {
        
        let backgroundTaskID = UIApplication.shared.beginBackgroundTask(expirationHandler: nil)
        
        let networkTask = NativeNetworkTask()
        
        //        self.queue.async {
        
        if let url = request.url,
            var urlComps = URLComponents(string: url.absoluteString) {
            
            var queryItems: [URLQueryItem] = [URLQueryItem]()
            
            request.queryString?.forEach({ (keyValue) in
                
                queryItems.append(URLQueryItem(name: keyValue.key, value: keyValue.value))
            })
            
            urlComps.queryItems = queryItems
            
            var urlRequest = URLRequest(url: urlComps.url!)
            
            urlRequest.httpMethod = request.method.rawValue
            
            switch request.contentType {
            case .json:
                
                urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
                urlRequest.setValue("application/json", forHTTPHeaderField: "Accept")
                
            default:
                ()
            }
            
            request.headers?.forEach({ (keyValue) in
                
                urlRequest.setValue(keyValue.value, forHTTPHeaderField: keyValue.key)
            })
            
            request.authorization?.forEach({ (keyValue) in
                
                urlRequest.setValue(keyValue.value, forHTTPHeaderField: keyValue.key)
            })
            
            if let parameters = request.parameters {
                
                urlRequest.httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
            }
            
            NSLog("\(urlRequest)")
            
            let task: URLSessionDataTask = self.session.dataTask(with: urlRequest) { (data, response, error) in
                
                let result: Result<Data?, CustomError>
                
                if let httpResponse = (response as? HTTPURLResponse) {
                 
                    if (RestWebServiceStatusCode.ok.rawValue ..< RestWebServiceStatusCode.multipleChoices.rawValue) ~= httpResponse.statusCode {
                        
                        result = .success(data)
                    }
                    else {
                        
                        result = .failure(RestWebServiceError(title: "RestWebServiceError", message: error?.localizedDescription, code: httpResponse.statusCode, data: data))
                    }
                }
                else {
                  
                    if let error = error as NSError? {
                     
                        result = .failure(RestWebServiceError(title: "RestWebServiceError", message: error.localizedDescription, code: error.code, data: data))
                    }
                    else {
                        
                        result = .failure(RestWebServiceError(title: "RestWebServiceError", message: error?.localizedDescription, code: CustomErrorEnum.responseIsEmpty.rawValue, data: data))
                    }
                }
                
                completion(result)
                
                UIApplication.shared.endBackgroundTask(backgroundTaskID)
            }
            
            task.resume()
            
            networkTask.set(task)
        }
        else {
            
            completion(.failure(RestWebServiceError(title: "RestWebServiceError", message: "", code: RestWebServiceStatusCode.malformedUrl.rawValue)))
            
            UIApplication.shared.endBackgroundTask(backgroundTaskID)
        }
        
        //        }
        
        self.appendNetworkTask(element: networkTask)
        
        return networkTask
    }
    
    func get(request: RestWebServiceRequest, completion: @escaping (Result<Data?, CustomError>) -> Void) -> NetworkTask {
        
        return self.REQUEST(request: request, completion: completion)
    }
    
    func post(request: RestWebServiceRequest, completion: @escaping (Result<Data?, CustomError>) -> Void) -> NetworkTask {
        
        return self.REQUEST(request: request, completion: completion)
    }
    
    func put(request: RestWebServiceRequest, completion: @escaping (Result<Data?, CustomError>) -> Void) -> NetworkTask {
        
        return self.REQUEST(request: request, completion: completion)
    }
    
    func patch(request: RestWebServiceRequest, completion: @escaping (Result<Data?, CustomError>) -> Void) -> NetworkTask {
        
        return self.REQUEST(request: request, completion: completion)
    }
}
