//
//  LocalizedError.swift
//  ColturViajes
//
//  Created by roni shender on 11/23/19.
//  Copyright © 2019 ENFASYS Consultores e Ingenieros. All rights reserved.
//

enum CustomErrorEnum: Int {
    case dataIsEmpty = 2000
}

class CustomError : LocalizedError {
    
    let title: String?
    let message: String?
    let code: Int?
    
    internal init(title: String?, message: String?, code: Int?) {
        self.title = title
        self.message = message
        self.code = code
    }
    
    class func emptyData() -> CustomError {
        
        return CustomError.init(title: "Error", message: "Response data is empty", code: CustomErrorEnum.dataIsEmpty.rawValue)
    }
}
