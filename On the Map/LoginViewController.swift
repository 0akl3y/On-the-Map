//  LoginViewController.swift
//  On the Map
//
//  Created by Johannes Eichler on 19.05.15.
//  Copyright (c) 2015 Eichler. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, LoginFeedbackDelegate {
    
    var activityIndicator: LoginFeedbackView?
    var session: UdacityClient? //keep a strong reference to the current session
    
    
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
        
    }

    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {
        
        //rescale when device orientation is changed
        self.activityIndicator?.frame.size = size
        self.activityIndicator?.recenterSpinner()
    }
    
    func startActivityIndicator(){
        
        self.activityIndicator = LoginFeedbackView(frame: self.view.frame)
        self.activityIndicator!.delegate = self
        self.view.addSubview(activityIndicator!)
        self.activityIndicator!.start()
    
    }
        
    
    func handleLoginResponse(success: Bool, error: NSError?){
        
        if(success){
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                self.activityIndicator?.stop()
                self.performSegueWithIdentifier("login", sender: self)
            })
        }
            
        else{
            
            if var currentError = error{
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    var errorDomain: String = error!.domain
                    self.activityIndicator?.showLoginErrorMessage(self.generateErrorMessageString(error!), errorDomain: errorDomain)
                })
                
            }
            
        }
    
    }
    
    func generateErrorMessageString(error: NSError) -> String{
        
        //Build error Message String
        
        var errorMessage: String = "\(error.domain)" + " \(String(error.code))" + ": " + "\(error.userInfo![NSLocalizedDescriptionKey]!)"
        
        
        //Add RecoverySuggestion only if there actually is one
        
        if let suggestion = error.userInfo?[NSLocalizedRecoverySuggestionErrorKey] as? String{
            
            errorMessage += " \(suggestion)"
            
        }
        
        return errorMessage
    
    }
    
    @IBAction func proceedLogin(sender: UIButton) {
        
        self.startActivityIndicator()
        
        self.session = UdacityStandardLogin(username: self.emailField.text, password: self.passwordField.text)
        self.session!.POSTSessionRequest { (success, error) -> Void in
                        
            self.handleLoginResponse(success, error: error)
            
            }
        }
    
    @IBAction func proceedSignup(sender: UIButton) {}
    
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
            
                    self.activityIndicator!.stop()
                    self.handleLoginResponse(success, error: error)
                    
                })
            }
            
            else{
                
                self.activityIndicator!.stop()
                self.handleLoginResponse(false, error: FBerror)
            
            }
        }
    }
    
    func didActivateRetryAction() {
        //delegate method that is called when retry is tapped
        
        self.activityIndicator!.removeFromSuperview()
        
        self.startActivityIndicator()
        self.session!.POSTSessionRequest { (success, error) -> Void in
            
            self.handleLoginResponse(success, error: error)
            
        }
    }
}