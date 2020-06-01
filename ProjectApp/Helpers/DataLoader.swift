//
//  DataLoader.swift
//  ProjectApp
//
//  Created by Николай Рыбин on 20.05.2020.
//  Copyright © 2020 Николай Рыбин. All rights reserved.
//

import Foundation
import Alamofire

class DataLoader {
    
    static var isConnectedToInternet:Bool {
        return NetworkReachabilityManager()!.isReachable
    }
    
    
    static func LoadData(url: URLConvertible, _ completion: @escaping ((DataResponse<Any>?, Bool)) -> ()) {
                
        if isConnectedToInternet{
            
            let authInfo = DataManager().LoadData()
            
            if NSDate().timeIntervalSince1970 > (authInfo?.deathTime)!{
                
                print("Token is old, update it")
                
                let login = authInfo?.login!
                let password = authInfo?.password!
                
                let parameters = [
                    "email": login!,
                    "password": password!
                    ] as [String : Any]
                
                request("https://event-admin.tapir.ws/api/login", method: .post, parameters: parameters, headers: nil).responseJSON { response in
                    
                    do {
                        let jsonData = response.data!
                        
                        let otvet = try JSONDecoder().decode(AuthResponse.self, from: jsonData)
                        
                        let token = otvet.accessToken
                        
                        let deathTime  = NSDate().timeIntervalSince1970 + Double(otvet.expiresIn)
                        
                        RequestInfo.header["AccessToken"]  = token
                        
                        //сохранение данных о том что пользователь авторизовался
                        
                        DataManager().isAppAuthorized = true
                        
                        let authInfo = AuthInfo(status: true, login: login!, password: password!, token: token, deathTime: deathTime)
                        
                        DataManager().SaveData(input: authInfo)
                        
                        
                        
                        
                        request(url, method: .get, headers: RequestInfo.getHeader()).responseJSON { response in
                            completion((response, true))
                        }
                        
                    } catch {
                        
                        print(error.localizedDescription)
                    }
                }
            }else{
                
                request(url, method: .get, headers: RequestInfo.getHeader()).responseJSON { response in
                    completion((response, true))
                }            }
        }else{
            completion((nil, false))
        }
    }
}
