//
//  SocialMediaAccount.swift
//  Friends
//
//  Created by Joel Field on 12/05/2016.
//  Copyright © 2016 Student. All rights reserved.
//

import Foundation

class SocialMediaAccount{
    
    var type = ""
    var id = ""
    var entries : [TimelineEntry]?
    
    init(type: String, id: String){
        self.id = id
        self.type = type
    }
    
}
