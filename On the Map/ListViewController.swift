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
        if (self.cache.locations == nil){
            
            parseClient.GETStudentLocations { (result, error) -> Void in
                self.cache.locations = result
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
        return self.cache.locations!.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell
        
        let currentLocation = self.cache.locations![indexPath.row]
        
        let firstName: String = currentLocation["firstName"] as! String
        let lastName: String = currentLocation["lastName"] as! String
        let mediaURL: String = currentLocation["mediaURL"] as! String
        
        cell.textLabel!.text = "\(firstName) \(lastName)"
        cell.detailTextLabel!.text = "\(mediaURL)"
        
        return cell
        
    }
    

    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        
    }

}
