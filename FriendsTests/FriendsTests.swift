//
//  FriendsTests.swift
//  FriendsTests
//
//  Created by Joel Field on 12/05/2016.
//  Copyright © 2016 Student. All rights reserved.
//

import XCTest

import Foundation

import UIKit

import Darwin

import MapKit

import CoreLocation
@testable import Friends

class FriendsTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measureBlock {
            // Put the code you want to measure the time of here.
        }
    }
    func testFlickrAPI(){
        let userPhotos = photosForUser("Matthias.Kahrs", maximumResults: 10)
        XCTAssertNotNil(userPhotos)
        XCTAssertEqual(userPhotos!.count, 10)
        var urlArray = [NSURL]()
        for photo in userPhotos!{
            let photoURL = url(photo, format: .Small)
            XCTAssertNotNil(photoURL)
            urlArray.append(photoURL!)
        }
        XCTAssertEqual(urlArray.count, 10)
        var urlDataArray = [NSData]()
        for url in urlArray{
            let photoData = NSData(contentsOfURL: url)
            XCTAssertNotNil(photoData)
            urlDataArray.append(photoData!)
        }
        XCTAssertEqual(urlDataArray.count, 10)
    }
    
    // Test Google Maps API with downloadMapInfo function in OtherAPIs.swift
    func testMapView(){
        // This address should return false
        let falseResult: Bool = downloadMapInfo("swlslslsls")
        XCTAssertFalse(falseResult)
        
        // This address should return true
        let trueResult: Bool = downloadMapInfo("58 taylor place queensland")
        XCTAssertTrue(trueResult)
    }
    
    func testSocialMediaRelationshipsBetweenMultipleContacts(){
        
        let newSocial = SocialMediaAccount(id: "test", type: "Flickr")
        let newSocial2 = SocialMediaAccount(id: "moretests", type: "Web-Page")
        var socialArray = [SocialMediaAccount]()
        socialArray += [newSocial, newSocial2]
        let person = Contact(firstName: "joel", lastName: "field", address: "123 fake st", imageURL: "https://upload.wikimedia.org/wikipedia/en/9/9b/Manx_cat_by_Karen_Weaver.jpg", sites: socialArray)
        
        XCTAssertEqual(person.sites[1].id, "moretests")
        XCTAssertEqual(person.sites.count, 2)
        
        let newSocial3 = SocialMediaAccount(id: "user2", type: "Flickr")
        let newSocial4 = SocialMediaAccount(id: "no", type: "Web-Page")
        var socialArray2 = [SocialMediaAccount]()
        socialArray2 += [newSocial3, newSocial4]
        let person2 = Contact(firstName: "chris", lastName: "adams", address: "new st", imageURL: "https://upload.wikimedia.org/wikipedia/en/9/9b/Manx_cat_by_Karen_Weaver.jpg", sites: socialArray2)
        
        XCTAssertNotEqual(person.sites[0].id, person2.sites[0].id)
    }
    
    func testWebView(){
        let trueResult: Bool = loadWebPage("www.google.com")
        XCTAssertTrue(trueResult)
        
        let falseResult: Bool = loadWebPage("this will fail")
        XCTAssertFalse(falseResult)
    }

    func loadWebPage(url: String) -> Bool{
        let webView: UIWebView!
        var urlString = url
        // If the user didn't type in "https://" we will insert it in for them
        if urlString.lowercaseString.rangeOfString("https://") == nil {
            urlString = "https://" + urlString
            print(urlString)
        }
        // Check if URL is a valid NSURL
        guard let url = NSURL(string: urlString) else{
            print("Not a valid URL")
            return false;
        }
        // Fire URL request
        let request = NSURLRequest(URL: url)
        return true;
    }
}
