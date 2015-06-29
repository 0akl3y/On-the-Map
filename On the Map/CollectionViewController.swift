//
//  CollectionViewController.swift
//  On the Map
//
//  Created by Johannes Eichler on 24.06.15.
//  Copyright (c) 2015 Eichler. All rights reserved.
//

import UIKit

class CollectionViewController: DataViewController, UICollectionViewDataSource, UICollectionViewDelegate, StatusViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.addButtons()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadLocations(){
        
        var parseClient = ParseClient()
        parseClient.GETStudentLocations { (error) -> Void in
            
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                self.stopReloadIndicator(self.reloadLocationsButton)
                
                if(error != nil){
                    self.addStatusView()
                    self.errorMessageVC!.delegate = self
                    self.displayErrorMessage(error!)
                    self.updateButtonStatus()
                    return
                }
                
                self.collectionView.reloadData()
                self.collectionView.setNeedsDisplay()
                
            })
            
        }
    }
    
    override func reloadLocation(sender: UIBarButtonItem) {
        
        self.cache.locations.removeAll(keepCapacity: false)
        self.loadLocations()
        self.startReloadIndicator(sender)

    }
    
    override func addLocation(sender: UIBarButtonItem) {
        
        self.performSegueWithIdentifier("collectionToSearch", sender: self)
        
    }
    
    func didActivateRetryAction() {
        
        self.loadLocations()
    
    }
    
    func didCloseErrorDialog() {}
    
    
    //Collection View Delegate Methods
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.cache.locations.count
        
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var cell = collectionView.dequeueReusableCellWithReuseIdentifier("collectionCell", forIndexPath: indexPath) as? UICollectionViewCell
        
        let currentLocation = self.cache.locations[indexPath.row] as StudentLocation
        
        let firstName: String = currentLocation.firstName
        let lastName: String = currentLocation.lastName
        let mediaURL: String = currentLocation.mediaURL!
        
        var nameLabel = cell!.contentView.viewWithTag(1) as! UILabel
        var surnameLabel = cell!.contentView.viewWithTag(2) as! UILabel
        var URLLabel = cell!.contentView.viewWithTag(3) as! UILabel
        
        nameLabel.text = "\(firstName)"
        surnameLabel.text = "\(lastName)"
        URLLabel.text = "\(mediaURL)"
        
        
        return cell!
        
    }
    
    func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {

        var mediaLink = self.cache.locations[indexPath.row].mediaURL
        if let link = self.validateURLString(mediaLink!){
            
            let app = UIApplication.sharedApplication()
            app.openURL(link)
        }
    }
}
