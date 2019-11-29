//
//  MovieDetailResponse.swift
//  trakt
//
//  Created by Lab Positiva Dev on 11/28/19.
//  Copyright © 2019 Technious. All rights reserved.
//

import UIKit

class MovieDetailResponse: CodableObject {
    
    let overview: String?
    let posterPath: String?
    
    enum CodingKeys: String, CodingKey {
        
        case posterPath = "poster_path",
        overview
    }
}
