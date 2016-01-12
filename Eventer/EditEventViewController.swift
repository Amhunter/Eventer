//
//  EditEventViewController.swift
//  Eventer
//
//  Created by Grisha on 08/11/2015.
//  Copyright © 2015 Grisha. All rights reserved.
//

import UIKit
protocol EditEventViewControllerDelegate {
    func didFinishEditing(updated:Bool,event:FetchedEvent!)
}
class EditEventViewController: UIViewController,UITextViewDelegate,UITextFieldDelegate,EventDatePickerViewDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate {
    
    let mainView = UIView()
    let eventNameTextfield = UITextField()
    let eventDescriptionTextview = UITextView()
    let eventDescriptionPlaceholderLabel = UILabel()
    let eventDateButton = UIButton()
    let datePickerView = EventDatePickerView()
    let imageView = UIImageView()
    var imageChanged = false
    let progressActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
    
    var event:FetchedEvent!
    
    var eventDate = NSDate()
    
    // Additional Variables
    let screenWidth = UIScreen.mainScreen().bounds.width
    let screenHeight = UIScreen.mainScreen().bounds.height
    var currentKeyboardHeight:CGFloat = 0
    var delegate:EditEventViewControllerDelegate!
    var completionHandler:((Bool,FetchedEvent!) -> Void)!
    override func viewDidLoad() {
        super.viewDidLoad()
        setSubviews()
        setEventData()
    }
    func initializeEditController(withEvent:FetchedEvent, handler: (updated:Bool,event:FetchedEvent!) -> Void){
        print("init")
        self.completionHandler = handler
        self.event = withEvent
    }
    func setSubviews() {
        // Back Button
        let backButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Stop, target: self, action: "back")
        backButton.tintColor = UIColor.whiteColor()
        self.navigationItem.leftBarButtonItem = backButton
        self.navigationController!.navigationBar.barTintColor = ColorFromCode.sexyPurpleColor()
        // Views Hierarchy
        self.view.addSubview(datePickerView)
        self.view.addSubview(mainView)
        mainView.frame.size = CGSizeMake(screenWidth, 3000)
        self.view.bringSubviewToFront(datePickerView)
        
        // Save Button
        let DoneButton:UIBarButtonItem = UIBarButtonItem(title: "SAVE", style: UIBarButtonItemStyle.Plain, target: self, action: "updateEvent")
        DoneButton.enabled = false
        DoneButton.tintColor = UIColor.whiteColor()
        self.navigationItem.rightBarButtonItem = DoneButton
        
        // Navigation Bar Title Label
        let titleLabel:UILabel = UILabel()
        titleLabel.numberOfLines = 1
        titleLabel.text = "EDIT EVENT"
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.textAlignment = NSTextAlignment.Center
        titleLabel.font = UIFont(name: "Lato-Semibold", size: 18)
        self.navigationItem.titleView = titleLabel
        titleLabel.sizeToFit()
        
        // Scroll View Autolayout
        self.mainView.addSubview(eventDateButton)
        self.mainView.addSubview(eventNameTextfield)
        self.mainView.addSubview(eventDescriptionTextview)
        self.mainView.addSubview(imageView)
        self.eventDateButton.translatesAutoresizingMaskIntoConstraints = false
        self.eventNameTextfield.translatesAutoresizingMaskIntoConstraints = false
        self.eventDescriptionTextview.translatesAutoresizingMaskIntoConstraints = false
        self.imageView.translatesAutoresizingMaskIntoConstraints = false
        
        let line1 = UIView()
        line1.translatesAutoresizingMaskIntoConstraints = false
        line1.backgroundColor = ColorFromCode.colorWithHexString("#C8C6CC")
        self.mainView.addSubview(line1)
        
        let line2 = UIView()
        line2.translatesAutoresizingMaskIntoConstraints = false
        line2.backgroundColor = ColorFromCode.colorWithHexString("#C8C6CC")
        self.mainView.addSubview(line2)
        
        let line3 = UIView()
        line3.translatesAutoresizingMaskIntoConstraints = false
        line3.backgroundColor = ColorFromCode.tabForegroundColor()
        self.mainView.addSubview(line3)
        
