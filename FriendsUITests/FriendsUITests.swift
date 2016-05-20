//
//  FriendsUITests.swift
//  FriendsUITests
//
//  Created by Joel Field on 12/05/2016.
//  Copyright © 2016 Student. All rights reserved.
//

import XCTest

class FriendsUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        XCUIApplication().launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testExample() {
        // Use recording to get started writing UI tests.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }
    
    func wait(delay: NSTimeInterval = 2){ // set delay between testing elemeents
        let runLoop = NSRunLoop.mainRunLoop()
        let someTimeInTheFuture = NSDate(timeIntervalSinceNow: delay)
       runLoop.runUntilDate(someTimeInTheFuture)
    }
    
// Can't get UI test to work...
    
    /*
    func testAddingContact(){
        
        let app = XCUIApplication()
        wait(10)
        app.navigationBars["Master"].buttons["Add"].tap()
        wait(10)
        
        app.textFields["First Name"].tap()
        wait(5)
        let firstNameTextField = app.textFields["First Name"]
        wait(5)
        firstNameTextField.typeText("joel")
        wait(5)
        
        /*
        app.textFields["Last Name"].tap()
        wait(5)
        let lastNameTextField = app.textFields["Last Name"]
        wait(5)
        lastNameTextField.typeText("field")
        wait(5)
        */
        
        app.textFields["Address"].tap()
        wait(5)
        let addressTextField = app.textFields["Address"]
        wait(5)
        addressTextField.typeText("58 taylor place queensland")
        wait(5)
        
        app.textFields["Image URL"].tap()
        wait(5)
        let imageUrlTextField = app.textFields["Image URL"]
        wait(5)
        imageUrlTextField.typeText("https://upload.wikimedia.org/wikipedia/en/9/9b/Manx_cat_by_Karen_Weaver.jpg")
        wait(5)
        
        app.textFields["Flickr"].tap()
        wait(5)
        let flickrTextField = app.textFields["Flickr"]
        wait(5)
        flickrTextField.typeText("Matthias.Kahrs")
        wait(5)
        
        app.textFields["Web Page"].tap()
        wait(5)
        let webTextField = app.textFields["Web Page"]
        wait(5)
        webTextField.typeText("https://twitter.com/UnderoathBand")
        wait(5)
        app.navigationBars.matchingIdentifier("Detail").buttons["Master"].tap()
        wait(10)
    }
    */
}
