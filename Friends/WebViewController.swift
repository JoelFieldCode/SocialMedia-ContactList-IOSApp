//
//  WebViewController.swift
//  Friends
//
//  Created by Joel Field on 19/05/2016.
//  Copyright © 2016 Student. All rights reserved.
//

import Foundation

import UIKit

import WebKit

class WebViewController: UIViewController, UITextFieldDelegate {
    
    //init user's address url
    var userURL: String?
    
    /*
    Text Field Outlet
    */
    
    @IBOutlet weak var urlTextField: UITextField!
    
    /*
    Home page URL
    */
    var url : String = "http://www.google.com"
    
    /*
    Hold the Web View Outlet Variable
    */
    
    @IBOutlet weak var webView: UIWebView!
    
    /*
    Load Google as the home page for the web view
    */
    override func viewDidLoad() {
        super.viewDidLoad()
        self.urlTextField.text = self.userURL!
        loadWebPage(self.userURL!)
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        let urlString = urlTextField.text!
        loadWebPage(urlString)
        return true;
    }
/*
Load a web page with a given url string
*/
    func loadWebPage(url: String){
        var urlString = url
        // If the user didn't type in "https://" we will insert it in for them
        if urlString.lowercaseString.rangeOfString("https://") == nil {
            urlString = "https://" + urlString
            print(urlString)
        }
        // Check if URL is a valid NSURL
        guard let url = NSURL(string: urlString) else{
            print("Not a valid URL")
            return;
        }
        // Fire URL request
        let request = NSURLRequest(URL: url)
        webView.loadRequest(request)
    }
}


