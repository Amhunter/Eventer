//
//  CreateEventViewController.swift
//  Eventer
//
//  Created by Grisha on 17/12/2014.
//  Copyright (c) 2014 Grisha. All rights reserved.
//

import UIKit
extension String {
    var isEmptyField: Bool {
        return stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()) == ""
    }
}

class CreateEventViewController: UIViewController,UIImagePickerControllerDelegate, UINavigationControllerDelegate,UIGestureRecognizerDelegate,UITextFieldDelegate,UITextViewDelegate,EventDatePickerViewDelegate, InvitePeopleViewControllerDelegate,EventCreationNotificationDelegate  {
    
    var screenWidth:CGFloat = UIScreen.mainScreen().bounds.width
    var screenHeight:CGFloat = UIScreen.mainScreen().bounds.height
    var mainView = UIView()
    var delegate:EventCreationNotificationDelegate! = nil
    var eventNameTextField = UITextField()
    
    var eventDescriptionTextView = UITextView()
    var eventDescriptionPlaceholderLabel = UILabel()
    
    var eventDate = NSDate()
    var pickDateButton = UIButton()
    var eventDateLabel = UILabel()
    var datePicker = UIDatePicker()
    var datePickerView = EventDatePickerView()
    
    var publicButton = UIButton()
    var privateButton = UIButton()
    var publicOrPrivateLabel = UILabel()
    var eventPictureLabel:UILabel = UILabel()
    var eventPictureImageView:UIImageView = UIImageView()
    var eventImage:UIImage? = nil
    var eventIsPublic = false
    
    var inviteVC:InvitePeopleViewController!
    var inviteNC:UINavigationController!
    var InviteButton:UIButton = UIButton()
    var invitedPeople:[KCSUser] = []
    var InvitedPeopleCountLabel:UILabel = UILabel() // number of invited
    var InviteLabel:UILabel = UILabel() // "Invite People"
    var InvitingPeople:Bool!
    var ContainerView:UIView = UIView()
    
