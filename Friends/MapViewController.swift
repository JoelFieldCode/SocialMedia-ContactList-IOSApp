//
//  MapViewController.swift
//  Friends
//
//  Created by Joel Field on 13/05/2016.
//  Copyright © 2016 Student. All rights reserved.
//

import Foundation

import UIKit

import MapKit

import CoreLocation

class MapViewController: UIViewController, UITextFieldDelegate{
    
    var address: String?
    
    let APIKEY = "AIzaSyDnFnhZJKwVwfiu9py_HVpLcvM-BG5IRNQ"
    
    @IBOutlet weak var mapView: MKMapView!
    
    
    @IBOutlet weak var mapSearchTextField: UITextField!


    override func viewWillAppear(animated: Bool) {
        downloadMapInfo(address!)
    }
    func downloadMapInfo(addressText: String){
        let addressStr = addressText.stringByReplacingOccurrencesOfString(" ", withString: "+")
        
        let requestURL: NSURL = NSURL(string: "https://maps.googleapis.com/maps/api/geocode/json?address=\(addressStr)+QLD&key=\(APIKEY)")!
        let urlRequest: NSMutableURLRequest = NSMutableURLRequest(URL: requestURL)
        let session = NSURLSession.sharedSession()
        let task = session.dataTaskWithRequest(urlRequest) {
            (data, response, error) -> Void in
            
            let httpResponse = response as! NSHTTPURLResponse
            let statusCode = httpResponse.statusCode
            
            if (statusCode == 200) {
                do{
                    let json = try NSJSONSerialization.JSONObjectWithData(data!, options:.AllowFragments)
                    guard let status = json["status"]! else{
                        return
                    }
                    if status.lowercaseString.rangeOfString("zero_results") == nil {
                        guard let lat = json.valueForKey("results")!.valueForKey("geometry")!.valueForKey("location")!.valueForKey("lat")![0] as? Double else{
                            return
                        }
                        guard let lng = json.valueForKey("results")!.valueForKey("geometry")!.valueForKey("location")!.valueForKey("lng")![0] as? Double else{
                            return
                        }
                        let userAddress = CLLocationCoordinate2D(latitude: lat, longitude: lng)
                        let userAddressRegion = MKCoordinateRegion(center: userAddress, span: MKCoordinateSpan(latitudeDelta: 2, longitudeDelta: 2))
                        self.mapView.setRegion(userAddressRegion, animated: true)
                    }else{
                        print("zero results")
                    }
                }catch {
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
            /*
                let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0)
                
                /* Multithread download stored in a variable */
                let backgroundDownload = {
                    self.downloadMapInfo(searchText)
                }
                dispatch_async(queue, backgroundDownload) //run the multithread
            */
        }
        return true
    }

        
}
