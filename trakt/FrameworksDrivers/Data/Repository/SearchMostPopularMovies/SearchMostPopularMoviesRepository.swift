//
//  SearchMostPopularMoviesRepository.swift
//  trakt
//
//  Created by roni shender on 11/30/19.
//  Copyright © 2019 Technious. All rights reserved.
//

import UIKit

protocol SearchMostPopularMoviesRepository: RestWebServiceRepository {
    
    func searchMostPopularMovies(request: MostPopularMovieRequest, completion: @escaping (Result<[MostPopularMovieResponse]?, CustomError>) -> Void)
}

class SearchMostPopularMoviesRepositoryRestWebService: BaseRepository, SearchMostPopularMoviesRepository {
    
    func searchMostPopularMovies(request: MostPopularMovieRequest, completion: @escaping (Result<[MostPopularMovieResponse]?, CustomError>) -> Void) {
        
        let _ = self.webServiceClient.get(request: request.request) { (result) in
            
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
