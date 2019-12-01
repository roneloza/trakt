//
//  RestWebServiceRequest.swift
//  ColturViajes
//
//  Created by roni shender on 11/10/19.
//  Copyright © 2019 ENFASYS Consultores e Ingenieros. All rights reserved.
//

import UIKit

enum RestWebServiceRequestMethod: String {
    
    case GET = "GET"
    case POST = "POST"
    case PUT = "PUT"
    case PATCH = "PATCH"
    case DELETE = "DELETE"
}

enum RestWebServiceRequestContentType: String {
    
    case formdata = "multipart/form-data"
    case urlencoded = "application/x-www-form-urlencoded"
    case json = "application/json"
}


protocol RestWebServiceRequest: class {

    var path: String { get }
    var url: URL? { get }
    var baseUrl: URL? { get }
    var method: RestWebServiceRequestMethod { get }
    var parameters: [String: Codable]? { get }
    var headers: [String: String]? { get }
    var authorization: [String: String]? { get }
    var contentType: RestWebServiceRequestContentType { get }
    var queryString: [String: String]? { get }
}

extension RestWebServiceRequest {
    
    private var userDataStore: AppUserDataStore {
        
        get {
            return AppUserDataStandarDefaults()
        }
    }
    
    var method: RestWebServiceRequestMethod { get { return .GET } }
    
    var contentType: RestWebServiceRequestContentType { get { return .json } }
    
    var path: String { get { return "" } }
    
    var baseUrl: URL? { return URL(string: AppSettingsBuilder.shared.settings.baseURL) }
    
    var url: URL? { return URL(string: self.path, relativeTo: self.baseUrl) }
    
    var parameters: [String: Codable]? { get { return nil } }
    
    var headers: [String: String]? { get { return nil } }
    
    var authorization: [String : String]? {

        get {

            return ["trakt-api-version": "2",
                    "trakt-api-key": "15f97ca740262a437c80d08526f32084aca986fcddbeee99c6c4957ce9fa4947"]
        }
    }
    
//    var authorization: [String : String]? { get { return nil } }
    
    var queryString: [String: String]? { get { return nil } }
}
