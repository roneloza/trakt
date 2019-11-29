//
//  AppSettings.swift
//  ColturViajes
//
//  Created by roni shender on 11/17/19.
//  Copyright © 2019 ENFASYS Consultores e Ingenieros. All rights reserved.
//

import Foundation

class AppSettingsBuilder {

    static let shared = AppSettingsBuilder()
    
    let settings: AppSettings = {
        
        let schemeName = Bundle.main.infoDictionary?["SchemeName"] as? String ?? "trakt-mocks"
        
        switch schemeName {
        case "trakt-mocks":
            
            return AppSettingsMocks()
        case "trakt-dev":
            
            return AppSettingsDev()
        case "trakt-releases":
            
            return AppSettingsRelease()
        default:
            
            return AppSettingsMocks()
        }
    }()
    
    private init() {
        
    }
}

class AppSettingsRelease: AppSettings {
    
    let baseURL: String = "https://api.trakt.tv/"
}

class AppSettingsDev: AppSettings {
    
    public let baseURL: String = "https://private-anon-0a3a8c48d7-trakt.apiary-proxy.com/"
}

class AppSettingsMocks: AppSettings {
 
    public let baseURL: String = "https://private-anon-0a3a8c48d7-trakt.apiary-proxy.com/"
}

protocol AppSettings: class {
    
    var baseURL: String { get }
}
