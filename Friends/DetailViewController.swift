//
//  DetailViewController.swift
//  Friends
//
//  Created by Joel Field on 12/05/2016.
//  Copyright © 2016 Student. All rights reserved.
//

import UIKit

protocol DataEnteredDelegate{
    func userDidEnterInformation(vc: DetailViewController) //user entered information, send this info back to the master view for proccessing.
}

class DetailViewController: UIViewController, UITextFieldDelegate{

    @IBOutlet weak var detailDescriptionLabel: UILabel!
    
    @IBOutlet weak var firstNameTextField: UITextField!
    
    @IBOutlet weak var lastNameTextField: UITextField!
    
    @IBOutlet weak var addressTextField: UITextField!
    
    @IBOutlet weak var imageURLTextField: UITextField!
    
    @IBOutlet weak var flickrTextField: UITextField!
    
    @IBOutlet weak var webPageTextField: UITextField!
    
    
    @IBOutlet weak var displayPic: UIImageView!

//current image data of photo
    var currentImageData: NSData?
    
// determine if detail item was set
    var detailItem: Contact? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }
// assign delegate
    var delegate : DataEnteredDelegate? = nil
    
// init index path
    var indexPath : Int?

/*
Setup the view
*/
    func configureView() {
        // Update the user interface for the detail item.
        if let detail = self.detailItem {
            if let label = detailDescriptionLabel{ //wait for controller to find the labels and text fields
                firstNameTextField.text = detail.firstName
                lastNameTextField.text = detail.lastName
                addressTextField.text = detail.address
                imageURLTextField.text = detail.imageURL
                if(false == detail.sites.isEmpty){ // if user does has at least one social media account
                    for(var i = 0; i < detail.sites.count; i++){ //loop through their accounts
                        if(detail.sites[i].type == "Flickr"){ //if the account is a flickr acc
                            flickrTextField.text = detail.sites[i].id //take the flickr id
                        }
                        if(detail.sites[i].type == "Web-Page"){ //if the account is a web page
                            webPageTextField.text = detail.sites[i].id //take the web page id
                        }
                    }
                }
                if currentImageData != nil{ // if contact's display pic data has been downloaded
                    displayPic.image = UIImage(data: currentImageData!) //set UIImage
                }else{ /* User clicked the item before it was downloaded so we need to re-download the item */
                    loadPhotoInBackground(detail.imageURL) //download photo
                }
            }
            
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        //take url
        let urlString = imageURLTextField.text!
        //download photo
        loadPhotoInBackground(urlString)
        return true;
    }
/* 
Load Photo in background
*/
    func loadPhotoInBackground(url: String){
        let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0)
        
        let backgroundDownload = { // put the multi thread logic in a variable
            guard let urlData = NSURL(string: url) else{ // if string can be cast to NSURL
                print("invalid url string")
                return;
            }
            guard let data = NSData(contentsOfURL: urlData) else{ // if NSURL can be cast to NSDATA
                print("Could not download Image '\(url)'")
                return;
            }
            let mainQueue = dispatch_get_main_queue()
            dispatch_async(mainQueue, {
                //assign picture
                self.currentImageData = data
                self.detailItem?.imageData = data
                self.displayPic.image = UIImage(data: data)
            })
        }
        dispatch_async(queue, backgroundDownload) //run the multithread
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(animated: Bool) {
        delegate?.userDidEnterInformation(self)
    }
/*
Segues
*/
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showMap" {
            let controller = (segue.destinationViewController as! UINavigationController).topViewController as! MapViewController
            controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
            controller.navigationItem.leftItemsSupplementBackButton = true
            //give the controller the user's address
            controller.address = self.addressTextField.text!
        }
        if segue.identifier == "showWebPage" {
            let controller = (segue.destinationViewController as! UINavigationController).topViewController as! WebViewController
            controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
            controller.navigationItem.leftItemsSupplementBackButton = true
            //give the controller the web page url
            controller.userURL = self.webPageTextField.text!
        }
        if segue.identifier == "showFlickr" {
            let controller = (segue.destinationViewController as! UINavigationController).topViewController as! PhotoCollectionViewController
            controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
            controller.navigationItem.leftItemsSupplementBackButton = true
            //give the controller the user's flickr id
            controller.flickrUser = self.flickrTextField.text!
        }
    }
}

