//
//  MapViewController.swift
//  On the Map
//
//  Created by Johannes Eichler on 19.05.15.
//  Copyright (c) 2015 Eichler. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var locations:[AnyObject]?
    var cache:CachedResponses {
        get{ return CachedResponses.cachedResponses() }
    }
    
    var logoutButton:UIBarButtonItem!
    var addLocationButton: UIBarButtonItem!
    var reloadLocationsButton: UIBarButtonItem!
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        // draw the buttons
        
        self.logoutButton = UIBarButtonItem(title: "Logout", style: UIBarButtonItemStyle.Plain, target: self, action: "logout:")
        self.addLocationButton = UIBarButtonItem(image: UIImage(named: "pin"), style: UIBarButtonItemStyle.Plain, target: self, action: "addLocation")
        self.reloadLocationsButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Refresh, target: self, action: "reloadLocations")
        
        self.navigationItem.leftBarButtonItem = self.logoutButton
        self.navigationItem.rightBarButtonItems = [self.addLocationButton, self.reloadLocationsButton]

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mapView.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
        
        let parseClient = ParseClient()
        
        // Take the data from cache if already there otherwise download them again

        if (self.cache.locations.count < 1){
            
            parseClient.GETStudentLocations { (result, error) -> Void in
                for locationEntry in result! {
                    
                    let newLocations = StudentLocation(placeAttributeDict: locationEntry)
                    self.cache.locations.append(newLocations)
                    
                }
                self.generateMapAnnotationsForMapView(self.mapView, studentLocations: self.cache.locations)
            }
        }
            
        else {
            
            self.generateMapAnnotationsForMapView(self.mapView, studentLocations: self.cache.locations)

        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func generateMapAnnotation(studentLocation:StudentLocation) -> MKPointAnnotation {
        
        let lat = CLLocationDegrees(studentLocation.latitude)
        let long = CLLocationDegrees(studentLocation.longitude)
        
        // The lat and long are used to create a CLLocationCoordinates2D instance.
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        
        let first = studentLocation.firstName
        let last = studentLocation.lastName
        let mediaURL = studentLocation.mediaURL!
        
        // Here we create the annotation and set its coordiate, title, and subtitle properties
        var annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "\(first) \(last)"
        annotation.subtitle = mediaURL
        
        return annotation
        // Finally we place the annotation in an array of annotations.
    }
    
    func generateMapAnnotationsForMapView(mapView:MKMapView, studentLocations:[StudentLocation]) -> Void{
        
        //Generate the Annotations for mapView
        
        var annotationList = [MKPointAnnotation]()
        
        for location in studentLocations{
            
            let annotationItem = self.generateMapAnnotation(location)
            annotationList.append(annotationItem)
           
        }
        
         mapView.addAnnotations(annotationList)
    }
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        
        let reuseID = "pin"
        var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseID) as? MKPinAnnotationView

        if pinView == nil {
            
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseID)
            pinView!.canShowCallout =  true
            pinView!.pinColor = MKPinAnnotationColor.Purple
            pinView!.rightCalloutAccessoryView = UIButton.buttonWithType(UIButtonType.DetailDisclosure) as! UIButton
        }
        
        else{
            
            pinView!.annotation = annotation
        
        }
        
        return pinView
        
    }
    
    func mapView(mapView: MKMapView!, annotationView: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        
        println(control)
        
        if control == annotationView.rightCalloutAccessoryView {
            let app = UIApplication.sharedApplication()
            app.openURL(NSURL(string: annotationView.annotation.subtitle!)!)
        }
    }
    
    func logout(sender:UIBarButtonItem){
        
        let FBSession = FBSDKLoginManager()
        FBSession.logOut()
        
        self.dismissViewControllerAnimated(true, completion: nil)        
    
    }
    
    func addLocation(sender:UIBarButtonItem){}
    
    func reloadLocation(sender:UIBarButtonItem){}
    
   
}
