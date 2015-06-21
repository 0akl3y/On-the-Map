//
//  StudentLocation.swift
//  On the Map
//
//  Created by Johannes Eichler on 07.06.15.
//  Copyright (c) 2015 Eichler. All rights reserved.
//


enum StudentLocationKey: String {
    
    case firstNameKey = "firstName"
    case lastNameKey = "lastName"
    case latitudeKey = "latitude"
    case longitudeKey = "longitude"
    case mapStringKey = "mapString"
    case uniqueKeyKey = "uniqueKey"
    
    case objectIDKey = "objectID"
    case mediaURLKey = "mediaURL"

}


struct StudentLocation {
    
    let firstName: String!
    let lastName: String!
    let latitude: Double!
    let longitude: Double!
    let mapString: String!
    let uniqueKey: String!
    
    var objectID: String? // is generated automatically
    var mediaURL: String?

    
    init(placeAttributeDict:[String: AnyObject]){
        
        self.firstName = placeAttributeDict[StudentLocationKey.firstNameKey.rawValue] as! String
        self.lastName = placeAttributeDict[StudentLocationKey.lastNameKey.rawValue] as! String
        self.latitude = placeAttributeDict[StudentLocationKey.latitudeKey.rawValue] as! Double
        self.longitude = placeAttributeDict[StudentLocationKey.longitudeKey.rawValue] as! Double
        
        self.mapString = placeAttributeDict[StudentLocationKey.mapStringKey.rawValue] as! String
        self.uniqueKey = placeAttributeDict[StudentLocationKey.uniqueKeyKey.rawValue] as! String
        
        self.mediaURL = placeAttributeDict[StudentLocationKey.mediaURLKey.rawValue] as? String
    
    
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
