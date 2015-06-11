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
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.cache.locations!.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell
        
        let currentDict = self.cache.locations![indexPath.row]
        
        let firstName: String = currentDict["firstName"] as! String
        let lastName: String = currentDict["lastName"] as! String
        let mediaURL: String = currentDict["mediaURL"] as! String
        
        cell.textLabel!.text = "\(firstName) \(lastName)"
        cell.detailTextLabel!.text = "\(mediaURL)"
        
        return cell
        
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
