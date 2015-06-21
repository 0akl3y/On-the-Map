//
//  URLInputViewController.swift
//  On the Map
//
//  Created by Johannes Eichler on 21.06.15.
//  Copyright (c) 2015 Eichler. All rights reserved.
//

import UIKit
import MapKit

class URLInputViewController: AbstractViewController,  StatusViewDelegate {

    @IBOutlet weak var mapPreview: MKMapView!
    @IBOutlet weak var mapActiviyIndicator: UIActivityIndicatorView!
    var placeToSearch: String!
    var firstResult:CLPlacemark?
    
    @IBOutlet weak var mediaURL: UITextField!
    

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    override func viewWillAppear(animated: Bool) {
        self.view.alpha = 0
        self.geocodePlacename(self.placeToSearch)
    }
    
    
    override func viewDidAppear(animated: Bool) {
                        
        UIView.animateWithDuration(1, animations: { () -> Void in
            self.view.alpha = 1
            }) { (completed) -> Void in
        }
    }
    
    
    func geocodePlacename(placeName: String){
        
        //Forward geocodes the placename string an returns the location
        
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(placeName, completionHandler: { (placemarks, error) -> Void in
            
            if(error != nil){
                
                
                self.mapActiviyIndicator.stopAnimating()
                self.mapActiviyIndicator.alpha = 0
                self.addStatusView()
                self.errorMessageVC!.delegate = self
                self.displayErrorMessage(error)
                
                return
            }
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                
                self.mapActiviyIndicator.stopAnimating()
                self.mapActiviyIndicator.alpha = 0
                self.mediaURL.alpha = 1.0
                self.firstResult = placemarks[0] as? CLPlacemark
                println(self.firstResult?.location)
                
                let newAnnotation = MKPointAnnotation()
                newAnnotation.title = self.placeToSearch
                newAnnotation.coordinate = self.firstResult!.location.coordinate
                
                
                
                self.mapPreview.addAnnotation(newAnnotation)

            })
        })
        
        mapActiviyIndicator.startAnimating()
        
        
    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    
    func createStudentLocation(userLocation: CLLocation, mediaURL: String) -> StudentLocation{
        
        var currentLocationDict: [String: AnyObject] = [StudentLocationKey.firstNameKey.rawValue : self.cache.userData!.firstName!,
            StudentLocationKey.mapStringKey.rawValue: self.placeToSearch,
            StudentLocationKey.uniqueKeyKey.rawValue: self.cache.userData!.uniqueKey!,
            StudentLocationKey.lastNameKey.rawValue : self.cache.userData!.lastName!,
            StudentLocationKey.latitudeKey.rawValue: userLocation.coordinate.longitude as Double,
            StudentLocationKey.longitudeKey.rawValue: userLocation.coordinate.latitude as Double,
            StudentLocationKey.mediaURLKey.rawValue: mediaURL ]
        
        
        let userLocation = StudentLocation(placeAttributeDict: currentLocationDict)
        
        return userLocation
    }
    
    
    @IBAction func confirm(sender: UIButton) {
        
        //Todo Validierung einbauen

        let newLocation = self.createStudentLocation(firstResult!.location, mediaURL: self.mediaURL.text)
        
        let parseClient = ParseClient()
        
        parseClient.POSTStudentLocations(newLocation, completion: { (result, error) -> Void in
            println(error)
            println(result)
        })
        
        
    }
    
    
    func removeView(){
        
        UIView.animateWithDuration(0.4, animations: { () -> Void in
            
            self.view.alpha = 0
            
            }) { (Bool) -> Void in
                
                self.willMoveToParentViewController(nil)
                self.view.removeFromSuperview()
                self.removeFromParentViewController()
        }
    }
    
    
    
    func didActivateRetryAction() {
        
    }
    
    func didCloseErrorDialog() {
        
        self.removeView()

    }

}
