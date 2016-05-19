//
//  FullViewController.swift
//  Friends
//
//  Created by Joel Field on 19/05/2016.
//  Copyright © 2016 Student. All rights reserved.
//

import Foundation

import UIKit



class FullViewController: UIViewController{
    var detailEntry: TimelineEntry? = nil
    
    @IBOutlet weak var fullDisplayImage: UIImageView!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        if  detailEntry != nil{ // if object exists we know the user is viewing an existing entry, so we can use the object's properties to set up the view
            self.navigationItem.title = detailEntry!.title!
            self.fullDisplayImage.image = UIImage(data: detailEntry!.image!) //set UIImage
            
        }
    }
    
    
}
