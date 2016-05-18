//
//  SocialMediaAccount.swift
//  Friends
//
//  Created by Joel Field on 12/05/2016.
//  Copyright © 2016 Student. All rights reserved.
//

import Foundation

class SocialMediaAccount: PropertyListConvertible {
    
    var type = ""
    var id = ""
    var entries : [TimelineEntry]?
    
    /*init(firstName: String, lastName: String, address: String, imageURL: String,type: String, id: String){
        super.init(firstName: firstName, lastName: lastName, address: address, imageURL: imageURL)
        self.id = id
        self.type = type
    }*/
    
    init(id: String, type: String) {
        self.id = id
        self.type = type
    }
    
    required init(fromPropertyList propertyList: NSDictionary) {
        self.type = propertyList["type"] as! String
        self.id = propertyList["id"] as! String
    }
    
    func propertyListRepresentation() -> NSDictionary {
        return [
            "type": type,
            "id": id
        ]
    }
    
}

extension SocialMediaAccount: CustomStringConvertible {
    
    var description: String {
        return "type: \(type), id: \(id)"
    }
    
}
