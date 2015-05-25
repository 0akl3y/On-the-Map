//
//  Udacity Client.swift
//  On the Map
//
//  Created by Johannes Eichler on 19.05.15.
//  Copyright (c) 2015 Eichler. All rights reserved.
//

import UIKit
    
class UdacityClient: SimpleNetworking {
    
    //Implements Udacity API Methods and Error Handling
    
    var sessionID: String?
    let sessionURL = "https://www.udacity.com/api/session"    
    var loginCredentials = [String: [String: String]]()
    
    
    init(loginCredentials: [String: [String: String]]){
        
        self.loginCredentials = loginCredentials
    
    }
    
    func POSTSessionRequest(completion:(success: Bool, error: NSError?) -> Void) -> Void{
    
        
        self.sendPOSTRequest(sessionURL, POSTData: loginCredentials) { (result, error) -> Void in
            
            if(error != nil){

                completion(success: false, error: error)
                return
            }
            
            let parsedResult: AnyObject! = NSJSONSerialization.JSONObjectWithData(result!, options: NSJSONReadingOptions.AllowFragments, error: nil)
            
            if var accountDictionary = parsedResult.valueForKey("account") as? [String: AnyObject]{
                
                var isRegistered: Bool = accountDictionary["registered"] as! Bool
                
                if(isRegistered){
                    
                    completion(success: true, error: nil)
                }
            }
            
            else {
                
                if var loginError = parsedResult.valueForKey("error") as? String {
                    
                    let loginErrorCode = parsedResult.valueForKey("status") as! Int
                    let loginErrorString = "\(loginErrorCode): " + loginError
                    
                    
                    var userInfoDictionary = [String: AnyObject]()
                    
                    userInfoDictionary[NSLocalizedDescriptionKey] = loginError
                    
                    if(loginErrorCode == 403){
                        
                        userInfoDictionary[NSLocalizedRecoverySuggestionErrorKey] = "Please check your password and/or username."                    
                    }
                    
                    var loginErrorMessage: NSError = NSError(domain: "UdacityClientLoginError", code: loginErrorCode,
                        userInfo: userInfoDictionary)
                    
                    completion(success: false, error: loginErrorMessage)
                
                }
            
            }
        }
        
    }
    
}


