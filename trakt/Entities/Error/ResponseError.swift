//
//  ResponseError.swift
//  ColturViajes
//
//  Created by roni shender on 11/24/19.
//  Copyright © 2019 ENFASYS Consultores e Ingenieros. All rights reserved.
//

import UIKit

//"{\"data\":null,\"success\":false,\"message\":\"Sesión expirada, volver a iniciar sesión\"}"
//"{\"status_code\":34,\"status_message\":\"The resource you requested could not be found.\"}"

class ResponseError: CodableObject {
    
    let success: Bool?
    let message: String?
    let statusCode: Int?
    let statusMessage: String?
    
    enum CodingKeys: String, CodingKey {
        
        case success,
        message,
        statusCode = "status_code",
        statusMessage = "status_message"
    }
}
