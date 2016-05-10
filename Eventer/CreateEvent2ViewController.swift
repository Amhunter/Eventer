//
//  CreateEvent2ViewController.swift
//  Eventer
//
//  Created by Grisha on 03/10/2015.
//  Copyright © 2015 Grisha. All rights reserved.
//

import UIKit
protocol EventCreationNotificationDelegate {
    func eventWasCreatedSuccessfully()
    func cancelledCreatingEvent()

}
class CreateEvent2ViewController: UIViewController,UIActionSheetDelegate,UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    var screenWidth:CGFloat = UIScreen.mainScreen().bounds.width
    var screenHeight:CGFloat = UIScreen.mainScreen().bounds.height
    var eventName:String?
    var eventDescription:String?
    var eventDate:NSDate?
    var eventIsPublic:Bool?
    var eventImage:UIImage?
    var invitedPeople:[KCSUser] = []
    var tableView = UITableView()
    
    var progressIndicator = UIView()
    var progressActivityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.White)
    var delegate:EventCreationNotificationDelegate! = nil
    //!---Header View----//
    var tableHeaderView = UIView()

//    var profileView = UIView()
//    var profileUsernameLabel = TTTAttributedLabel(frame: CGRectZero)
//    var profileImageView = UIImageView()
//    var createdAtLabel = UILabel()
//    
    var eventNameLabel = UILabel()
    var eventDateLabel = UILabel()
    var eventImageView = ImageProgressView()
    
    var descriptionLabel = TTTAttributedLabel(frame: CGRectZero)
    var timeLocationLabel = TTTAttributedLabel(frame: CGRectZero)
    
    
    var transparentView = UIView()
    var numberOfComments:Int!
    
    
    var goingbtn:UIButton = UIButton()
    var likesbtn:UIButton = UIButton()
    var commentsbtn:UIButton = UIButton()
    var sharesbtn:UIButton = UIButton()
    
    var goingimg:UIImageView = UIImageView(image: UIImage(named: "small-going.png"))
    var likesimg:UIImageView = UIImageView(image: UIImage(named: "small-like.png"))
    var commentsimg:UIImageView = UIImageView(image: UIImage(named: "small-comment.png"))
    var sharesimg:UIImageView = UIImageView(image: UIImage(named: "small-share.png"))
    
    
    var numberOfGoing:Int = 0
    var numberOfMaybe:Int = 0
    var numberOfInvited:Int = 0
    var numberOfLikes:Int = 0
    var numberOfShares:Int = 0
    
    
    var numberOfGoingLabel = UIButton(frame: CGRectZero)
    var numberOfMaybeLabel = UIButton(frame: CGRectZero)
    var numberOfInvitedLabel = UIButton(frame: CGRectZero)
    
    var numberOfLikesButton:UIButton = UIButton()
    var numberOfCommentsButton:UIButton = UIButton()
    var numberOfSharesButton:UIButton = UIButton()
    
    
    
    
    var label = UILabel()
    var customizeButton = UIButton()
    func back(){
        if eventImage != nil {
            (self.navigationController!.viewControllers[0] as! CreateEventViewController).eventImage = eventImage!
        }
        self.navigationController!.popViewControllerAnimated(true)
    }
    override func viewWillAppear(animated: Bool) {
        self.navigationController!.navigationBar.barTintColor = ColorFromCode.orangeFollowColor()
        super.viewWillAppear(animated)
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        Utility.dropShadow(self.navigationController!.navigationBar, offset: 0, opacity: 0)
        self.navigationController!.navigationBar.barTintColor = ColorFromCode.standardBlueColor()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setSubviews()
        setHeaderSubviews()
        setEventData()
    }
    
    func customizeEvent(){
        let actionSheet = UIActionSheet(title: "CUSTOMIZE OPTIONS", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: "Select from Photos", otherButtonTitles: "Take a Picture", "Remove Selected Picture")
        actionSheet.destructiveButtonIndex = 3
        actionSheet.showInView(self.view)

    }
    
    func updateProgressIndicators(progress:Double){
        if progress < 0 {
            // haven't  started yet
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "DONE!", style: UIBarButtonItemStyle.Plain, target: self, action: "done")
            self.navigationItem.rightBarButtonItem?.tintColor = UIColor.whiteColor()
            self.progressIndicator.frame.size.width = 0
            progressActivityIndicator.stopAnimating()
            self.navigationItem.leftBarButtonItem!.enabled = true

        } else {
            // actual progress
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: progressActivityIndicator)
            progressActivityIndicator.startAnimating()
            self.progressIndicator.frame.size.width = (screenWidth/100)*CGFloat(progress)
            self.navigationItem.leftBarButtonItem!.enabled = false
        }
        
    }
    var progress:Double = 0
    func done(){
        tableView.setContentOffset(CGPointZero, animated: true)
        self.navigationItem.leftBarButtonItem!.enabled = false
        self.updateProgressIndicators(0)

        EventsManager.createEvent(eventName!,
            date: eventDate!,
            description: (eventDescription != nil) ? (eventDescription) : nil,
            image: (eventImage != nil) ? (eventImage) : nil,
            isPublic: eventIsPublic!,
            invitedPeople: invitedPeople) {
                (progress:Double, error:NSError!) -> Void in
                if error == nil {
                    self.delegate.eventWasCreatedSuccessfully()
                    print(progress)
                    self.updateProgressIndicators(progress)
                } else {
                    let message = error.localizedDescription
                    let alert = UIAlertView(
                        title: NSLocalizedString("Failed To Create Event", comment: "This is sad"),
                        message: message,
                        delegate: nil,
                        cancelButtonTitle: NSLocalizedString("OK", comment: "OK")
                    )
                    alert.show()
                }
        }
    }
    
    func setSubviews(){
        let backButton = UIBarButtonItem(image: UIImage(named: "back.png"), style: UIBarButtonItemStyle.Plain, target: self, action: "back")
        backButton.tintColor = UIColor.whiteColor()
        self.navigationItem.leftBarButtonItem = backButton
        Utility.dropShadow(self.navigationController!.navigationBar, offset: 3, opacity: 0.25)
        updateProgressIndicators(-1)


        let titleLabel:UILabel = UILabel()
        titleLabel.numberOfLines = 1
        titleLabel.text = "ALMOST THERE"
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.textAlignment = NSTextAlignment.Center
        titleLabel.font = UIFont(name: "Lato-Semibold", size: 18)
        self.navigationItem.titleView = titleLabel
        titleLabel.sizeToFit()
        
        
        // tableView is redundant,we just need its tableHeaderView since UIScrollView causes problems with autolayout
        self.view.addSubview(tableView)
        let offset = self.navigationController!.navigationBar.frame.height + UIApplication.sharedApplication().statusBarFrame.height
        tableView.frame = CGRectMake(0, 0, screenWidth, self.view.frame.height-offset)
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None


    }
    func setHeaderSubviews(){
        tableHeaderView.addSubview(label)
        tableHeaderView.addSubview(customizeButton)

        label.translatesAutoresizingMaskIntoConstraints = false
        customizeButton.translatesAutoresizingMaskIntoConstraints = false
        eventImageView.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        timeLocationLabel.translatesAutoresizingMaskIntoConstraints = false
        
        tableHeaderView.addSubview(eventImageView)
        tableHeaderView.addSubview(timeLocationLabel)
        tableHeaderView.addSubview(descriptionLabel)


        
        let views = [
            "label": label,
            "customizeButton" : customizeButton,
            "eventImageView": eventImageView,
            "timeLocationLabel": timeLocationLabel,
            "descriptionLabel": descriptionLabel
        ]
        let metrics = [
            "screenWidth" : screenWidth
        ]
        let H_Constraint0 = NSLayoutConstraint.constraintsWithVisualFormat("H:|-20-[label]-20-|", options: [], metrics: nil, views: views)
        let H_Constraint1 = NSLayoutConstraint.constraintsWithVisualFormat("H:|-20-[customizeButton]-20-|", options: [], metrics: nil, views: views)
        let H_Constraint2 = NSLayoutConstraint.constraintsWithVisualFormat("H:|[eventImageView]|", options: [], metrics: nil, views: views)
        let H_Constraint3 = NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[timeLocationLabel]-10@999-|", options: [], metrics: nil, views: views)
        let H_Constraint4 = NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[descriptionLabel]-10@999-|", options: [], metrics: nil, views: views)
        
        let V_Constraint0 = NSLayoutConstraint.constraintsWithVisualFormat("V:|-10-[label(70)]-10-[customizeButton(40)]-10-[eventImageView]-15-[timeLocationLabel(<=100@999)]-5-[descriptionLabel(<=550@999)]->=15@999-|", options: [], metrics: metrics, views: views)
        
        
        let squareConstraint = NSLayoutConstraint(item: eventImageView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: eventImageView, attribute: NSLayoutAttribute.Width, multiplier: 1, constant: 0)
        
        self.tableHeaderView.addConstraints(H_Constraint0)
        self.tableHeaderView.addConstraints(H_Constraint1)
        self.tableHeaderView.addConstraints(H_Constraint2)
        self.tableHeaderView.addConstraints(H_Constraint3)
        self.tableHeaderView.addConstraints(H_Constraint4)

        self.tableHeaderView.addConstraints(V_Constraint0)
        self.tableHeaderView.addConstraint(squareConstraint)

        // Set ImageView and ProgressView
        
        self.tableHeaderView.setNeedsLayout()
        self.tableHeaderView.layoutIfNeeded()
        
        self.eventImageView.addSubview(transparentView)
        self.eventImageView.bringSubviewToFront(eventNameLabel)
        self.eventImageView.sendSubviewToBack(transparentView)
        eventImageView.userInteractionEnabled = true
        self.eventImageView.sendSubviewToBack(transparentView)
        
        self.transparentView.frame.origin = CGPointMake(0,screenWidth-160)
        self.transparentView.frame.size = CGSizeMake(screenWidth, 160)
        self.transparentView.layer.insertSublayer(Utility.gradientLayer(self.transparentView.frame, height: self.transparentView.frame.height, alpha: 0.75), atIndex: 0)
        
        
        
        
        
        timeLocationLabel.textAlignment = NSTextAlignment.Center
        timeLocationLabel.numberOfLines = 3
        
        let attrs = [NSForegroundColorAttributeName: UIColor.blackColor()]
        timeLocationLabel.activeLinkAttributes = attrs
        descriptionLabel.activeLinkAttributes = attrs
        
        
        // Image View
        eventNameLabel.alpha = 1
        eventNameLabel.backgroundColor = UIColor.clearColor()
        eventNameLabel.textColor = UIColor.whiteColor()
        eventNameLabel.textAlignment = NSTextAlignment.Center
        eventNameLabel.font = UIFont(name: "Lato-Semibold", size: 21)
        eventNameLabel.numberOfLines = 0
        eventDateLabel.backgroundColor = ColorFromCode.colorWithHexString("#02A8F3")
        eventDateLabel.textColor = UIColor.whiteColor()
        eventDateLabel.numberOfLines = 0
        eventDateLabel.textAlignment = NSTextAlignment.Center
        descriptionLabel.numberOfLines = 0
        // Progress View
        transparentView.backgroundColor = UIColor.clearColor()

        
        numberOfGoingLabel.titleLabel!.font = UIFont(name: "Lato-Bold", size: 12)
        numberOfGoingLabel.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        numberOfGoingLabel.setTitleColor(ColorFromCode.orangeFollowColor(), forState: UIControlState.Highlighted)
        numberOfGoingLabel.titleLabel!.textAlignment = NSTextAlignment.Center
        numberOfGoingLabel.titleLabel!.numberOfLines = 1
        
        numberOfMaybeLabel.titleLabel!.font = UIFont(name: "Lato-Bold", size: 12)
        numberOfMaybeLabel.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        numberOfMaybeLabel.setTitleColor(ColorFromCode.orangeFollowColor(), forState: UIControlState.Highlighted)
        numberOfMaybeLabel.titleLabel!.textAlignment = NSTextAlignment.Center
        numberOfMaybeLabel.titleLabel!.numberOfLines = 1
        
        
        numberOfInvitedLabel.titleLabel!.font = UIFont(name: "Lato-Bold", size: 12)
        numberOfInvitedLabel.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        numberOfInvitedLabel.setTitleColor(ColorFromCode.orangeFollowColor(), forState: UIControlState.Highlighted)
        numberOfInvitedLabel.titleLabel!.textAlignment = NSTextAlignment.Center
        numberOfInvitedLabel.titleLabel!.numberOfLines = 1
        
        numberOfLikesButton.tintColor = UIColor.whiteColor()
        numberOfLikesButton.titleLabel!.font = UIFont(name: "Lato-Bold", size: 12)
        UIImage().scale
        numberOfLikesButton.titleLabel!.numberOfLines = 1
        
        numberOfLikesButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 2, bottom: 1.5, right: -2)
        numberOfLikesButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -2, bottom: 1.5, right: 2)
        numberOfLikesButton.setImage(UIImage(named: "small-like")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate), forState: UIControlState.Normal)
        numberOfLikesButton.setImage(UIImage(named: "small-like-active")!, forState: UIControlState.Highlighted)
        numberOfLikesButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        numberOfLikesButton.setTitleColor(ColorFromCode.orangeFollowColor(), forState: UIControlState.Highlighted)
        numberOfSharesButton.tintColor = UIColor.whiteColor()
        numberOfSharesButton.titleLabel!.font = UIFont(name: "Lato-Bold", size: 12)
        numberOfSharesButton.titleLabel!.numberOfLines = 1
        
        numberOfSharesButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 2, bottom: 1.5, right: -2)
        numberOfSharesButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -2, bottom: 1.5, right: 2)
        numberOfSharesButton.setImage(UIImage(named: "small-share")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate), forState: UIControlState.Normal)
        numberOfSharesButton.setImage(UIImage(named: "small-share-active")!, forState: UIControlState.Highlighted)
        numberOfSharesButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        numberOfSharesButton.setTitleColor(ColorFromCode.orangeFollowColor(), forState: UIControlState.Highlighted)
        
        eventImageView.backgroundColor = ColorFromCode.standardBlueColor()
        transparentView.userInteractionEnabled = false
        
        label.text = "Brilliant! This is a preview of your event , maybe a picture can make it look even nicer!"
        let xSpacing:CGFloat = 40
        let ySpacing:CGFloat = 40
        label.preferredMaxLayoutWidth = screenWidth-(2*xSpacing)
        label.numberOfLines = 0
        label.font = UIFont(name: "Lato-Semibold", size: 17)
        label.textColor = UIColor.blackColor()
        label.frame = CGRectMake(xSpacing, ySpacing, screenWidth-(2*xSpacing), 100)
        
        customizeButton.setTitle("Customize It!", forState: UIControlState.Normal)
        customizeButton.setTitleColor(ColorFromCode.orangeFollowColor(), forState: UIControlState.Normal)
        customizeButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Highlighted)
        customizeButton.titleLabel!.font = UIFont(name: "Lato-Semibold", size: 18)
        customizeButton.backgroundColor = ColorFromCode.tabBackgroundColor()
        customizeButton.addTarget(self, action: "customizeEvent", forControlEvents: UIControlEvents.TouchUpInside)
        
        sizeHeaderToFit(false)
        self.tableHeaderView.addSubview(progressIndicator)
        progressIndicator.frame.size.height = 4
        progressIndicator.backgroundColor = UIColor.greenColor()
        progressIndicator.frame.size.width = 0

    }

    func sizeHeaderToFit(animated:Bool){
        let view = self.tableHeaderView
        view.setNeedsLayout()
        view.layoutIfNeeded()
        
        let descrHeight = descriptionLabel.sizeThatFits(CGSizeMake(descriptionLabel.frame.width, 550)).height
        let timelocHeight = timeLocationLabel.sizeThatFits(CGSizeMake(timeLocationLabel.frame.width, 100)).height
        let labelHeight = label.frame.height
        let buttonHeight = customizeButton.frame.height
        let height = 10 + labelHeight + 10 + buttonHeight + 10 + screenWidth + 15 + timelocHeight + 5 + descrHeight + 15
        view.frame.size.height = height
        if (animated){
            UIView.animateWithDuration(0.25, delay: 0, options: [], animations: {
                () -> Void in
                self.tableView.tableHeaderView = view
                }, completion: nil)
        }else{
            self.tableView.tableHeaderView = view
        }
        

    }
    
    func showImage(){
        let ImageSubviews = [
            "evDate": eventDateLabel,
            "evName": eventNameLabel,
            "numberOfGoing": numberOfGoingLabel,
            "numberOfMaybe": numberOfMaybeLabel,
            "numberOfInvited": numberOfInvitedLabel,
            "likesButton": numberOfLikesButton,
            "sharesButton": numberOfSharesButton
            
        ]
        eventNameLabel.translatesAutoresizingMaskIntoConstraints = false
        eventDateLabel.translatesAutoresizingMaskIntoConstraints = false
        numberOfGoingLabel.translatesAutoresizingMaskIntoConstraints = false
        numberOfMaybeLabel.translatesAutoresizingMaskIntoConstraints = false
        numberOfInvitedLabel.translatesAutoresizingMaskIntoConstraints = false
        numberOfLikesButton.translatesAutoresizingMaskIntoConstraints = false
        numberOfSharesButton.translatesAutoresizingMaskIntoConstraints = false
        
        if (eventImage != nil){//no picture
            
            self.eventImageView.addSubview(eventNameLabel)
            self.eventImageView.addSubview(eventDateLabel)
            self.eventImageView.addSubview(numberOfGoingLabel)
            self.eventImageView.addSubview(numberOfMaybeLabel)
            self.eventImageView.addSubview(numberOfInvitedLabel)
            self.eventImageView.addSubview(numberOfLikesButton)
            self.eventImageView.addSubview(numberOfSharesButton)
            
            let IH_Constraint1 = NSLayoutConstraint.constraintsWithVisualFormat("H:|[evDate(60)]->=0@999-|", options: [], metrics: nil, views: ImageSubviews)
            let IH_Constraint2 = NSLayoutConstraint.constraintsWithVisualFormat("H:|-20-[evName(>=0@999)]-20-|", options: [], metrics: nil, views: ImageSubviews)
            let IH_Constraint3 = NSLayoutConstraint.constraintsWithVisualFormat("H:|-12-[likesButton]-15-[sharesButton]->=0@999-[numberOfGoing]-10-[numberOfMaybe]-10-[numberOfInvited]-10-|", options: NSLayoutFormatOptions.AlignAllCenterY, metrics: nil, views: ImageSubviews)
            
            
            let IV_Constraint1 = NSLayoutConstraint.constraintsWithVisualFormat("V:|[evDate(60)]->=0@999-[evName(<=100@999)][numberOfGoing(45)]|", options: [], metrics: nil, views: ImageSubviews)
            
            
            self.eventImageView.removeConstraints(eventImageView.constraints)
            self.eventImageView.addConstraints(IH_Constraint1)
            self.eventImageView.addConstraints(IH_Constraint2)
            self.eventImageView.addConstraints(IH_Constraint3)
            
            self.eventImageView.addConstraints(IV_Constraint1)
            self.transparentView.hidden = false
            self.eventImageView.image = eventImage
        }else{
            self.eventImageView.updateView(nil, showProgress: false)
            self.eventImageView.addSubview(eventNameLabel)
            self.eventImageView.addSubview(eventDateLabel)
            self.eventImageView.addSubview(numberOfGoingLabel)
            self.eventImageView.addSubview(numberOfMaybeLabel)
            self.eventImageView.addSubview(numberOfInvitedLabel)
            self.eventImageView.addSubview(numberOfLikesButton)
            self.eventImageView.addSubview(numberOfSharesButton)
            
            //var IH_Constraint1 = NSLayoutConstraint.constraintsWithVisualFormat("H:|--[evDate]-10-|", options: nil, metrics: nil, views: ImageSubviews)
            let IH_Constraint1 = NSLayoutConstraint.constraintsWithVisualFormat("H:|[evDate(60)]->=0@999-|", options: [], metrics: nil, views: ImageSubviews)
            let IH_Constraint2 = NSLayoutConstraint.constraintsWithVisualFormat("H:|-20-[evName]-20-|", options: [], metrics: nil, views: ImageSubviews)
            let IH_Constraint3 = NSLayoutConstraint.constraintsWithVisualFormat("H:|-12-[likesButton]-15-[sharesButton]->=0@999-[numberOfGoing]-10-[numberOfMaybe]-10-[numberOfInvited]-10-|", options: NSLayoutFormatOptions.AlignAllCenterY, metrics: nil, views: ImageSubviews)
            
            let IV_Constraint1 = NSLayoutConstraint.constraintsWithVisualFormat("V:|[evDate(60)]-[evName(>=0@999)]-10-[numberOfGoing(45)]|", options: [], metrics: nil, views: ImageSubviews)
            self.eventImageView.removeConstraints(eventImageView.constraints)
            self.eventImageView.addConstraints(IH_Constraint1)
            self.eventImageView.addConstraints(IH_Constraint2)
            self.eventImageView.addConstraints(IH_Constraint3)
            
            self.eventImageView.addConstraints(IV_Constraint1)
            transparentView.hidden = true
            self.eventImageView.image = nil
            
        }
        
        
    }
    
    