    var currentKeyboardHeight:CGFloat = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        setSubviews()

    }
    
    func back(){
        delegate.cancelledCreatingEvent()
    }
    func eventWasCreatedSuccessfully() {
        delegate.eventWasCreatedSuccessfully()
    }
    func cancelledCreatingEvent() {
        // do nothing
    }
    func continueCreatingEvent(){
        if eventNameTextField.text!.isEmptyField {
            return
        } else {
            let nextVC = self.storyboard?.instantiateViewControllerWithIdentifier("CreateEvent2ViewController") as! CreateEvent2ViewController
            nextVC.eventName = eventNameTextField.text!
            nextVC.eventDate = eventDate
            nextVC.delegate = self
            if !eventDescriptionTextView.text.isEmptyField {
                nextVC.eventDescription = eventDescriptionTextView.text
            }
            if eventImage != nil {
                nextVC.eventImage = eventImage
            }
            nextVC.eventIsPublic = self.eventIsPublic
            self.navigationController!.pushViewController(nextVC, animated: true)
        }
    }
    func setSubviews(){
        let backButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Stop, target: self, action: "back")
        backButton.tintColor = UIColor.whiteColor()
        self.navigationItem.leftBarButtonItem = backButton

        
        self.view.addSubview(datePickerView)
        self.view.addSubview(mainView)
        mainView.frame.size = CGSizeMake(screenWidth, 3000)
        self.view.bringSubviewToFront(datePickerView)
        
        let DoneButton:UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "forward"), style: UIBarButtonItemStyle.Plain, target: self, action: "continueCreatingEvent")
        DoneButton.enabled = false
        DoneButton.tintColor = UIColor.whiteColor()
        self.navigationItem.rightBarButtonItem = DoneButton
        
        let titleLabel:UILabel = UILabel()
        titleLabel.numberOfLines = 1
        titleLabel.text = "CREATE EVENT"
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.textAlignment = NSTextAlignment.Center
        titleLabel.font = UIFont(name: "Lato-Semibold", size: 18)
        self.navigationItem.titleView = titleLabel
        titleLabel.sizeToFit()
        
        // Scroll View Autolayout
        self.mainView.addSubview(pickDateButton)
        self.mainView.addSubview(eventNameTextField)
        self.mainView.addSubview(eventDescriptionTextView)
        self.mainView.addSubview(eventDateLabel)
        self.mainView.addSubview(publicButton)
        self.mainView.addSubview(privateButton)
        self.mainView.addSubview(publicOrPrivateLabel)
        self.pickDateButton.translatesAutoresizingMaskIntoConstraints = false
        self.eventNameTextField.translatesAutoresizingMaskIntoConstraints = false
        self.eventDescriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        self.eventDateLabel.translatesAutoresizingMaskIntoConstraints = false
        self.publicButton.translatesAutoresizingMaskIntoConstraints = false
        self.privateButton.translatesAutoresizingMaskIntoConstraints = false
        self.publicOrPrivateLabel.translatesAutoresizingMaskIntoConstraints = false
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
            "eventNameLbl": eventNameTextField,
            "pickDateButton" : pickDateButton,
            "descrLabel": eventDescriptionTextView,
            "dateLabel": eventDateLabel,
            "line1": line1,
            "publicButton": publicButton,
            "privateButton" : privateButton,
            "pubOrPriLabel": publicOrPrivateLabel,
            "line2": line2,
            "line3": line3
        ]
        let SH_Constraints0 = NSLayoutConstraint.constraintsWithVisualFormat("H:|-20-[eventNameLbl]-50@999-|", options: [], metrics: nil, views: views)
        let SH_Constraints1 = NSLayoutConstraint.constraintsWithVisualFormat("H:|-20-[pickDateButton(120)]-10-[dateLabel(>=165@999)]->=0@999-|", options: [], metrics: nil, views: views)
        let SH_Constraints2 = NSLayoutConstraint.constraintsWithVisualFormat("H:|-20-[line1]-50@999-|", options: [], metrics: nil, views: views)
        let SH_Constraints3 = NSLayoutConstraint.constraintsWithVisualFormat("H:|-50-[publicButton(==privateButton@999)][line3(0.5)][privateButton(==publicButton)]-50@999-|", options: [], metrics: nil, views: views)
        let SH_Constraints4 = NSLayoutConstraint.constraintsWithVisualFormat("H:|-15-[pubOrPriLabel]-15@999-|", options: [], metrics: nil, views: views)
        let SH_Constraints5 = NSLayoutConstraint.constraintsWithVisualFormat("H:|-20-[descrLabel]-50@999-|", options: [], metrics: nil, views: views)
        let SH_Constraints6 = NSLayoutConstraint.constraintsWithVisualFormat("H:|-20-[line2]-50@999-|", options: [], metrics: nil, views: views)

        let SV_Constraints0 = NSLayoutConstraint.constraintsWithVisualFormat("V:|-20@999-[eventNameLbl(40@999)]-2-[line1(0.5)]->=5-[pickDateButton(30)]->=5-[publicButton(30)]-10-[pubOrPriLabel]-20-[descrLabel(80@999)]-2-[line2(0.5)]->=100@999-|", options: [], metrics: nil, views: views)
        let SV_Constraints1 = NSLayoutConstraint.constraintsWithVisualFormat("V:|-20@999-[eventNameLbl(40@999)]-2-[line1(0.5)]-5-[dateLabel(60)]->=5-[privateButton(30)]-10-[pubOrPriLabel]-20-[descrLabel(80@999)]-2-[line2(0.5)]->=100@999-|", options: [], metrics: nil, views: views)
        let SV_Constraint3 = NSLayoutConstraint(item: line3, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: publicButton, attribute: NSLayoutAttribute.Height, multiplier: 1, constant: 0)
        let SV_Constraint4 = NSLayoutConstraint(item: line3, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: publicButton, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0)
        let SV_Constraint5 = NSLayoutConstraint(item: pickDateButton, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: eventDateLabel, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0)

        self.mainView.addConstraints(SH_Constraints0)
        self.mainView.addConstraints(SH_Constraints1)
        self.mainView.addConstraints(SH_Constraints2)
        self.mainView.addConstraints(SH_Constraints3)
        self.mainView.addConstraints(SH_Constraints4)
        self.mainView.addConstraints(SH_Constraints5)
        self.mainView.addConstraints(SH_Constraints6)

        self.mainView.addConstraints(SV_Constraints0)
        self.mainView.addConstraints(SV_Constraints1)
        self.mainView.addConstraint(SV_Constraint3)
        self.mainView.addConstraint(SV_Constraint4)
        self.mainView.addConstraint(SV_Constraint5)

        self.mainView.setNeedsLayout()
        self.mainView.layoutIfNeeded()
        
        // Event Name Textfield
        eventNameTextField.placeholder = "Event Name"
        eventNameTextField.font = UIFont(name: "Helvetica", size: 17)
        eventNameTextField.tintColor =  ColorFromCode.colorWithHexString("#B8B7B9")
        eventNameTextField.addTarget(self, action: "checkData", forControlEvents: UIControlEvents.EditingChanged)
        
        
        // Description textview and placeholder
        eventDescriptionTextView.font = UIFont(name: "Helvetica", size: 17)
        eventDescriptionTextView.tintColor =  ColorFromCode.colorWithHexString("#B8B7B9")
        eventDescriptionTextView.delegate  = self
        eventDescriptionTextView.textContainer.lineFragmentPadding = 0
        eventDescriptionTextView.textContainerInset = UIEdgeInsetsZero

        eventDescriptionPlaceholderLabel = UILabel()
        eventDescriptionPlaceholderLabel.text = "Description (Optional)"
        eventDescriptionPlaceholderLabel.font = eventDescriptionTextView.font
        eventDescriptionPlaceholderLabel.sizeToFit()
        eventDescriptionPlaceholderLabel.userInteractionEnabled = false
        eventDescriptionTextView.addSubview(eventDescriptionPlaceholderLabel)
        eventDescriptionPlaceholderLabel.frame.origin = CGPointMake(0, 0)
        eventDescriptionPlaceholderLabel.textColor = ColorFromCode.colorWithHexString("#BEBEBE")
        eventDescriptionPlaceholderLabel.hidden = eventDescriptionTextView.text.characters.count != 0

        // Pick Date Button
        pickDateButton.translatesAutoresizingMaskIntoConstraints = false
        pickDateButton.setTitleColor(ColorFromCode.randomBlueColorFromNumber(2), forState: UIControlState.Normal)
        pickDateButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Highlighted)
        pickDateButton.backgroundColor = ColorFromCode.tabBackgroundColor()
        pickDateButton.layer.cornerRadius = 4
        pickDateButton.setTitle("Choose Date", forState: UIControlState.Normal)
        pickDateButton.titleLabel!.font = UIFont(name: "Lato-Semibold", size: 17)
        pickDateButton.addTarget(self, action: "pickDate", forControlEvents: UIControlEvents.TouchUpInside)
        
        // Date Label
        eventDateLabel.font = UIFont(name: "Lato-Semibold", size: 16)
        eventDateLabel.textColor = ColorFromCode.randomBlueColorFromNumber(3)
        eventDateLabel.numberOfLines = 0
        eventDateLabel.textAlignment = NSTextAlignment.Center
        setDate(NSDate())
        
        datePickerView.frame.origin.y = self.view.frame.height
        datePickerView.initializeView(CGSizeMake(95, 150))
        datePickerView.delegate = self
        
        // Public & Private Views
        publicButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        publicButton.setTitle("PUBLIC", forState: UIControlState.Normal)
        publicButton.addTarget(self, action: "switchToPublic", forControlEvents: UIControlEvents.TouchUpInside)
        publicButton.titleLabel!.font = UIFont(name: "Lato-Semibold", size: 15)
        publicButton.backgroundColor = ColorFromCode.tabBackgroundColor()
        
        privateButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        privateButton.setTitle("PRIVATE", forState: UIControlState.Normal)
        privateButton.addTarget(self, action: "switchToPrivate", forControlEvents: UIControlEvents.TouchUpInside)
        privateButton.titleLabel!.font = UIFont(name: "Lato-Semibold", size: 15)
        privateButton.backgroundColor = ColorFromCode.tabBackgroundColor()

        publicOrPrivateLabel.text = "This is a public event - everyone will see it"
        publicOrPrivateLabel.font = UIFont(name: "Lato-Medium", size: 16)
        publicOrPrivateLabel.numberOfLines = 0
        publicOrPrivateLabel.textAlignment = NSTextAlignment.Center
        switchToPublic()
        let tapRec = UITapGestureRecognizer(target: self, action: "endEditing")
        let swipeRec = UISwipeGestureRecognizer(target: self, action: "endEditing")
        swipeRec.direction = UISwipeGestureRecognizerDirection.Down
        self.mainView.addGestureRecognizer(tapRec)
        self.mainView.addGestureRecognizer(swipeRec)

        
        //!----Container view for invite people view controller----//
        inviteVC = self.storyboard?.instantiateViewControllerWithIdentifier("InvitePeopleView") as! InvitePeopleViewController
        inviteNC = UINavigationController(rootViewController: inviteVC)
        inviteVC.delegate = self
