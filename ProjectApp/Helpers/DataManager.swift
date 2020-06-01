//
//  DataManager.swift
//  ProjectApp
//
//  Created by Николай Рыбин on 12.05.2020.
//  Copyright © 2020 Николай Рыбин. All rights reserved.
//

import Foundation

class DataManager{
    
    let statusKey = "isLoggedIn"
    let authKey = "authInfo"
    
    var isAppAuthorized: Bool {
        
        get{
            UserDefaults.standard.bool(forKey: statusKey)
        }
        
        set{
            let userDefault = UserDefaults.standard
            userDefault.set(newValue, forKey: statusKey)
            userDefault.synchronize()
        }
    }
    
    func SaveData(input: AuthInfo){
        UserDefaults.standard.set(try? PropertyListEncoder().encode(input), forKey: authKey)
    }
    
    func LoadData() -> AuthInfo? {
        
        if let data = UserDefaults.standard.value(forKey: authKey) as? Data {
            let auth = try? PropertyListDecoder().decode(AuthInfo.self, from: data)
            
            return auth ?? nil
        }
        return nil
    }
}
