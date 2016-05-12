//
//  SocialMediaAccount.swift
//  Friends
//
//  Created by Joel Field on 12/05/2016.
//  Copyright © 2016 Student. All rights reserved.
//

import Foundation

class SocialMediaAccount : Contact{
    
    var type = ""
    var id = ""
    var entries : [TimelineEntry]?
    
    init(firstName: String, lastName: String, address: String, middleName: String? = nil,imageURL: String,imageData: NSData? = nil, type : String, id: String){
        super.init()
        self.id = id
        self.type = type
    }
    
}
