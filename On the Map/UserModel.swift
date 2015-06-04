//
//  UserModel.swift
//  On the Map
//
//  Created by Johannes Eichler on 04.06.15.
//  Copyright (c) 2015 Eichler. All rights reserved.
//

import UIKit

class UserModel {
    
    let uniqueKey:String!
    var firstName:String?
    var lastName:String?
    
    
    init(userKey:String, session:UdacityClient){
        self.uniqueKey = userKey
        self.getUserDataFromSession(session)
    }
    
    func getUserDataFromSession(session:UdacityClient){
        
       session.GETUserData(self.uniqueKey, completion: { (result, error) -> Void in
        
            if(error == nil){
                
                var userJSONObject: AnyObject? = NSJSONSerialization.JSONObjectWithData(result!, options: NSJSONReadingOptions.AllowFragments, error: nil)
                
                var userDictionary = userJSONObject?.valueForKey("user") as! [String : AnyObject]
                self.firstName = userDictionary["first_name"] as? String
                self.lastName = userDictionary["last_name"] as? String
            }
        
            else{
                //handle error
            }
       })
    }
   
}
