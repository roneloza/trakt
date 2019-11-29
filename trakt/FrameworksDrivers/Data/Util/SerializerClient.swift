//
//  SerializerClient.swift
//  ColturViajes
//
//  Created by roni shender on 11/23/19.
//  Copyright © 2019 ENFASYS Consultores e Ingenieros. All rights reserved.
//

import UIKit

protocol SerializerClient: class {

    func decode<T: CodableObject>(data: Data?, class t: T.Type) -> T?
    func decodeArray<T: CodableObject>(data: Data?, class t: T.Type) -> [T]?
}

class SerializerJSONClient: SerializerClient {

    func decode<T: CodableObject>(data: Data?, class t: T.Type) -> T? {
        
        guard let data = data,
            let object = try? JSONDecoder().decode(t, from: data) else { return nil }
        
        return object
    }
    
    func decodeArray<T: CodableObject>(data: Data?, class t: T.Type) -> [T]? {
        
        guard let data = data,
            let object = try? JSONDecoder().decode([T].self, from: data) else { return nil }
        
        return object
    }
}
