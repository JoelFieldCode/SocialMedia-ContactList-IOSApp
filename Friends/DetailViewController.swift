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
    
    @IBOutlet weak var facebookTextField: UITextField!
    
    @IBOutlet weak var webPageTextField: UITextField!
    
    
    @IBOutlet weak var displayPic: UIImageView!
    
    var currentImageData: NSData?
    
    var detailItem: Contact? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }
    var delegate : DataEnteredDelegate? = nil
    var indexPath : Int?
    
    func configureView() {
        // Update the user interface for the detail item.
        if let detail = self.detailItem {
            if let label = detailDescriptionLabel{
                firstNameTextField.text = detail.firstName
                lastNameTextField.text = detail.lastName
                addressTextField.text = detail.address
                imageURLTextField.text = detail.imageURL
                if(false == detail.sites.isEmpty){
                    for(var i = 0; i < detail.sites.count; i++){
                        if(detail.sites[i].type == "Flickr"){
                            flickrTextField.text = detail.sites[i].id
                        }
                    }
                }
                if currentImageData != nil{
                    displayPic.image = UIImage(data: currentImageData!) //set UIImage
                }else{ /* If user clicks the item before it is downloaded then we need to re-download the item */
                    loadPhotoInBackground(detail.imageURL)
                }
            }
            
        }
    }
    /* Load Photo in background */
    func loadPhotoInBackground(url: String){
        let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0)
        
        let backgroundDownload = { // put the multi thread logic in a variable
            if let data = NSData(contentsOfURL: NSURL(string: url )!) {
                let mainQueue = dispatch_get_main_queue()
                dispatch_async(mainQueue, {
                    self.currentImageData = data
                    self.detailItem?.imageData = data
                    self.displayPic.image = UIImage(data: data)
                })
            } else {
                print("Could not download Image '\(url)'")
            }
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
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showMap" {
            let controller = (segue.destinationViewController as! UINavigationController).topViewController as! MapViewController
            controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
            controller.navigationItem.leftItemsSupplementBackButton = true
            controller.address = self.detailItem!.address
        }
        
    }
    

}

