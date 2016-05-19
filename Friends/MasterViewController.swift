//
//  MasterViewController.swift
//  Friends
//
//  Created by Joel Field on 12/05/2016.
//  Copyright © 2016 Student. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController, DataEnteredDelegate {

    var detailViewController: DetailViewController? = nil
    
    var objects = [Contact]()
    let directory = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)[0] as NSString //set directory

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpContacts()
        // Do any additional setup after loading the view, typically from a nib.
        self.navigationItem.leftBarButtonItem = self.editButtonItem()

        let addButton = UIBarButtonItem(barButtonSystemItem: .Add, target: self, action: "insertNewObject:")
        self.navigationItem.rightBarButtonItem = addButton
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = (controllers[controllers.count-1] as! UINavigationController).topViewController as? DetailViewController
        }
    }
    
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
                
                let socialCount = fileContent[i].valueForKey("sites")!.count
                var socialArray = [SocialMediaAccount]()
                for(var b = 0; b < socialCount; b++){
                    let id = fileContent[i].valueForKey("sites")![b].valueForKey("id") as! String
                    let type = fileContent[i].valueForKey("sites")![b].valueForKey("type") as! String
                    let newSocial = SocialMediaAccount(id: id as String, type: type as String)
                    socialArray += [newSocial]
                }
                let contact = Contact(firstName: firstName, lastName: lastName, address: address, imageURL: imageURL, sites: socialArray)
                loadPhotoInBackground(contact)
                objects += [contact] //append photo to array of photos
            }
        }else{
            print("nothing in contacts.plist") //nothing in file
        }
    }
    func userDidEnterInformation(vc: DetailViewController) {
        if(vc.imageURLTextField.text != ""){
            let newSocial = SocialMediaAccount(id: vc.flickrTextField.text!, type: "Flickr")
            let newSocial2 = SocialMediaAccount(id: vc.webPageTextField.text!, type: "Web-Page")
            var socialArray = [SocialMediaAccount]()
            socialArray += [newSocial, newSocial2]
            
            let newContact = Contact(
                firstName: vc.firstNameTextField.text!,
                lastName: vc.lastNameTextField.text!,
                address: vc.addressTextField.text!,
                imageURL: vc.imageURLTextField.text!,
                sites: socialArray
            )
            
            if(vc.detailItem == nil){
                objects.append(newContact)
                loadPhotoInBackground(newContact)
            }else{
                objects[vc.indexPath!] = newContact
                loadPhotoInBackground(newContact)
            }
            let temp: [NSDictionary] = self.objects.map { $0.propertyListRepresentation() }
            let arrayPLIST: NSArray = temp
            let file = directory.stringByAppendingPathComponent("contactList.plist") //set destination file
            arrayPLIST.writeToFile(file, atomically: true) //write property list to fill
        }else{
            print("url text field empty, dont save user")
        }
    }
    func loadPhotoInBackground(contact : Contact){
        let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0)
        
        let backgroundDownload = { // put the multi thread logic in a variable
            if let data = NSData(contentsOfURL: NSURL(string: contact.imageURL)!) {
                let mainQueue = dispatch_get_main_queue()
                dispatch_async(mainQueue, {
                    contact.imageData = data
                    self.tableView!.reloadData()
                })
            } else {
                print("Could not download Image '\(contact.imageURL)'")
            }
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
    
    
    func insertNewObject(sender: AnyObject) {
        performSegueWithIdentifier("showDetail", sender: nil)
    }
    
    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showDetail" {
            let controller = (segue.destinationViewController as! UINavigationController).topViewController as! DetailViewController
            controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
            controller.navigationItem.leftItemsSupplementBackButton = true
            controller.delegate = self
            if let indexPath = self.tableView.indexPathForSelectedRow {
                let object = objects[indexPath.row]
                controller.detailItem = object
                controller.indexPath = indexPath.row
                if(object.imageData != nil){
                    controller.currentImageData = object.imageData!
                }else{ /* If user clicks the item before the picture is downloaded then let detail know by setting it to nil */
                    controller.currentImageData = nil
                }
            }else{
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

