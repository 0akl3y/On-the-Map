//
//  URLPreviewController.swift
//  On the Map
//
//  Created by Johannes Eichler on 23.06.15.
//  Copyright (c) 2015 Eichler. All rights reserved.
//

import UIKit

class URLPreviewController: AbstractViewController,  UIWebViewDelegate, StatusViewDelegate {
    
    var previewURL: NSURL?
    @IBOutlet weak var webView: UIWebView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.webView.delegate = self
        
        self.errorMessageVC?.delegate = self

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        self.loadPreviewURL()

        
    }
    
    func loadPreviewURL(){
        
        let request = NSURLRequest(URL: self.previewURL!)
        
        self.webView.loadRequest(request)
    
    }
    
    
    func webViewDidFinishLoad(webView: UIWebView) {
        spinner.stopAnimating()
    }
    

    func webView(webView: UIWebView, didFailLoadWithError error: NSError) {
        self.addStatusView()
        self.displayErrorMessage(error)
    }
    

    func didActivateRetryAction() {
        
        self.loadPreviewURL()
        
    }
}
