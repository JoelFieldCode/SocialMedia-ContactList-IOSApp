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
    //init flickr pic
    var detailEntry: TimelineEntry? = nil
    
    //init image view
    @IBOutlet weak var fullDisplayImage: UIImageView!
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        if  detailEntry != nil{
            //assign the photo's title to the nav title
            self.navigationItem.title = detailEntry!.title!
            //assign the image to the image view
            self.fullDisplayImage.image = UIImage(data: detailEntry!.image!) //set UIImage
            
        }
    }
}
