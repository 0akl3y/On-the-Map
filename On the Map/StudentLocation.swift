//
//  StudentLocation.swift
//  On the Map
//
//  Created by Johannes Eichler on 07.06.15.
//  Copyright (c) 2015 Eichler. All rights reserved.
//


struct StudentLocation {
    
    let firstName: String!
    let lastName: String!
    let latitude: Float!
    let longitude: Float!
    let mapString: String!
    let uniqueKey: String!
    
    var objectID: String? // is generated automatically
    var mediaURL: String?

    
    init(firstName:String, lastName:String, latitude:Float, longitude:Float, mapString:String, uniqueKey: String, mediaURL:String?){
    
        self.firstName = firstName
        self.lastName = lastName
        self.latitude = latitude
        self.longitude = longitude
        self.mapString = mapString
        self.uniqueKey = uniqueKey
        
        self.mediaURL = (mediaURL != nil) ? mediaURL : nil
    
    }
    
    func getAttrDictionary() -> [String: AnyObject]{
        // Returns  a dictionary containing all set attributes

        var attrDict = ["firstName" : self.firstName,
            "lastName" : self.lastName,
            "latitude" : self.latitude,
            "longitude" : self.longitude,
            "mapString" : self.mapString,
            "uniqueKey" : self.uniqueKey,
            "mediaURL" : self.mediaURL!]
        
        if(self.objectID != nil){
            
            attrDict.setValue(self.objectID, forKey: "objectID")
        }
        
        return attrDict as! [String : AnyObject]
    }
   
}
