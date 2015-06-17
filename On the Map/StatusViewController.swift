//
//  StatusViewController.swift
//  On the Map
//
//  Created by Johannes Eichler on 15.06.15.
//  Copyright (c) 2015 Eichler. All rights reserved.
//
// This View Controller provides the views for  error message handling and activity indication

import UIKit

@objc protocol StatusViewDelegate {
    
    //called when a retry button was pressed in an ErrorDialog
    
    func didActivateRetryAction()
    optional func didCloseErrorDialog()
    
}

class StatusViewController: UIViewController, ErrorDialogDelegate {
    
    var delegate: StatusViewDelegate?
    
    var backgroundColor:UIColor!
    var error: NSError?
    var dialogWindow: ErrorDialog?
    
    var spinner:UIActivityIndicatorView?
    var spinnerArea:UIView?
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        
    }
    
    override func viewWillLayoutSubviews() {
        
        self.view.backgroundColor = UIColor(hue: 0.07, saturation: 0, brightness: 0.75, alpha: 0.5)
        self.view.frame = self.parentViewController!.view.frame
        
        super.viewWillLayoutSubviews()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        
    }
    
    override func viewWillTransitionToSize(size: CGSize, withTransitionCoordinator coordinator: UIViewControllerTransitionCoordinator) {

            let centerPosition = CGPointMake(size.width / 2, size.height / 2)        
            self.view.frame = CGRectMake(centerPosition.x, centerPosition.y, size.width, size.height)
        
            self.dialogWindow?.center = centerPosition
            self.spinnerArea?.center = centerPosition
    }
    
    override func viewDidDisappear(animated: Bool) {
        self.delegate?.didCloseErrorDialog?()
    }
    
    
    func showLoginErrorMessage(){
        
        //Displays a custom error message for an login error.
        
        self.dialogWindow = ErrorDialog()        
        self.dialogWindow!.delegate = self
        
        var errorDomain = self.error?.domain
        self.spinner?.stopAnimating()
        
        self.dialogWindow?.setErrorMessage(self.error!)
        self.dialogWindow?.center = self.view.center
        self.view.addSubview(self.dialogWindow!)
        
        //Only add a retry button if it is a network connection related error
        
        if(errorDomain != "UdacityClientLoginError"){
            
            self.dialogWindow!.addRetryButton()
        }
        
        self.dialogWindow!.alpha = CGFloat(0)
        
        
        UIView.animateWithDuration(0.4, delay: 0, options: UIViewAnimationOptions.AllowUserInteraction, animations: { () -> Void in
            
            self.spinnerArea?.backgroundColor = UIColor.clearColor()
            self.dialogWindow!.center = self.view.center
            
            }) { (completed) -> Void in
                
        }
        
        UIView.animateWithDuration(0.4, delay: 0.4, options: UIViewAnimationOptions.AllowUserInteraction, animations: { () -> Void in
            
            
            self.view.addSubview(self.dialogWindow!)
            
            self.dialogWindow!.alpha = 1.0
            }) { (completed) -> Void in
                
                
        }
        
    }
    
    func removeStatusView(){
        
        UIView.animateWithDuration(0.4, animations: { () -> Void in
            
            self.dialogWindow!.alpha = 0
            self.view.alpha = 0
            
            }) { (Bool) -> Void in
                
                self.willMoveToParentViewController(nil)
                self.view.removeFromSuperview()
                self.removeFromParentViewController()
        }
    }
    
    func errorDialogCloseButtonPressed() {
        
        self.removeStatusView()
        
    }
    
    func errorDialogRetryButtonPressed() {                
        
        self.delegate?.didActivateRetryAction()
        self.removeStatusView()
        
    }
    
    func addSpinnerArea() {
        
        self.backgroundColor = UIColor(hue: 0.07, saturation: 0, brightness: 0.75, alpha: 0.7)
        
        self.spinner = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
        self.spinner!.frame = CGRectMake(0.0, 0.0, 40.0, 40.0)
        self.spinner!.center = self.view.center
        self.spinner!.hidesWhenStopped = true
        
        self.spinnerArea = UIView(frame: CGRectMake(0.0, 0.0, 80.0, 80.0))
        self.spinnerArea!.backgroundColor =  UIColor(hue: 0.07, saturation: 0, brightness: 0.5, alpha: 1.0)
        self.spinnerArea!.clipsToBounds = true
        self.spinnerArea!.layer.cornerRadius = 10
        
        self.spinnerArea!.addSubview(spinner!)
        
        self.spinnerArea!.center = self.view.center
        self.spinner!.center = CGPointMake(self.spinnerArea!.frame.width / 2.0, self.spinnerArea!.frame.height / 2.0)
        
        self.view.addSubview(spinnerArea!)
        
    }
    
    func startSpinner(){
        
        // Start spinner animation
        self.addSpinnerArea()
        self.spinner!.startAnimating()
        
    }
    
    func stopSpinner(){
        
        self.spinner!.stopAnimating()
        self.spinnerArea!.removeFromSuperview()
        
    }
    
    
}
