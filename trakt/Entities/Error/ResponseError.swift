//
//  ResponseError.swift
//  ColturViajes
//
//  Created by roni shender on 11/24/19.
//  Copyright © 2019 ENFASYS Consultores e Ingenieros. All rights reserved.
//

import UIKit

//"{\"data\":null,\"success\":false,\"message\":\"Sesión expirada, volver a iniciar sesión\"}"

class ResponseError: CodableObject {
    
    internal init(success: Bool?, message: String?) {
        
        self.success = success
        self.message = message
    }
    
    let success: Bool?
    let message: String?
    
    enum CodingKeys: String, CodingKey {
        
        case success,
        message
    }
}
