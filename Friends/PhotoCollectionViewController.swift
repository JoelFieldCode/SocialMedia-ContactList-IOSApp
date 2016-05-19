//
//  PhotoCollectionViewController.swift
//  Friends
//
//  Created by Joel Field on 19/05/2016.
//  Copyright © 2016 Student. All rights reserved.
//

import Foundation

import UIKit

class PhotoCollectionViewController : UICollectionViewController, UICollectionViewDelegateFlowLayout{
    
    var photoList = [TimelineEntry]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Flickr Photos for \(flickrUser!)"
        loadPhotosInBackground()
    }
    
    var flickrUser : String? = nil
    
    func loadPhotosInBackground(){
        let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0)
        
        let backgroundDownload = { // put the multi thread logic in a variable
            guard let photos = photosForUser(self.flickrUser!, maximumResults: 50) else{
                return;
            }
            for photo in photos{
                guard let urlData = url(photo, format: .Small) else{
                    print("invalid")
                    return;
                }
                guard let data = NSData(contentsOfURL: urlData) else {
                    print("Could not download Image '\(photo)'")
                    return;
                }
                let mainQueue = dispatch_get_main_queue()
                dispatch_async(mainQueue, {
                    let userPhoto = TimelineEntry(image: data, title: photo.title)
                    self.photoList.append(userPhoto)
                    self.collectionView!.reloadData()
                })
            }
        }
        dispatch_async(queue, backgroundDownload) //run the multithread
    }
    
    
    //initalize sections
    override func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    //initailize number of items needed
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photoList.count
    }
    
    // Set up each cell's UIImage
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("PhotoCell", forIndexPath: indexPath) as! CollectionViewCell
        cell.backgroundColor = UIColor.blackColor()
        if let picture = photoList[indexPath.row].image{
            cell.image.image = UIImage(data: picture) //set cell's UIImage to the photo's NSData
        }
        return cell
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showFullPic"{ //segue to existing photo detail view screen
            let controller = (segue.destinationViewController as! UINavigationController).topViewController as! FullViewController
            controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
            controller.navigationItem.leftItemsSupplementBackButton = true
            let indexPaths = self.collectionView!.indexPathsForSelectedItems()
            let indexPath = indexPaths![0] as NSIndexPath //get the selected cell's indexpath
            controller.detailEntry = photoList[indexPath.row] //set the detail view's object to the object that was pressed
        }
    }

}
