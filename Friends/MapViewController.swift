//
//  MapViewController.swift
//  Friends
//
//  Created by Joel Field on 13/05/2016.
//  Copyright © 2016 Student. All rights reserved.
//

import Foundation

import UIKit

import Darwin

import MapKit

import CoreLocation

class MapViewController: UIViewController, UITextFieldDelegate{
    // init address
    var address: String?
    //init api key
    let APIKEY = "AIzaSyDnFnhZJKwVwfiu9py_HVpLcvM-BG5IRNQ"
    // for zooming in later on
    let regionRadius: CLLocationDistance = 1000
    
    //assign map view
    @IBOutlet weak var mapView: MKMapView!
    
    //assign map text field
    @IBOutlet weak var mapSearchTextField: UITextField!


    override func viewWillAppear(animated: Bool) {
        downloadMapInfo(address!)
    }
/*
Download the latitude and longtitude from a given address
*/
    func downloadMapInfo(addressText: String){
        self.mapSearchTextField.text = addressText
        //replace spaces with +'s
        let addressStr = addressText.stringByReplacingOccurrencesOfString(" ", withString: "+")
        
        //create the url
        let requestURL: NSURL = NSURL(string: "https://maps.googleapis.com/maps/api/geocode/json?address=\(addressStr)&key=\(APIKEY)")!
        
        // create the request
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(URL: requestURL)
        //do a async request
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(urlRequest) {
            (data, response, error) -> Void in
            
            let httpResponse = response as! NSHTTPURLResponse
            let statusCode = httpResponse.statusCode
            
            if (statusCode == 200) { //if we successfully got a response
                do{ // try to convert the data
                    let json = try NSJSONSerialization.JSONObjectWithData(data!, options:.AllowFragments)
                    guard let status = json["status"]! else{ //get the status of the results
                        return
                    }
                    if status.lowercaseString.rangeOfString("zero_results") == nil { // if status does not contact "zero_results" then we can proceed
                        //assign latitude
                        guard let lat = json.valueForKey("results")!.valueForKey("geometry")!.valueForKey("location")!.valueForKey("lat")![0] as? Double else{
                            return
                        }
                        //assign longtitude
                        guard let lng = json.valueForKey("results")!.valueForKey("geometry")!.valueForKey("location")!.valueForKey("lng")![0] as? Double else{
                            return
                        }
                        //create CLLocation
                        let userAddress = CLLocationCoordinate2D(latitude: lat, longitude: lng)
                        //create region
                        let userAddressRegion = MKCoordinateRegionMakeWithDistance(userAddress, self.regionRadius * 2.0, self.regionRadius * 2.0)
                        //assign to map view
                        self.mapView.setRegion(userAddressRegion, animated: true)
                    }else{ //no results
                        print("zero results")
                    }
                }catch { //failed to parse the data
                    print("Error with Json: \(error)")
                }
            }
        }
        task.resume()
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        if let searchText = mapSearchTextField.text{
            print(searchText)
            downloadMapInfo(searchText)
        }
        return true
    }
}
