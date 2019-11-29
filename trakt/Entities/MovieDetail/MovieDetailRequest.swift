//
//  MovieDetailRequest.swift
//  trakt
//
//  Created by Lab Positiva Dev on 11/28/19.
//  Copyright © 2019 Technious. All rights reserved.
//

import UIKit

class MovieDetailRestWebServiceRequest: RestWebServiceRequest {
    
//    https://api.themoviedb.org/3/movie/259316?api_key=39b1e0b797714dc728457343c5b3e401&language=en-US

    let baseUrl: URL? = URL(string: "https://api.themoviedb.org/3/movie/")
    
    var  path: String {
        
        return "\(self.movieId)"
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

class MovieDetailRequest: NSObject {
    
    let movieId: Int
    
    internal init(movieId: Int) {
        
        self.movieId = movieId
    }
    
    lazy var request = {
        
        return MovieDetailRestWebServiceRequest(movieId: self.movieId)
    }()
}
