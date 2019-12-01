//
//  SearchMostPopularMoviesPresenter.swift
//  trakt
//
//  Created by roni shender on 11/30/19.
//  Copyright © 2019 Technious. All rights reserved.
//

import UIKit

protocol SearchMostPopularMoviesPresenterInput: SearchMostPopularMoviesUseCaseOutput {
    
}

protocol SearchMostPopularMoviesPresenterOutput: class {
    
    func willSearchMostPopularMovies()
    func successSearchMostPopularMovies(data: [MostPopularMovieViewModel]?)
    func failSearchMostPopularMovies(error: CustomError)
    func didSearchMostPopularMovies()
    
    func willPaginateSearchMostPopularMovies()
    func successPaginateSearchMostPopularMovies(data: [MostPopularMovieViewModel]?)
    func failPaginateSearchMostPopularMovies(error: CustomError)
    func didPaginateSearchMostPopularMovies()
}

class SearchMostPopularMoviesPresenter: NSObject {
    
    internal init(output: SearchMostPopularMoviesPresenterOutput?) {
        self.output = output
    }
    
    private weak var output: SearchMostPopularMoviesPresenterOutput?
}

extension SearchMostPopularMoviesPresenter: SearchMostPopularMoviesPresenterInput {
    
    func willPaginateSearchMostPopularMovies() {
        
        self.output?.willPaginateSearchMostPopularMovies()
    }
    
    func successPaginateSearchMostPopularMovies(data: [MostPopularMovieResponse]?) {
        
        let movies = data?.compactMap( {
            
            MostPopularMovieViewModel(response: $0)
        })
        
        self.output?.successPaginateSearchMostPopularMovies(data: movies)
    }
    
    func failPaginateSearchMostPopularMovies(error: CustomError) {
        
        self.output?.failPaginateSearchMostPopularMovies(error: error)
    }
    
    func didPaginateSearchMostPopularMovies() {
        
        self.output?.didPaginateSearchMostPopularMovies()
    }
    
    func willSearchMostPopularMovies() {
        
        self.output?.willSearchMostPopularMovies()
    }
    
    func successSearchMostPopularMovies(data: [MostPopularMovieResponse]?) {
        
        let movies = data?.compactMap( {
            
            MostPopularMovieViewModel(response: $0)
        })
        
        self.output?.successSearchMostPopularMovies(data: movies)
    }
    
    func failSearchMostPopularMovies(error: CustomError) {
        
        self.output?.failSearchMostPopularMovies(error: error)
    }
    
    func didSearchMostPopularMovies() {
        
        self.output?.didSearchMostPopularMovies()
    }
    
}
