//
//  Contact.swift
//  Friends
//
//  Created by Joel Field on 12/05/2016.
//  Copyright © 2016 Student. All rights reserved.
//

import Foundation

class Contact: PropertyListConvertible {
    
    var firstName = ""
    var lastName = ""
    var address = ""
    var imageURL = ""
    var imageData: NSData?
    var sites : [SocialMediaAccount]
    
    
    /* Present properties as NSDictionary */
    func propertyListRepresentation() -> NSDictionary{
        return [
            "firstName": firstName,
            "lastName": lastName,
            "address": address,
            "imageURL": imageURL,
            "sites" : sites.map { $0.propertyListRepresentation() }
        ]
    }
    
    init(firstName: String, lastName: String, address: String, imageURL: String, imageData: NSData? = nil, sites: [SocialMediaAccount] = []){
        self.firstName = firstName
        self.lastName = lastName
        self.address = address
        self.imageURL = imageURL
        self.imageData = imageData
        self.sites = sites
    }
    
    /* Property list init */
    required init (fromPropertyList propertyList : NSDictionary) {
        firstName = propertyList["firstName"] as! String
        lastName = propertyList["lastName"] as! String
        address = propertyList["address"] as! String
        imageURL = propertyList["imageURL"] as! String
        let sites: [NSDictionary] = propertyList["sites"] as! [NSDictionary]
        self.sites = sites.map{ SocialMediaAccount(fromPropertyList: $0) }
    }

    func fullName() ->String{
        let firstNameValue = firstName
        let lastNameValue = lastName
        return "\(firstNameValue) \(lastNameValue)"
    }
}
