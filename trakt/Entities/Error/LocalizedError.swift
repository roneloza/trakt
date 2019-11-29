//
//  LocalizedError.swift
//  ColturViajes
//
//  Created by roni shender on 11/23/19.
//  Copyright © 2019 ENFASYS Consultores e Ingenieros. All rights reserved.
//

protocol LocalizedError : Error {
    
    var title: String? { get }
    var message: String? { get }
    var code: Int? { get }
}
