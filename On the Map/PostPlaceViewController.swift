//
//  PostPlaceViewController.swift
//  On the Map
//
//  Created by Johannes Eichler on 18.06.15.
//  Copyright (c) 2015 Eichler. All rights reserved.
//

import UIKit
import MapKit

class PostPlaceViewController: AbstractViewController, StatusViewDelegate {
    
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var placeNameInputField: UITextField!
    
    @IBOutlet weak var findPlaceButton: UIButton!
    
    var firstResult:CLPlacemark?
    var overlay:URLInputViewController?

    override func viewDidLoad() {
        super.viewDidLoad()
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    @IBAction func findPlace(sender: AnyObject) {
        
       self.displayURLInputView()
    }
    
    func displayURLInputView(){

        self.overlay = self.storyboard?.instantiateViewControllerWithIdentifier("URLInputVC") as? URLInputViewController
        self.overlay!.placeToSearch = placeNameInputField.text
        
        self.displayOverlay(overlay!)
    }
    

    func didCloseErrorDialog() {
        
    }
    
    @IBAction func cancel(sender: UIBarButtonItem) {
        self.overlay?.removeView()
        self.presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func didActivateRetryAction() {
        
        self.findPlace(self)
    }
}
