//
//  ErrorDialog.swift
//  On the Map
//
//  Created by Johannes Eichler on 31.05.15.
//  Copyright (c) 2015 Eichler. All rights reserved.
//

import UIKit
import CoreGraphics



@objc protocol ErrorDialogDelegate {
    
    func errorDialogCloseButtonPressed() -> Void
    optional func errorDialogRetryButtonPressed() -> Void

}

class ErrorDialog: UIView
{
    
    var delegate: ErrorDialogDelegate?
    var hasRetryButton:Bool!
    var messageLabel:UILabel!
    var symbolArea: UIImageView?
    
    var closeButton:UIButton!
    var retryButton:UIButton?
    
    
    let buttonSize: CGSize = CGSizeMake(50.0, 16.0)

    init(){
        
        super.init(frame:CGRectMake(0.0, 0.0, 300.0, 125.0 ))
                        
        let centerPos: CGPoint = CGPointMake((self.frame.width / 2.0) - (self.buttonSize.width / 2.0), 100.0)
        
        self.layer.cornerRadius = 10


        self.closeButton = UIButton(frame: CGRectMake(centerPos.x, centerPos.y, self.buttonSize.width, self.buttonSize.height))
        self.closeButton.setTitle("Close", forState: UIControlState.Normal)
        self.closeButton.addTarget(self, action: "closeWarning:", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.messageLabel = UILabel(frame: CGRectMake(0, 0, 250, 57))
        self.messageLabel.center = self.center
        self.messageLabel.textAlignment = NSTextAlignment.Center
        self.messageLabel.font = UIFont.boldSystemFontOfSize(12.0)
        self.messageLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        self.messageLabel.numberOfLines = 0
        
        var messageIcon = UIImage(named: "messageIcon")
        

        self.symbolArea = UIImageView(image: messageIcon)
        self.symbolArea!.frame = CGRectMake(120, -30, 60, 60)

        
        self.addSubview(self.symbolArea!)
        self.addSubview(closeButton)
        self.addSubview(messageLabel)
        
        self.backgroundColor = UIColor(red: 1.000, green: 0.606, blue: 0.016, alpha: 1.000)
        
    
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addRetryButton(){
        
        //Render a version of the dialog with the retry buttonv when connection problems did occur
        
        self.retryButton = UIButton(frame: CGRectMake(50.0, 100.0, self.buttonSize.width, self.buttonSize.height))
        self.retryButton!.setTitle("Retry", forState: UIControlState.Normal)
        self.retryButton!.addTarget(self, action: "retry:", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.closeButton.center.x = 225.0
        self.addSubview(self.retryButton!)
        
    }
    
    func setErrorMessage(error:NSError){
        
        //Build error Message String
        
        var errorMessage: String = "\(error.domain)" + " \(String(error.code))"
        
        //Add RecoverySuggestion only if there actually is one
        
        if let suggestion = error.userInfo?[NSLocalizedRecoverySuggestionErrorKey] as? String{
            
            errorMessage += " \(suggestion)"
        }
        
        // For kCLErrorMessages without value set for NSLocalizedDescriptionKey
        
        if(error.userInfo?[NSLocalizedDescriptionKey] == nil){
            
            errorMessage = "\(error.description)"
        }
        else{
            
            errorMessage += ": \(error.userInfo![NSLocalizedDescriptionKey]!)"
        
        }
        
        self.messageLabel.text = errorMessage
    
    }
    
    
    
    //Call the delegate methods to handle the button taps in the error dialog
    
    func closeWarning(sender:UIButton){
        delegate!.errorDialogCloseButtonPressed()
    }
    
    func retry(sender:UIButton){        
        delegate!.errorDialogRetryButtonPressed!()
    
    }
    
    

    
}