//    func UpdateProfilePicture(){
//        dispatch_async(dispatch_get_main_queue(), {
//            () -> Void in
//            if (self.event.profilePictureID == ""){//no picture
//            }else{
//                if (self.event.profilePictureProgress < 1){ //picture is loading
//                }else{ //picture is loaded
//                    self.profileImageView.image = self.event.profilePicture
//                }
//            }
//        })
//    }
    func setResponsesData(){
        numberOfGoingLabel.hidden = false
        numberOfMaybeLabel.hidden = false
        numberOfInvitedLabel.hidden = false

        if eventIsPublic! {
            numberOfInvitedLabel.setTitle("All invited", forState: UIControlState.Normal)
            numberOfGoingLabel.setTitle("\(Utility.randomNumber(0, highestValue: 999)) going", forState: UIControlState.Normal)
            numberOfMaybeLabel.setTitle("\(Utility.randomNumber(0, highestValue: 999)) maybe", forState: UIControlState.Normal)
        } else {
            numberOfInvitedLabel.setTitle("\(invitedPeople.count) invited", forState: UIControlState.Normal)
            
            var goingNumber = 0
            var maybeNumber = 0
            if invitedPeople.count != 0 {
                maybeNumber = Utility.randomNumber(0, highestValue: invitedPeople.count)
                goingNumber = invitedPeople.count - maybeNumber
            }
            numberOfGoingLabel.setTitle("\(goingNumber) going", forState: UIControlState.Normal)
            numberOfMaybeLabel.setTitle("\(maybeNumber) maybe", forState: UIControlState.Normal)
        }
        
        
    }
    func setEventData(){
        for number in (self.navigationController!.viewControllers[0] as! CreateEventViewController).inviteVC.invitedPeople {
            invitedPeople.append((self.navigationController!.viewControllers[0] as! CreateEventViewController).inviteVC.followers[number].user)

        }


        
        numberOfLikesButton.hidden = false
        numberOfSharesButton.hidden = false
        
        
//        let authorNameText = self.event.author!.username
        let eventNameText = self.eventName
        let eventDateText = DateToStringConverter.eventDateToText(eventDate!, tab: TargetView.Home)
        
        let dateFormatter:NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let timeString = dateFormatter.stringFromDate(self.eventDate!)
        
        self.eventDateLabel.attributedText = eventDateText
        self.eventNameLabel.text = eventNameText
        // details
        let eventDetailsText = NSMutableAttributedString()
        if (self.eventDescription != nil){
            var attrs = [NSFontAttributeName : UIFont(name: "Lato-Medium", size: 14)!, NSForegroundColorAttributeName: ColorFromCode.randomBlueColorFromNumber(3)]
            var content = NSMutableAttributedString(string: "\(KCSUser.activeUser().username)", attributes: attrs)
            eventDetailsText.appendAttributedString(content)
            attrs = [NSFontAttributeName : UIFont(name: "Lato-Regular", size: 14)!, NSForegroundColorAttributeName: UIColor.blackColor()]
            content = NSMutableAttributedString(string: " \(self.eventDescription!)", attributes: attrs)
            eventDetailsText.appendAttributedString(content)
        }
        let eventTimeAndLocationText = NSMutableAttributedString()
        // time
        let attrs = [NSFontAttributeName : UIFont(name: "Lato-Regular", size: 16)!, NSForegroundColorAttributeName: ColorFromCode.randomBlueColorFromNumber(3)]
        let content = NSMutableAttributedString(string: "\(timeString) ", attributes:attrs)
        eventTimeAndLocationText.appendAttributedString(content)

        timeLocationLabel.attributedText = eventTimeAndLocationText
        descriptionLabel.attributedText = eventDetailsText
        Utility.highlightHashtagsInString(eventDetailsText, withColor: ColorFromCode.randomBlueColorFromNumber(3), inLabel: descriptionLabel)
        Utility.highlightMentionsInString(eventDetailsText, withColor: ColorFromCode.randomBlueColorFromNumber(3), inLabel: descriptionLabel)
        
        numberOfLikesButton.setTitle("\(Utility.randomNumber(0, highestValue: 999))", forState: UIControlState.Normal)
        numberOfSharesButton.setTitle("\(Utility.randomNumber(0, highestValue: 999))", forState: UIControlState.Normal)
        
        
        self.showImage()
//        self.UpdateProfilePicture()
        setResponsesData()
        sizeHeaderToFit(false)
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
        if image == nil {
            eventImage = nil
        } else {
            eventImage = image
        }
        showImage()

    }

    
}
