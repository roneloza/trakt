//
//  MovieVideoUseCase.swift
//  trakt
//
//  Created by roni shender on 11/30/19.
//  Copyright © 2019 Technious. All rights reserved.
//

import UIKit

protocol MovieVideoUseCaseInput {
    
    func getMovieVideo(request: MovieVideoRequest)
}

protocol MovieVideoUseCaseOutput {
    
    func willGetMovieVideo()
    func successGetMovieVideo(movieUrl: String?, key: String?)
    func failGetMovieVideo(error: CustomError)
    func didGetMovieVideo()
}

class MovieVideoUseCase: MovieVideoUseCaseInput {
    
    internal init(output: MovieVideoUseCaseOutput?) {
        self.output = output
    }
    
    private let repository: MovieVideoRepository = MovieVideoRepositoryRestWebService()
    private let output: MovieVideoUseCaseOutput?
    
     func getMovieVideo(request: MovieVideoRequest) {
        
        self.output?.willGetMovieVideo()
        
        self.repository.getMovieVideo(request: request) { (result) in
            
            switch result {
                
            case .success(let object):
                
                let youtubeUrl = "https://www.youtube.com/watch?v=\(object?.results?.last?.key ?? "")"
                
                self.output?.successGetMovieVideo(movieUrl: youtubeUrl,key: object?.results?.last?.key)
                
            case .failure(let error):
                
                self.output?.failGetMovieVideo(error: error)
            }
            
            self.output?.didGetMovieVideo()
        }
    }
}
