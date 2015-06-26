//
//  MapViewController.swift
//  On the Map
//
//  Created by Johannes Eichler on 19.05.15.
//  Copyright (c) 2015 Eichler. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: DataViewController, MKMapViewDelegate, StatusViewDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    
    var locations:[AnyObject]?

    

    var annotationList = [MKPointAnnotation]()
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        // draw the buttons

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mapView.delegate = self        
        
        self.addButtons()
        
        // Take the data from cache if already there otherwise download them again

        if (self.cache.locations.count < 1){
            
            self.loadLocations()
            self.generateMapAnnotationsForMapView(self.mapView, studentLocations: self.cache.locations)

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
        
        for location in studentLocations{
            
            let annotationItem = self.generateMapAnnotation(location)
            self.annotationList.append(annotationItem)
        }
        
         mapView.addAnnotations(self.annotationList)
    }
    


    func loadLocations(){
        
        
        let parseClient = ParseClient()
        
        parseClient.GETStudentLocations { (error) -> Void in
            
            if(error == nil){
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    
                    self.stopReloadIndicator(self.reloadLocationsButton!)
                    
                    self.generateMapAnnotationsForMapView(self.mapView, studentLocations: self.cache.locations)
                    self.updateButtonStatus()
                })                
            
            }
            
            else{
                
                dispatch_async(dispatch_get_main_queue(), { () -> Void in
                                        
                    self.stopReloadIndicator(self.reloadLocationsButton!)
                    self.addStatusView()
                    self.displayErrorMessage(error!)
                    self.errorMessageVC!.delegate = self
                    self.updateButtonStatus()
                })
            }
            
        }
        
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
        
        if control == annotationView.rightCalloutAccessoryView {
            let app = UIApplication.sharedApplication()
            app.openURL(NSURL(string: annotationView.annotation.subtitle!)!)
        }
    }
    

    
    override func addLocation(sender:UIBarButtonItem){
        
        self.performSegueWithIdentifier("mapToSearch", sender: self)
    
    
    }
    
    override func reloadLocation(sender:UIBarButtonItem){
        
        self.cache.locations.removeAll(keepCapacity: false)
        self.mapView.removeAnnotations(self.annotationList)        
        
        self.startReloadIndicator(sender)
        self.loadLocations()

    }
    

    func didActivateRetryAction() {
        self.loadLocations()
    }
    
    func didCloseErrorDialog() {
        self.updateButtonStatus()
    }

    
   
}
