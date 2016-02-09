//
//  EditProfileViewController.swift
//  SaveTheChildren
//
//  Created by Grisha on 05/12/2015.
//  Copyright © 2015 Grisha. All rights reserved.
//

import UIKit

class EditProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate {
    let screenWidth = UIScreen.mainScreen().bounds.width
    let screenHeight = UIScreen.mainScreen().bounds.height
    
    var user:FetchedUser!
    var username:String!
    var profilePicture:UIImage! //to show on imageview
    
    
    var tableView = UITableView(frame: CGRectZero, style: UITableViewStyle.Grouped)
    
    var pickImageView:UIImageView = UIImageView()
    var pickImageSuperview:UIView = UIView()
    var pickedImage:UIImage!
    var pictureChanged = false
    var profilePictureImageView = UIImageView()
    let tableHeaderView = UIView()
    var currentKeyboardHeight:CGFloat = 0
    var navBarOriginY:CGFloat!
    
    var progressActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
    
    var loadingView:LoadingIndicatorView = LoadingIndicatorView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, 100))
    func back(){
        self.navigationController!.popViewControllerAnimated(true)
    }
    
    func setSubviews(){
        let backButton = UIBarButtonItem(image: UIImage(named: "back.png"), style: UIBarButtonItemStyle.Plain, target: self, action: "back")
        backButton.tintColor = UIColor.whiteColor()
        if (self.navigationController!.viewControllers.count > 1){
            self.navigationItem.leftBarButtonItem = backButton
        }
        
        let saveButton = UIBarButtonItem(title: "SAVE", style: UIBarButtonItemStyle.Plain, target: self, action: "save")
        saveButton.tintColor = UIColor.whiteColor()
        self.navigationItem.rightBarButtonItem = saveButton
        
        let titleLabel:UILabel = UILabel()
        titleLabel.numberOfLines = 1
        titleLabel.text = "YOUR PROFILE"
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.textAlignment = NSTextAlignment.Center
        titleLabel.font = UIFont(name: "Lato-Medium", size: 17)
        self.navigationItem.titleView = titleLabel
        titleLabel.sizeToFit()
        
        
        //self.tableView.backgroundColor = ColorFromCode.sexyPurpleColor()
        
        // Set tableView Autolayout
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        let H_Constraints0 = NSLayoutConstraint.constraintsWithVisualFormat("H:|[tableView]|", options: [], metrics: nil , views: ["tableView" : tableView])
        let V_Constraints0 = NSLayoutConstraint.constraintsWithVisualFormat("V:|[tableView]|", options: [], metrics: nil , views: ["tableView" : tableView])
        self.view.addConstraints(H_Constraints0)
        self.view.addConstraints(V_Constraints0)
        
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerClass(EditProfileTableViewCell.self, forCellReuseIdentifier: "Cell 1")
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 300
        tableView.allowsSelection = false
        tableView.backgroundColor = UIColor.whiteColor()
        //For Hiding Keyboard
        let TapRecognizer:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "HideKeyboard")
        self.view.addGestureRecognizer(TapRecognizer)
        
        
        setTableHeaderView()
        
        // refresh control background thing
        let tableViewRefreshBackground = UIView()
        let height:CGFloat = screenHeight
        tableViewRefreshBackground.frame.origin.y = -height
        tableViewRefreshBackground.backgroundColor = ColorFromCode.sexyPurpleColor()
        tableViewRefreshBackground.frame.size = CGSizeMake(screenWidth,height)
        self.tableView.insertSubview(tableViewRefreshBackground, atIndex: 0)
        
    }
    func setTableHeaderView(){
        // Set TableHeader View with subviews
        self.pickImageSuperview.translatesAutoresizingMaskIntoConstraints = false
        self.tableHeaderView.addSubview(pickImageSuperview)
        self.tableHeaderView.backgroundColor = ColorFromCode.sexyPurpleColor()
        let buttonSide:CGFloat = 100
        let borderWidth:CGFloat = 2
        let verticalSpacing:CGFloat = 30
        let metrics = [
            "buttonSide" : buttonSide+(borderWidth*2),
            "xSpacing" : (screenWidth - (buttonSide+(borderWidth*2)))/2,
            "ySpacing" : verticalSpacing
        ]
        let views = [
            "view" : pickImageSuperview
        ]
        let H_Constraints0 = NSLayoutConstraint.constraintsWithVisualFormat("H:|-xSpacing-[view(==buttonSide@999)]-xSpacing@700-|", options: [], metrics: metrics, views: views)
        let V_Constraints0 = NSLayoutConstraint.constraintsWithVisualFormat("V:|-ySpacing-[view(==buttonSide@999)]-ySpacing@700-|", options: [], metrics: metrics, views: views)
        
        self.tableHeaderView.addConstraints(H_Constraints0)
        self.tableHeaderView.addConstraints(V_Constraints0)
        sizeHeaderToFit(false)
        
        self.pickImageSuperview.backgroundColor = UIColor.whiteColor()
        self.pickImageSuperview.layer.cornerRadius = 10
        self.pickImageSuperview.layer.borderWidth = borderWidth
        self.pickImageSuperview.layer.borderColor = UIColor.whiteColor().CGColor
        
        self.tableHeaderView.setNeedsLayout()
        self.tableHeaderView.layoutIfNeeded()
        self.pickImageSuperview.addSubview(pickImageView)
        self.pickImageView.frame.size = CGSizeMake(buttonSide, buttonSide)
        self.pickImageView.center = CGPointMake(pickImageSuperview.frame.width/2, pickImageSuperview.frame.width/2)
        let rec = UITapGestureRecognizer(target: self, action: "presentActionSheet")
        self.pickImageView.addGestureRecognizer(rec)
        self.pickImageView.userInteractionEnabled = true
        
        setupLoadingIndicator()
        startLoadingData()
    }
    
    func setupLoadingIndicator(){
        self.view.addSubview(loadingView)
        tableView.hidden = true
        loadingView.center = CGPointMake(self.view.frame.width/2, self.view.frame.height/2)
        loadingView.button.addTarget(self, action: "startLoadingData", forControlEvents: UIControlEvents.TouchUpInside)
        loadingView.disableAfterFirstTime = false
        self.navigationItem.rightBarButtonItem?.enabled = false
        
    }
    func startLoadingData(){
        tableView.hidden = true
        loadingView.startAnimating()
        
        UsersManager.loadMyProfileData(true) {
            (user:FetchedUser!, error:NSError!) -> Void in
            if error == nil {
                self.user = user
                
                if self.user.picture == nil {
                    self.updateImageView(nil)
                } else {
                    self.updateImageView(self.user.picture)
                }
                self.pictureChanged = false
                self.updateTextfields()
                self.navigationItem.rightBarButtonItem?.enabled = true
                
            } else {
                
                self.navigationItem.rightBarButtonItem?.enabled = false
                print(error!.description)
                
            }
            
            self.loadingView.stopAnimating(error == nil)
            self.tableView.hidden = (error != nil)
        }

    }
    func updateTextfields(){
        let Cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as! EditProfileTableViewCell
        Cell.fullNameTextField.text = user.fullname
        Cell.bioTextView.text = user.bio
        Cell.textViewDidChange(Cell.bioTextView)
        Cell.fullNameTextFieldDidChange()
    }
    func updateImageView(image:UIImage!){
        pictureChanged = true
        if image != nil {
            self.pickImageView.image = image
            self.pickedImage = image
        } else {
            self.pickImageView.image = UIImage(named: "defaultProfilePicture")
            self.pickedImage = nil
        }
    }
    
    func sizeHeaderToFit(animated:Bool){
        let view = self.tableHeaderView
        view.setNeedsLayout()
        view.layoutIfNeeded()
        let height:CGFloat = view.systemLayoutSizeFittingSize(UILayoutFittingCompressedSize).height
        var frame:CGRect = view.frame
        frame.size.height = height
        view.frame = frame
        tableHeaderView.frame = frame
        if (animated){
            UIView.animateWithDuration(0.25, delay: 0, options: [], animations: {
                () -> Void in
                self.tableView.tableHeaderView = view
                }, completion: nil)
        }else{
            self.tableView.tableHeaderView = view
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setSubviews()
    }
    
    
    func updateBarButtons(showLoading:Bool){
        if !showLoading {
            // haven't  started yet
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "SAVE", style: UIBarButtonItemStyle.Plain, target: self, action: "save")
            self.navigationItem.rightBarButtonItem?.tintColor = UIColor.whiteColor()
            progressActivityIndicator.stopAnimating()
            self.navigationItem.leftBarButtonItem!.enabled = true
            
        } else {
            // actual progress
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: progressActivityIndicator)
            progressActivityIndicator.startAnimating()
            self.navigationItem.leftBarButtonItem!.enabled = false
        }
        
    }
    var progress:Double = 0
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let Cell = tableView.dequeueReusableCellWithIdentifier("Cell 1", forIndexPath: indexPath) as! EditProfileTableViewCell
        return Cell
        
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    
    //    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    //        if (section == 1){
    //            return "General Information"
    //        }else if (section == 2){
    //            return "Private Information"
    //        }else{
    //            return "Your Profile Picture"
    //        }
    //    }
    //
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
    }
    
    func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
    
    func save() {
        let Cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0)) as! EditProfileTableViewCell
        
        let fullname = Cell.fullNameTextField.text
        let bio = Cell.bioTextView.text
        let removeImage = pictureChanged ? (pickedImage == nil) : false
        self.navigationItem.leftBarButtonItem?.enabled = false
        self.navigationItem.rightBarButtonItem?.enabled = false
        
        var dictionary = [
            "fullname" : fullname,
            "bio": bio
        ]
        if removeImage {
            if user.pictureId != "" {
                dictionary["idOfPictureToRemove"] = user.pictureId
            }
        }
    
        UsersManager.uploadMyProfileData(dictionary, pictureToUpload: pictureChanged ? pickedImage : nil) {
            (error:NSError!) -> Void in
            if error == nil {
                self.navigationController?.popViewControllerAnimated(true)
                (self.navigationController?.viewControllers[0] as! MyProfileViewController).loadProfileData()
            }
            self.navigationItem.rightBarButtonItem?.enabled = (error == nil)
            self.navigationItem.leftBarButtonItem?.enabled = (error == nil)
        }

