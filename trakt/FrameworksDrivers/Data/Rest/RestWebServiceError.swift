//
//  RestWebServiceError.swift
//  ColturViajes
//
//  Created by roni shender on 11/23/19.
//  Copyright © 2019 ENFASYS Consultores e Ingenieros. All rights reserved.
//

import UIKit

enum RestWebServiceStatusCode: Int {
    
    case ok = 200
    
    case multipleChoices = 300
    
    case badRequest = 400
    case unauthorised = 401
    
    case internalServerError = 500
    case connectionTimedOut = 522
    
    case malformedUrl = 2000
}

class RestWebServiceError: CustomError {

}
