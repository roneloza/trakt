//
//  MovieVideoResponse.swift
//  trakt
//
//  Created by roni shender on 11/30/19.
//  Copyright © 2019 Technious. All rights reserved.
//

import UIKit

//{
//    "id": 293660,
//    "results": [
//    {
//    "id": "5bac8f44c3a3683a9c0388c3",
//    "iso_639_1": "en",
//    "iso_3166_1": "US",
//    "key": "FyKWUTwSYAs",
//    "name": "Deadpool | Red Band Trailer [HD] | 20th Century FOX",
//    "site": "YouTube",
//    "size": 1080,
//    "type": "Trailer"
//    }

class MovieVideoResponse: CodableObject {

    let id: Int?
    let results: [MovieVideoResponseResult]?
    
    enum CodingKeys: String, CodingKey {
        
        case id,
        results
    }
}

class MovieVideoResponseResult: CodableObject {
    
    let id: String?
    let key: String?
    let name: String?
    
    enum CodingKeys: String, CodingKey {
        
        case id,
        key,
        name
    }
}
