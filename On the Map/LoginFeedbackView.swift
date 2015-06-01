//
//  SpinnerView.swift
//  On the Map
//
//  Created by Johannes Eichler on 25.05.15.
//  Copyright (c) 2015 Eichler. All rights reserved.
//
// This view displays an overlay with a spinner that indicates that a network or file operation in progress

import UIKit



class LoginFeedbackView: UIView, ErrorDialogDelegate {
    
    var spinner: UIActivityIndicatorView!
    var spinnerArea: UIView!
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        self.backgroundColor = UIColor(hue: 0.07, saturation: 0, brightness: 0.75, alpha: 0.7)
    
        self.spinner = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
        self.spinner.frame = CGRectMake(0.0, 0.0, 40.0, 40.0)
        self.spinner.center = self.center
        self.spinner.hidesWhenStopped = true
        
        self.spinnerArea = UIView(frame: CGRectMake(0.0, 0.0, 80.0, 80.0))
        self.spinnerArea.backgroundColor =  UIColor(hue: 0.07, saturation: 0, brightness: 0.5, alpha: 1.0)
        self.spinnerArea.clipsToBounds = true
        self.spinnerArea.layer.cornerRadius = 10
        
        self.spinnerArea.addSubview(spinner)
        
        self.spinnerArea.center = self.center
        self.spinner.center = CGPointMake(self.spinnerArea.frame.width / 2.0, self.spinnerArea.frame.height / 2.0)
        
        self.addSubview(spinnerArea)
    }
    
    
    func recenterSpinner(){
        
        // Usually called when size of owning view has changed to recenter the spinner
        //test
        
        self.spinner.center = self.center
    }
    
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    func start(){
        
        // Start spinner animation

        self.spinner.startAnimating()
    
    }
    
    func stop(){
        
        self.spinner.stopAnimating()
        self.removeFromSuperview()            
       
    }
    
    

    
    
    func showLoginErrorMessage(errorMessage:String){
        
        //Displays a custom error message for an login error.
        
        self.spinner.stopAnimating()
        
        let loginErrorMessage = ErrorDialog()
        loginErrorMessage.delegate = self
        loginErrorMessage.messageLabel.text = errorMessage
        
        loginErrorMessage.alpha = CGFloat(0)
        
        UIView.animateWithDuration(1.0, delay: 0, options: UIViewAnimationOptions.AllowUserInteraction, animations: { () -> Void in
            self.spinnerArea.frame.size = CGSize(width: 300.0, height: 100.0)
            self.spinnerArea.backgroundColor = UIColor.redColor()
            
            self.spinnerArea.center = self.center

            }) { (completed) -> Void in
                
        }
        
        UIView.animateWithDuration(1.0, delay: 1.0, options: UIViewAnimationOptions.AllowUserInteraction, animations: { () -> Void in

            self.spinnerArea.addSubview(loginErrorMessage)
            loginErrorMessage.alpha = 1.0
            }) { (completed) -> Void in
                
        }
        
    }
    
    // Delegate methods to handle ErrorDialog buttons
    
    func errorDialogRetryButtonPressed() {
        self.removeFromSuperview()
    }
    
    
    func errorDialogCloseButtonPressed() {
        self.removeFromSuperview()
    }
    

}
