//
//  Contact.swift
//  Friends
//
//  Created by Joel Field on 12/05/2016.
//  Copyright © 2016 Student. All rights reserved.
//

import Foundation

class Contact {
    
    var firstName = ""
    var lastName = ""
    var address = ""
    var imageURL = ""
    var imageData: NSData?
    var sites : [SocialMediaAccount]?
    
    
    /* Present properties as NSDictionary */
    func propertyListRepresentation() -> NSDictionary{
        return [ "firstName": firstName, "lastName" : lastName, "address": address,"imageURL" : imageURL]
    }
    
    /* Contact Init */
    convenience init (firstName: String, lastName: String, address: String, middleName: String? = nil, imageURL: String, imageData: NSData? = nil){
        self.init()
        self.firstName = firstName
        self.lastName = lastName
        self.address = address
        self.imageData = imageData
        self.imageURL = imageURL
    }
    /* Property list init */
    convenience init (propertyList : NSDictionary) {
        self.init()
        firstName = propertyList["firstName"] as! String
        lastName = propertyList["lastName"] as! String
        address = propertyList["address"] as! String
        imageURL = propertyList["imageURL"] as! String
    }

    func fullName() ->String{
        let firstNameValue = firstName
        let lastNameValue = lastName
        return "\(firstNameValue) \(lastNameValue)"
    }
}
