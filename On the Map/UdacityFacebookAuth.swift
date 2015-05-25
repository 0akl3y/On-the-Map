//
//  UdacityFacebookAuth.swift
//  On the Map
//
//  Created by Johannes Eichler on 21.05.15.
//  Copyright (c) 2015 Eichler. All rights reserved.
//

import UIKit

class UdacityFacebookAuth: UdacityClient {
    
    var FBAccessToken: String!
    
    init(accessToken: String){
        
        self.FBAccessToken = accessToken
        
        let credentials = ["facebook_mobile": ["access_token": accessToken]]
        super.init(loginCredentials: credentials)
    
    }

}

