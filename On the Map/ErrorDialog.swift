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
        
        super.init(frame:CGRectMake(0.0, 50.0, 300.0, 100.0 ))
                        
        var centerPos: CGPoint = CGPointMake((self.frame.width / 2.0) - (self.buttonSize.width / 2.0), 74.0)
        
        self.layer.cornerRadius = 10

        self.closeButton = UIButton(frame: CGRectMake(centerPos.x, centerPos.y, self.buttonSize.width, self.buttonSize.height))
        self.closeButton.setTitle("Close", forState: UIControlState.Normal)
        self.closeButton.addTarget(self, action: "closeWarning:", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.messageLabel = UILabel(frame: CGRectMake(25, 15, 250, 57))
        self.messageLabel.textAlignment = NSTextAlignment.Left
        self.messageLabel.font = UIFont.boldSystemFontOfSize(12.0)
        self.messageLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        self.messageLabel.numberOfLines = 0 as Int
        
        
        var messageIcon = UIImage(named: "messageIcon")
        

        self.symbolArea = UIImageView(image: messageIcon)
        self.symbolArea!.frame = CGRectMake(125, -25, 50, 50)

        
        self.addSubview(self.symbolArea!)
        self.addSubview(closeButton)
        self.addSubview(messageLabel)
        
        self.backgroundColor = UIColor(red: 1.000, green: 0.896, blue: 0.000, alpha: 1)
        
    
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func addRetryButton(){
        
        //Render a version of the dialog with the retry button when connection problems did occur
        
        self.retryButton = UIButton(frame: CGRectMake(50.0, 74.0, self.buttonSize.width, self.buttonSize.height))
        self.retryButton!.setTitle("Retry", forState: UIControlState.Normal)
        self.retryButton!.addTarget(self, action: "retry:", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.closeButton.center.x = 225.0
        self.addSubview(self.retryButton!)
        
    }
    
    func setErrorMessage(errorMessage:String){
        
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