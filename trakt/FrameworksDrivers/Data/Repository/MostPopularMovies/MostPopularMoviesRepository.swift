//
//  ReserveListRepository.swift
//  ColturViajes
//
//  Created by roni shender on 11/24/19.
//  Copyright © 2019 ENFASYS Consultores e Ingenieros. All rights reserved.
//

import UIKit

protocol MostPopularMoviesRepository: class {
    
    func getMostPopularMovies(request: MostPopularMovieRequest, completion: @escaping (Result<[MostPopularMovieResponse]?, CustomError>) -> Void)
}

class MostPopularMoviesRepositoryRestWebService: BaseRepository, MostPopularMoviesRepository {

    func getMostPopularMovies(request: MostPopularMovieRequest, completion: @escaping (Result<[MostPopularMovieResponse]?, CustomError>) -> Void) {
        
        self.webServiceClient.GET(request: request.request) { (result) in
            
            switch result {
                
            case .success(let data):
                
                if let response = self.deserialize.decodeArray(data: data, class: MostPopularMovieResponse.self) {
                    
                    completion(.success(response))
                }
                else {
                    
                    completion(.failure(MostPopularMovieError.emptyData()))
                }
            case .failure(let error):
                
                completion(.failure(error))
            }
        }
    }
}
