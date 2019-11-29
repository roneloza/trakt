//
//  ReserveViewModel.swift
//  ColturViajes
//
//  Created by roni shender on 11/24/19.
//  Copyright © 2019 ENFASYS Consultores e Ingenieros. All rights reserved.
//

import UIKit

class MostPopularMovieViewModel: NSObject {
   
    internal init(title: String?, year: Int?, imdb: String?, tmdb: Int?) {
        self.title = title
        self.year = year
        self.imdb = imdb
        self.tmdb = tmdb
    }
    
    convenience init(response: MostPopularMovieResponse?) {
        
        self.init(title: response?.title, year: response?.year, imdb: response?.ids?.imdb, tmdb: response?.ids?.tmdb)
    }

    let imdb: String?
    let tmdb: Int?
    let title: String?
    let year: Int?
    
    var overview: String?
    var posterUrl: String?
}
