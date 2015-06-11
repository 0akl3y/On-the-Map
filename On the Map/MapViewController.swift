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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.mapView.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
        
        let parseClient = ParseClient()
        
        // Take the data from cache if already there otherwise download them again

        if (self.cache.locations == nil){
            
            parseClient.GETStudentLocations { (result, error) -> Void in
                self.cache.locations = result
                self.generateMapAnnotationsForMapView(self.mapView, locationDict: self.cache.locations!)
            }
        }
            
        else {
            
            self.generateMapAnnotationsForMapView(self.mapView, locationDict: self.cache.locations!)

        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func generateMapAnnotation(locationDict:[String: AnyObject]) -> MKPointAnnotation {
        
        let lat = CLLocationDegrees(locationDict["latitude"] as! Double)
        let long = CLLocationDegrees(locationDict["longitude"] as! Double)
        
        // The lat and long are used to create a CLLocationCoordinates2D instance.
        let coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        
        let first = locationDict["firstName"] as! String
        let last = locationDict["lastName"] as! String
        let mediaURL = locationDict["mediaURL"] as! String
        
        // Here we create the annotation and set its coordiate, title, and subtitle properties
        var annotation = MKPointAnnotation()
        annotation.coordinate = coordinate
        annotation.title = "\(first) \(last)"
        annotation.subtitle = mediaURL
        
        return annotation
        // Finally we place the annotation in an array of annotations.
    }
    
    func generateMapAnnotationsForMapView(mapView:MKMapView, locationDict:[[String: AnyObject]]) -> Void{
        
        //Generate the Annotations for mapView
        
        var annotationList = [MKPointAnnotation]()
        
        for location in locationDict{
            
            let annotationItem = self.generateMapAnnotation(location as [String : AnyObject])
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
    
    
   
}
