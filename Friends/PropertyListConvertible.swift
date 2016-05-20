//
//  PropertyListConvertible.swift
//  Friends
//
//  Created by Joel Field on 18/05/2016.
//  Copyright © 2016 Student. All rights reserved.
//

import Foundation

protocol PropertyListConvertible {
    
    // return a NSDictionary
    func propertyListRepresentation() -> NSDictionary
    
    // init property list
    init(fromPropertyList: NSDictionary)
    
}