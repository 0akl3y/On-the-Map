//
//  ErrorDialog.swift
//  On the Map
//
//  Created by Johannes Eichler on 31.05.15.
//  Copyright (c) 2015 Eichler. All rights reserved.
//

import UIKit

protocol ErrorDialogDelegate {
    
    func errorDialogRetryButtonPressed() -> Void
    func errorDialogCloseButtonPressed() -> Void

}

class ErrorDialog: UIView
{
    
    var delegate: ErrorDialogDelegate?
    var hasRetryButton:Bool!
    var messageLabel:UILabel!
    
    
    init(){
        
        super.init(frame:CGRectMake(0.0, 0.0, 300.0, 100.0 ))
        
        var buttonSize: CGSize = CGSizeMake(50.0, 16.0)
        
        let retryButton = UIButton(frame: CGRectMake(50.0, 74.0, buttonSize.width, buttonSize.height))
        retryButton.setTitle("Retry", forState: UIControlState.Normal)
        retryButton.addTarget(self, action: "retry:", forControlEvents: UIControlEvents.TouchUpInside)
        
        let closeButton = UIButton(frame: CGRectMake(200.0, 74.0, buttonSize.width, buttonSize.height))
        closeButton.setTitle("Close", forState: UIControlState.Normal)
        closeButton.addTarget(self, action: "closeWarning:", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.messageLabel = UILabel(frame: CGRectMake(25, 10, 250, 57))
        self.messageLabel.textAlignment = NSTextAlignment.Left
        self.messageLabel.font = UIFont.boldSystemFontOfSize(10.0)
        self.messageLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        self.messageLabel.drawTextInRect(CGRectMake(25, 10, 250, 57))
        
        
        self.addSubview(retryButton)
        self.addSubview(closeButton)
        self.addSubview(messageLabel)
    
    }
    
    
    func setErrorMessage(errorMessage:String){
        
        self.messageLabel.text = errorMessage
    
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func closeWarning(sender:UIButton){
        delegate!.errorDialogCloseButtonPressed()
    }
    
    
    
    
    func retry(sender:UIButton){        
        delegate!.errorDialogRetryButtonPressed()
    
    }
    
    

    
}