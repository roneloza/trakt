//
//  RestWebService.swift
//  ColturViajes
//
//  Created by roni shender on 11/10/19.
//  Copyright © 2019 ENFASYS Consultores e Ingenieros. All rights reserved.
//

import Foundation

protocol RestWebServiceClient: class {
    
    func GET(request: RestWebServiceRequest, completion: @escaping (Result<Data?, CustomError>) -> Void)
    
    func POST(request: RestWebServiceRequest, completion: @escaping (Result<Data?, CustomError>) -> Void)
    
    func PUT(request: RestWebServiceRequest, completion: @escaping (Result<Data?, CustomError>) -> Void)
    
    func PATCH(request: RestWebServiceRequest, completion: @escaping (Result<Data?, CustomError>) -> Void)
}