        let views = [
            "nameLabel": eventNameTextfield,
            "descrView": eventDescriptionTextview,
            "dateButton": eventDateButton,
            "imageView": imageView,
            "line1": line1,
            "line2": line2,
            "line3": line3
        ]
        let SH_Constraints0 = NSLayoutConstraint.constraintsWithVisualFormat("H:|-20-[nameLabel]-50@999-|", options: [], metrics: nil, views: views)
        let SH_Constraints1 = NSLayoutConstraint.constraintsWithVisualFormat("H:|-20-[dateButton]-20@999-|", options: [], metrics: nil, views: views)
        let SH_Constraints2 = NSLayoutConstraint.constraintsWithVisualFormat("H:|-20-[line1]-50@999-|", options: [], metrics: nil, views: views)
        let SH_Constraints3 = NSLayoutConstraint.constraintsWithVisualFormat("H:|-20-[descrView]-50@999-|", options: [], metrics: nil, views: views)
        let SH_Constraints4 = NSLayoutConstraint.constraintsWithVisualFormat("H:|-20-[imageView]-20@999-|", options: [], metrics: nil, views: views)
        let SH_Constraints5 = NSLayoutConstraint.constraintsWithVisualFormat("H:|-20-[line2]-50@999-|", options: [], metrics: nil, views: views)
        
        let SV_Constraints0 = NSLayoutConstraint.constraintsWithVisualFormat("V:|-20@999-[nameLabel(40@999)]-2-[line1(0.5)]-10-[dateButton(>=0@999)]-10-[descrView(80@999)]-2-[line2(0.5)]-5-[imageView]->=0@999-|", options: [], metrics: nil, views: views)
        let squareConstraint = NSLayoutConstraint(item: imageView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: imageView, attribute: NSLayoutAttribute.Width, multiplier: 1, constant: 0)
        
        self.mainView.addConstraints(SH_Constraints0)
        self.mainView.addConstraints(SH_Constraints1)
        self.mainView.addConstraints(SH_Constraints2)
        self.mainView.addConstraints(SH_Constraints3)
        self.mainView.addConstraints(SH_Constraints4)
        self.mainView.addConstraints(SH_Constraints5)
        
        self.mainView.addConstraints(SV_Constraints0)
        self.mainView.addConstraint(squareConstraint)
        
        
        self.mainView.setNeedsLayout()
        self.mainView.layoutIfNeeded()
        
        // Event Name Textfield
        eventNameTextfield.placeholder = "Event Name"
        eventNameTextfield.font = UIFont(name: "Helvetica", size: 17)
        eventNameTextfield.tintColor =  ColorFromCode.colorWithHexString("#B8B7B9")
        eventNameTextfield.addTarget(self, action: "checkData", forControlEvents: UIControlEvents.EditingChanged)
        
        
        // Description textview and placeholder
        eventDescriptionTextview.font = UIFont(name: "Helvetica", size: 17)
        eventDescriptionTextview.tintColor =  ColorFromCode.colorWithHexString("#B8B7B9")
        eventDescriptionTextview.delegate  = self
        eventDescriptionTextview.textContainer.lineFragmentPadding = 0
        eventDescriptionTextview.textContainerInset = UIEdgeInsetsZero
        
        eventDescriptionPlaceholderLabel.text = "Description (Optional)"
        eventDescriptionPlaceholderLabel.font = eventDescriptionTextview.font
        eventDescriptionPlaceholderLabel.sizeToFit()
        eventDescriptionPlaceholderLabel.userInteractionEnabled = false
        eventDescriptionTextview.addSubview(eventDescriptionPlaceholderLabel)
        eventDescriptionPlaceholderLabel.frame.origin = CGPointMake(0, 0)
        eventDescriptionPlaceholderLabel.textColor = ColorFromCode.colorWithHexString("#BEBEBE")
        eventDescriptionPlaceholderLabel.hidden = eventDescriptionTextview.text.characters.count != 0
        
