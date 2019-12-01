//
//  MovieVideoRepository.swift
//  trakt
//
//  Created by roni shender on 11/30/19.
//  Copyright © 2019 Technious. All rights reserved.
//

import UIKit

protocol MovieVideoRepository: RestWebServiceRepository {
    
    func getMovieVideo(request: MovieVideoRequest, completion: @escaping (Result<MovieVideoResponse?, CustomError>) -> Void)
}

class MovieVideoRepositoryRestWebService: BaseRepository, MovieVideoRepository {
    
    func getMovieVideo(request: MovieVideoRequest, completion: @escaping (Result<MovieVideoResponse?, CustomError>) -> Void) {
        
        let _ = self.webServiceClient.get(request: request.request) { (result) in
            
            switch result {
                
            case .success(let data):
                
                if let response = self.deserialize.decode(data: data, class: MovieVideoResponse.self) {
                    
                    completion(.success(response))
                }
                else {
                    
                    completion(.failure(MovieVideoError.emptyData()))
                }
            case .failure(let error):
                
                completion(.failure(error))
            }
        }
    }
}