//        var user = PFUser.currentUser()
//        user!["name"] = fullname
//        user!["bio"] = bio
//        user!["photo"] = (pickedImage == nil) ? (PFFile(data: UIImageJPEGRepresentation(UIImage(named: "defaultPicture")!, 1)!)) : (PFFile(data: UIImageJPEGRepresentation(pickedImage, 1)!))
//        
//        user?.saveInBackgroundWithBlock({ (success:Bool, error:NSError?) -> Void in
//            if error == nil {
//                if success {
//                    self.navigationController?.popViewControllerAnimated(true)
//                    (self.navigationController?.viewControllers[0] as! MyProfileViewController).loadProfileData()
//                }
//            }
//            self.navigationItem.rightBarButtonItem?.enabled = (error == nil)
//            self.navigationItem.leftBarButtonItem?.enabled = (error == nil)
//        })
        
    }
    func animateSave(){
        
    }
    
    func stopSave(){
        
    }
    
    func presentActionSheet(){
        let actionSheet = UIActionSheet(title: "Add a photo", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: "Select from Photos", otherButtonTitles: "Take a Picture", "Remove Selected Picture")
        actionSheet.destructiveButtonIndex = 3
        
        
        actionSheet.showInView(self.view)
    }
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex == 0 { // Select from Photos
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            imagePicker.delegate = self
            imagePicker.navigationBar.tintColor = UIColor.whiteColor()
            imagePicker.allowsEditing = true
            self.presentViewController(imagePicker, animated: true, completion: {
                self.viewWillAppear(false)
            })
            
        } else if buttonIndex == 2 { // Take a Picture
            
            let imagePicker = ProfileCameraViewController(handler: {
                (image:UIImage!) -> Void in
                if image != nil {
                    self.updateImageView(image)
                }
                self.dismissViewControllerAnimated(true, completion:{
                    UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: UIStatusBarAnimation.Slide)
                })
            })
            let navController = UINavigationController(rootViewController: imagePicker)
            self.presentViewController(navController, animated: true, completion: {
                self.viewWillAppear(false)
            })
            
        } else if buttonIndex == 3 {
            self.updateImageView(nil)
        }
    }
    func navigationController(navigationController: UINavigationController, willShowViewController viewController: UIViewController, animated: Bool) {
        
        
        let titleLabel:UILabel = UILabel()
        titleLabel.numberOfLines = 1
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.textAlignment = NSTextAlignment.Center
        titleLabel.font = UIFont(name: "Lato-Semibold", size: 18)
        if navigationController.viewControllers.count == 1 {
            if viewController.view.tag != 1 {
                titleLabel.text = "Photos"
                titleLabel.sizeToFit()
                viewController.navigationItem.titleView = titleLabel
                viewController.view.tag = 1
            }
        }
        
        if navigationController.viewControllers.count == 2 {
            if viewController.view.tag != 1 {
                titleLabel.text = viewController.navigationItem.title!
                titleLabel.sizeToFit()
                viewController.navigationItem.titleView = titleLabel
                
                viewController.view.tag = 1
            }
        }
        
        if navigationController.viewControllers.count == 3 {
            if viewController.view.tag != 1 {
                //                let cropOverlay = viewController.view.subviews[1].subviews[0]
                //                cropOverlay.hidden = true
                
                viewController.view.tag = 1
            }
        }
        
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: false)
        
    }
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        //        self.viewWillAppear(true)
        self.dismissViewControllerAnimated(true, completion:{
            UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: UIStatusBarAnimation.Slide)
        })
        
        
    }
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        //        var position:CGFloat = 80
        //        if (screenHeight == 568){
        //            position = 124
        //        }
        //        let rect = CGRectMake(0, position, screenWidth, screenWidth)
        //        let imageRef = CGImageCreateWithImageInRect(image.CGImage, rect)
        //        var croppedImage = UIImage(CGImage: imageRef!)
        updateImageView(image)
        self.dismissViewControllerAnimated(true, completion:{
            UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: UIStatusBarAnimation.Slide)
        })
    }
    
    func HideKeyboard(){
        self.view.endEditing(true)
    }
    
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController!.navigationBar.barTintColor = ColorFromCode.colorWithHexString("#663399")
        self.navigationController?.navigationBar.hideBottomHairline()
        super.viewWillAppear(animated)
        self.navigationController!.navigationBarHidden = false
        UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: UIStatusBarAnimation.None)
        self.Add_Keyboard_Observers()
        navBarOriginY = self.navigationController!.navigationBar.frame.origin.y
    }
    
    override func viewWillDisappear(animated: Bool) {
        Utility.dropShadow(self.navigationController!.navigationBar, offset: 0, opacity: 0)
        self.navigationController!.navigationBar.barTintColor = ColorFromCode.standardBlueColor()
        self.navigationController?.navigationBar.showBottomHairline()
        super.viewWillDisappear(animated)
        self.view.endEditing(true)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func Add_Keyboard_Observers(){
        //initial view frame
        //make trigger when keyboard displayed/changed
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        
        //when keyboard is hidden
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    
    func keyboardWillShow(notification: NSNotification) {
        let info:NSDictionary = notification.userInfo!
        let keyboardSize = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        let keyboardHeight:CGFloat = keyboardSize.height
        let movement:CGFloat = keyboardHeight
        //var movement:CGFloat = self.logoSuperView.frame.size.height/2
        self.currentKeyboardHeight = movement
        
        let animationDuration = (info[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        
        UIView.animateWithDuration(animationDuration, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            
            //self.navigationController!.navigationBar.frame.origin.y = self.navBarOriginY-movement
            self.tableView.frame.origin.y = self.view.frame.origin.y-movement
            }
            , completion: nil)
        
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        let info:NSDictionary = notification.userInfo!
        //        let keyboardSize = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        //        let keyboardHeight:CGFloat = keyboardSize.height
        
        //        var movement:CGFloat = keyboardHeight
        
        self.currentKeyboardHeight = 0
        let animationDuration = (info[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        
        UIView.animateWithDuration(animationDuration, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            //self.navigationController!.navigationBar.frame.origin.y = Utility.statusBarHeight()
            self.tableView.frame.origin.y = 0
            }, completion: nil)
    }
}


