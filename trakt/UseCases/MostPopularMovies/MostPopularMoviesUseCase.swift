//
//  ReserveListUseCase.swift
//  ColturViajes
//
//  Created by roni shender on 11/24/19.
//  Copyright © 2019 ENFASYS Consultores e Ingenieros. All rights reserved.
//

import UIKit

protocol MostPopularMoviesUseCaseInput {
    
    func getMostPopularMovies(request: MostPopularMovieRequest)
}

protocol MostPopularMoviesUseCaseOutput {
    
    func willGetMostPopularMovies()
    func successGetMostPopularMovies(data: [MostPopularMovieResponse]?)
    func failGetMostPopularMovies(error: CustomError)
    func didGetMostPopularMovies()
}

class MostPopularMoviesUseCase: MostPopularMoviesUseCaseInput {
    
    internal init(output: MostPopularMoviesUseCaseOutput?) {
        self.output = output
    }
    
    private let repository: MostPopularMoviesRepository = MostPopularMoviesRepositoryRestWebService()
    private let output: MostPopularMoviesUseCaseOutput?
    
    func getMostPopularMovies(request: MostPopularMovieRequest) {
        
        self.output?.willGetMostPopularMovies()
        
        self.repository.getMostPopularMovies(request: request) { (result) in
            
            switch result {
                
            case .success(let object):
                
                self.output?.successGetMostPopularMovies(data: object)
                
            case .failure(let error):
                
                self.output?.failGetMostPopularMovies(error: error)
            }
            
            self.output?.didGetMostPopularMovies()
        }
    }
}
