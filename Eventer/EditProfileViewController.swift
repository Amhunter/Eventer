//
//  EditProfileViewController.swift
//  Eventer
//
//  Created by Grisha on 31/01/2015.
//  Copyright (c) 2015 Grisha. All rights reserved.
//

import UIKit

class EditProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    var user:KCSUser!
    var username:String!
    var fullname:String!
    var profilePicture:UIImage! //to show on imageview
    var bio:String!
    
    
    
    @IBOutlet var SettingsTableView: UITableView!
    var profilePictureImageView:UIImageView! = UIImageView(frame: CGRectMake(0, 0, 150 , 150))
    func back(){
        self.navigationController!.popViewControllerAnimated(true)
    }
    
    func Set_Subviews(){
        let backButton = UIBarButtonItem(image: UIImage(named: "back.png"), style: UIBarButtonItemStyle.Plain, target: self, action: "back")
        backButton.tintColor = UIColor.whiteColor()
        if (self.navigationController!.viewControllers.count > 1){
            self.navigationItem.leftBarButtonItem = backButton
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.Set_Subviews()
        //For Image Picking
        let ImagePickRecognizer:UITapGestureRecognizer = UITapGestureRecognizer(target:self, action: "ChoosePhoto")
        self.profilePictureImageView.addGestureRecognizer(ImagePickRecognizer)
        self.profilePictureImageView.userInteractionEnabled = true
        
        //For Hiding Keyboard
        
        let TapRecognizer:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "HideKeyboard")
        self.view.addGestureRecognizer(TapRecognizer)
        
        
        KCSUser.activeUser().refreshFromServer {
            (objects:[AnyObject]!, error:NSError!) -> Void in
            if (error == nil){
                self.user = objects[0] as! KCSUser
                self.SettingsTableView.reloadData()
            }else{
                print("Error:" + error.description)
            }
            
        }

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (section == 1){
            return 4
        }else if (section == 2){
            return 3
        }else{
            return 0
        }
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        if (indexPath.section == 1){
            switch (indexPath.row){
            case(0):
                let Cell:ProfileUsernameCell = tableView.dequeueReusableCellWithIdentifier("Username Cell", forIndexPath: indexPath) as! ProfileUsernameCell
                Cell.usernameLabel.text = user.username
                return Cell
            case(1):
                let Cell:ProfileFullnameCell = tableView.dequeueReusableCellWithIdentifier("Fullname Cell", forIndexPath: indexPath) as! ProfileFullnameCell
                Cell.fullnameLabel.text = user.givenName
                return Cell
            case(2):
                let Cell:ProfileWebsiteCell = tableView.dequeueReusableCellWithIdentifier("Website Cell", forIndexPath: indexPath) as! ProfileWebsiteCell
                //Cell.websiteLabel.text = user.valueForKey("website") as? String
                return Cell
            case(3):
                let Cell:ProfileStatementCell = tableView.dequeueReusableCellWithIdentifier("Statement Cell", forIndexPath: indexPath) as! ProfileStatementCell
                Cell.statementLabel.text = user.getValueForAttribute("bio") as? String
                return Cell
            default:
                let Cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("Username Cell", forIndexPath: indexPath) 
                return Cell
            }
        }else if (indexPath.section == 2){
            switch (indexPath.row){
            case(0):
                let Cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("Mailbox Cell", forIndexPath: indexPath) 
                Cell.textLabel?.tag = 4
                return Cell
            case(1):
                let Cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("Phone Cell", forIndexPath: indexPath) 
                Cell.textLabel?.tag = 5
                return Cell
            case(2):
                let Cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("Gender Cell", forIndexPath: indexPath) 
                Cell.textLabel?.tag = 6
                return Cell
            default:
                let Cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("Username Cell", forIndexPath: indexPath) 
                return Cell
            }
        }else{
            let Cell:UITableViewCell = tableView.dequeueReusableCellWithIdentifier("Username Cell", forIndexPath: indexPath) 
            return Cell
        }

    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if (section == 0){
            let HeaderView:UIView = UIView()
            self.profilePictureImageView.frame = CGRectMake(110, 30, 100, 100)
            if (user.getValueForAttribute("picture") != nil){
                self.profilePictureImageView.image = user.getValueForAttribute("picture") as? UIImage
            }else{
                self.profilePictureImageView.image = UIImage(named: "defaultPicture")
            }
            self.profilePictureImageView.layer.cornerRadius = 20
            self.profilePictureImageView.layer.masksToBounds = true // otherwise the corner radius doesnt work

            HeaderView.addSubview(self.profilePictureImageView)
            return HeaderView
        }else{
            return nil
        }
    }
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if (section == 1){
            return "General Information"
        }else if (section == 2){
            return "Private Information"
        }else{
            return "Your Profile Picture"
        }
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if (section == 0){
            return 150
        }else{
            return 20
        }
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        if (section == 2){
            return 100
        }else{
            return 0
        }
    }
    
    @IBAction func Save(sender: AnyObject) {
        
        var indexPath:NSIndexPath
        
        //saving information in variables---------------//
        
        //username
        indexPath = NSIndexPath(forRow: 0, inSection: 1)
        let UsernameCell:ProfileUsernameCell = SettingsTableView.cellForRowAtIndexPath(indexPath) as! ProfileUsernameCell
        self.username = UsernameCell.usernameLabel.text
        //fullname
        indexPath = NSIndexPath(forRow: 1, inSection: 1)
        let FullnameCell:ProfileFullnameCell = SettingsTableView.cellForRowAtIndexPath(indexPath) as! ProfileFullnameCell
        self.fullname = FullnameCell.fullnameLabel.text
        //personal Statement
        indexPath = NSIndexPath(forRow: 3, inSection: 1)
        let StatementCell:ProfileStatementCell = SettingsTableView.cellForRowAtIndexPath(indexPath) as! ProfileStatementCell
        self.bio = StatementCell.statementLabel.text
        
        self.user.username = self.username
        self.user.givenName = self.fullname
        self.user.setValue(self.bio, forAttribute: "bio")
        
        let data = UIImageJPEGRepresentation(self.profilePictureImageView.image!, 1)
        
        //making photo findable by all users
        let metadata:KCSMetadata = KCSMetadata()
        metadata.setGloballyReadable(true)
        
        KCSFileStore.uploadData(data, options: [KCSFilePublic : true, KCSFileACL : metadata], completionBlock: {
            (file:KCSFile!, error:NSError!) -> Void in
            if (error == nil){
                self.user.setValue(file.fileId, forAttribute: "pictureId")
                self.user.saveWithCompletionBlock { (objects:[AnyObject]!, error:NSError!) -> Void in
                    if (error == nil){
                        print("success", terminator: "")
                        self.navigationController?.popViewControllerAnimated(true)
                    }else{
                        print("Error:" + error.description, terminator: "")
                    }
                }
                
            }else{
                print("Error: " + error.description, terminator: "")
            }
        }, progressBlock: nil)

        
    }
    
    
    func ChoosePhoto(){
        let imagePicker:UIImagePickerController = UIImagePickerController()
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        imagePicker.allowsEditing = true
        imagePicker.delegate = self
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        
        _ = UIImagePNGRepresentation(image) //save our image as binary file in order to save on cloud        
        
        self.profilePictureImageView.image = image
        //scale it down to display on imageview
        //var pickedImage:UIImage
        //pickedImage = image as UIImage
        //let scaledImage = self.scaleImage(pickedImage, newSize: CGSizeMake(100, 100))

        //self.eventPicture.image = scaledImage as UIImage

        picker.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func HideKeyboard(){
        self.view.endEditing(true)
    }

}
