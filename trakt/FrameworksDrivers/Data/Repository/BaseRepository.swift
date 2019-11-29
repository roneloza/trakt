//
//  BaseRepository.swift
//  ColturViajes
//
//  Created by roni shender on 11/24/19.
//  Copyright © 2019 ENFASYS Consultores e Ingenieros. All rights reserved.
//

import UIKit

class BaseRepository {

    var deserialize: SerializerClient = SerializerJSONClient()
    var webServiceClient: RestWebServiceClient = RestWebServiceNativeClient()
}
