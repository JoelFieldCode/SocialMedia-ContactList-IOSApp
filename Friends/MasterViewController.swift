//
//  MasterViewController.swift
//  Friends
//
//  Created by Joel Field on 12/05/2016.
//  Copyright © 2016 Student. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController, DataEnteredDelegate {

// Delegate setup
    var detailViewController: DetailViewController? = nil
    
// Contact Array setup
    var objects = [Contact]()
    
// File Directory Setup
    let directory = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString //set directory

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Read Contacts from Property List
        setUpContacts()
        self.navigationItem.leftBarButtonItem = self.editButtonItem()

        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "insertNewObject:")
        self.navigationItem.rightBarButtonItem = addButton
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
    }
/*
Read the property list and assign objects to the contact array as appropiate
*/
    func setUpContacts() {
        let file = directory.stringByAppendingPathComponent("contactList.plist") //set file location
        if let fileContent = NSArray(contentsOfFile: file) as! Array<NSDictionary>?{ //if file has contents
            let count = fileContent.count //count how many elements are in file
            for(var i = 0; i < count; i++){ //loop through each element in file
                /* take data from each element in file */
                let firstName = fileContent[i].valueForKey("firstName") as! String
                let lastName = fileContent[i].valueForKey("lastName") as! String
                let address = fileContent[i].valueForKey("address") as! String
                let imageURL = fileContent[i].valueForKey("imageURL") as! String
                
                // count how many social media accounts the user has
                let socialCount = fileContent[i].valueForKey("sites")!.count
                //create the social media account array
                var socialArray = [SocialMediaAccount]()
                // loop through each social media account
                for(var b = 0; b < socialCount; b++){
                    //grab values
                    let id = fileContent[i].valueForKey("sites")![b].valueForKey("id") as! String
                    let type = fileContent[i].valueForKey("sites")![b].valueForKey("type") as! String
                    //create the social media account object with the values
                    let newSocial = SocialMediaAccount(id: id as String, type: type as String)
                    //add it to the array of social media accounts
                    socialArray += [newSocial]
                }
                //create the contact object
                let contact = Contact(firstName: firstName, lastName: lastName, address: address, imageURL: imageURL, sites: socialArray)
                //downnload contact's display pic
                loadPhotoInBackground(contact)
                objects += [contact] //append photo to array of photos
            }
        }else{
            print("nothing in contacts.plist") //nothing in file
        }
    }
/*
Handle User entered data from the detail view
*/
    func userDidEnterInformation(vc: DetailViewController) {
        //Only accept data if user uploads a profile pic
        if(vc.imageURLTextField.text != ""){
            // Create social media account objects
            let newSocial = SocialMediaAccount(id: vc.flickrTextField.text!, type: "Flickr")
            let newSocial2 = SocialMediaAccount(id: vc.webPageTextField.text!, type: "Web-Page")
            //Create social media acc array
            var socialArray = [SocialMediaAccount]()
            //append each object to array
            socialArray += [newSocial, newSocial2]
            
            //create new contact object
            let newContact = Contact(
                firstName: vc.firstNameTextField.text!,
                lastName: vc.lastNameTextField.text!,
                address: vc.addressTextField.text!,
                imageURL: vc.imageURLTextField.text!,
                sites: socialArray
            )
            
            // if detail item is nil we know the user was adding a contact
            if(vc.detailItem == nil){
                objects.append(newContact) //append to contact array
                loadPhotoInBackground(newContact) //download photo
            }else{ // else they were updating an existing contact
                objects[vc.indexPath!] = newContact //update contact in array
                loadPhotoInBackground(newContact) //download photo
            }
            // Assign NSDictionary
            let temp: [NSDictionary] = self.objects.map { $0.propertyListRepresentation() }
            //Assign NSArray
            let arrayPLIST: NSArray = temp
            // save to contactList.plist
            let file = directory.stringByAppendingPathComponent("contactList.plist") //set destination file
            arrayPLIST.writeToFile(file, atomically: true) //write to file
        }else{
            // user has no picture, don't add contact
            print("url text field empty, dont save user")
        }
    }
/*
Download the photo in the background
*/
    func loadPhotoInBackground(contact : Contact){
        let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0)
        
        let backgroundDownload = { // put the multi thread logic in a variable
            guard let urlData = NSURL(string: contact.imageURL) else{ // if string can be cast to NSURL
                print("invalid url string")
                return;
            }
            guard let data = NSData(contentsOfURL: urlData) else{
                print("Could not download Image '\(contact.imageURL)'") // image coudn't be downloaded
                return;
            }
            let mainQueue = dispatch_get_main_queue()
            dispatch_async(mainQueue, {
                contact.imageData = data //assign the NSData to the contact
                self.tableView!.reloadData() //reload view
            })
        }
        dispatch_async(queue, backgroundDownload) //run the multithread
    }

    override func viewWillAppear(animated: Bool) {
        self.clearsSelectionOnViewWillAppear = self.splitViewController!.collapsed
        super.viewWillAppear(animated)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
/*
Segue to detail view to add contact
*/
    func insertNewObject(sender: AnyObject) {
        performSegueWithIdentifier("showDetail", sender: nil)
    }
    
    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" { //segue to detail view
            let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
            controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
            controller.navigationItem.leftItemsSupplementBackButton = true
            controller.delegate = self //assign delegate
            if let indexPath = self.tableView.indexPathForSelectedRow { //user clicked a existing object
                let object = objects[indexPath.row] //assign object
                controller.detailItem = object //give detail controller the object
                controller.indexPath = indexPath.row //give controller the index path
                if(object.imageData != nil){ //image data was downloaded before user clicked the item
                    controller.currentImageData = object.imageData!
                }else{ /* If user clicks the item before the picture is downloaded then let detail know by setting it to nil */
                    controller.currentImageData = nil
                }
            }else{ //user is adding a object
                controller.detailItem = nil
            }
        }
    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)

        let object = objects[indexPath.row]
        cell.textLabel!.text = object.fullName()
            if let picture = objects[indexPath.row].imageData {
                cell.imageView!.image = UIImage(data: picture) //set cell's UIImage to the photo's NSData
            }
        return cell

    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }

    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            objects.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
            let arrayPLIST = NSMutableArray() //initialize mutable array
            if(objects.count > 0){
                for contact in objects{  //loop through array of photos
                    arrayPLIST.addObject(contact.propertyListRepresentation()) //add photo to the mutable array
                }
            }
            let file = directory.stringByAppendingPathComponent("contactList.plist") //set destination file
            arrayPLIST.writeToFile(file, atomically: true) //write property list to file
            
        }
    }
}

