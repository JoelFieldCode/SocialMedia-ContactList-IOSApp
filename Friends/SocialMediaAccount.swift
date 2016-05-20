//
//  SocialMediaAccount.swift
//  Friends
//
//  Created by Joel Field on 12/05/2016.
//  Copyright © 2016 Student. All rights reserved.
//

import Foundation

class SocialMediaAccount: PropertyListConvertible {
    
    //init variables
    var type = ""
    var id = ""
    
    //init socialmediaaccount
    init(id: String, type: String) {
        self.id = id
        self.type = type
    }
    
    //init property list
    required init(fromPropertyList propertyList: NSDictionary) {
        self.type = propertyList["type"] as! String
        self.id = propertyList["id"] as! String
    }
    
    //return property list rep
    func propertyListRepresentation() -> NSDictionary {
        return [
            "type": type,
            "id": id
        ]
    }
}
