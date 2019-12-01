//
//  MovieVideoRequest.swift
//  trakt
//
//  Created by roni shender on 11/30/19.
//  Copyright © 2019 Technious. All rights reserved.
//

import UIKit

class MovieVideoRestWebServiceRequest: RestWebServiceRequest {
    
    let baseUrl: URL? = URL(string: "https://api.themoviedb.org")
    
    var  path: String {
        
        return "/3/movie/\(self.movieId)/videos"
    }
    
    var queryString: [String : String]? {
        
        return ["api_key": "39b1e0b797714dc728457343c5b3e401",
                "language": "en-US"]
    }
    
    internal init(movieId: Int) {
        
        self.movieId = movieId
    }
    
    let movieId: Int
}

class MovieVideoRequest: NSObject {
    
    let movieId: Int
    
    internal init(movieId: Int) {
        
        self.movieId = movieId
    }
    
    lazy var request = {
        
        return MovieVideoRestWebServiceRequest(movieId: self.movieId)
    }()
}
