//
//  AppUserData.swift
//  ColturViajes
//
//  Created by roni shender on 11/24/19.
//  Copyright © 2019 ENFASYS Consultores e Ingenieros. All rights reserved.
//

import UIKit

enum AppUserDataStoreKeys: String {
    
    case loginDataUser = "loginDataUser"
}

protocol AppUserDataStore {
    
    func setString(value: String, key: String)
    func setObject<T: CodableObject>(value: T?, key: String)
    func getString(key: String) -> String?
    func getObject<T: CodableObject>(class t: T.Type, key: String) -> T?
    func removeObject(key: String)
}

class AppUserDataStandarDefaults: AppUserDataStore {
    
    private let userDefaults = UserDefaults.standard
    
    func removeObject(key: String) {
     
        self.userDefaults.removeObject(forKey: key)
    }
    
    func setString(value: String, key: String) {
        
        self.userDefaults.set(value, forKey: key)
    }
    
    func setObject<T: CodableObject>(value: T?, key: String) {
        
        if let encoded = try? JSONEncoder().encode(value) {
            
            self.userDefaults.set(encoded, forKey: key)
        }
    }
    
    func getString(key: String) -> String? {
        
        return self.userDefaults.string(forKey: key)
    }
    
    func getObject<T: CodableObject>(class t: T.Type, key: String) -> T? {
        
        guard let data = self.userDefaults.object(forKey: key) as? Data,
            let object = try? JSONDecoder().decode(t, from: data) else { return nil }
        
        return object
    }

}
