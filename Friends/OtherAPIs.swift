//
//  OtherAPIs.swift
//  Friends
//
//  Created by Joel Field on 20/05/2016.
//  Copyright © 2016 Student. All rights reserved.
// Google Maps API function for testing
//

import Foundation

import UIKit

import Darwin

import MapKit

import CoreLocation

//init api key
public var APIKEY = "AIzaSyDnFnhZJKwVwfiu9py_HVpLcvM-BG5IRNQ"

//init zoom variable
public var regionRadius: CLLocationDistance = 1000

//download lat and lng with a given address url
//return false at all times unless we got the lng and lat from the request
public func downloadMapInfo(addressText: String) -> Bool {
    let addressStr = addressText.stringByReplacingOccurrencesOfString(" ", withString: "+")
    let data = fetch("https://maps.googleapis.com/maps/api/geocode/json?address=\(addressStr)&key=\(APIKEY)")
            do{
                guard let status = data!["status"] else{
                    return false;
                }
                if status.lowercaseString.rangeOfString("zero_results") == nil {
                    guard let lat = data!.valueForKey("results")!.valueForKey("geometry")!.valueForKey("location")!.valueForKey("lat")![0] as? Double else{
                        return false;
                    }
                    guard let lng = data!.valueForKey("results")!.valueForKey("geometry")!.valueForKey("location")!.valueForKey("lng")![0] as? Double else{
                        return false;
                    }
                    let userAddress = CLLocationCoordinate2D(latitude: lat, longitude: lng)
                    let userAddressRegion = MKCoordinateRegionMakeWithDistance(userAddress, regionRadius * 2.0, regionRadius * 2.0)
                    // we got the lng and lat so return true
                    return true;
                }else{
                    print("zero results")
                    return false;
                }
            }catch {
                print("Error with Json: \(error)")
                return false;
            }
    return false;
}