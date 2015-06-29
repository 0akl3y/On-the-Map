//  ListViewController.swift
//  On the Map
//
//  Created by Johannes Eichler on 11.06.15.
//  Copyright (c) 2015 Eichler. All rights reserved.
//

import UIKit

class ListViewController: DataViewController, UITableViewDelegate, UITableViewDataSource, StatusViewDelegate {
    
    @IBOutlet weak var listView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.addButtons()
        
        
        if (self.cache.locations.count < 1){
            
            self.loadLocations()

        }
        
        listView.delegate = self
        listView.dataSource = self

    }
    
    func loadLocations(){
        
        var parseClient = ParseClient()
        parseClient.batchLoadLocations({ () -> Void in
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                self.stopReloadIndicator(self.reloadLocationsButton)
                self.listView.reloadData()
                
            })
            
        }, failure: { (error) -> Void in
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                self.stopReloadIndicator(self.reloadLocationsButton)
                
                self.addStatusView()
                self.errorMessageVC!.delegate = self
                self.displayErrorMessage(error)
                self.updateButtonStatus()
                return
            })
        })
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.cache.locations.count
        
    }
        
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell
        
        let currentLocation = self.cache.locations[indexPath.row] as StudentLocation
        
        let firstName: String = currentLocation.firstName
        let lastName: String = currentLocation.lastName
        let mediaURL: String = currentLocation.mediaURL!
        
        cell.textLabel!.text = "\(firstName) \(lastName)"
        cell.detailTextLabel!.text = "\(mediaURL)"
        
        return cell
        
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        var mediaLink = self.cache.locations[indexPath.row].mediaURL
        
            if let link = self.validateURLString(mediaLink!){
                
                let app = UIApplication.sharedApplication()
                app.openURL(link)
            }
    }
    
    
    override func addLocation(sender: UIBarButtonItem) {
        
        self.performSegueWithIdentifier("listToSearch", sender: self)
        
    }

    override func reloadLocation(sender: UIBarButtonItem) {
        
        self.cache.locations.removeAll(keepCapacity: false)
        self.loadLocations()
        self.startReloadIndicator(sender)
        
    }
    
    func didActivateRetryAction() {
        
    }
    
    func didCloseErrorDialog() {
        
        self.updateButtonStatus()
        
    }
    
}
