//
//  SpinnerView.swift
//  On the Map
//
//  Created by Johannes Eichler on 25.05.15.
//  Copyright (c) 2015 Eichler. All rights reserved.
//
// This view displays an overlay with a spinner that indicates that a network or file operation in progress

import UIKit

class SpinnerView: UIView {
    
    var spinner: UIActivityIndicatorView!
    
    override init(frame: CGRect) {
        
        super.init(frame: frame)
        self.backgroundColor = UIColor(hue: 26.0, saturation: 0, brightness: 75.0, alpha: 0.7)
    
        self.spinner = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
        self.spinner.frame = CGRectMake(0.0, 0.0, 40.0, 40.0);
        self.spinner.center = self.center
        self.spinner.hidesWhenStopped = true
        
        self.addSubview(spinner)
    }
    
    
    func recenterSpinner(){
        
        // Usually called when sizw of owning view has changed to recenter the spinner
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
    
    }
    

    


}