//        self.addChildViewController(inviteVC)
//        inviteVC.didMoveToParentViewController(self)
//        inviteVC.view.frame = CGRectMake(0, self.mainView.frame.height, screenWidth, self.mainView.frame.height)
//        self.view.addSubview(inviteVC.view)
//        VC.delegate = self
        //--------------------------------------------------------//
        //!-------Invite People-------//
//        self.InviteButton.addSubview(InvitedPeopleCountLabel)
//        self.InviteButton.addSubview(InviteLabel)
//        self.InvitingPeople = false
//        
//        //InviteButton.layer.borderWidth = 1
//        //InviteButton.layer.borderColor = UIColor.blackColor().CGColor
//        InviteButton.layer.cornerRadius = 5
//        InviteButton.addTarget(self, action: "InvitePeople", forControlEvents: UIControlEvents.TouchUpInside)
//        
//        InviteLabel.text = "Invite People"
//        InviteLabel.textAlignment = NSTextAlignment.Center
//        InviteLabel.backgroundColor = UIColor.whiteColor()
//        InviteLabel.font = UIFont(name: "Helvetica", size: 22)
//        InviteLabel.textColor = UIColor.lightGrayColor()
//        
//        InvitedPeopleCountLabel.text = "\(InvitedPeople.count)"
//        InvitedPeopleCountLabel.textAlignment = NSTextAlignment.Center
//        InvitedPeopleCountLabel.backgroundColor = UIColor.whiteColor()
//        InvitedPeopleCountLabel.font = UIFont(name: "Helvetica", size: 22)
//        InvitedPeopleCountLabel.textColor = UIColor.lightGrayColor()
//        
//        //!----Container view for invite people view controller----//
//        var VC:InvitePeopleViewController = self.storyboard?.instantiateViewControllerWithIdentifier("InvitePeopleView") as! InvitePeopleViewController
//        self.addChildViewController(VC)
//        VC.didMoveToParentViewController(self)
//        VC.view.frame = CGRectMake(0, 0, screenWidth, ScreenHeight-40)
//        self.ContainerView.addSubview(VC.view)
//        self.view.addSubview(ContainerView)
//        VC.delegate = self
//        //--------------------------------------------------------//
//
//        //--------Invite People-------//
//        
//        
//        //!------Recognizers-------//
//        let labelClicked:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "ChooseDate")
//        eventDateLabel.addGestureRecognizer(labelClicked)
//        
//        //-------Recognizers-------//
//        
//        
//        //DatePickingView.addSubview(DatePicker)
        
    }


    func checkData(){
        self.navigationItem.rightBarButtonItem!.enabled = !eventNameTextField.text!.isEmptyField
    }
    func switchToPublic(){
        switchEventType(true)
    }
    func switchToPrivate(){
        switchEventType(false)
    }
    func switchEventType(eventIsPublic:Bool){
        self.eventIsPublic = eventIsPublic
        if eventIsPublic {
            //public
            publicOrPrivateLabel.text = "This is a public event, everyone will see it"
            publicOrPrivateLabel.textColor = ColorFromCode.colorWithHexString("#00CA7D")
            publicButton.backgroundColor = ColorFromCode.colorWithHexString("#00CA7D")
            publicButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            privateButton.backgroundColor = ColorFromCode.tabBackgroundColor()
            privateButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        } else {
            publicOrPrivateLabel.text = "This is a private event. \n\(inviteVC.invitedPeople.count)\nare invited"
            publicOrPrivateLabel.textColor = ColorFromCode.colorWithHexString("#FF6067")
            privateButton.backgroundColor = ColorFromCode.colorWithHexString("#FF6067")
            privateButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            publicButton.backgroundColor = ColorFromCode.tabBackgroundColor()
            publicButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
            showInviteView(true)
            
        }
    }
    func didPickDate(date: NSDate) {
        showDatePickerView(false)
        setDate(date)
    }
    func dismissInvitedView() {
        publicOrPrivateLabel.text = "This is a private event. \n\(inviteVC.invitedPeople.count)\nare invited"
        showInviteView(false)
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
        self.eventDateLabel.attributedText = attributedString
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func textViewDidChange(textView: UITextView) {
        eventDescriptionPlaceholderLabel.hidden = eventDescriptionTextView.text!.characters.count != 0
    }
    func pickDate(){
        showDatePickerView(!self.datePickerView.active)
    }
    func endEditing(){
        self.view.endEditing(true)
        showDatePickerView(false)
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
    
    func showInviteView(show:Bool){
        self.inviteVC.active = show
        if show {
            self.presentViewController(inviteNC, animated: true, completion: nil)
        } else {
            self.dismissViewControllerAnimated(true, completion: nil)

        }
    }
//    func ChooseDate(){
//        if (ChoosingDate == false){
//            HideKeyboard()
//            Slide_View(true)
//            ChoosingDate = true
//        }else{
//            Slide_View(false)
//            ChoosingDate = false
//        }
//        
//    }
//    
//    
//    func Slide_View(MakeVisible:Bool) { // hide/show header when scrolled down/up , scrolldown = 0 , scrollup = 1
//        
//        let duration:NSTimeInterval = 0.5
//        var TabBarHeight:CGFloat = 100
//        if (MakeVisible == true){
//            UIView.animateWithDuration(duration, delay: 0 ,options: UIViewAnimationOptions.AllowUserInteraction, animations: {
//                () -> Void in
//                self.DatePickingView.frame = CGRectMake(0, (self.ScreenHeight-(self.screenWidth/2))-TabBarHeight, self.screenWidth, self.screenWidth/2)
//                self.ScrollView.frame = CGRectMake(0, 0, self.screenWidth, (self.ScreenHeight-(self.screenWidth/2))-TabBarHeight)
//                },completion: nil)
//            self.ScrollView.scrollEnabled = false
//        }else if (MakeVisible == false){
//            UIView.animateWithDuration(duration, delay: 0 ,options: UIViewAnimationOptions.AllowUserInteraction, animations: {
//                () -> Void in
//                self.DatePickingView.frame = CGRectMake(0, self.ScreenHeight, self.screenWidth, self.screenWidth/2)
//                self.ScrollView.frame = CGRectMake(0, 0, self.screenWidth, self.ScreenHeight)
//                },completion: nil)
//            self.ScrollView.scrollEnabled = true
//            DateChanged()
//        }
//        
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.Add_Keyboard_Observers()
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
        //var movement:CGFloat = self.logoSuperView.frame.size.height/2
        self.currentKeyboardHeight = movement
        
        let animationDuration = (info[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        if eventDescriptionTextView.isFirstResponder() {
            UIView.animateWithDuration(animationDuration, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
                self.mainView.frame.origin.y = self.view.frame.origin.y-movement
                }
        , completion: nil)
        }
        

        
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        let info:NSDictionary = notification.userInfo!
        //        let keyboardSize = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        //        let keyboardHeight:CGFloat = keyboardSize.height
        
        //        var movement:CGFloat = keyboardHeight
        
        self.currentKeyboardHeight = 0
        let animationDuration = (info[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        
        UIView.animateWithDuration(animationDuration, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            self.mainView.frame.origin.y = 0
        }, completion: nil)
        
    }
        
        
        
}
    
    //hide keyboard and DatePicker
//    func HideKeyboard(){
//        self.view.endEditing(true)
//        if (!InvitingPeople){
//            HidePicker()
//        }
//        
//    }
//    func HidePicker(){
//        Slide_View(false)
//
//    func DateChanged(){
//        //set selected date
//        eventDate = DatePicker.date
//        let EventDateFormatter = NSDateFormatter()
//        EventDateFormatter.dateFormat = "dd/MM/yy HH:mm"
//        //eventDateLabel.text = EventDateFormatter.stringFromDate(eventDate)
//    }
//    
//    
//    func ChoosePhoto(){
//        var imagePicker:UIImagePickerController = UIImagePickerController()
//        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
//        imagePicker.allowsEditing = true
//        imagePicker.delegate = self
//        self.presentViewController(imagePicker, animated: true, completion: nil)
//    }
//        
//    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
//        self.pickedImage = image as UIImage
//        //scale it down
//        let scaledImage = scaleImage(pickedImage, newSize: CGSizeMake(100, 100))
//        let ImageData = UIImagePNGRepresentation(image) //save our image as binary file in order to save on cloud
//        self.eventPicture.image = scaledImage as UIImage
//        picker.dismissViewControllerAnimated(true, completion: nil)
//    }
//    
////    
//    func scaleImage(image:UIImage, newSize:CGSize) ->UIImage{
//        UIGraphicsBeginImageContextWithOptions(newSize, false,  0.0)
//        image.drawInRect(CGRectMake(0, 0, newSize.width, newSize.height))
//        let newImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//        return newImage
//    }
//
//}
