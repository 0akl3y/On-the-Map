//
//  DataViewController.swift
//  On the Map
//
//  Created by Johannes Eichler on 24.06.15.
//  Copyright (c) 2015 Eichler. All rights reserved.
//

import UIKit

class DataViewController: AbstractViewController{
    
    var logoutButton:UIBarButtonItem!
    var addLocationButton: UIBarButtonItem!
    var reloadLocationsButton: UIBarButtonItem?
    
    func addButtons(){
        
        self.logoutButton = UIBarButtonItem(title: "Logout", style: UIBarButtonItemStyle.Plain, target: self, action: "logout:")
        self.addLocationButton = UIBarButtonItem(image: UIImage(named: "pin"), style: UIBarButtonItemStyle.Plain, target: self, action: "addLocation:")
        self.reloadLocationsButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Refresh, target: self, action: "reloadLocation:")
        
        self.navigationItem.leftBarButtonItem = self.logoutButton
        self.navigationItem.rightBarButtonItems = [self.addLocationButton, self.reloadLocationsButton!]
        
    }
    
    func logout(sender:UIBarButtonItem){
        
        self.performLogout()
        
    }
    
    func addLocation(sender:UIBarButtonItem){}
    
    func reloadLocation(sender:UIBarButtonItem){}
    
    func updateButtonStatus(){
        //Disable the reloadButton when an error message is presented
        
        if(self.errorMessageVC != nil){
            
            var buttonsEnabled = (!self.errorMessageVC!.view.isDescendantOfView(self.view))
            
            self.reloadLocationsButton!.enabled = buttonsEnabled
            self.addLocationButton.enabled = buttonsEnabled
            self.logoutButton.enabled = buttonsEnabled
            
        }
    }

}
