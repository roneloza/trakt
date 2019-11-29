//
//  ReserveListPresenter.swift
//  ColturViajes
//
//  Created by roni shender on 11/24/19.
//  Copyright © 2019 ENFASYS Consultores e Ingenieros. All rights reserved.
//

import UIKit

protocol MostPopularMoviesPresenterInput: MostPopularMoviesUseCaseOutput {
    
}

protocol MostPopularMoviesPresenterOutput: class {
    
    func willGetMostPopularMovies()
    func successGetMostPopularMovies(data: [MostPopularMovieViewModel]?)
    func failGetMostPopularMovies(error: CustomError)
    func didGetMostPopularMovies()
}

class MostPopularMoviesPresenter: NSObject {

    internal init(output: MostPopularMoviesPresenterOutput?) {
        self.output = output
    }

    private weak var output: MostPopularMoviesPresenterOutput?
}

extension MostPopularMoviesPresenter: MostPopularMoviesPresenterInput {
    
    func willGetMostPopularMovies() {
        
        self.output?.willGetMostPopularMovies()
    }
    
    func successGetMostPopularMovies(data: [MostPopularMovieResponse]?) {
        
        let movies = data?.compactMap( {
            
            MostPopularMovieViewModel(response: $0)
        })
        
        self.output?.successGetMostPopularMovies(data: movies)
    }
    
    func failGetMostPopularMovies(error: CustomError) {
        
        self.output?.failGetMostPopularMovies(error: error)
    }
    
    func didGetMostPopularMovies() {
        
        self.output?.didGetMostPopularMovies()
    }
    
}
