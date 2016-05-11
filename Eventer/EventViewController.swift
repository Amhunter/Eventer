//
//  EventViewController.swift
//  GCalendar
//
//  Created by Grisha on 26/10/2014.
//  Copyright (c) 2014 Grisha. All rights reserved.
//

import UIKit

class EventViewController: UIViewController,UITableViewDelegate, UITableViewDataSource, UIScrollViewDelegate,UITextViewDelegate,UIGestureRecognizerDelegate,TTTAttributedLabelDelegate {
    var viewWidth:CGFloat = UIScreen.mainScreen().bounds.width
    var viewHeight:CGFloat = UIScreen.mainScreen().bounds.height
    var offset:CGFloat!
    var viewFrame:CGRect = CGRect()
    
    var MVC:MentionsViewController!
    var HVC:HashtagsViewController!
    var loadedFromActivity = false

    //!---Header View----//
    var headerView = UIView()
    var footerView = UIView()
    
    var profileView = UIView()
    var profileUsernameLabel = TTTAttributedLabel(frame: CGRectZero)
    var profileImageView = UIImageView()
    var createdAtLabel = UILabel()

    var eventNameLabel = UILabel()
    var eventDateLabel = UILabel()
    var eventImageView = ImageProgressView()

    var descriptionLabel = TTTAttributedLabel(frame: CGRectZero)
    var timeLocationLabel = TTTAttributedLabel(frame: CGRectZero)

    var GoButton = HomeResponseButton()
    var LikeButton = HomeLikeButton()
    var ShareButton = HomeShareButton()
    var MoreButton = HomeMoreButton()
    
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
    
    
    var separatorLine = UIView()
    var pushAllCommentsButton = UIButton()
    var writeComment = UIButton()


    var ScrollPosition:CGFloat = CGFloat()
    var MainView:UIView = UIView(frame: CGRectMake(0, 0, 320, 528)) // part of main table view
    var tableView = UITableView()
    
    var responseView = ResponseManager()
    
    //Toolbar
//    var PostCommentView:UIView = UIView(frame: CGRectMake(0, UIScreen.mainScreen().bounds.height-50, UIScreen.mainScreen().bounds.width, 50))
//    var InputTextView:CommentTextView = CommentTextView(frame: CGRectMake(10, 10, 240, 30))
//    var PostCommentButton:UIButton = UIButton(frame: CGRectMake(260,10,50,30))
    var CurrentKeyboardHeight:CGFloat = CGFloat() // crucial
    var KeyBoardActive:Bool! // when app becomes active from background , it's somewhy resizes view.frame, that's why we ll put it back
    
