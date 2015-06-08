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
    let userInfoURL = "https://www.udacity.com/api/users/"
    
    var loginCredentials = [String: [String: String]]()
    var userKey: String?
    
    
    init(loginCredentials: [String: [String: String]]){
        
        self.loginCredentials = loginCredentials
    
    }
    
    func POSTSessionRequest(completion:(success: Bool, error: NSError?) -> Void) -> Void{
    
        
        self.sendJSONRequest(sessionURL, method:"POST", additionalHeaderValues:nil,  bodyData: loginCredentials) { (result, error) -> Void in
            
            if(error != nil){

                completion(success: false, error: error)
                return
            }
            
            let newResult = result!.subdataWithRange(NSMakeRange(5, result!.length - 5))
            let parsedResult: AnyObject! = NSJSONSerialization.JSONObjectWithData(newResult, options: NSJSONReadingOptions.AllowFragments, error: nil)
            
            if var accountDictionary = parsedResult.valueForKey("account") as? [String: AnyObject]{
                //the login succeeded
                //Create a model for the current user
                self.userKey = accountDictionary["key"] as? String
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
    
    func GETUserData(key:String, completion:(result: NSData?, error: NSError?) -> Void){
        //We should not take self.userKey here, because we do not know, if it has been already retrieved in all contexts
        
        let getUserMethodString = "\(self.userInfoURL)" + "\(key)"
        self.sendGETRequest(getUserMethodString, GETData: nil, headerValues:nil ) { (result, error) -> Void in
            
            if(error != nil){
                
                completion(result: nil, error: error)
            }
            
            let newResult = result!.subdataWithRange(NSMakeRange(5, result!.length - 5))
            completion(result:newResult, error: nil)
        
        }
    
    }
    
}


