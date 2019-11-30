//
//  ReserveListRequest.swift
//  ColturViajes
//
//  Created by roni shender on 11/24/19.
//  Copyright © 2019 ENFASYS Consultores e Ingenieros. All rights reserved.
//

import Foundation

class MostPopularMovieRestWebServiceRequest: RestWebServiceRequest {
    
    let path: String = "/movies/popular"
    let method: RestWebServiceRequestMethod = .GET
    
    var page: Int
    var query: String = ""
    
    private let limit: Int
    
    var queryString: [String : String]? {
        
        if self.query.count > 0 {
            
            return ["page": self.page.description,
                    "limit": self.limit.description,
                    "query": self.query]
        }
        else {
         
            return ["page": self.page.description,
                    "limit": self.limit.description]
        }
    }
    
    internal init(page: Int, limit: Int = 10, query: String = "") {
        
        self.page = page
        self.limit = limit
        self.query = query
    }
}

class MostPopularMovieRequest: NSObject {
    
    internal init(page: Int,  limit: Int = 10, query: String = "") {
        
        self.page = page
        self.limit = limit
        self.query = query
    }
    
    var query: String {
        
        willSet(myNewValue) {
            
            self.request.query = myNewValue
        }
    }
    
    var page: Int {
        
        willSet(myNewValue) {
            
            self.request.page = myNewValue
        }
    }
    
    let limit: Int
    
    lazy var request = {
       
        return MostPopularMovieRestWebServiceRequest(page: self.page, limit: self.limit, query: self.query)
    }()
}