    var Comments:[FetchedActivityUnit] = []
    
    
    var event:FetchedEvent!

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        Utility.dropShadow(self.navigationController!.navigationBar, offset: 1, opacity: 0.25)
//        self.Add_Keyboard_Observers()
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        Utility.dropShadow(self.navigationController!.navigationBar, offset: 0, opacity: 0)
        HideKeyboard()
//        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
//        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setHeader()
        setInitialData()
        setMainView()
        setEventData() // temp
        getEventData()
        //LoadChildControllers()
        
    }
    
    func setHeader(){
        sizeHeaderToFit(false)
        profileView.translatesAutoresizingMaskIntoConstraints = false
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        profileUsernameLabel.translatesAutoresizingMaskIntoConstraints = false
        createdAtLabel.translatesAutoresizingMaskIntoConstraints = false
        
        eventImageView.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        LikeButton.translatesAutoresizingMaskIntoConstraints = false
        ShareButton.translatesAutoresizingMaskIntoConstraints = false
        timeLocationLabel.translatesAutoresizingMaskIntoConstraints = false
        responseView.translatesAutoresizingMaskIntoConstraints = false
        separatorLine.translatesAutoresizingMaskIntoConstraints = false
        pushAllCommentsButton.translatesAutoresizingMaskIntoConstraints = false
        writeComment.translatesAutoresizingMaskIntoConstraints = false
        
        headerView.addSubview(profileView)
        headerView.addSubview(eventImageView)
        headerView.addSubview(timeLocationLabel)
        headerView.addSubview(descriptionLabel)
        headerView.addSubview(LikeButton)
        headerView.addSubview(ShareButton)
        headerView.addSubview(responseView)
        headerView.addSubview(separatorLine)
        headerView.addSubview(pushAllCommentsButton)
        headerView.addSubview(writeComment)
        
        responseView.initialize(self.event)

        separatorLine.backgroundColor = ColorFromCode.colorWithHexString("#DAE4E7")
        
        let views = [
            "profileView": profileView,
            "eventImageView": eventImageView,
            "timeLocationLabel": timeLocationLabel,
            "descriptionLabel": descriptionLabel,
            "LikeButton": LikeButton,
            "ShareButton": ShareButton,
            "responseView": responseView,
            "separatorLine": separatorLine,
            "pushCommentsBtn": pushAllCommentsButton,
            "writeCommentBtn": writeComment
        ]
        let metrics = [
            "screenWidth" : viewWidth
        ]
        let H_Constraint0 = NSLayoutConstraint.constraintsWithVisualFormat("H:|[profileView]|", options: [], metrics: nil, views: views)
        let H_Constraint1 = NSLayoutConstraint.constraintsWithVisualFormat("H:|[eventImageView]|", options: [], metrics: nil, views: views)
        let H_Constraint2 = NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[timeLocationLabel]-10@999-|", options: [], metrics: nil, views: views)
        let H_Constraint3 = NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[descriptionLabel]-10@999-|", options: [], metrics: nil, views: views)
        let H_Constraint4 = NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[LikeButton]-25-[ShareButton]->=0@700-[responseView(>=0@999)]-5@999-|", options: NSLayoutFormatOptions.AlignAllCenterY, metrics: nil, views: views)
        let H_Constraint5 = NSLayoutConstraint.constraintsWithVisualFormat("H:|[separatorLine]|", options: [], metrics: nil, views: views)
        let H_Constraint6 = NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[pushCommentsBtn(>=0@999)]-10-[writeCommentBtn(<=60@999)]-10@999-|", options: NSLayoutFormatOptions.AlignAllCenterY, metrics: nil, views: views)

        let V_Constraint0 = NSLayoutConstraint.constraintsWithVisualFormat("V:|[profileView(60)][eventImageView]-15-[timeLocationLabel(<=100@999)]-5-[descriptionLabel(<=550@999)]-15-[LikeButton]-15-[separatorLine(0.5)]-[pushCommentsBtn(30)]->=0@999-|", options: [], metrics: metrics, views: views)
        

        let squareConstraint = NSLayoutConstraint(item: eventImageView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: eventImageView, attribute: NSLayoutAttribute.Width, multiplier: 1, constant: 0)
        
        self.headerView.addConstraints(H_Constraint0)
        self.headerView.addConstraints(H_Constraint1)
        self.headerView.addConstraints(H_Constraint2)
        self.headerView.addConstraints(H_Constraint3)
        self.headerView.addConstraints(H_Constraint4)
        self.headerView.addConstraints(H_Constraint5)
        self.headerView.addConstraints(H_Constraint6)

        self.headerView.addConstraints(V_Constraint0)
        self.headerView.addConstraint(squareConstraint)
        
        
        // Setting Profile View
        self.profileView.addSubview(profileImageView)
        self.profileView.addSubview(profileUsernameLabel)
        self.profileView.addSubview(createdAtLabel)
        
        self.profileImageView.translatesAutoresizingMaskIntoConstraints = false
        self.profileUsernameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.createdAtLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let profileViews = [
            "profilePicture": profileImageView,
            "profileName" : profileUsernameLabel,
            "createdAt" : createdAtLabel
        ]
        
        let SH_Constraint0 = NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[profilePicture(40@999)]-10-[profileName]->=10@999-[createdAt]-15-|", options: [], metrics: nil, views: profileViews)
        let SV_Constraint0 = NSLayoutConstraint.constraintsWithVisualFormat("V:|-10-[profilePicture(40@999)]-10-|", options: [], metrics: nil, views: profileViews)
        let SV_Constraint1 = NSLayoutConstraint.constraintsWithVisualFormat("V:|-10-[profileName(40@999)]-10-|", options: [], metrics: nil, views: profileViews)
        let SV_Constraint2 = NSLayoutConstraint.constraintsWithVisualFormat("V:|-10-[createdAt(40@999)]-10-|", options: [], metrics: nil, views: profileViews)
        
        self.profileView.addConstraints(SH_Constraint0)
        self.profileView.addConstraints(SV_Constraint0)
        self.profileView.addConstraints(SV_Constraint1)
        self.profileView.addConstraints(SV_Constraint2)


        // Set ImageView and ProgressView
        
        self.headerView.setNeedsLayout()
        self.headerView.layoutIfNeeded()
        
        self.eventImageView.addSubview(transparentView)
        self.eventImageView.bringSubviewToFront(eventNameLabel)
        self.eventImageView.sendSubviewToBack(transparentView)
        eventImageView.userInteractionEnabled = true
        self.eventImageView.sendSubviewToBack(transparentView)
    
        
//        println(eventImageView.origin.y)
//        println(eventImageView.frame.height)
        self.transparentView.frame.origin = CGPointMake(0,viewWidth-160)
        self.transparentView.frame.size = CGSizeMake(viewWidth, 160)
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
        
        profileView.backgroundColor = UIColor.whiteColor()
        profileImageView.layer.cornerRadius = 20
        profileImageView.layer.masksToBounds = true
        profileUsernameLabel.font = UIFont(name: "Lato-Medium", size: 15)
        
        profileView.userInteractionEnabled = true
        profileUsernameLabel.userInteractionEnabled = true
        profileImageView.userInteractionEnabled = true
        profileUsernameLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(pushAuthor)))
        profileImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(pushAuthor)))

        createdAtLabel.textColor = UIColor.lightGrayColor()
        createdAtLabel.font = UIFont(name: "Lato-Regular", size: 14)
        createdAtLabel.textAlignment = NSTextAlignment.Right
        
        numberOfGoingLabel.titleLabel!.font = UIFont(name: "Lato-Bold", size: 12)
        numberOfGoingLabel.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        numberOfGoingLabel.setTitleColor(ColorFromCode.orangeFollowColor(), forState: UIControlState.Highlighted)
        numberOfGoingLabel.titleLabel!.textAlignment = NSTextAlignment.Center
        numberOfGoingLabel.titleLabel!.numberOfLines = 1
        numberOfGoingLabel.addTarget(self, action: #selector(pushGoing), forControlEvents: UIControlEvents.TouchUpInside)

        numberOfMaybeLabel.titleLabel!.font = UIFont(name: "Lato-Bold", size: 12)
        numberOfMaybeLabel.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        numberOfMaybeLabel.setTitleColor(ColorFromCode.orangeFollowColor(), forState: UIControlState.Highlighted)
        numberOfMaybeLabel.titleLabel!.textAlignment = NSTextAlignment.Center
        numberOfMaybeLabel.titleLabel!.numberOfLines = 1
        numberOfMaybeLabel.addTarget(self, action: #selector(pushMaybe), forControlEvents: UIControlEvents.TouchUpInside)


        numberOfInvitedLabel.titleLabel!.font = UIFont(name: "Lato-Bold", size: 12)
        numberOfInvitedLabel.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        numberOfInvitedLabel.setTitleColor(ColorFromCode.orangeFollowColor(), forState: UIControlState.Highlighted)
        numberOfInvitedLabel.titleLabel!.textAlignment = NSTextAlignment.Center
        numberOfInvitedLabel.titleLabel!.numberOfLines = 1
        numberOfInvitedLabel.addTarget(self, action: #selector(pushInvited), forControlEvents: UIControlEvents.TouchUpInside)

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
        numberOfLikesButton.addTarget(self, action: #selector(pushLikes), forControlEvents: UIControlEvents.TouchUpInside)
        numberOfSharesButton.tintColor = UIColor.whiteColor()
        numberOfSharesButton.titleLabel!.font = UIFont(name: "Lato-Bold", size: 12)
        numberOfSharesButton.titleLabel!.numberOfLines = 1

        numberOfSharesButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 2, bottom: 1.5, right: -2)
        numberOfSharesButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: -2, bottom: 1.5, right: 2)
        numberOfSharesButton.setImage(UIImage(named: "small-share")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate), forState: UIControlState.Normal)
        numberOfSharesButton.setImage(UIImage(named: "small-share-active")!, forState: UIControlState.Highlighted)
        numberOfSharesButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        numberOfSharesButton.setTitleColor(ColorFromCode.orangeFollowColor(), forState: UIControlState.Highlighted)
        numberOfSharesButton.addTarget(self, action: #selector(pushShares), forControlEvents: UIControlEvents.TouchUpInside)

        eventImageView.backgroundColor = ColorFromCode.standardBlueColor()

        pushAllCommentsButton.setTitle("Loading comments ...", forState: UIControlState.Normal)
        pushAllCommentsButton.setTitleColor(ColorFromCode.colorWithHexString("#0087D9"), forState: UIControlState.Normal)
        pushAllCommentsButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Highlighted)
        pushAllCommentsButton.backgroundColor = ColorFromCode.colorWithHexString("#EBF0F2")
        pushAllCommentsButton.titleLabel!.font = UIFont(name: "Lato-Semibold", size: 14)
        pushAllCommentsButton.layer.cornerRadius = 7
        pushAllCommentsButton.addTarget(self, action: #selector(pushAllComments), forControlEvents: UIControlEvents.TouchUpInside)
        writeComment.setImage(UIImage(named: "comment"), forState: UIControlState.Normal)
        writeComment.setImage(UIImage(named: "comment-highlighted"), forState: UIControlState.Highlighted)


        transparentView.userInteractionEnabled = false
        
        sizeHeaderToFit(false)

    }
    func setInitialData(){

        numberOfGoingLabel.setTitle("\(self.event.goManager.numberOfGoing) going", forState: UIControlState.Normal)

        numberOfMaybeLabel.hidden = true
        numberOfInvitedLabel.hidden = true
        if event.goManager.isGoing {
            responseView.buttons["yes"]?.setActive(true)
            responseView.buttons["maybe"]?.setActive(false)
            responseView.buttons["no"]?.setActive(false)
        }else{
            responseView.buttons["yes"]?.setActive(false)
            responseView.buttons["maybe"]?.setActive(false)
            responseView.buttons["no"]?.setActive(false)
            responseView.buttons["yes"]?.enabled = false
            responseView.buttons["maybe"]?.enabled = false
            responseView.buttons["no"]?.enabled = false
        }
        
        if loadedFromActivity {
            self.LikeButton.enabled = false
            self.ShareButton.enabled = false
            self.numberOfLikesButton.hidden = true
            self.numberOfSharesButton.hidden = true
        }
    }

    func showImage(show:Bool){
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

        if (self.event.pictureId != ""){//no picture
            
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



            if (show){
                transparentView.hidden = false
            }else{ // show progress
                transparentView.hidden = true
            }
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


        }
        

    }
    
    
    func UpdateEventPicture(){
        dispatch_async(dispatch_get_main_queue(), {
            () -> Void in
            if (self.event.pictureId == ""){//no picture
                self.showImage(false)
            }else{
                
                if (self.event.pictureProgress < 1){ //picture is loading
                    self.eventImageView.updateView(nil, showProgress: true)
                    self.eventImageView.updateProgress(self.event.pictureProgress)
                    self.showImage(false)
                }else{ //picture is loaded
                    self.eventImageView.updateView(self.event.picture, showProgress: false)
                    self.showImage(true)
                    
                }
            }
        })
    }
    func UpdateProfilePicture(){
        
        dispatch_async(dispatch_get_main_queue(), {
            () -> Void in
            if (self.event.profilePictureID == ""){//no picture
            }else{
                if (self.event.profilePictureProgress < 1){ //picture is loading
                }else{ //picture is loaded
                    self.profileImageView.image = self.event.profilePicture
                }
            }
        })
    }
    
    

    
    func setMainView(){

        let backButton = UIBarButtonItem(image: UIImage(named: "back.png"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(back))
        backButton.tintColor = UIColor.whiteColor()
        if (self.navigationController!.viewControllers.count > 1){
            self.navigationItem.leftBarButtonItem = backButton
        }
        
        let titleLabel:UILabel = UILabel()
        titleLabel.numberOfLines = 1
        titleLabel.text = "EVENT"
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.textAlignment = NSTextAlignment.Center
        titleLabel.font = UIFont(name: "Lato-Semibold", size: 18)
        self.navigationItem.titleView = titleLabel
        titleLabel.sizeToFit()
        
        
        self.view.addSubview(tableView)

        let offset = self.navigationController!.navigationBar.frame.height + UIApplication.sharedApplication().statusBarFrame.height + self.tabBarController!.tabBar.frame.height
        tableView.frame = CGRectMake(0, 0, viewWidth, self.view.frame.height-offset)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.autoresizesSubviews = true
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        self.tableView.registerClass(MiniCommentTableViewCell.self, forCellReuseIdentifier: "Comment Cell")
        self.tableView.allowsSelection = false
        self.tableView.estimatedRowHeight = 100
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.eventImageView.progressCircle.addTarget(self, action: #selector(refresh(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
        let view = UIView(frame: CGRectMake(0,0,viewWidth,30))
        tableView.tableFooterView = view
    }
    func setResponsesData(){
        numberOfGoingLabel.hidden = false
        numberOfMaybeLabel.hidden = false
        numberOfInvitedLabel.hidden = false
        numberOfGoingLabel.setTitle("\(numberOfGoing) going", forState: UIControlState.Normal)
        numberOfMaybeLabel.setTitle("\(numberOfMaybe) maybe", forState: UIControlState.Normal)
        numberOfInvitedLabel.setTitle("\(numberOfInvited) invited", forState: UIControlState.Normal)
        
//        numberOfLikesButton.hidden = false
//        numberOfSharesButton.hidden = false
        
        for button in self.responseView.buttons.values {
            button.enabled = true
        }
        self.responseView.Display_Changes()
    }
    
    func setLikesAndSharesData(){
        self.LikeButton.enabled = true
        self.ShareButton.enabled = true
        self.numberOfLikesButton.hidden = false
        self.numberOfSharesButton.hidden = false
        
        LikeButton.initialize(event.likeManager.isLiked)
        LikeButton.addTarget(self, action: #selector(like(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        ShareButton.initialize(event.shareManager.isShared)
        ShareButton.addTarget(self, action: #selector(share(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        numberOfLikesButton.setTitle("\(self.event.likeManager.numberOfLikes)", forState: UIControlState.Normal)
        numberOfSharesButton.setTitle("\(self.event.shareManager.numberOfShares)", forState: UIControlState.Normal)
    }
    func setAuthorData(){
        if event.author != nil {
            var authorNameText = ""
            authorNameText = self.event.author!.username
            self.profileUsernameLabel.text = authorNameText
            let eventDetailsText = NSMutableAttributedString()
            if (self.event.details != ""){
                var attrs = [NSFontAttributeName : UIFont(name: "Lato-Medium", size: 14)!, NSForegroundColorAttributeName: ColorFromCode.randomBlueColorFromNumber(3)]
                var content = NSMutableAttributedString(string: "\(authorNameText)", attributes: attrs)
                eventDetailsText.appendAttributedString(content)
                attrs = [NSFontAttributeName : UIFont(name: "Lato-Regular", size: 14)!, NSForegroundColorAttributeName: UIColor.blackColor()]
                
                if event.author != nil {
                    content = NSMutableAttributedString(string: " \(self.event.details)", attributes: attrs)
                } else {
                    content = NSMutableAttributedString(string: "\(self.event.details)", attributes: attrs)
                }
                eventDetailsText.appendAttributedString(content)
            }
            // clickable author name
            if (self.event.details != "") && (self.event.author != nil){
                let url:NSURL = NSURL(scheme: "pushAuthor", host: "", path: "/")!
                descriptionLabel.addLinkToURL(url, withRange:NSRange(location: 0,length: (authorNameText as NSString).length))
                descriptionLabel.delegate = self
            }
            
            descriptionLabel.attributedText = eventDetailsText
            Utility.highlightHashtagsInString(eventDetailsText, withColor: ColorFromCode.randomBlueColorFromNumber(3), inLabel: descriptionLabel)
            Utility.highlightMentionsInString(eventDetailsText, withColor: ColorFromCode.randomBlueColorFromNumber(3), inLabel: descriptionLabel)
        }
    }
    func setEventData(){
       
        
        LikeButton.initialize(event.likeManager.isLiked)
        LikeButton.addTarget(self, action: #selector(like(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        ShareButton.initialize(event.shareManager.isShared)
        ShareButton.addTarget(self, action: #selector(share(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        
        var authorNameText = ""
        if event.author != nil {
            authorNameText = self.event.author!.username
            self.profileUsernameLabel.text = authorNameText
        }
        let eventNameText = self.event.name as String
        let eventDateText = self.event.eventDateText
        let createdAtText = self.event.createdAtText as String
        
        self.createdAtLabel.text = createdAtText
        self.eventDateLabel.attributedText = eventDateText
        self.eventNameLabel.text = eventNameText
        // details
        let eventDetailsText = NSMutableAttributedString()
        if (self.event.details != ""){
            var attrs = [NSFontAttributeName : UIFont(name: "Lato-Medium", size: 14)!, NSForegroundColorAttributeName: ColorFromCode.randomBlueColorFromNumber(3)]
            var content = NSMutableAttributedString(string: "\(authorNameText)", attributes: attrs)
            eventDetailsText.appendAttributedString(content)
            attrs = [NSFontAttributeName : UIFont(name: "Lato-Regular", size: 14)!, NSForegroundColorAttributeName: UIColor.blackColor()]
            
            if event.author != nil {
                content = NSMutableAttributedString(string: " \(self.event.details)", attributes: attrs)
            } else {
                content = NSMutableAttributedString(string: "\(self.event.details)", attributes: attrs)
            }
            eventDetailsText.appendAttributedString(content)
        }
        let eventTimeAndLocationText = NSMutableAttributedString()
        // time
        var attrs = [NSFontAttributeName : UIFont(name: "Lato-Regular", size: 16)!, NSForegroundColorAttributeName: ColorFromCode.randomBlueColorFromNumber(3)]
        var content = NSMutableAttributedString(string: "\(self.event.timeString) ", attributes:attrs)
        eventTimeAndLocationText.appendAttributedString(content)
        
        
        if (event.location != ""){
            attrs = [NSFontAttributeName : UIFont(name: "Lato-Regular", size: 16)!, NSForegroundColorAttributeName: UIColor.darkGrayColor()]
            content = NSMutableAttributedString(string: " at ", attributes: attrs)
            eventTimeAndLocationText.appendAttributedString(content)
            attrs = [NSFontAttributeName : UIFont(name: "Lato-Regular", size: 16)!, NSForegroundColorAttributeName: ColorFromCode.colorWithHexString("#C78B14")]
            content = NSMutableAttributedString(string: "\(event.location)", attributes: attrs)
            eventTimeAndLocationText.appendAttributedString(content)
            
        }
        
        // clickable author name
        if (self.event.details != "" && (self.event.author != nil)){
            let url:NSURL = NSURL(scheme: "pushAuthor", host: "", path: "/")!
            descriptionLabel.addLinkToURL(url, withRange:NSRange(location: 0,length: (authorNameText as NSString).length))
            descriptionLabel.delegate = self
        }
        
        // clickable location
        if (self.event.location != ""){
            let url:NSURL = NSURL(scheme: "pushLocation", host: "", path: "/")!
            let range = NSRange(location: (eventTimeAndLocationText.length-self.event.location.length),length: self.event.location.length)
            timeLocationLabel.addLinkToURL(url, withRange: range)
            timeLocationLabel.delegate = self

        }
        timeLocationLabel.attributedText = eventTimeAndLocationText
        descriptionLabel.attributedText = eventDetailsText
        Utility.highlightHashtagsInString(eventDetailsText, withColor: ColorFromCode.randomBlueColorFromNumber(3), inLabel: descriptionLabel)
        Utility.highlightMentionsInString(eventDetailsText, withColor: ColorFromCode.randomBlueColorFromNumber(3), inLabel: descriptionLabel)

        numberOfLikesButton.setTitle("\(self.event.likeManager.numberOfLikes)", forState: UIControlState.Normal)
        numberOfSharesButton.setTitle("\(self.event.shareManager.numberOfShares)", forState: UIControlState.Normal)
        
        self.UpdateEventPicture()
        self.setAuthorData()
        sizeHeaderToFit(false)
    }
    
    func refresh(sender: UIButton){

        (sender.superview! as! ImageProgressView).updateProgress(0)
//        var tag = sender.superview!.superview!.superview!.tag
        EventsManager().loadPictureForEvent(&event!, completionHandler: {
            (error:NSError!) -> Void in
            self.UpdateEventPicture()
        })
    }
    func sizeHeaderToFit(animated:Bool){
        headerView.setNeedsLayout()
        headerView.layoutIfNeeded()
        let descrHeight = descriptionLabel.sizeThatFits(CGSizeMake(descriptionLabel.frame.width, 550)).height
        let timelocHeight = timeLocationLabel.sizeThatFits(CGSizeMake(timeLocationLabel.frame.width, 100)).height
        //println(descrHeight)
        //println(timelocHeight)
        //println(self.LikeButton.frame.size.height)
        
        // manual calculation
        let height = 60 + viewWidth + 15 + timelocHeight + 5 + descrHeight + 15 + 20 + 15 + 0.5 + 55
        //           pr   imageView   sp   timelocHeight  sp   descrHeight   sp  likeB sp
//        var V_Constraint0 = NSLayoutConstraint.constraintsWithVisualFormat("V:|[profileView(60)][eventImageView]-15-[timeLocationLabel(<=100@999)]-5-[descriptionLabel(<=550@999)]-15-[LikeButton]-10-[separatorLine(0.5)]-[pushCommentsBtn(40)]->=15@999-|", options: nil, metrics: metrics, views: views)

        headerView.frame.size.height = height

        if (animated){
            UIView.animateWithDuration(0.25, delay: 0, options: [], animations: {
                () -> Void in
                self.tableView.tableHeaderView = self.headerView
                }, completion: nil)
        }else{
            self.tableView.tableHeaderView = self.headerView
        }
    }
    
    func like(sender: HomeLikeButton){
        
        self.event.likeManager.tab = TargetView.EventView
        self.event.likeManager.button = sender
        self.event.likeManager.Like()
    }
    func share(sender: HomeShareButton){
        self.event.shareManager.tab = TargetView.EventView
        self.event.shareManager.button = sender
        self.event.shareManager.Share()
    }
    
//    func LoadChildControllers(){
//        //!----Container view for Mentions------------------------//
//        self.MVC = self.storyboard?.instantiateViewControllerWithIdentifier("MentionsView") as! MentionsViewController
//        
//        self.addChildViewController(MVC)
//        self.MVC.didMoveToParentViewController(self)
//        self.MVC.delegate = self
//        self.view.addSubview(MVC.view)
//        self.MVC.view.frame = self.tableView.frame
//        self.MVC.view.hidden = true
//        //--------------------------------------------------------//
//        
//        //!----Container view for Hashtags------------------------//
//        self.HVC = self.storyboard?.instantiateViewControllerWithIdentifier("HashtagsView") as! HashtagsViewController
//        
//        self.addChildViewController(HVC)
//        self.HVC.didMoveToParentViewController(self)
//        self.HVC.delegate = self
//        self.view.addSubview(HVC.view)
//        self.HVC.view.frame = self.tableView.frame
//        self.HVC.view.hidden = true
//        //--------------------------------------------------------//
//    }
    func back(){
        self.navigationController!.popViewControllerAnimated(true)
    }
//    func Set_Subviews(){

        
//        offset = self.navigationController!.navigationBar.frame.height + UIApplication.sharedApplication().statusBarFrame.height + self.tabBarController!.tabBar.frame.height
//        self.viewHeight = self.view.bounds.height
//        self.viewWidth = self.view.bounds.width
//        PostCommentView = UIView(frame: CGRectMake(0, viewHeight-offset-50, viewWidth, 50))
//        self.tableView = MiniCommentsTableView(frame: CGRectMake(0, 0, viewWidth,viewHeight-offset-50))
//        
//        var TapRecognizer:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "HideKeyboard")
//        self.MainView.addGestureRecognizer(TapRecognizer)
        
        //!--------------Setting Main TableView-----------------//

        //------------------------------------------------------//
        
        //!---------Setting PostCommentView---------------------//
//        self.view.addSubview(PostCommentView)
//        self.KeyBoardActive = false
//        PostCommentView.addSubview(InputTextView)
//        PostCommentView.addSubview(PostCommentButton)
//        PostCommentView.backgroundColor = UIColor.groupTableViewBackgroundColor()
//        
//        PostCommentButton.backgroundColor = UIColor.whiteColor()
//        PostCommentButton.layer.cornerRadius = 3
//        InputTextView.delegate = self
//
//        //resize everything according textview height
//        InputTextView.frame.size.height = InputTextView.sizeThatFits(CGSizeMake(InputTextView.frame.size.width, 200)).height
//        PostCommentButton.frame.size.height = InputTextView.frame.size.height
//        var yOffset:CGFloat = 10
//        var twiceYoffset = yOffset*2
//        self.PostCommentView.frame = CGRectMake(0, self.view.frame.height - PostCommentButton.frame.size.height - twiceYoffset-offset, self.viewWidth, PostCommentButton.frame.size.height+twiceYoffset)
//        self.tableView.frame = CGRectMake(0,0,viewWidth,viewHeight - self.PostCommentView.frame.height - offset)
//
//        
//        
//        PostCommentButton.setTitle("Send", forState: UIControlState.Normal)
//        PostCommentButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
//        PostCommentButton.titleLabel?.font = UIFont(name: "Helvetica", size: 13)
//        PostCommentButton.addTarget(self, action: "Post_Comment", forControlEvents: UIControlEvents.TouchUpInside)
        //----------Setting PostCommentView---------------------//
        
        //!---------Setting HeaderView------------------//
        //self.view.addSubview(HeaderView)
        //set profile picture
//        if (event.profilePictureID == ""){//no picture
//            profilePicture.image = UIImage(named: "defaultPicture.png")!
//        }else{
//            if (event.profilePictureProgress < 100){ //picture should be re-loaded
//                
//                profilePicture.image = UIImage(named: "defaultPicture.png")!
//                //!Load Profile Pictures
//                var query = KCSQuery(onField: KCSEntityKeyId, withExactMatchForValue: event.profilePictureID)
//                KCSFileStore.downloadFile(event.profilePictureID, options: [KCSFileOnlyIfNewer : true], completionBlock: {
//                    (objects:[AnyObject]!, error:NSError!) -> Void in
//                    if (error == nil){
//                        if (objects.count > 0){
//                            let file = objects[0] as KCSFile
//                            let fileURL = file.localURL
//                            self.event.profilePicture = UIImage(contentsOfFile: fileURL.path!)!
//                            self.profilePicture.image = self.event.profilePicture
//                            self.event.profilePictureProgress = 100
//                        }else{
//                            self.event.profilePictureProgress = -1
//                            println("Error: object not found")
//                        }
//                    }else{
//                        println("Error: " + error.description)
//                    }
//                    //self.tableView.reloadRowsAtIndexPaths(NSArray(object: NSIndexPath(forRow: index, inSection: 0)), withRowAnimation: UITableViewRowAnimation.Automatic)
//                    }, progressBlock: { (objects:[AnyObject]!, percentComplete:Double) -> Void in
//                        self.event.profilePictureProgress = percentComplete
//                })
//                
//                
//            }else{ //picture is loaded
//                profilePicture.image = event.profilePicture
//            }
//        }

        //if you are creator of this event, u dont have buttons to response
//        ResponseView.delegate = self
//        var lowestY = CGRectGetMaxY(NumberOfInvitedButton.frame)
//        if (self.event.creatorID == KCSUser.activeUser().userId){
//            self.ResponseView.frame = CGRectMake(0, lowestY, 0, 0)
//            self.ResponseView.hidden = true
//            self.ResponseView.initialize(event)
//
//        }else{
//            self.ResponseView.frame = CGRectMake(0, lowestY, viewWidth, 80)
//            self.ResponseView.initialize(event)
//        }
//        //for offset before comments start
//        self.MainView.addSubview(BlankView)
//        lowestY = CGRectGetMaxY(ResponseView.frame)
//        BlankView.frame = CGRectMake(0,lowestY,0,20)

        
        //-----------------------------//
        
        

    //}
    //!-------------Get-Data-----------------------------//
    func getAuthorData(){
        if self.event.author == nil {
            return
        }
        self.UpdateProfilePicture()
        EventsManager().loadProfilePictureForEvent(&event!, completionHandler: {
            (error:NSError!) -> Void in
            if error == nil {
                self.UpdateProfilePicture()
            }
        })

    }
    func getEventData(){
        
        if event.profilePictureProgress < 1 {
            event.profilePictureProgress = -99
        }
        if event.pictureProgress < 1 {
            event.pictureProgress = -99
        }
        
//        var responsesLoaded:Bool = false
//        var dataUpdated:Bool = false
        responseView.getResponses(&event!, handler: {
            (goingNumber:Int, maybeNumber:Int, invitedNumber:Int, yourResponse:String!, error: NSError!) -> Void in
            if error == nil {
                self.numberOfGoing = goingNumber
                self.numberOfMaybe = maybeNumber
                self.numberOfInvited = invitedNumber
                self.responseView.localResponse = yourResponse
                self.responseView.actualResponse = yourResponse
                
                self.setResponsesData()
            }
        })
        
        ActivityManager.getLikesAndSharesForEvent(&event!) {
            (error:NSError!) -> Void in
            if error == nil {
                self.setLikesAndSharesData()
            }
        }
        
        EventsManager().updateEventData(&event!, completionHandler: {
            (error:NSError!) -> Void in
            if error == nil {
                self.getAuthorData()
                self.setEventData()
                
            }
        })

        if event.pictureId != "" {
            EventsManager().loadPictureForEvent(&event!, completionHandler: {
                (error:NSError!) -> Void in
                if error == nil {
                    self.UpdateEventPicture()
                }
            })
        }


        ActivityManager.countComments(event.eventOriginal, handler: {
            (number:Int, error:NSError!) -> Void in
            if error == nil {
                if number > 0 {
                    self.pushAllCommentsButton.setTitle("View all \(number) comments", forState: UIControlState.Normal)
                } else {
                    self.pushAllCommentsButton.setTitle("Be first to comment!", forState: UIControlState.Normal)
                }
            }else{
                print(error.description)
            }
        })
        
        ActivityManager.loadComments(nil, event: event.eventOriginal, limit: 10, handler: {
            (data:[FetchedActivityUnit]!, error:NSError!) -> Void in
            if error == nil {
                self.Comments = data
                if data.count > 10 {
                    self.Comments.removeLast()
                }
                self.tableView.reloadData()
            }else{
                print(error.description)
            }
        })
    }
    


    
    //------------User--Name-Tapped-----------------------//
    func pushAuthor(){
        if self.event.author == nil {
            return
        }
        pushUserByUserObject(event.author!)
    }
    func pushUserByUserObject(user:KCSUser){
        print("by user object")
        if (user.userId == KCSUser.activeUser().userId){
            
            let VC:MyProfileViewController = self.storyboard?.instantiateViewControllerWithIdentifier("MyProfileViewController") as! MyProfileViewController
            self.navigationController?.pushViewController(VC, animated: true)
            
        }else{
            
            let VC:UserProfileViewController = self.storyboard?.instantiateViewControllerWithIdentifier("UserProfileViewController") as! UserProfileViewController
            VC.user = user
            VC.mainUserDataLoaded = true
            self.navigationController?.pushViewController(VC, animated: true)
        }
    }
    
    func pushUserByUsername(username:String){
        print("by username")
        
        if (username == KCSUser.activeUser().username){
            
            let VC:MyProfileViewController = self.storyboard?.instantiateViewControllerWithIdentifier("MyProfileViewController") as! MyProfileViewController
            self.navigationController?.pushViewController(VC, animated: true)
            
        }else{
            
            let VC:UserProfileViewController = self.storyboard?.instantiateViewControllerWithIdentifier("UserProfileViewController") as! UserProfileViewController
            VC.username = username
            self.navigationController?.pushViewController(VC, animated: true)
        }
    }
    //----------------------------------------------------//

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Comments.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let Cell = tableView.dequeueReusableCellWithIdentifier("Comment Cell", forIndexPath: indexPath) as! MiniCommentTableViewCell
        Cell.commentLabel.delegate = self
        Cell.commentLabel.tag = indexPath.row
        
        let attributedString = NSMutableAttributedString()

        // Name
        let authorName =  " \(self.Comments[indexPath.row].fromUser!.username)" as NSString
        var attrs = [NSFontAttributeName : UIFont(name: "Lato-Medium", size: 14)!, NSForegroundColorAttributeName: ColorFromCode.randomBlueColorFromNumber(3)]
        var content = NSMutableAttributedString(string: authorName as String, attributes: attrs)
        attributedString.appendAttributedString(content)
        
        // Content
        attrs = [NSFontAttributeName : UIFont(name: "Lato-Regular", size: 14)!, NSForegroundColorAttributeName: UIColor.blackColor()]
        content = NSMutableAttributedString(string: " \(self.Comments[indexPath.row].content)", attributes: attrs)
        attributedString.appendAttributedString(content)
        

        // clickable author name
        let url:NSURL = NSURL(scheme: "pushUser", host: "", path: "/")!
        Cell.commentLabel.addLinkToURL(url, withRange:NSRange(location: 0,length: authorName.length))
        
        Utility.highlightHashtagsInString(attributedString, withColor: ColorFromCode.randomBlueColorFromNumber(3), inLabel: Cell.commentLabel)
        Utility.highlightMentionsInString(attributedString, withColor: ColorFromCode.randomBlueColorFromNumber(3), inLabel: Cell.commentLabel)
        return Cell
    }
    
    func attributedLabel(label: TTTAttributedLabel!, didSelectLinkWithURL url: NSURL!) {
        switch url.scheme {
            case "pushAuthor": pushAuthor()
            case "mention": pushUserByUsername(url.host!)
            case "hashtag": return
            case "pushUser": pushUserByUserObject(Comments[label.tag].fromUser!)
        default: return
        }
    }
    func pushAllComments(){
        if self.event.author == nil {
            return
        }
        let VC:CommentsViewController = self.storyboard!.instantiateViewControllerWithIdentifier("CommentsView") as! CommentsViewController
        VC.event = self.event
        //VC.author = self.author
        self.navigationController?.pushViewController(VC, animated: true)
    }

    func HideKeyboard(){
        self.view.endEditing(true) // will hide keyboard, works like switch
//        self.InputTextView.resignFirstResponder()
        
    }
    //    func Add_Keyboard_Observers(){
    //        //initial view frame
    //        self.viewFrame = self.view.frame
    //
    //
    //        var TapRecognizer:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "HideKeyboard")
    //        self.view.addGestureRecognizer(TapRecognizer)
    //        //make trigger when keyboard displayed/changed
    //        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
    //
    //        //when keyboard is hidden
    //        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    //        
    //        
    //    }
//
//    func keyboardWillShow(notification: NSNotification) {
//        var info:NSDictionary = notification.userInfo!
//        var keyboardSize = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
//        var keyboardHeight:CGFloat = keyboardSize.height
//        var movement:CGFloat = keyboardHeight - offset
//        
//        self.CurrentKeyboardHeight = movement
//        
//        var animationDuration = (info[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
//        var futurePostCommentViewframe:CGRect = CGRectMake(0, self.view.frame.height-self.PostCommentView.frame.height-movement-offset, PostCommentView.frame.width, PostCommentView.frame.height)
//        var futureTableViewframe:CGRect = CGRectMake(0, 0, self.view.frame.width,futurePostCommentViewframe.origin.y)
//        println("\(futurePostCommentViewframe.origin.y)")
//        
//        UIView.animateWithDuration(animationDuration, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
//            self.tableView.frame = futureTableViewframe
//            self.PostCommentView.frame = futurePostCommentViewframe
//            }, completion: nil)
//        
//        
//    }
//    
//    func keyboardWillHide(notification: NSNotification) {
//        var info:NSDictionary = notification.userInfo!
//        var keyboardSize = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
//        var keyboardHeight:CGFloat = keyboardSize.height
//        
//        var movement:CGFloat = keyboardHeight - offset
//        
//        self.CurrentKeyboardHeight = 0
//        
//        var animationDuration = (info[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
//        var futurePostCommentViewframe:CGRect = CGRectMake(0, self.viewHeight-self.PostCommentView.frame.height-offset, PostCommentView.frame.width, PostCommentView.frame.height)
//        var futureTableViewframe:CGRect = CGRectMake(0, 0, self.view.frame.width,futurePostCommentViewframe.origin.y)
//        
//        UIView.animateWithDuration(animationDuration, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
//            self.tableView.frame = futureTableViewframe
//            self.PostCommentView.frame = futurePostCommentViewframe
//            }, completion: nil)
//
//    }
//
//    func setTabBarVisible(visible:Bool, animated:Bool) {
//        
//        //* This cannot be called before viewDidLayoutSubviews(), because the frame is not set before this time
//        
//        // bail if the current state matches the desired state
//        if (tabBarIsVisible() == visible) { return }
//        
//        // get a frame calculation ready
//        let frame = self.tabBarController?.tabBar.frame
//        let height = frame?.size.height
//        let offsetY = (visible ? -height! : height)
//        
//        // zero duration means no animation
//        let duration:NSTimeInterval = (animated ? 0.3 : 0.0)
//        
//        //  animate the tabBar
//        if frame != nil {
//            UIView.animateWithDuration(duration) {
//                self.tabBarController?.tabBar.frame = CGRectOffset(frame!, 0, offsetY!)
//                return
//            }
//        }
//    }
//    func tabBarIsVisible() ->Bool {
//        return self.tabBarController?.tabBar.frame.origin.y < CGRectGetMaxY(self.view.frame)
//    }
//    func textViewDidBeginEditing(textView: UITextView) { //for placeholder
//        if (textView as! CommentTextView).textColor == UIColor.lightGrayColor() {
//            textView.text = ""
//            textView.textColor = UIColor.blackColor()
//        }
//    }
//    
//    func textViewDidChange(textView: UITextView) {
//        (textView as! CommentTextView).previousNumberOfLines = (textView as! CommentTextView).newNumberOfLines
//        if (textView.text.isEmpty){
//            (textView as! CommentTextView).isEmpty = true
//            PostCommentButton.enabled = false
//            (textView as! CommentTextView).newNumberOfLines = 1
//        }else{
//            (textView as! CommentTextView).isEmpty = false
//            (textView as! CommentTextView).newNumberOfLines  = textView.contentSize.height / textView.font.lineHeight
//            PostCommentButton.enabled = true
//            detectHashtagsOrMentions((textView as! CommentTextView))
//        }
//        Resize_TextView((textView as! CommentTextView))
//        
//    }
//    
//    func Resize_TextView(textView:CommentTextView){
//        var yOffset:CGFloat = 10
//        var twiceYoffset = yOffset*2
//        
//        if (textView.newNumberOfLines < 6){
//            var height:CGFloat = textView.sizeThatFits(CGSizeMake(textView.frame.size.width, CGFloat.max)).height
//            
//            var PostCommentViewFrame = CGRectMake(0, self.view.frame.height-height-twiceYoffset-self.CurrentKeyboardHeight-offset, self.viewWidth, height+twiceYoffset)
//            var PostCommentButtonFrame = CGRectMake(self.PostCommentButton.frame.origin.x, height + yOffset - self.PostCommentButton.frame.height , self.PostCommentButton.frame.width, self.PostCommentButton.frame.height)
//            var futureTableViewframe:CGRect = CGRectMake(0, 0, self.view.frame.width,PostCommentViewFrame.origin.y)
//            
//            UIView.animateWithDuration(0.1, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
//                self.InputTextView.setContentOffset(CGPointZero, animated: false)
//                self.PostCommentView.frame = PostCommentViewFrame
//                self.PostCommentButton.frame = PostCommentButtonFrame
//                self.tableView.frame = futureTableViewframe
//                self.resizeMentionView()
//                self.resizeHashtagView()
//                textView.frame = CGRectMake(textView.frame.origin.x, textView.frame.origin.y, textView.frame.width , height)
//                
//                }, completion: nil)
//            textView.scrollEnabled = false
//        }else{ //if 5 lines or more
//            //scroll to bottom
//            
//            textView.scrollEnabled = true
//            var bottomOffset:CGPoint = CGPointMake(0, textView.contentSize.height - textView.bounds.size.height)
//            textView.setContentOffset(bottomOffset, animated: false)
//        }
//        
//    }
//    
//    func textViewDidEndEditing(textView: UITextView) {
//        if textView.text.isEmpty {
//            (textView as! CommentTextView).putPlaceHolder()
//            PostCommentButton.enabled = false
//        }else{
//            (textView as! CommentTextView).isEmpty = false
//            PostCommentButton.enabled = true
//        }
//    }
//    
//    func detectHashtagsOrMentions(textView:CommentTextView) {
//        //identify the word we are on
//        var insertionLocation:Int = textView.selectedRange.location
//        var regex:NSRegularExpression = NSRegularExpression(pattern: "\\b[@#\\w]+\\b", options: NSRegularExpressionOptions.UseUnicodeWordBoundaries, error: nil)!
//        var word:NSString = NSString()
//        var range:NSRange = NSMakeRange(NSNotFound, 0)
//        regex.enumerateMatchesInString(textView.text, options: nil, range: NSMakeRange(0, (textView.text as NSString).length)) {
//            (result:NSTextCheckingResult!, flags:NSMatchingFlags, stop:UnsafeMutablePointer<ObjCBool>) -> Void in
//            if (result.range.location <= insertionLocation && result.range.location+result.range.length >= insertionLocation){
//                word = (textView.text as NSString).substringWithRange(result.range)
//                range = result.range
//                stop.memory = true
//            }
//        }
//        
//        
//        // if word doesnt degenerate
//        if (word.length >= 1 && range.location != NSNotFound){
//            var first:NSString = word.substringToIndex(1) //
//            var rest:NSString = word.substringFromIndex(1) //actual word
//            range.location++  // to avoid replacing @ or #
//            if (first.isEqualToString("@")){
//                if (rest.length > 0){
//                    //call our method and pass rest
//                    self.MVC.textRange = range
//                    self.MVC.filterString = rest
//                    self.MVC.Load_User_List()
//                    
//                    self.showMentionView()
//                    println("@")
//                }else{
//                    self.hideViews()
//                }
//            }else if (first.isEqualToString("#")){
//                if (rest.length > 0){
//                    //call our method and pass rest
//                    self.HVC.textRange = range
//                    self.HVC.filterString = rest
//                    self.HVC.Load_Hashtags()
//                    
//                    self.showHashtagView()
//                    println("@")
//                }else{
//                    self.hideViews()
//                }
//                println("#")
//            }else{
//                self.hideViews()
//            }
//            // else if didfinish word
//            //println("\(self.tableView.frame.origin.y)"+"_"+"\(self.tableView	.frame.height)")
//            
//            //println("\(self.MentionsContainerView.frame.origin.y)"+"_"+"\(self.MentionsContainerView.frame.height)")
//        }
//        //source https://github.com/bogardon/GGHashtagMentionController/blob/master/GGHashtagMentionController/src/GGHashtagMentionController.m
//    }
//    func showMentionView(){ //dont ask why these rects, just a fix
//        self.resizeMentionView()
//        self.tableView.hidden = true
//        self.MVC.view.hidden = false
//        self.HVC.view.hidden = true
//    }
//    func resizeMentionView(){ //dont ask why these rects, just a fix
//        self.MVC.view.frame = CGRectMake(0, topLayoutGuide.length, self.tableView.frame.width, self.PostCommentView.frame.origin.y-self.topLayoutGuide.length)
//        self.MVC.tableView.frame.size = self.MVC.view.frame.size
//        
//    }
//    
//    func showHashtagView(){ //dont ask why these rects, just a fix
//        self.resizeHashtagView()
//        self.tableView.hidden = true
//        self.HVC.view.hidden = false
//        self.MVC.view.hidden = true
//    }
//    func resizeHashtagView(){ //dont ask why these rects, just a fix
//        self.HVC.view.frame = CGRectMake(0, topLayoutGuide.length, self.tableView.frame.width, self.PostCommentView.frame.origin.y-self.topLayoutGuide.length)
//        self.HVC.tableView.frame.size = self.MVC.view.frame.size
//        
//    }
//    
//    
//    func hideViews(){
//        self.tableView.hidden = false
//        self.MVC.view.hidden = true
//        self.HVC.view.hidden = true
//    }
//    func didChooseUser(controller: MentionsViewController, Username: String, textRange:NSRange) {
//        self.InputTextView.selectedRange = textRange
//        self.InputTextView.replaceRange(InputTextView.selectedTextRange!, withText: Username+" ")
//        //println("location \(textRange.location) and length = \(textRange.length)")
//        self.tableView.hidden = false
//        controller.view.hidden = true
//    }
//    func didChooseHashtag(controller: HashtagsViewController, Hashtag: String, textRange: NSRange) {
//        self.InputTextView.selectedRange = textRange
//        self.InputTextView.replaceRange(InputTextView.selectedTextRange!, withText: Hashtag+" ")
//        //println("location \(textRange.location) and length = \(textRange.length)")
//        self.tableView.hidden = false
//        controller.view.hidden = true
//    }
    

    func pushLikes(){
        
        let VC:UserListViewController = self.storyboard?.instantiateViewControllerWithIdentifier("UserListViewController") as! UserListViewController
        VC.event = event.eventOriginal
        VC.Target = "Likers"
        
        self.navigationController?.pushViewController(VC, animated: true)
    }
    func pushGoing(){
        
        let VC:UserListViewController = self.storyboard?.instantiateViewControllerWithIdentifier("UserListViewController") as! UserListViewController
        VC.event = event.eventOriginal
        VC.Target = "Accepted"
        
        self.navigationController?.pushViewController(VC, animated: true)
    }
    func pushMaybe(){
        
        let VC:UserListViewController = self.storyboard?.instantiateViewControllerWithIdentifier("UserListViewController") as! UserListViewController
        VC.event = event.eventOriginal
        VC.Target = "Maybe"
        
        self.navigationController?.pushViewController(VC, animated: true)
    }
    func pushInvited(){
        
        let VC:UserListViewController = self.storyboard?.instantiateViewControllerWithIdentifier("UserListViewController") as! UserListViewController
        VC.event = event.eventOriginal
        VC.Target = "Invited"
        
        self.navigationController?.pushViewController(VC, animated: true)
    }
    func pushShares(){
        
        let VC:UserListViewController = self.storyboard?.instantiateViewControllerWithIdentifier("UserListViewController") as! UserListViewController
        VC.event = event.eventOriginal
        VC.Target = "Shares"
        
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
}
