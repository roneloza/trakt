//
//  RestWebServiceAlamofireClient.swift
//  ColturViajes
//
//  Created by roni shender on 11/10/19.
//  Copyright © 2019 ENFASYS Consultores e Ingenieros. All rights reserved.
//

import UIKit
//import Alamofire

class RestWebServiceNativeClient: RestWebServiceClient {
    
    private func REQUEST(request: RestWebServiceRequest, completion: @escaping (Result<Data?, CustomError>) -> Void) {
        
        guard let url = request.url,
        var urlComps = URLComponents(string: url.absoluteString)
            else { return completion(.failure(RestWebServiceError(title: "RestWebServiceError", message: "", code: RestWebServiceStatusCode.malformedUrl.rawValue)))}
        
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
        
        URLSession.shared.dataTask(with: urlRequest) { (data, response, error) in
            
            let httpResponse = (response as! HTTPURLResponse)
            
            if (RestWebServiceStatusCode.ok.rawValue ..< RestWebServiceStatusCode.multipleChoices.rawValue) ~= httpResponse.statusCode {
                
                completion(.success(data))
            }
            else {
                
                completion(.failure(RestWebServiceError(title: "RestWebServiceError", message: error?.localizedDescription, code: httpResponse.statusCode, data: data)))
            }
            }.resume()
    }
    
    func GET(request: RestWebServiceRequest, completion: @escaping (Result<Data?, CustomError>) -> Void) {
        
        self.REQUEST(request: request, completion: completion)
    }
    
    func POST(request: RestWebServiceRequest, completion: @escaping (Result<Data?, CustomError>) -> Void) {
        
        self.REQUEST(request: request, completion: completion)
    }
    
    func PUT(request: RestWebServiceRequest, completion: @escaping (Result<Data?, CustomError>) -> Void) {
        
        self.REQUEST(request: request, completion: completion)
    }
    
    func PATCH(request: RestWebServiceRequest, completion: @escaping (Result<Data?, CustomError>) -> Void) {
        
        self.REQUEST(request: request, completion: completion)
    }
    
}
