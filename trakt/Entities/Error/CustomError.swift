//
//  LocalizedError.swift
//  ColturViajes
//
//  Created by roni shender on 11/23/19.
//  Copyright © 2019 ENFASYS Consultores e Ingenieros. All rights reserved.
//

import Foundation

enum CustomErrorEnum: Int {
    case dataIsEmpty = 2000
}

class CustomError : LocalizedError {
    
    let title: String?
    let message: String?
    let code: Int?
    let data: Data? = nil
    
    internal init(title: String?, message: String?, code: Int?, data: Data? = nil) {
        
        let deserialize: SerializerClient = SerializerJSONClient()
        
        if let responseError = deserialize.decode(data: data, class: ResponseError.self) {
            
            self.title = title
            self.message = responseError.statusMessage
            self.code = responseError.statusCode
        }
        else {
            
            self.title = title
            self.message = message
            self.code = code
        }
    }
    
    class func emptyData() -> CustomError {
        
        return CustomError.init(title: "Error", message: "Response data is empty", code: CustomErrorEnum.dataIsEmpty.rawValue)
    }
}
