//  LoginViewController.swift
//  On the Map
//
//  Created by Johannes Eichler on 19.05.15.
//  Copyright (c) 2015 Eichler. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, StatusViewDelegate {
    
    var activityIndicatorVC:StatusViewController?
    var session: UdacityClient?
    
    var cache:CachedResponses {
        get{ return CachedResponses.cachedResponses() }
    }
    
    @IBOutlet weak var emailField: UITextField!
    @IBOutlet weak var passwordField: UITextField!

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
        
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        passwordField.secureTextEntry = true

        FBSDKProfile.enableUpdatesOnAccessTokenChange(true)
        
        if (FBSDKAccessToken.currentAccessToken() != nil) {
            
            self.startActivityIndicator()
            
            if var accessToken = FBSDKAccessToken.currentAccessToken().tokenString{
                let session = UdacityFacebookAuth(accessToken: accessToken)
                session.POSTSessionRequest({ (success, error) -> Void in
                    
                    self.handleLoginResponse(success, error: error)
                
                })
            }
            
        }
        
    }
    
    override func viewWillAppear(animated: Bool) {
        
        super.viewWillAppear(true)
        self.emailField.text = nil
        self.passwordField.text = nil
        
    }
    
    func startActivityIndicator(){
        
        self.activityIndicatorVC = StatusViewController()       
        self.addChildViewController(self.activityIndicatorVC!)
        self.view.addSubview(self.activityIndicatorVC!.view)
        self.activityIndicatorVC!.didMoveToParentViewController(self)
        
        self.activityIndicatorVC!.delegate = self

        self.activityIndicatorVC!.startSpinner()
    
    }
        
    
    func handleLoginResponse(success: Bool, error: NSError?){
        
        if(success){
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                self.activityIndicatorVC!.stopSpinner()
                self.activityIndicatorVC!.removeStatusView()
                let key = self.session!.userKey
                let userData = UserModel(userKey: key!, session: self.session!)
                self.cache.userData = userData
                
                self.performSegueWithIdentifier("login", sender: self)
                
            })
        }
            
        else{
            
            if var currentError = error{
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    self.activityIndicatorVC!.error = error
                    self.activityIndicatorVC!.showLoginErrorMessage()
                })
                
            }
            
        }
    
    }
        
    
    @IBAction func proceedLogin(sender: UIButton) {
        
        //proceed the standard login to udacity
        
        self.startActivityIndicator()
        
        self.session = UdacityStandardLogin(username: self.emailField.text, password: self.passwordField.text)
        self.session!.POSTSessionRequest { (success, error) -> Void in
                        
            self.handleLoginResponse(success, error: error)
            
            }
        }
    
    @IBAction func proceedSignup(sender: UIButton) {
        
        let signupURL = NSURL(string: "https://www.udacity.com/account/auth#!/signup)")
        UIApplication.sharedApplication().openURL(signupURL!)
    
    }
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        println("Customer logged out")
        FBSDKAccessToken.setCurrentAccessToken(nil)
    }    

    @IBAction func proceedFBLogin(sender: UIButton) {
        
        self.startActivityIndicator()
        
        let FBSession = FBSDKLoginManager()
        FBSession.logInWithReadPermissions(["public_profile", "email", "user_friends"]) { (FBResponse, FBerror) -> Void in
            
            if var accessToken = FBSDKAccessToken.currentAccessToken()?.tokenString{
                
                self.session = UdacityFacebookAuth(accessToken: accessToken)
                self.session!.POSTSessionRequest({ (success, error) -> Void in
            
                    self.activityIndicatorVC!.stopSpinner()
                    self.handleLoginResponse(success, error: error)
                    
                })
            }
            
            else{
                
                self.activityIndicatorVC!.stopSpinner()
                self.activityIndicatorVC!.removeStatusView()
                self.handleLoginResponse(false, error: FBerror)
            
            }
        }
    }
    
    func didActivateRetryAction() {
        //delegate method that is called when retry is tapped
        
        self.activityIndicatorVC!.removeStatusView()
        
        self.startActivityIndicator()
        self.session!.POSTSessionRequest { (success, error) -> Void in
            
            self.handleLoginResponse(success, error: error)
            
        }
    }
}