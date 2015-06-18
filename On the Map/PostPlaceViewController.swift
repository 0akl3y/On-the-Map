//
//  PostPlaceViewController.swift
//  On the Map
//
//  Created by Johannes Eichler on 18.06.15.
//  Copyright (c) 2015 Eichler. All rights reserved.
//

import UIKit

class PostPlaceViewController: UIViewController {
    
    
    @IBOutlet weak var questionLabel: UILabel!
    
    @IBOutlet weak var placeNameInputField: UITextField!
    
    @IBOutlet weak var findPlaceButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    @IBAction func findPlace(sender: AnyObject) {
    }
    

}