        // Pick Date Button
        eventDateButton.translatesAutoresizingMaskIntoConstraints = false
        eventDateButton.setTitleColor(ColorFromCode.randomBlueColorFromNumber(2), forState: UIControlState.Normal)
        eventDateButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Highlighted)
        eventDateButton.backgroundColor = ColorFromCode.tabBackgroundColor()
        eventDateButton.layer.cornerRadius = 4
        eventDateButton.titleLabel!.font = UIFont(name: "Lato-Semibold", size: 17)
        eventDateButton.addTarget(self, action: "pickDate", forControlEvents: UIControlEvents.TouchUpInside)
        
        // Date Label
        eventDateButton.titleLabel!.font = UIFont(name: "Lato-Semibold", size: 16)
        eventDateButton.setTitleColor(ColorFromCode.randomBlueColorFromNumber(3), forState: UIControlState.Normal)
        eventDateButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        eventDateButton.titleLabel!.numberOfLines = 0
        
        // Image View
        let imageRec = UITapGestureRecognizer(target: self, action: "imageViewClicked")
        imageView.backgroundColor = ColorFromCode.standardBlueColor()
        imageView.addGestureRecognizer(imageRec)
        imageView.userInteractionEnabled = true
        
        datePickerView.frame.origin.y = self.view.frame.height
        datePickerView.initializeView(CGSizeMake(95, 150))
        datePickerView.delegate = self
        let tapRec = UITapGestureRecognizer(target: self, action: "endEditing")
        let swipeRec = UISwipeGestureRecognizer(target: self, action: "endEditing")
        swipeRec.direction = UISwipeGestureRecognizerDirection.Down
        self.mainView.addGestureRecognizer(tapRec)
        self.mainView.addGestureRecognizer(swipeRec)
    }
    func setEventData(){
        eventNameTextfield.text = event.name as String
        eventDescriptionTextview.text = event.details as String
        setDate(event.date)
        checkData()
        textViewDidChange(eventDescriptionTextview)
        imageView.image = event.picture
    }
    
    // Delegate Methods
    func updateEvent(){
        startUpdatingAnimation()
        // Read Data from Inputs
        event.name = eventNameTextfield.text!
        event.details = eventDescriptionTextview.text
        event.date = self.eventDate
        event.pictureProgress = 1
        if imageChanged {
            (imageView.image != nil) ? (event.picture = imageView.image!) : (event.picture = UIImage())
        }
        // Try to Save
        EventsManager.modifyEventData(event, imageChanged: imageChanged, newImage: (imageView.image != nil) ? event.picture : nil) {
            (updatedEvent:Event!, error:NSError!) -> Void in
            if error == nil {
                if updatedEvent != nil {
                    // Save Updated Data and Uploaded Image if there was one
                    self.event.eventOriginal = updatedEvent
                    self.event.pictureProgress = 1
                    if updatedEvent.pictureId != nil {
                        self.event.pictureId = updatedEvent.pictureId!
                    }
                    self.completionHandler(true, self.event)
                }
            } else {
                self.stopUpdatingAnimation()
                let alert = UIAlertController(title: "Error", message: error.description, preferredStyle: UIAlertControllerStyle.Alert)
                alert.addAction(UIAlertAction(title: "OK, just fux off", style: UIAlertActionStyle.Default, handler: nil))
                self.presentViewController(alert, animated: true, completion: nil)
            }
        }
    }
    func back(){
        self.completionHandler(false, nil)
    }
    
    // Animation Methods
    func startUpdatingAnimation(){
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: progressActivityIndicator)
        progressActivityIndicator.startAnimating()
        self.navigationItem.leftBarButtonItem!.enabled = false
    }
    func stopUpdatingAnimation(){
        let doneButton:UIBarButtonItem = UIBarButtonItem(title: "SAVE", style: UIBarButtonItemStyle.Plain, target: self, action: "updateEvent")
        self.navigationItem.rightBarButtonItem = doneButton
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.whiteColor()
        progressActivityIndicator.stopAnimating()
        self.navigationItem.leftBarButtonItem!.enabled = true
    }
    
    // Date Picking Methods
    func pickDate(){
        showDatePickerView(!self.datePickerView.active)
    }
    func didPickDate(date: NSDate) {
        showDatePickerView(false)
        setDate(date)
    }
    func setDate(date:NSDate){
        self.eventDate = date
        let dayString = DateToStringConverter.dateToUsualFullString(date)
        let attributedString = NSMutableAttributedString(string: dayString, attributes: [NSForegroundColorAttributeName:ColorFromCode.randomBlueColorFromNumber(3)])
        attributedString.appendAttributedString(NSAttributedString(string: " at ", attributes: [NSForegroundColorAttributeName: UIColor.blackColor()]))
        
        let timeFormatter = NSDateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        let timeString = NSAttributedString(string: timeFormatter.stringFromDate(date), attributes:
            [NSForegroundColorAttributeName:ColorFromCode.randomBlueColorFromNumber(3)])
        attributedString.appendAttributedString(timeString)
        self.eventDateButton.setAttributedTitle(attributedString, forState: UIControlState.Normal)
    }
    func showDatePickerView(show:Bool){
        self.datePickerView.active = show
        if show {
            UIView.animateWithDuration(0.25, animations: {
                () -> Void in
                self.datePickerView.frame.origin.y = self.view.frame.height - self.datePickerView.frame.height
            })
        } else {
            UIView.animateWithDuration(0.25, animations: {
                () -> Void in
                self.datePickerView.frame.origin.y = self.view.frame.height
                
            })
        }
    }
    
    // Image Picking Methods
    func imageViewClicked(){
        let actionSheet = UIActionSheet(title: "CUSTOMIZE OPTIONS", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: "Select from Photos", otherButtonTitles: "Take a Picture", "Remove Selected Picture")
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
            
            
            let imagePicker = EventCameraViewController(handler: {
                (image:UIImage!) -> Void in
                if image != nil {
                    self.setImage(image)
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
            setImage(nil)
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
        //
        //        if navigationController.viewControllers.count == 3 {
        //            if viewController.view.tag != 1 {
        //                let cropOverlay = viewController.view.subviews[1].subviews[0]
        //                cropOverlay.hidden = true
        //
        //                var position:CGFloat = 80
        //                if (screenHeight == 568){
        //                    position = 124
        //                }
        //                // ()
        //                let circleLayer = CAShapeLayer()
        //                let path2 = UIBezierPath(ovalInRect: CGRectMake(0, position, screenWidth, screenWidth))
        //                path2.usesEvenOddFillRule = true
        //                circleLayer.path = path2.CGPath
        //                circleLayer.fillColor = UIColor.clearColor().CGColor
        //
        //                // []
        //                let path = UIBezierPath(roundedRect: CGRectMake(0, 0, screenWidth, screenHeight-72), cornerRadius: 0)
        //                path.usesEvenOddFillRule = true
        //                path.appendPath(path2)
        //
        //                let fillLayer = CAShapeLayer()
        //                fillLayer.path = path.CGPath
        //                fillLayer.fillRule = kCAFillRuleEvenOdd
        //                fillLayer.fillColor = UIColor.blackColor().CGColor
        //                fillLayer.opacity = 0.8
        //                viewController.view.layer.addSublayer(fillLayer)
        //                let scrollView = viewController.view.subviews[0].subviews[0] as! UIScrollView
        //                //                let imageView = viewController.view.subviews[0].subviews[0].subviews[0].subviews[0] as! UIImageView
        //                scrollView.bounces = false
        //
        //                //scrollView.zoomScale = imageView.image!.size.height / scrollView.frame.size.height
        //                viewController.view.tag = 1
        //            }
        //        }
        
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
        setImage(image)
        self.dismissViewControllerAnimated(true, completion:{
            UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: UIStatusBarAnimation.Slide)
        })
    }
    func setImage(image:UIImage!){
        imageChanged = true
        if image == nil {
            event.picture = UIImage()
            imageView.image = nil
        } else {
            event.picture = image
            imageView.image = image
        }
    }
    
    
    // Textfield and Textview delegate methods
    func checkData(){
        self.navigationItem.rightBarButtonItem!.enabled = !eventNameTextfield.text!.isEmptyField
    }
    func textViewDidChange(textView: UITextView) {
        eventDescriptionPlaceholderLabel.hidden = eventDescriptionTextview.text!.characters.count != 0
    }
    
    // Keyboard Notification/Change Methods
    func endEditing() {
        self.view.endEditing(true)
        showDatePickerView(false)
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        // Temporarily Disable View Shift
        //self.Add_Keyboard_Observers()
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        endEditing()
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
        self.currentKeyboardHeight = movement
        
        let animationDuration = (info[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        if eventDescriptionTextview.isFirstResponder() {
            UIView.animateWithDuration(animationDuration, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
                self.mainView.frame.origin.y = self.view.frame.origin.y-movement
                }
                , completion: nil)
        }
    }
    func keyboardWillHide(notification: NSNotification) {
        let info:NSDictionary = notification.userInfo!
        self.currentKeyboardHeight = 0
        let animationDuration = (info[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        
        UIView.animateWithDuration(animationDuration, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            self.mainView.frame.origin.y = 0
            }, completion: nil)
        
    }
}
