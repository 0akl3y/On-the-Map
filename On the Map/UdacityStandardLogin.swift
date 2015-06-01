//
//  UdacityStandardLogin.swift
//  On the Map
//
//  Created by Johannes Eichler on 21.05.15.
//  Copyright (c) 2015 Eichler. All rights reserved.
//
// Handles the standard login

import UIKit

class UdacityStandardLogin: UdacityClient {
    
    var username: String!
    var password: String!
    
    init(username: String, password: String){
        
        self.username = username
        self.password = password
        
        super.init(loginCredentials: ["udacity" : ["username": username, "password": password]])        
        
    }
   
}
