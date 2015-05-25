//
//  SimpleNetworking.swift
//  On the Map
//
//  Created by Johannes Eichler on 19.05.15.
//  Copyright (c) 2015 Eichler. All rights reserved.
//

import UIKit

class SimpleNetworking: NSObject {
   
    var sharedSession: NSURLSession {
        
        get{
            
            return NSURLSession.sharedSession()
        }
        
    }
    
    
    func escapeToURL(targetURL: String, methodCall: [String: AnyObject]) -> String{
        
        //takes the methodCall array containing the method call and all parameters and returns the complete URL for the GET request
        
        var parsedURLString = [String]()
        
        for (key, value) in methodCall {
            
            let currentValue: String = "\(value)".stringByAddingPercentEncodingWithAllowedCharacters( NSCharacterSet.URLQueryAllowedCharacterSet())!
            let methodElement = "\(key)" + "=" + "\(currentValue)"
            
            parsedURLString.append(methodElement)
            
        }
        
        var getRequestPart = join("&", parsedURLString)
        var completeURL = targetURL + "?" + getRequestPart
        
        return completeURL
        
    }
    
    
    
    func sendPOSTRequest(targetURL: String, POSTData: [String:AnyObject], completion:(result:NSData?, error:NSError?) -> Void){
        
        let request = NSMutableURLRequest(URL: NSURL(string: targetURL)!)
        
        request.HTTPMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Accept")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        var JSONError: NSError? = nil
        
        request.HTTPBody = NSJSONSerialization.dataWithJSONObject(POSTData, options: nil, error: &JSONError)
        
        let task = sharedSession.dataTaskWithRequest(request) { data, response, error in
            
            if error != nil { // Handle error…
                completion(result: nil, error: error!)
                return
            }
            
            let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5))
            completion(result: newData, error: error)
            
        }
        task.resume()
    }
    
    
    func sendGETRequest(targetURL: String, GETData: [String:AnyObject]){
            
            var requestURL: NSURL = NSURL(string: targetURL)!
        
            let requestURLString: String = self.escapeToURL(targetURL, methodCall: GETData)
            requestURL = NSURL(string: requestURLString)!
                
        
            var currentRequest = NSMutableURLRequest(URL: requestURL)
        
            let task = sharedSession.dataTaskWithRequest(currentRequest) { data, response, error in
            
            if error != nil { // Handle error…
                return
            }
            
            let newData = data.subdataWithRange(NSMakeRange(5, data.length - 5)) /* subset response data! */
            println(NSString(data: newData, encoding: NSUTF8StringEncoding))
        }
        task.resume()

        
            

            
    }
    
    
}
