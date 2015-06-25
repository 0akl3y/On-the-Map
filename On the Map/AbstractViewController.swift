//
//  AbstractViewController.swift
//  On the Map
//
//  Created by Johannes Eichler on 18.06.15.
//  Copyright (c) 2015 Eichler. All rights reserved.
//
// This VC actually serves as an abstract class for OTM VC with common behavior

import UIKit

class AbstractViewController: UIViewController {
    
    var cache:CachedResponses {
        get{ return CachedResponses.cachedResponses() }
    }
    
    var errorMessageVC: StatusViewController?
    
    //The reload indicator serves as spinner for bar button items
    var reloadIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
    
    
    func addStatusView(){
        
        //add a status view that displays errorMessages and a large loading indicator

        self.errorMessageVC = StatusViewController()
        self.displayOverlay(self.errorMessageVC!)
        
        
    }
    
    func displayOverlay(overlay:UIViewController){
        
        self.addChildViewController(overlay)
        self.view.addSubview(overlay.view)
        overlay.didMoveToParentViewController(self)
    
    }
    
    
    func displayErrorMessage(error:NSError){

        self.errorMessageVC?.error = error
        self.errorMessageVC?.showLoginErrorMessage()
    
    }
    
    
    func startReloadIndicator(forButton:UIBarButtonItem?){
        
        if(forButton != nil){
            
            // Based on an idea from Anoop Vaidya
            // http://stackoverflow.com/questions/14318368/uibarbuttonitem-how-can-i-find-its-frame
            
            if var barButtonView = forButton?.valueForKey("view") as? UIView{
                
                // the reload indicator needs to be centered as there is an ugly offset that moves it to the left at start
                self.reloadIndicator.frame = barButtonView.frame
            
            }
            
            forButton!.customView = reloadIndicator
            
            self.reloadIndicator.color = UIColor.blueColor()
            self.reloadIndicator.startAnimating()
        
        }
    }
    
    func stopReloadIndicator(forButton:UIBarButtonItem?){
        
        if(forButton != nil){
            
            self.reloadIndicator.stopAnimating()
            forButton!.customView = nil            
        }
    }
    
    
    func performLogout(){
        
        
        UdacityClient.logoutOfUdacity { (success, error) -> Void in
            println(success)
            
            if(error != nil){
                
                self.addStatusView()                
                self.displayErrorMessage(error!)
            
            }
        }
        
        let FBSession = FBSDKLoginManager()
        FBSession.logOut()
        FBSDKAccessToken.setCurrentAccessToken(nil)
        
        self.cache.userData = nil
        self.dismissViewControllerAnimated(true, completion: nil)
    
    }
    
    func validateURLString(URLString: String) -> NSURL?{
        
        var validationError: NSError?
        
        let pattern = "(https?|ftp)://(-\\.)?([^\\s/?\\.#-]+\\.?)+(/[^\\s]*)?$"
        let regex = NSRegularExpression(pattern: pattern, options: NSRegularExpressionOptions.CaseInsensitive, error: &validationError)
        
        let matches = regex!.matchesInString(URLString, options: NSMatchingOptions.allZeros, range: NSMakeRange(0, count(URLString)))
        
        if (matches.count > 0){
            
            return NSURL(string: URLString)!
        
        }
        
        let errorDescription = "The URL is not valid"
        let errorInfo = [NSLocalizedDescriptionKey: errorDescription]
        
        
        let errorMessage = NSError(domain: "invalidURLError", code: 99, userInfo: errorInfo)
        
        self.addStatusView()
        self.displayErrorMessage(errorMessage)
        
        
        return nil
        
    }

    

}
