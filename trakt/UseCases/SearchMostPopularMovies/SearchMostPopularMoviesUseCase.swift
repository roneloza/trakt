//
//  SearchMostPopularMoviesUseCase.swift
//  trakt
//
//  Created by roni shender on 11/30/19.
//  Copyright © 2019 Technious. All rights reserved.
//

import UIKit

protocol SearchMostPopularMoviesUseCaseInput {
    
    func searchMostPopularMovies(request: MostPopularMovieRequest)
    func paginateSearchMostPopularMovies(request: MostPopularMovieRequest)
}

protocol SearchMostPopularMoviesUseCaseOutput {
    
    func willSearchMostPopularMovies()
    func successSearchMostPopularMovies(data: [MostPopularMovieResponse]?)
    func failSearchMostPopularMovies(error: CustomError)
    func didSearchMostPopularMovies()
    
    func willPaginateSearchMostPopularMovies()
    func successPaginateSearchMostPopularMovies(data: [MostPopularMovieResponse]?)
    func failPaginateSearchMostPopularMovies(error: CustomError)
    func didPaginateSearchMostPopularMovies()
}

class SearchMostPopularMoviesUseCase: SearchMostPopularMoviesUseCaseInput {
    
    internal init(output: SearchMostPopularMoviesUseCaseOutput?) {
        self.output = output
    }
    
    private let repository: SearchMostPopularMoviesRepository = SearchMostPopularMoviesRepositoryRestWebService()
    
    private let output: SearchMostPopularMoviesUseCaseOutput?
    
    func searchMostPopularMovies(request: MostPopularMovieRequest) {
        
        self.repository.webServiceClient.allNetworkTask.forEach { (task) in
            
            task.cancel()
        }
        
        self.output?.willSearchMostPopularMovies()
        
        self.repository.searchMostPopularMovies(request: request) { (result) in
            
            switch result {
                
            case .success(let object):
                
                self.output?.successSearchMostPopularMovies(data: object)
                
            case .failure(let error):
                
                self.output?.failSearchMostPopularMovies(error: error)
            }
            
            self.output?.didSearchMostPopularMovies()
        }
    }
    
    func paginateSearchMostPopularMovies(request: MostPopularMovieRequest) {
        
        self.output?.willPaginateSearchMostPopularMovies()
        
        self.repository.searchMostPopularMovies(request: request) { (result) in
            
            switch result {
                
            case .success(let object):
                
                self.output?.successPaginateSearchMostPopularMovies(data: object)
                
            case .failure(let error):
                
                self.output?.failPaginateSearchMostPopularMovies(error: error)
            }
            
            self.output?.didPaginateSearchMostPopularMovies()
        }
    }
}
