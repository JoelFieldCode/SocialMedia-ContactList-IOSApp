//
//  TimelineEntry.swift
//  Friends
//
//  Created by Joel Field on 12/05/2016.
//  Copyright © 2016 Student. All rights reserved.
//

import Foundation

class TimelineEntry{
    var image: NSData?
    var title: String?
    
    init(image: NSData? = nil, title: String? = nil) {
        self.image = image
        self.title = title
    }
}
