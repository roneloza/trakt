//
//  MovieDetailUseCase.swift
//  trakt
//
//  Created by Lab Positiva Dev on 11/28/19.
//  Copyright © 2019 Technious. All rights reserved.
//

import UIKit

protocol MovieDetailUseCaseInput {
    
    func getMovieDetail(modelView: MostPopularMovieViewModel?, request: MovieDetailRequest)
}

protocol MovieDetailUseCaseOutput {
    
    func willGetMovieDetail()
    func successMovieDetail(modelView: MostPopularMovieViewModel?)
    func failGetMovieDetail(error: CustomError)
    func didGetMovieDetail()
}

class MovieDetailUseCase: MovieDetailUseCaseInput {
    
    internal init(output: MovieDetailUseCaseOutput?) {
        self.output = output
    }
    
    private let repository: MovieDetailRepository = MovieDetailRepositoryRestWebService()
    private let output: MovieDetailUseCaseOutput?
    
    func getMovieDetail(modelView: MostPopularMovieViewModel?, request: MovieDetailRequest) {
        
        self.output?.willGetMovieDetail()
        
        self.repository.getMovieDetail(request: request) { (result) in
            
            switch result {
                
            case .success(let object):
                
                modelView?.posterUrl = "https://image.tmdb.org/t/p/w500/\(object?.posterPath ?? "")"
                modelView?.overview = object?.overview
                
                self.output?.successMovieDetail(modelView: modelView)
                
            case .failure(let error):
                
                self.output?.failGetMovieDetail(error: error)
            }
            
            self.output?.didGetMovieDetail()
        }
    }
}
