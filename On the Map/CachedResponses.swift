//
//  CachedResponses.swift
//  On the Map
//
//  Created by Johannes Eichler on 11.06.15.
//  Copyright (c) 2015 Eichler. All rights reserved.
//

import UIKit

 //Create a singletion object to cache the network responses
let _cachedResponses: CachedResponses = { CachedResponses() }()

class CachedResponses: NSObject {
    
    var locations = [StudentLocation]()
    var userData: UserModel?
    
    class func cachedResponses() -> CachedResponses {
    
        return _cachedResponses
    }
   
}
