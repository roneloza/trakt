//
//  MovieDetailRepository.swift
//  trakt
//
//  Created by Lab Positiva Dev on 11/28/19.
//  Copyright © 2019 Technious. All rights reserved.
//

import UIKit

protocol MovieDetailRepository: class {
    
    func getMovieDetail(request: MovieDetailRequest, completion: @escaping (Result<MovieDetailResponse?, CustomError>) -> Void)
}

class MovieDetailRepositoryRestWebService: BaseRepository, MovieDetailRepository {
    
    func getMovieDetail(request: MovieDetailRequest, completion: @escaping (Result<MovieDetailResponse?, CustomError>) -> Void) {
        
        self.webServiceClient.GET(request: request.request) { (result) in
            
            switch result {
                
            case .success(let data):
                
                if let response = self.deserialize.decode(data: data, class: MovieDetailResponse.self) {
                    
                    completion(.success(response))
                }
                else {
                    
                    completion(.failure(MovieDetailError.emptyData()))
                }
            case .failure(let error):
                
                completion(.failure(error))
            }
        }
    }
}
