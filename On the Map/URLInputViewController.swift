//
//  URLInputViewController.swift
//  On the Map
//
//  Created by Johannes Eichler on 21.06.15.
//  Copyright (c) 2015 Eichler. All rights reserved.
//

import UIKit
import MapKit

class URLInputViewController: AbstractViewController,  StatusViewDelegate, MKMapViewDelegate, UITextFieldDelegate {

    @IBOutlet weak var mapPreview: MKMapView!
    @IBOutlet weak var mapActiviyIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var browseButton: UIButton!
    
    var placeToSearch: String!
    var firstResult:CLPlacemark?
    
    @IBOutlet weak var mediaURL: UITextField!
    
    var previewURL: NSURL!

    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapPreview.delegate = self

    }
    
    override func viewWillAppear(animated: Bool) {
        self.geocodePlacename(self.placeToSearch)
    }
    
    
    override func viewDidAppear(animated: Bool) {
        
        self.mediaURL.delegate = self
                        
        /* UIView.animateWithDuration(1, animations: { () -> Void in
            self.view.alpha = 1
            }) { (completed) -> Void in
        }*/
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
                
                let newAnnotation = MKPointAnnotation()
                newAnnotation.title = self.placeToSearch
                newAnnotation.coordinate = self.firstResult!.location.coordinate
                
                self.mapPreview.addAnnotation(newAnnotation)

            })
        })
        
        mapActiviyIndicator.startAnimating()

        
    }

    
    func mapViewDidFinishRenderingMap(mapView: MKMapView!, fullyRendered: Bool) {
        var viewPoint = CLLocationCoordinate2DMake(self.firstResult!.location.coordinate.latitude - 0.1, self.firstResult!.location.coordinate.longitude)
        
        var zoomedCamera = MKMapCamera(lookingAtCenterCoordinate: self.firstResult!.location.coordinate, fromEyeCoordinate:viewPoint, eyeAltitude: 50000.0 as CLLocationDistance)
        
        self.mapPreview.setCamera(zoomedCamera, animated: true)
    }

    
    
    
    func createStudentLocation(userLocation: CLLocation, mediaURL: String) -> StudentLocation{
        
        var currentLocationDict: [String: AnyObject] = [StudentLocationKey.firstNameKey.rawValue : self.cache.userData!.firstName!,
            StudentLocationKey.mapStringKey.rawValue: self.placeToSearch,
            StudentLocationKey.uniqueKeyKey.rawValue: self.cache.userData!.uniqueKey!,
            StudentLocationKey.lastNameKey.rawValue : self.cache.userData!.lastName!,
            StudentLocationKey.latitudeKey.rawValue: userLocation.coordinate.latitude as Double,
            StudentLocationKey.longitudeKey.rawValue: userLocation.coordinate.longitude as Double,
            StudentLocationKey.mediaURLKey.rawValue: mediaURL ]
        
        
        let userLocation = StudentLocation(placeAttributeDict: currentLocationDict)
        
        return userLocation
    }
    
    @IBAction func confirm(sender: UIButton) {
        
        let newLocation = self.createStudentLocation(firstResult!.location, mediaURL: self.mediaURL.text)
        
        let parseClient = ParseClient()
        
        parseClient.POSTStudentLocations(newLocation, completion: { (result, error) -> Void in
            
            if(error != nil){
                
                self.displayErrorMessage(error!)
                return
            }
            
            self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)

        })
    }
    
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
        self.browseButton.alpha = 1.0

    }
    
    
    
    @IBAction func browseLink(sender: UIButton) {
        //open the current link in browser
        
        if let URL = self.validateURLString(self.mediaURL.text){
            
            
            self.previewURL = URL
            
            //UIApplication.sharedApplication().openURL(signupURL)
            self.performSegueWithIdentifier("URLPreview", sender: self)
            
            
        }
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        if(segue.identifier == "URLPreview"){
            
            var targetVC = segue.destinationViewController as! URLPreviewController
            targetVC.previewURL = self.previewURL
        
        
        }
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
