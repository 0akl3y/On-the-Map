//  ParseClient.swift
//  On the Map
//
//  Created by Johannes Eichler on 07.06.15.
//  Copyright (c) 2015 Eichler. All rights reserved.
//

import UIKit

class ParseClient: SimpleNetworking {
    
    let headerFields: [String: String] = ["X-Parse-Application-Id": "QrX47CA9cyuGewLdsL7o5Eb8iug6Em8ye0dnAbIr", "X-Parse-REST-API-Key": "QuWThTdiRmTux3YaDseUSEpUKo7aBYM737yKd4gY"]
    let mainURL = "https://api.parse.com/1/classes/StudentLocation"
    
    var cache:CachedResponses {
        get{ return CachedResponses.cachedResponses() }
    }
    
    override init(){
     
        super.init()
        
    }

    func GETStudentLocations(completion:(error: NSError?) -> Void ){
        // Fetches the student locations, converts them into a StudentLocation instance and appends this instance to the locations array of the CachedResponses singleton
        
        self.sendGETRequest(self.mainURL, GETData: nil, headerValues: self.headerFields) { (result, error) -> Void in

            if(error == nil){
            
                let parsedResult: AnyObject! = NSJSONSerialization.JSONObjectWithData(result!, options: NSJSONReadingOptions.AllowFragments, error: nil)
                let studentLocations = parsedResult.valueForKey("results") as? [[String: AnyObject]]
                
                for locationEntry in studentLocations! {
                    
                    let newLocations = StudentLocation(placeAttributeDict: locationEntry)
                    //append the new locations to the cachedResponses singleton
                    self.cache.locations.append(newLocations)
                    
                }
            }
            
            completion(error: error)
        }
    }
    
    func POSTStudentLocations(studentLocation:StudentLocation, completion:(result: [String: String]?, error: NSError?) -> Void){
        // post the customer location to the Parse API and return a dictionary with objectID & createdAt date
        
        var attrDictionary = studentLocation.getAttrDictionary()
        
        self.sendJSONRequest(self.mainURL, method: "POST", additionalHeaderValues: self.headerFields, bodyData: attrDictionary) { (result, error) -> Void in

            let parsedResult: AnyObject! = NSJSONSerialization.JSONObjectWithData(result!, options: NSJSONReadingOptions.AllowFragments, error: nil)
            
            let studentLocations = parsedResult as? [String: String]
            completion(result: studentLocations, error: error)
        }
    }
    
    func queryStudentLocation(queryArgs:[String: String]?, options:[String: String]?, completion:(error: NSError?) -> Void){

        var argumentsList = [String]()
        
        var completeQuery = [String: String]()
        
        if (queryArgs != nil){
            
            for (key, value) in queryArgs! {
                
                var arg = "\"\(key)\":\"\(value)\""
                argumentsList.append(arg)
                
            }
            
            let query = join(",", argumentsList)
            
            completeQuery["where"] = "{\(query)}"
            
        }
        
        if(options != nil){
            
            for (key, value) in options! {
                
                completeQuery[key] = value                
            }
        }
        
        self.sendGETRequest(mainURL, GETData: completeQuery, headerValues: self.headerFields) { (result, error) -> Void in
            
            if(error == nil){
                
                let parsedResult: AnyObject! = NSJSONSerialization.JSONObjectWithData(result!, options: NSJSONReadingOptions.AllowFragments, error: nil)
                let studentLocations = parsedResult.valueForKey("results") as? [[String: AnyObject]]
                
                for locationEntry in studentLocations! {
                    
                    let newLocations = StudentLocation(placeAttributeDict: locationEntry)
                    //append the new locations to the cachedResponses singleton
                    self.cache.locations.append(newLocations)
                    
                }
            }
            
            completion(error: error)
            
        }
    }
    
    func updateStudentLocation(objectID:String, newData: StudentLocation, completion:(result: [String: AnyObject]?, error: NSError?) -> Void ){
        
        let urlString = "https://api.parse.com/1/classes/StudentLocation/\(objectID)"
        let attrDictionary = newData.getAttrDictionary()
        
        self.sendJSONRequest(urlString, method: "PUT", additionalHeaderValues: self.headerFields, bodyData: attrDictionary) { (result, error) -> Void in
            
            let parsedResult: AnyObject! = NSJSONSerialization.JSONObjectWithData(result!, options: NSJSONReadingOptions.AllowFragments, error: nil)
            let resultDict = parsedResult as? [String: AnyObject]

            completion(result: resultDict, error: error)
        }
    }
}
