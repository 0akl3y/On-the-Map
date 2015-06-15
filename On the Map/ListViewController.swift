//
//  ListViewController.swift
//  On the Map
//
//  Created by Johannes Eichler on 11.06.15.
//  Copyright (c) 2015 Eichler. All rights reserved.
//

import UIKit




class ListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    

    @IBOutlet weak var listView: UITableView!

    var cache:CachedResponses {
        get{ return CachedResponses.cachedResponses() }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var parseClient = ParseClient()
        if (self.cache.locations.count < 1){
            
            parseClient.GETStudentLocations { (result, error) -> Void in
                for locationEntry in result! {
                    
                    let newLocations = StudentLocation(placeAttributeDict: locationEntry)
                    self.cache.locations.append(newLocations)
                    
                }
            }
        }        
        
        listView.delegate = self
        listView.dataSource = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
    

    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        
    }

}
