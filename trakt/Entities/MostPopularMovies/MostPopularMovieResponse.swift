//
//  ReserveListResponse.swift
//  ColturViajes
//
//  Created by roni shender on 11/24/19.
//  Copyright © 2019 ENFASYS Consultores e Ingenieros. All rights reserved.
//

import UIKit

//{
//    "title": "The Dark Knight",
//    "year": 2008,
//    "ids": {
//        "trakt": 16,
//        "slug": "the-dark-knight-2008",
//        "imdb": "tt0468569",
//        "tmdb": 155
//    }
//}

class MostPopularMovieResponse: CodableObject {
    
    let title: String?
    let year: Int?
    let ids: MostPopularMovieResponseIds?
    
    enum CodingKeys: String, CodingKey {
        
        case title,
        year,
        ids
    }
}

class MostPopularMovieResponseIds: CodableObject {
    
    let trakt: Int?
    let slug: String?
    let imdb: String?
    let tmdb: Int?
    
    enum CodingKeys: String, CodingKey {
        
        case trakt,
        slug,
        imdb,
        tmdb
    }
}
