//
//  ProfileViewController.swift
//  Eventer
//
//  Created by Grisha on 12/12/2014.
//  Copyright (c) 2014 Grisha. All rights reserved.
//

import UIKit
extension UINavigationBar {
    func hideBottomHairline()
    {
        hairlineImageViewInNavigationBar(self)?.hidden = true
    }
    
    func showBottomHairline()
    {
        hairlineImageViewInNavigationBar(self)?.hidden = false
    }
    
    private func hairlineImageViewInNavigationBar(view: AnyObject) -> UIImageView?
    {
        if let imageView = view as? UIImageView where imageView.bounds.height <= 1
        {
            return view as? UIImageView
        }
        
        let subviews = view.subviews
        for subview: UIView in subviews
        {
            if let imageView = hairlineImageViewInNavigationBar(subview)
            {
                return imageView
            }
        }
        
        return nil
    }
    
}

class MyProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate, TTTAttributedLabelDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var screenWidth = UIScreen.mainScreen().bounds.width
    var screenHeight = UIScreen.mainScreen().bounds.height
    var events:[FetchedEvent] = []
    
    //!----Profile Data-------------------//
    
    var mainUserDataLoaded:Bool = false
    var additionalUserDataLoaded:Bool = false
    //var user:KCSUser!
    var fetcheduser:FetchedUser!
    var profilePictureID:String = String()
    var profilePictureProgress:Double = 0
    var profilePicture:UIImage = UIImage()
    
    var numberOfFollowers:UInt!
    var numberOfFollowing:UInt!
    var numberOfEvents:Int!
    
    var tableHeaderView:UIView = UIView()
    
    var bioLabel:UILabel = UILabel()
    var fullNameLabel:UILabel = UILabel()
    var websiteLabel:TTTAttributedLabel = TTTAttributedLabel(frame: CGRectZero)
    var editProfileButton:UIButton = UIButton()
    
    
    var numberOfEventsLabel:TTTAttributedLabel = TTTAttributedLabel(frame: CGRectZero)
    var numberOfFollowersLabel:TTTAttributedLabel = TTTAttributedLabel(frame: CGRectZero)
    var numberOfFollowingLabel:TTTAttributedLabel = TTTAttributedLabel(frame: CGRectZero)
    var profilePictureImageView:UIImageView = UIImageView()
    var profilePictureShadowView = UIView()
    
    var collectionCellWidth = (UIScreen.mainScreen().bounds.width-2)/3
    var collectionCellHeight = (UIScreen.mainScreen().bounds.width-2)/2
    var flowLayout:ProfileGridViewLayout = ProfileGridViewLayout()

    var gridButton:UIButton = UIButton()
    var tableButton:UIButton = UIButton()
    var goingButton:UIButton = UIButton() // button which oopens list of events person going to

    var NowDate:NSDate = NSDate() //default constructor gets current date if I get it right
    var tableView: UITableView = UITableView()
    var collectionView: UICollectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: UICollectionViewFlowLayout())
    var tableViewRefreshControl:UIRefreshControl = UIRefreshControl()
    var collectionViewRefreshControl:UIRefreshControl = UIRefreshControl()
    var footerView = TableFooterRefreshView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, 100))
    var end = false
    var gridUnderline = UIView()
    var tableUnderline = UIView()
    var goingUnderline = UIView()
    var selectedView:Int = 0
    var t1 = UITableViewController()
    
    
    var cellHeights:[CGFloat] = []

    func back(){
        self.navigationController!.popViewControllerAnimated(true)
    }
    
    override func viewWillAppear(animated: Bool) {
        self.navigationController?.navigationBar.hideBottomHairline()
        super.viewWillAppear(animated)
        self.navigationController!.navigationBarHidden = false
        UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: UIStatusBarAnimation.None)
        
    }
    
    override func viewWillDisappear(animated: Bool) {
        Utility.dropShadow(self.navigationController!.navigationBar, offset: 0, opacity: 0)
        self.navigationController?.navigationBar.showBottomHairline()
        super.viewWillDisappear(animated)
        self.view.endEditing(true)
        
    }

    func setSubviews(){
        let backButton = UIBarButtonItem(image: UIImage(named: "back.png"), style: UIBarButtonItemStyle.Plain, target: self, action: "back")
        backButton.tintColor = UIColor.whiteColor()
        if (self.navigationController!.viewControllers.count > 1){
            self.navigationItem.leftBarButtonItem = backButton
        }
        // bar button
        let settingsButton = UIBarButtonItem(image: UIImage(named: "settings.png"), style: UIBarButtonItemStyle.Plain, target: self, action: "pushSettings")
        settingsButton.tintColor = UIColor.whiteColor()
        
        self.navigationItem.rightBarButtonItem = settingsButton
        
        // Refresh controls
        t1.refreshControl = tableViewRefreshControl
        collectionView.addSubview(collectionViewRefreshControl)
        tableViewRefreshControl.tintColor = UIColor.whiteColor()
        collectionViewRefreshControl.tintColor = UIColor.whiteColor()
        tableViewRefreshControl.addTarget(self, action: "Refresh", forControlEvents: UIControlEvents.ValueChanged)
        collectionViewRefreshControl.addTarget(self, action: "Refresh", forControlEvents: UIControlEvents.ValueChanged)
        footerView.button.addTarget(self, action: "loadMoreEvents", forControlEvents: UIControlEvents.TouchUpInside)
        
        // Table View

        let offset = self.navigationController!.navigationBar.frame.height + UIApplication.sharedApplication().statusBarFrame.height + self.tabBarController!.tabBar.frame.height
        tableView.allowsSelection = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerClass(ProfileEventTableViewCell.self, forCellReuseIdentifier: "Event Cell")
        tableView.registerClass(ProfileNoPictureTableViewCell.self, forCellReuseIdentifier: "EventNoPic Cell")
        tableView.frame = CGRectMake(0, 0, screenWidth, self.view.frame.height-offset)
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        tableView.rowHeight = UITableViewAutomaticDimension
        self.addChildViewController(t1)
        t1.tableView = tableView
        self.view.addSubview(t1.tableView)
        self.view.addSubview(collectionView)


        
        // Collection View
        collectionView.frame = CGRectMake(0, 0, screenWidth, self.view.frame.height-offset)
        collectionView.collectionViewLayout = self.flowLayout
        collectionView.scrollsToTop = true
        collectionView.backgroundColor = UIColor.whiteColor()
        collectionView.alwaysBounceVertical = true
        collectionView.bounces = true
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.tag = 0
        collectionView.registerClass(ExploreCollectionViewCell.self, forCellWithReuseIdentifier: "collection Cell")
        collectionView.registerClass(CollectionHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "header")
        collectionView.registerClass(CollectionHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "footer")
        collectionView.hidden = true
        
        // Edit Profile Button
        editProfileButton.setTitle("Edit Your Profile", forState: UIControlState.Normal)
        editProfileButton.titleLabel!.font = UIFont(name: "Lato-Regular", size: 14)
        editProfileButton.setTitleColor(ColorFromCode.colorWithHexString("#0087D9"), forState: UIControlState.Normal)
        editProfileButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Highlighted)
        editProfileButton.backgroundColor = ColorFromCode.colorWithHexString("#EBF0F2")
        editProfileButton.addTarget(self, action: "editProfile", forControlEvents: UIControlEvents.TouchUpInside)
        editProfileButton.layer.cornerRadius = 4
        
        // Grid and Table Buttons
        gridButton.tag = 1
        tableButton.tag = 2
        gridButton.enabled = false
        tableButton.enabled = false
        gridButton.addTarget(self, action: "switchBtnPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        tableButton.addTarget(self, action: "switchBtnPressed:", forControlEvents: UIControlEvents.TouchUpInside)
        
        
        // Labels
        numberOfFollowersLabel.textAlignment = NSTextAlignment.Center
        numberOfFollowersLabel.numberOfLines = 2
        numberOfFollowingLabel.textAlignment = NSTextAlignment.Center
        numberOfFollowingLabel.numberOfLines = 2
        numberOfEventsLabel.textAlignment = NSTextAlignment.Center
        numberOfEventsLabel.numberOfLines = 2
        
        var attrs = [NSFontAttributeName : UIFont(name: "Lato-Regular", size: 21)!, NSForegroundColorAttributeName: UIColor.lightGrayColor()]
        var content = NSMutableAttributedString(string: " ", attributes: attrs)
        attrs = [NSFontAttributeName : UIFont(name: "Lato-Regular", size: 13)!, NSForegroundColorAttributeName: UIColor.lightGrayColor()]
        content.appendAttributedString(NSMutableAttributedString(string: "\nfollowers", attributes: attrs))
        numberOfFollowersLabel.attributedText = content
        
        attrs = [NSFontAttributeName : UIFont(name: "Lato-Regular", size: 21)!, NSForegroundColorAttributeName: UIColor.lightGrayColor()]
        content = NSMutableAttributedString(string: " ", attributes: attrs)
        attrs = [NSFontAttributeName : UIFont(name: "Lato-Regular", size: 13)!, NSForegroundColorAttributeName: UIColor.lightGrayColor()]
        content.appendAttributedString(NSMutableAttributedString(string: "\nfollowing", attributes: attrs))
        numberOfFollowingLabel.attributedText = content
        
        
        attrs = [NSFontAttributeName : UIFont(name: "Lato-Regular", size: 21)!, NSForegroundColorAttributeName: UIColor.lightGrayColor()]
        content = NSMutableAttributedString(string: " ", attributes: attrs)
        attrs = [NSFontAttributeName : UIFont(name: "Lato-Regular", size: 13)!, NSForegroundColorAttributeName: UIColor.lightGrayColor()]
        content.appendAttributedString(NSMutableAttributedString(string: "\nevents", attributes: attrs))
        numberOfEventsLabel.attributedText = content
        
        
        fullNameLabel.font = UIFont(name: "Lato-Semibold", size: 18)
        fullNameLabel.textAlignment = NSTextAlignment.Center
        fullNameLabel.numberOfLines = 0
        
        bioLabel.font = UIFont(name: "Lato-Regular", size: 14)
        bioLabel.textAlignment = NSTextAlignment.Left
        bioLabel.textColor = UIColor.blackColor()
        bioLabel.numberOfLines = 0
        
        websiteLabel.font = UIFont(name: "Lato-Regular", size: 14)
        websiteLabel.textAlignment = NSTextAlignment.Left
        websiteLabel.textColor = UIColor.darkGrayColor()
        websiteLabel.numberOfLines = 0

        profilePictureImageView.backgroundColor = UIColor.groupTableViewBackgroundColor()
        profilePictureImageView.layer.cornerRadius = 8
        profilePictureImageView.layer.borderWidth = 2
        profilePictureImageView.layer.borderColor = UIColor.whiteColor().CGColor
        profilePictureImageView.layer.masksToBounds = true // otherwise the corner radius doesnt work
        
        profilePictureShadowView.layer.shadowOffset = CGSizeMake(0, 0)
        profilePictureShadowView.layer.shadowRadius = 3
        profilePictureShadowView.layer.shadowColor = UIColor.blackColor().CGColor
        profilePictureShadowView.layer.shadowOpacity = 0.4
        
        let standardImage = UIImage(named: "going")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        let highlightedImage = UIImage(named: "going")
        goingButton.tintColor = ColorFromCode.tabForegroundColor()
        goingButton.setImage(standardImage, forState: UIControlState.Normal)
        goingButton.setImage(highlightedImage, forState: UIControlState.Highlighted)
        goingButton.enabled = false
        goingUnderline.backgroundColor = ColorFromCode.colorWithHexString("#DAE4E7")
        goingButton.addTarget(self, action: "pushGoingEventList", forControlEvents: UIControlEvents.TouchUpInside)
        

        // Set Refresh Control Background Color
        let tableViewRefreshBackground = UIView()
        let collectionViewRefreshBackground = UIView()
        let height:CGFloat = screenHeight
        tableViewRefreshBackground.frame.origin.y = -height
        collectionViewRefreshBackground.frame.origin.y = -height
        tableViewRefreshBackground.backgroundColor = ColorFromCode.standardBlueColor()
        collectionViewRefreshBackground.backgroundColor = ColorFromCode.standardBlueColor()
        tableViewRefreshBackground.frame.size = CGSizeMake(screenWidth,height)
        collectionViewRefreshBackground.frame.size = CGSizeMake(screenWidth,height)
        self.tableView.insertSubview(tableViewRefreshBackground, atIndex: 0)
        self.collectionView.insertSubview(collectionViewRefreshBackground, atIndex: 0)

        //Edit Profile button
        let EditProfileTapRecognizer:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "editProfile")
        editProfileButton.addGestureRecognizer(EditProfileTapRecognizer)
        editProfileButton.userInteractionEnabled = true
        //
        
        //Show Followers Button
        let ShowFollowersTapRecognizer:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "pushFollowers")
        numberOfFollowersLabel.addGestureRecognizer(ShowFollowersTapRecognizer)
        numberOfFollowersLabel.userInteractionEnabled = true
        
        
        //Show Following Button
        let ShowFollowingTapRecognizer:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "Push_Following_List")
        numberOfFollowingLabel.addGestureRecognizer(ShowFollowingTapRecognizer)
        numberOfFollowingLabel.userInteractionEnabled = true
        
        numberOfEventsLabel.hidden = true
        
        
        
    }
    
    func switchBtnPressed(sender:UIButton){
        switchToView(sender.tag)
        updateFooter()
    }
    func switchToView(tag:Int){
        
        if (selectedView != tag){
            if (tag == 1){ // to grid
                selectedView = 1
                tableView.hidden = true
                collectionView.hidden = false
                if (collectionViewRefreshControl.refreshing){
                    self.collectionView.setContentOffset(CGPointMake(0, -tableViewRefreshControl.frame.size.height), animated: false)
                }else{
                    collectionView.setContentOffset(CGPointZero, animated: false)
                }
                self.updateHeader()
                gridButton.setImage(UIImage(named: "grid-view-active.png"), forState: UIControlState.Normal)
                gridButton.setImage(UIImage(named: "grid-view.png"), forState: UIControlState.Highlighted)
                
                tableButton.setImage(UIImage(named: "stroke-view.png"), forState: UIControlState.Normal)
                tableButton.setImage(UIImage(named: "stroke-view-active.png"), forState: UIControlState.Highlighted)
                gridUnderline.backgroundColor = ColorFromCode.colorWithHexString("#0087D9")
                tableUnderline.backgroundColor = ColorFromCode.colorWithHexString("#DAE4E7")
            }else{ // to table
                selectedView = 2
                tableView.hidden = false
                collectionView.hidden = true
                
                if (tableViewRefreshControl.refreshing){
                    self.tableView.setContentOffset(CGPointMake(0, -tableViewRefreshControl.frame.size.height), animated: false)
                }else{
                    tableView.setContentOffset(CGPointZero, animated: false)
                }
                self.tableView.tableHeaderView? = UIView()
                sizeHeaderToFit(false)
                gridButton.setImage(UIImage(named: "grid-view.png"), forState: UIControlState.Normal)
                gridButton.setImage(UIImage(named: "grid-view-active.png"), forState: UIControlState.Highlighted)
                
                tableButton.setImage(UIImage(named: "stroke-view-active.png"), forState: UIControlState.Normal)
                tableButton.setImage(UIImage(named: "stroke-view"), forState: UIControlState.Highlighted)
                tableUnderline.backgroundColor = ColorFromCode.colorWithHexString("#0087D9")
                gridUnderline.backgroundColor = ColorFromCode.colorWithHexString("#DAE4E7")
            }
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
        self.flowLayout.headerReferenceSize = frame.size
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
    func setTableHeaderView(){
        
        //!---Set Header View
        tableHeaderView.addSubview(profilePictureShadowView)
        //tableHeaderView.addSubview(numberOfEventsLabel)
        tableHeaderView.addSubview(numberOfFollowingLabel)
        tableHeaderView.addSubview(numberOfFollowersLabel)
        tableHeaderView.addSubview(editProfileButton)
        tableHeaderView.addSubview(fullNameLabel)
        tableHeaderView.addSubview(bioLabel)
        tableHeaderView.addSubview(gridButton)
        tableHeaderView.addSubview(tableButton)
        tableHeaderView.addSubview(goingButton)

        profilePictureShadowView.translatesAutoresizingMaskIntoConstraints = false
        numberOfEventsLabel.translatesAutoresizingMaskIntoConstraints = false
        numberOfFollowingLabel.translatesAutoresizingMaskIntoConstraints = false
        numberOfFollowersLabel.translatesAutoresizingMaskIntoConstraints = false
        editProfileButton.translatesAutoresizingMaskIntoConstraints = false
        fullNameLabel.translatesAutoresizingMaskIntoConstraints = false
        bioLabel.translatesAutoresizingMaskIntoConstraints = false
        websiteLabel.translatesAutoresizingMaskIntoConstraints = false
        gridButton.translatesAutoresizingMaskIntoConstraints = false
        tableButton.translatesAutoresizingMaskIntoConstraints = false
        goingButton.translatesAutoresizingMaskIntoConstraints = false

        
        // for autoresizable labels
        bioLabel.setContentHuggingPriority(1000, forAxis: UILayoutConstraintAxis.Vertical)
        bioLabel.setContentCompressionResistancePriority(500, forAxis: UILayoutConstraintAxis.Vertical)
        
        //!---Constraints
        let border:UIView = UIView()
        border.translatesAutoresizingMaskIntoConstraints = false
        border.backgroundColor = ColorFromCode.colorWithHexString("#DAE4E7")
        tableHeaderView.addSubview(border)
        
        gridUnderline.translatesAutoresizingMaskIntoConstraints = false
        self.tableHeaderView.addSubview(gridUnderline)

        tableUnderline.translatesAutoresizingMaskIntoConstraints = false
        self.tableHeaderView.addSubview(tableUnderline)
        
        goingUnderline.translatesAutoresizingMaskIntoConstraints = false
        self.tableHeaderView.addSubview(goingUnderline)
        let views =
        [
            "pp": profilePictureShadowView,
            "ne": numberOfEventsLabel,
            "nfws": numberOfFollowersLabel,
            "nfwg": numberOfFollowingLabel,
            "editbtn": editProfileButton,
            "biolbl": bioLabel,
            "fullnamelbl": fullNameLabel,
            "border": border,
            "gridButton": gridButton,
            "tableButton": tableButton,
            "goingButton": goingButton,
            "gridUnderline": gridUnderline,
            "tableUnderline": tableUnderline,
            "goingUnderline": goingUnderline
        ]
        let metrics = [
            "o" : 15
        ]
//        let H_Constraint0 = NSLayoutConstraint(item: profilePictureImageView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self.tableHeaderView, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
        let H_Constraint0 = NSLayoutConstraint.constraintsWithVisualFormat("H:|-15-[fullnamelbl]-15@999-|", options: [], metrics: nil, views: views)
        let H_Constraint1 = NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[nfwg(==nfws)]-10-[pp(100@999)]-10-[nfws(==nfwg)]-10@999-|", options: [], metrics: metrics, views: views)
        let H_Constraint2 = NSLayoutConstraint.constraintsWithVisualFormat("H:|-30-[editbtn]-30@999-|", options: [], metrics: metrics, views: views)
        let H_Constraint4 = NSLayoutConstraint.constraintsWithVisualFormat("H:|-15-[biolbl(>=0@999)]-15@999-|", options: [], metrics: nil, views: views)
        let H_Constraint6 = NSLayoutConstraint.constraintsWithVisualFormat("H:|[gridButton(==tableButton)][tableButton(==goingButton)][goingButton(==gridButton)]|", options: [], metrics: metrics, views: views)
        let H_Constraint7 = NSLayoutConstraint.constraintsWithVisualFormat("H:|[border]|", options: [], metrics: metrics, views: views)
        let H_Constraint8 = NSLayoutConstraint.constraintsWithVisualFormat("H:|[gridUnderline(==tableUnderline)][tableUnderline(==goingUnderline)][goingUnderline]|", options: [], metrics: metrics, views: views)

        

        let V_Constraint0 = NSLayoutConstraint.constraintsWithVisualFormat("V:|-10@999-[pp(100@999)]-5@999-[fullnamelbl(>=0@300)]-10-[editbtn(35)]-5-[biolbl]-10-[border(0.5)]-13-[tableButton]-13-[tableUnderline(2)]->=0@999-|", options: [], metrics: metrics, views: views)
        let V_Constraint1 = NSLayoutConstraint.constraintsWithVisualFormat("V:|-50@999-[nfws]-[fullnamelbl(>=0@999)]-10-[editbtn(35)]-5-[biolbl]-10-[border(0.5)]-13-[gridButton]-13-[gridUnderline(2)]->=0@999-|", options: [], metrics: metrics, views: views)
        let V_Constraint2 = NSLayoutConstraint.constraintsWithVisualFormat("V:|-50@999-[nfwg]-[fullnamelbl(>=0@999)]-10-[editbtn(35)]-5-[biolbl]-10-[border(0.5)]-13-[goingButton]-13-[goingUnderline(2)]->=0@999-|", options: [], metrics: metrics, views: views)

//        let V_Constraint3 = NSLayoutConstraint.constraintsWithVisualFormat("V:|-10-[pp(100)]-5-[fullnamelbl]-4-[editbtn(>=0@999)]-5-[biolbl]-2-[websitelbl]-10-[border(0.5)]-13-[tableButton]-13-[tableUnderline(2)]->=0@999-|", options: [], metrics: metrics, views: views)

        let squarePictureConstraint = NSLayoutConstraint(item: profilePictureShadowView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: profilePictureShadowView, attribute: NSLayoutAttribute.Height, multiplier: 1, constant: 0)
        self.fullNameLabel.preferredMaxLayoutWidth = screenWidth-120
        self.tableHeaderView.addConstraints(H_Constraint0)
        self.tableHeaderView.addConstraints(H_Constraint1)
        self.tableHeaderView.addConstraints(H_Constraint2)
        self.tableHeaderView.addConstraints(H_Constraint4)
        self.tableHeaderView.addConstraints(H_Constraint6)
        self.tableHeaderView.addConstraints(H_Constraint7)
        self.tableHeaderView.addConstraints(H_Constraint8)

        self.tableHeaderView.addConstraints(V_Constraint0)
        self.tableHeaderView.addConstraints(V_Constraint1)
        self.tableHeaderView.addConstraints(V_Constraint2)

        self.tableHeaderView.addConstraint(squarePictureConstraint)
        self.tableHeaderView.setNeedsLayout()
        self.tableHeaderView.layoutIfNeeded()
        profilePictureShadowView.addSubview(profilePictureImageView)
        self.profilePictureImageView.frame.size = CGSizeMake(100,100)
        
        bioLabel.preferredMaxLayoutWidth = bioLabel.frame.width
        self.tableHeaderView.setNeedsUpdateConstraints()
        self.tableHeaderView.updateConstraintsIfNeeded()
        sizeHeaderToFit(true)

        
        let blueView = UIView()
        blueView.backgroundColor = ColorFromCode.standardBlueColor()
        blueView.frame.size = CGSizeMake(screenWidth,50)
        self.tableHeaderView.addSubview(blueView)
        self.tableHeaderView.sendSubviewToBack(blueView)
        
        
        
    }


    
    override func viewDidLoad() {
        super.viewDidLoad()
        Utility.checkForBeingActive()
        setSubviews()
        setTableHeaderView()
        switchToView(1)
        selectedView = 0
        Refresh()
        selectedView = 1
        
    }
    
    func Refresh(){
        if (selectedView == 1){ // put table refresh
            self.tableViewRefreshControl.beginRefreshing()
            self.tableView.setContentOffset(CGPointMake(0, -tableViewRefreshControl.frame.size.height), animated: false)
        }else if (selectedView == 2){ // put calendar refresh
            self.collectionViewRefreshControl.beginRefreshing()
            self.collectionView.setContentOffset(CGPointMake(0, -collectionViewRefreshControl.frame.size.height), animated: false)
        }
        Utility.checkForBeingActive()
        NowDate = NSDate()
        loadProfileData()
        loadEvents()
    }
    func loadProfileData(){
        
        var Done:Bool = false
        if (mainUserDataLoaded == false){
//            let store = KCSLinkedAppdataStore.storeWithOptions([
//                KCSStoreKeyCollectionName : KCSUserCollectionName,
//                KCSStoreKeyCollectionTemplateClass : KCSUser.self
//                ])
            KCSUser.activeUser().refreshFromServer {
                (objects:[AnyObject]!, error:NSError!) -> Void in
                if (error == nil){
                    self.fetcheduser = FetchedUser(forUser: KCSUser.activeUser(), username: nil)
                    
                    if (self.additionalUserDataLoaded && !Done){
                        Done = true
                        self.setProfileData()
                    }
                    self.mainUserDataLoaded = true
                    self.loadProfilePicture()
                    
                }else{
                    print("Error: " + error.description)
                }
            }
            
        }else{
            self.fetcheduser = FetchedUser(forUser: KCSUser.activeUser(), username: nil)
            self.loadProfilePicture()
        }
        if (additionalUserDataLoaded == false){
            let store = KCSLinkedAppdataStore.storeWithOptions([
                KCSStoreKeyCollectionName : "Activity",
                KCSStoreKeyCollectionTemplateClass : ActivityUnit.self
                ])
            var followersLoaded = false
            var followingLoaded = false
            var eventsLoaded = false
            var folDone = false
            // following
            let query:KCSQuery = KCSQuery(onField: "fromUser._id", withExactMatchForValue: KCSUser.activeUser().userId)
            query.addQueryOnField("type", withExactMatchForValue: "follow")
            query.addQueryOnField("content", withExactMatchForValue: "accepted")
            
            store.countWithQuery(query, completion: {
                (number:UInt, error:NSError!) -> Void in
                if (error == nil){
                    self.numberOfFollowing = number
                    if (followersLoaded && eventsLoaded && !folDone){ // check
                        folDone = true
                        if (self.mainUserDataLoaded && !Done){
                            Done = true
                            self.setProfileData()
                        }
                        self.additionalUserDataLoaded = true
                    }
                    followingLoaded = true
                    
                }else{
                    print("Error: " + error.description)
                }
            })
            
            // followers
            let query1:KCSQuery = KCSQuery(onField: "toUser._id", withExactMatchForValue: KCSUser.activeUser().userId)
            query1.addQueryOnField("type", withExactMatchForValue: "follow")
            query1.addQueryOnField("content", withExactMatchForValue: "accepted")
            store.countWithQuery(query1, completion: {
                (number:UInt, error:NSError!) -> Void in
                if (error == nil){
                    self.numberOfFollowers = number
                    if (followingLoaded && eventsLoaded && !folDone){ // check
                        folDone = true
                        if (self.mainUserDataLoaded && !Done){
                            Done = true
                            self.setProfileData()
                        }
                        self.additionalUserDataLoaded = true
                        
                    }
                    followersLoaded = true
                }else{
                    print("Error: " + error.description)
                }
            })
            
            // events
            let eventstore = KCSLinkedAppdataStore.storeWithOptions([
                KCSStoreKeyCollectionName : "Events",
                KCSStoreKeyCollectionTemplateClass : Event.self
                ])
            
            let query2:KCSQuery = KCSQuery(onField: "author._id", withExactMatchForValue: KCSUser.activeUser().userId)

            eventstore.countWithQuery(query2, completion: {
                (number:UInt, error:NSError!) -> Void in
                if (error == nil){
                    self.numberOfEvents = Int(number)
                    if (followingLoaded && followersLoaded && !folDone){ // check
                        folDone = true
                        if (self.mainUserDataLoaded && !Done){
                            Done = true
                            self.setProfileData()
                        }
                        self.additionalUserDataLoaded = true
                        
                    }
                    eventsLoaded = true
                }else{
                    print("Error: " + error.description)
                }
            })
        }
        
        
    }
    
    func loadProfilePicture(){
        //! get pic
        if ((KCSUser.activeUser().getValueForAttribute("pictureId") != nil) && (KCSUser.activeUser().getValueForAttribute("pictureId") as! String != "")){
            self.profilePictureID = KCSUser.activeUser().getValueForAttribute("pictureId") as! String
            FileDownloadManager.downloadImage(profilePictureID, completionBlock: {
                (images:[UIImage]!, error:NSError!) -> Void in
                if (error == nil){
                    if (images.count > 0){
                        self.profilePicture = images[0]
                        self.profilePictureProgress = 1
                        self.setProfilePicture()
                        
                    }else{
                        self.profilePictureProgress = -1
                        print("Error: object not found")
                    }
                }else{
                    self.profilePictureProgress = -1
                    print("Error: " + error.description)
                }

                }, progressBlock: {
                (objects:[AnyObject]!, percentComplete:Double) -> Void in
                self.profilePictureProgress = percentComplete
                if (self.profilePictureProgress == 1){
                    self.setProfilePicture()
                }
            })

        }else{
            self.profilePictureID = ""
            self.setProfilePicture()
            
        }
    }
    func setProfilePicture(){
        if (self.profilePictureID == ""){//no picture
            self.profilePictureImageView.image = UIImage(named: "defaultPicture.png")!
        }else{
            if (self.profilePictureProgress < 1){ //picture is loading
                
            }else{ //picture is loaded
                self.profilePictureImageView.image = self.profilePicture
                let cells = self.tableView.visibleCells
                for cell in cells{
                    if (cell.isKindOfClass(ProfileEventTableViewCell)){
                        if (events[cell.tag].author!.userId == KCSUser.activeUser().userId){
                            (cell as! ProfileEventTableViewCell).ProfilePicture.image = self.profilePicture
                        }
                    }else{
                        if (events[cell.tag].author!.userId == KCSUser.activeUser().userId){
                            (cell as! ProfileNoPictureTableViewCell).ProfilePicture.image = self.profilePicture
                        }
                    }
                }
            }
        }
    }
    
    func setProfileData(){
        let titleLabel:UILabel = UILabel()
        titleLabel.numberOfLines = 1
        titleLabel.text = self.fetcheduser.username.uppercaseString
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.textAlignment = NSTextAlignment.Center
        titleLabel.font = UIFont(name: "Lato-Semibold", size: 18)
        self.navigationItem.titleView = titleLabel
        titleLabel.sizeToFit()
        
        fullNameLabel.text = self.fetcheduser.fullname
        bioLabel.text = self.fetcheduser.bio
        
        var website = "allsaints.com"
        var linkattrs = [NSFontAttributeName : UIFont(name: "Lato-Regular", size: 13)!, NSForegroundColorAttributeName: ColorFromCode.colorWithHexString("#0087D9")]
        let websiteString = NSMutableAttributedString(string: website, attributes: linkattrs)
        if (!website.hasPrefix("http://")){
            website = "http://\(website)"
        }
        websiteLabel.delegate = self
        websiteLabel.attributedText = websiteString
        let url:NSURL = NSURL(string: website)!
        websiteLabel.addLinkToURL(url, withRange: NSRange(location: 0,length: (websiteLabel.text! as NSString).length))
        websiteLabel.attributedText = websiteString
        linkattrs = [NSFontAttributeName : UIFont(name: "Lato-Regular", size: 13)!, NSForegroundColorAttributeName: ColorFromCode.standardBlueColor()]
        websiteLabel.activeLinkAttributes = linkattrs

        let followers:NSMutableAttributedString = NSMutableAttributedString()
        let following:NSMutableAttributedString = NSMutableAttributedString()

        var attrs = [NSFontAttributeName : UIFont(name: "Lato-Medium", size: 21)!, NSForegroundColorAttributeName: ColorFromCode.colorWithHexString("#0087D9")]
        var content = NSMutableAttributedString(string: "\(numberOfFollowers)", attributes: attrs)
        followers.appendAttributedString(content)
        content = NSMutableAttributedString(string: "\(numberOfFollowing)", attributes: attrs)
        following.appendAttributedString(content)
        
        attrs = [NSFontAttributeName : UIFont(name: "Lato-Regular", size: 13)!, NSForegroundColorAttributeName: ColorFromCode.colorWithHexString("#747474")]
        content = NSMutableAttributedString(string: "\nfollowers", attributes: attrs)
        followers.appendAttributedString(content)
        content = NSMutableAttributedString(string: "\nfollowing", attributes: attrs)
        following.appendAttributedString(content)
        
        numberOfFollowersLabel.attributedText = followers
        numberOfFollowingLabel.attributedText = following
        setEvents()
        sizeHeaderToFit(true)
        self.mainUserDataLoaded = false
        self.additionalUserDataLoaded = false
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.bioLabel.sizeToFit()

    }
    func setEvents(){
        
        let events:NSMutableAttributedString = NSMutableAttributedString()
        
        var attrs = [NSFontAttributeName : UIFont(name: "Lato-Medium", size: 21)!, NSForegroundColorAttributeName: ColorFromCode.colorWithHexString("#0087D9")]
        var content = NSMutableAttributedString(string: "\(numberOfEvents)", attributes: attrs)
        events.appendAttributedString(content)

        attrs = [NSFontAttributeName : UIFont(name: "Lato-Regular", size: 13)!, NSForegroundColorAttributeName: ColorFromCode.colorWithHexString("#747474")]
        content = NSMutableAttributedString(string: "\nevents", attributes: attrs)
        events.appendAttributedString(content)
        numberOfEventsLabel.attributedText = events

    }
    func loadEvents(){
        EventsManager().loadEventsForProfileView(nil,forUserId: KCSUser.activeUser().userId, completionHandler: {
            (downloadedEventsArray:[FetchedEvent], error:NSError!) -> Void in
            self.tableViewRefreshControl.endRefreshing()
            self.collectionViewRefreshControl.endRefreshing()
            self.gridButton.enabled = true
            self.tableButton.enabled = true
            self.goingButton.enabled = true
            if (error == nil){
                var temp = downloadedEventsArray
                
                if (temp.count < 19){
                    self.end = true
                }else{
                    temp.removeLast()
                    self.end = false
                }
                self.events = temp
                for _ in temp {
                    self.cellHeights.append(0)
                }
                self.tableView.reloadData()
                self.collectionView.reloadData()
                self.setEvents()
                self.updateFooter()
                //load pictures
                
                for (index,_) in self.events.enumerate(){
                    EventsManager().loadPictureForEvent(&self.events[index], completionHandler: {
                        (error:NSError!) -> Void in
                        if (error == nil){
                            let cells = self.tableView.visibleCells
                            for cell in cells{
                                if (cell.tag == index){
                                    (cell as! ProfileEventTableViewCell).UpdateEventPicture(self.events[index], row: index)
                                }
                                
                            }
                            let ccells = self.collectionView.visibleCells()
                            for cell in ccells{
                                if (cell.tag == index){
                                    (cell as! ExploreCollectionViewCell).UpdateEventPicture(self.events[index], row: index)
                                }
                                
                            }
                            //println("\(index) event picture progress \(self.events[index].pictureProgress) %")
                            
                        }else{
                            print("Error:" + error.description)
                        }
                    })
                    if (self.events[index].author!.userId! != KCSUser.activeUser().userId){
                        EventsManager().loadProfilePictureForEvent(&self.events[index], completionHandler: {
                            (error:NSError!) -> Void in
                            if (error == nil){
                                let cells = self.tableView.visibleCells
                                for cell in cells{
                                    if (cell.isKindOfClass(ProfileEventTableViewCell)){
                                        if (cell.tag == index){
                                            (cell as! ProfileEventTableViewCell).UpdateProfilePicture(self.events[index].profilePictureID as String,
                                                progress: self.events[index].profilePictureProgress,
                                                image: self.events[index].profilePicture, row: index)
                                        }
                                    }else{
                                        if (cell.tag == index){
                                            (cell as! ProfileNoPictureTableViewCell).UpdateProfilePicture(self.events[index].profilePictureID as String,
                                                progress: self.events[index].profilePictureProgress,
                                                image: self.events[index].profilePicture, row: index)
                                        }
                                    }
                                }
                                //println("\(index) profile picture loaded \(self.events[index].profilePictureProgress) %")
                            }else{
                                print("Error:" + error.description)
                            }
                        })
                    }
                }
                
                
            }else{
                print("Error:" + error.description)
            }
        })
    }
    func loadMoreEvents(){
        print("loadmore")
        if footerView.isAnimating {
            return
        }
        footerView.startAnimating()

        EventsManager().loadEventsForProfileView(self.events.last, forUserId: KCSUser.activeUser().userId, completionHandler: {
            (downloadedEventsArray:[FetchedEvent], error:NSError!) -> Void in
            self.footerView.stopAnimating((error == nil) ? true : false)
            if (error == nil){
                var temp = downloadedEventsArray
                
                if (temp.count < 19){
                    self.end = true
                }else{
                    temp.removeLast()
                    self.end = false
                }
                self.events += temp
                for _ in temp {
                    self.cellHeights.append(0)
                }
                self.tableView.reloadData()
                self.collectionView.reloadData()
                self.updateFooter()
                //load pictures
                
                for (index,_) in self.events.enumerate(){
                    EventsManager().loadPictureForEvent(&self.events[index], completionHandler: {
                        (error:NSError!) -> Void in
                        if (error == nil){
                            let cells = self.tableView.visibleCells
                            for cell in cells{
                                if (cell.tag == index){
                                    (cell as! ProfileEventTableViewCell).UpdateEventPicture(self.events[index], row: index)
                                }
                                
                            }
                            let ccells = self.collectionView.visibleCells()
                            for cell in ccells{
                                if (cell.tag == index){
                                    (cell as! ExploreCollectionViewCell).UpdateEventPicture(self.events[index], row: index)
                                }
                                
                            }
                            //println("\(index) event picture progress \(self.events[index].pictureProgress) %")
                            
                        }else{
                            print("Error:" + error.description)
                        }
                    })
                    if (self.events[index].author!.userId! != KCSUser.activeUser().userId){
                        EventsManager().loadProfilePictureForEvent(&self.events[index], completionHandler: {
                            (error:NSError!) -> Void in
                            if (error == nil){
                                let cells = self.tableView.visibleCells
                                for cell in cells{
                                    if (cell.isKindOfClass(ProfileEventTableViewCell)){
                                        if (cell.tag == index){
                                            (cell as! ProfileEventTableViewCell).UpdateProfilePicture(self.events[index].profilePictureID as String,
                                                progress: self.events[index].profilePictureProgress,
                                                image: self.events[index].profilePicture, row: index)
                                        }
                                    }else{
                                        if (cell.tag == index){
                                            (cell as! ProfileNoPictureTableViewCell).UpdateProfilePicture(self.events[index].profilePictureID as String,
                                                progress: self.events[index].profilePictureProgress,
                                                image: self.events[index].profilePicture, row: index)
                                        }
                                    }
                                }
                                //println("\(index) profile picture loaded \(self.events[index].profilePictureProgress) %")
                            }else{
                                print("Error:" + error.description)
                            }
                        })
                    }
                }
                
                
            }else{
                print("Error:" + error.description)
            }
        })
    }
    
    
    
    
    //-------------------Table-Part--------------------//
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.events.count //first cell is profile cell
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        // prepare content
        let authorNameText = self.events[indexPath.row].author!.username
        let eventNameText = self.events[indexPath.row].name as String
        let eventDateText = self.events[indexPath.row].eventDateText
        let createdAtText = self.events[indexPath.row].createdAtText as String

        // details
        let eventDetailsText = NSMutableAttributedString()
        if (self.events[indexPath.row].details != ""){
            var attrs = [NSFontAttributeName : UIFont(name: "Lato-Medium", size: 14)!, NSForegroundColorAttributeName: ColorFromCode.randomBlueColorFromNumber(3)]
            var content = NSMutableAttributedString(string: "\(authorNameText)", attributes: attrs)
            eventDetailsText.appendAttributedString(content)
            attrs = [NSFontAttributeName : UIFont(name: "Lato-Regular", size: 14)!, NSForegroundColorAttributeName: UIColor.blackColor()]
            content = NSMutableAttributedString(string: " \(self.events[indexPath.row].details)", attributes: attrs)
            eventDetailsText.appendAttributedString(content)
        }
        let eventTimeAndLocationText = NSMutableAttributedString()
        // time
        var attrs = [NSFontAttributeName : UIFont(name: "Lato-Regular", size: 16)!, NSForegroundColorAttributeName: ColorFromCode.randomBlueColorFromNumber(3)]
        var content = NSMutableAttributedString(string: "\(self.events[indexPath.row].timeString) ", attributes:attrs)
        eventTimeAndLocationText.appendAttributedString(content)
        
        
        if (self.events[indexPath.row].location != ""){
            attrs = [NSFontAttributeName : UIFont(name: "Lato-Regular", size: 16)!, NSForegroundColorAttributeName: UIColor.darkGrayColor()]
            content = NSMutableAttributedString(string: " at ", attributes: attrs)
            eventTimeAndLocationText.appendAttributedString(content)
            attrs = [NSFontAttributeName : UIFont(name: "Lato-Regular", size: 16)!, NSForegroundColorAttributeName: ColorFromCode.colorWithHexString("#C78B14")]
            content = NSMutableAttributedString(string: "\(self.events[indexPath.row].location)", attributes: attrs)
            eventTimeAndLocationText.appendAttributedString(content)
            
        }
        
        
        if (self.events[indexPath.row].pictureId != ""){ // Image with Cell
            
            let Cell:ProfileEventTableViewCell = tableView.dequeueReusableCellWithIdentifier("Event Cell", forIndexPath: indexPath) as! ProfileEventTableViewCell
            Cell.tag = indexPath.row
            // set main labels
            Cell.AuthorName.text = authorNameText
            Cell.EventName.text = eventNameText
            Cell.EventDescription.attributedText = eventDetailsText
            Cell.timeLocationLabel.attributedText = eventTimeAndLocationText
            Cell.EventDate.attributedText = eventDateText
            Cell.createdAtLabel.text = createdAtText
            
            // clickable author name
            if (self.events[indexPath.row].details != ""){
                let url:NSURL = NSURL(scheme: "pushAuthor", host: "", path: "/")!
                Cell.EventDescription.addLinkToURL(url, withRange:NSRange(location: 0,length: (authorNameText as NSString).length))
                Cell.EventDescription.delegate = self
                Cell.EventDescription.tag = indexPath.row
            }
            
            // clickable location
            if (self.events[indexPath.row].location != ""){
                let url:NSURL = NSURL(scheme: "pushLocation", host: "", path: "/")!
                let range = NSRange(location: (eventTimeAndLocationText.length-self.events[indexPath.row].location.length),length: self.events[indexPath.row].location.length)
                Cell.timeLocationLabel.addLinkToURL(url, withRange: range)
                Cell.timeLocationLabel.delegate = self
                Cell.timeLocationLabel.tag = indexPath.row
            }
            Cell.timeLocationLabel.attributedText = eventTimeAndLocationText
            Cell.EventDescription.attributedText = eventDetailsText
            
            if (self.events[indexPath.row].date.timeIntervalSinceNow < 0){
                Cell.EventDate.backgroundColor = UIColor.redColor()
            }else{
                Cell.EventDate.backgroundColor = ColorFromCode.standardBlueColor()
            }
            
            Cell.Set_Numbers(self.events[indexPath.row].goManager.numberOfGoing,
                likes: self.events[indexPath.row].likeManager.numberOfLikes,
                comments: self.events[indexPath.row].numberOfComments,
                shares: self.events[indexPath.row].shareManager.numberOfShares)
            
            // Set Buttons
            Cell.LikeButton.initialize(self.events[indexPath.row].likeManager.isLiked)
            Cell.LikeButton.addTarget(self, action: "like:", forControlEvents: UIControlEvents.TouchUpInside)
            Cell.GoButton.initialize(self.events[indexPath.row].goManager.isGoing)
            Cell.GoButton.addTarget(self, action: "go:", forControlEvents: UIControlEvents.TouchUpInside)
            Cell.ShareButton.initialize(self.events[indexPath.row].shareManager.isShared)
            Cell.ShareButton.addTarget(self, action: "share:", forControlEvents: UIControlEvents.TouchUpInside)
            Cell.MoreButton.initialize()
            Cell.MoreButton.addTarget(self, action: "more:", forControlEvents: UIControlEvents.TouchUpInside)
            Cell.ProgressView.progressCircle.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.TouchUpInside)
            
            
            // Update profile picture
            if (self.events[indexPath.row].author!.userId == KCSUser.activeUser().userId){
                Cell.UpdateProfilePicture(self.profilePictureID, progress: self.profilePictureProgress, image: profilePicture, row: indexPath.row)
            }else{
                EventsManager().loadProfilePictureForEvent(&self.events[indexPath.row], completionHandler: {
                    (error:NSError!) -> Void in
                    let index = Cell.tag
                    Cell.UpdateProfilePicture(self.events[index].profilePictureID as String,
                        progress: self.events[index].profilePictureProgress,
                        image: self.events[index].profilePicture, row: index)
                })
            }

            Cell.UpdateEventPicture(self.events[indexPath.row], row: indexPath.row)
            
            Cell.contentView.userInteractionEnabled = true
            let pushEventRec1:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "pushEvent:")
            let pushEventRec2:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "pushEvent:")
            Cell.EventPicture.userInteractionEnabled = true
            Cell.EventPicture.tag = indexPath.row
            Cell.EventPicture.addGestureRecognizer(pushEventRec1)
            Cell.ProgressView.addGestureRecognizer(pushEventRec2)
            
            Cell.likesbtn.addTarget(self, action: "pushLikes:", forControlEvents: UIControlEvents.TouchUpInside)
            Cell.goingbtn.addTarget(self, action: "pushGoing:", forControlEvents: UIControlEvents.TouchUpInside)
            Cell.sharesbtn.addTarget(self, action: "pushShares:", forControlEvents: UIControlEvents.TouchUpInside)
            Cell.highlightMentionsInString(eventDetailsText, withColor: ColorFromCode.randomBlueColorFromNumber(3))
            Cell.highlightHashtagsInString(eventDetailsText, withColor: ColorFromCode.randomBlueColorFromNumber(3))
            
            let descrHeight = Cell.EventDescription.sizeThatFits(CGSizeMake(Cell.EventDescription.frame.width, CGFloat.max)).height
            let timelocHeight = Cell.timeLocationLabel.sizeThatFits(CGSizeMake(Cell.timeLocationLabel.frame.width, 100)).height
            let numberOfGoingHeight = Cell.numberOfGoingLabel.sizeThatFits(CGSizeMake(Cell.numberOfGoingLabel.frame.width, CGFloat.max)).height
            cellHeights.insert((55+screenWidth+15+timelocHeight+5+descrHeight+10+numberOfGoingHeight+5+60), atIndex: indexPath.row)
            return Cell
            
            
            
        }else{ // Cell without Image
            let Cell:ProfileNoPictureTableViewCell = tableView.dequeueReusableCellWithIdentifier("EventNoPic Cell", forIndexPath: indexPath) as! ProfileNoPictureTableViewCell
            Cell.tag = indexPath.row
            
            // set main labels
            Cell.AuthorName.text = authorNameText
            Cell.EventName.text = eventNameText
            Cell.EventDescription.attributedText = eventDetailsText
            Cell.timeLocationLabel.attributedText = eventTimeAndLocationText
            Cell.EventDate.attributedText = eventDateText
            Cell.createdAtLabel.text = createdAtText

            // clickable author name
            if (self.events[indexPath.row].details != ""){
                let url:NSURL = NSURL(scheme: "pushAuthor", host: "", path: "/")!
                Cell.EventDescription.addLinkToURL(url, withRange:NSRange(location: 0,length: (authorNameText as NSString).length))
                Cell.EventDescription.delegate = self
                Cell.EventDescription.tag = indexPath.row
            }
            
            // clickable location
            if (self.events[indexPath.row].location != ""){
                let url:NSURL = NSURL(scheme: "pushLocation", host: "", path: "/")!
                let range = NSRange(location: (eventTimeAndLocationText.length-self.events[indexPath.row].location.length),length: self.events[indexPath.row].location.length)
                Cell.timeLocationLabel.addLinkToURL(url, withRange: range)
                Cell.timeLocationLabel.delegate = self
                Cell.timeLocationLabel.tag = indexPath.row
            }
            Cell.timeLocationLabel.attributedText = eventTimeAndLocationText
            Cell.EventDescription.attributedText = eventDetailsText
            
            
            if (self.events[indexPath.row].date.timeIntervalSinceNow < 0){
                Cell.EventDate.backgroundColor = UIColor.redColor()
            }else{
                Cell.EventDate.backgroundColor = ColorFromCode.standardBlueColor()
            }
            
            // Update profile picture
            if (self.events[indexPath.row].author!.userId == KCSUser.activeUser().userId){
                Cell.UpdateProfilePicture(self.profilePictureID, progress: self.profilePictureProgress, image: profilePicture, row: indexPath.row)
            }else{
                EventsManager().loadProfilePictureForEvent(&self.events[indexPath.row], completionHandler: {
                    (error:NSError!) -> Void in
                    let index = Cell.tag
                    Cell.UpdateProfilePicture(self.events[index].profilePictureID as String,
                        progress: self.events[index].profilePictureProgress,
                        image: self.events[index].profilePicture, row: index)
                })
            }

            
            Cell.Set_Numbers(self.events[indexPath.row].goManager.numberOfGoing,
                likes: self.events[indexPath.row].likeManager.numberOfLikes,
                comments: self.events[indexPath.row].numberOfComments,
                shares: self.events[indexPath.row].shareManager.numberOfShares)
            
            Cell.LikeButton.initialize(self.events[indexPath.row].likeManager.isLiked)
            Cell.LikeButton.addTarget(self, action: "like:", forControlEvents: UIControlEvents.TouchUpInside)
            Cell.GoButton.initialize(self.events[indexPath.row].goManager.isGoing)
            Cell.GoButton.addTarget(self, action: "go:", forControlEvents: UIControlEvents.TouchUpInside)
            Cell.ShareButton.initialize(self.events[indexPath.row].shareManager.isShared)
            Cell.ShareButton.addTarget(self, action: "share:", forControlEvents: UIControlEvents.TouchUpInside)
            Cell.MoreButton.initialize()
            Cell.MoreButton.addTarget(self, action: "more:", forControlEvents: UIControlEvents.TouchUpInside)

            Cell.contentView.userInteractionEnabled = true
            let EventNameTapRecognizer:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "pushEvent:")
            Cell.EventView.userInteractionEnabled = true
            Cell.EventView.tag = indexPath.row
            Cell.EventView.addGestureRecognizer(EventNameTapRecognizer)
            Cell.likesbtn.addTarget(self, action: "pushLikes:", forControlEvents: UIControlEvents.TouchUpInside)
            Cell.goingbtn.addTarget(self, action: "pushGoing:", forControlEvents: UIControlEvents.TouchUpInside)
            Cell.sharesbtn.addTarget(self, action: "pushShares:", forControlEvents: UIControlEvents.TouchUpInside)
            Cell.highlightMentionsInString(eventDetailsText, withColor: ColorFromCode.randomBlueColorFromNumber(3))
            Cell.highlightHashtagsInString(eventDetailsText, withColor: ColorFromCode.randomBlueColorFromNumber(3))
            
            
            
            let descrHeight = Cell.EventDescription.sizeThatFits(CGSizeMake(Cell.EventDescription.frame.width, CGFloat.max)).height
            let timelocHeight = Cell.timeLocationLabel.sizeThatFits(CGSizeMake(Cell.timeLocationLabel.frame.width, 100)).height
            let numberOfGoingHeight = Cell.numberOfGoingLabel.sizeThatFits(CGSizeMake(Cell.numberOfGoingLabel.frame.width, CGFloat.max)).height
            cellHeights.insert((55+screenWidth+15+timelocHeight+5+descrHeight+10+numberOfGoingHeight+5+60), atIndex: indexPath.row)
            return Cell
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if cellHeights[indexPath.row] < 46 || (cellHeights[indexPath.row] == 0) {
            return UITableViewAutomaticDimension
        }else{
            return cellHeights[indexPath.row]
        }
    }
    
    func attributedLabel(label: TTTAttributedLabel!, didSelectLinkWithURL url: NSURL!) {
        //        var tag = label.tag
        print(url.scheme)
        if (url.scheme == "pushAuthor"){ // url = "scheme://host" , host is username
            let row = label.tag
            if (events[row].author!.userId == KCSUser.activeUser().userId as NSString){ //clicked on myself
                
                let VC:MyProfileViewController = self.storyboard?.instantiateViewControllerWithIdentifier("MyProfileViewController") as! MyProfileViewController
                self.navigationController?.pushViewController(VC, animated: true)
                
            }else{ //clicked on someone else
                
                let VC:UserProfileViewController = self.storyboard?.instantiateViewControllerWithIdentifier("UserProfileViewController") as! UserProfileViewController
                VC.user = events[row].author!
                self.navigationController?.pushViewController(VC, animated: true)
                
            }
            
        }else if (url.scheme == "mention"){
            pushUserByUsername(url.host!)
        }
    }
    
    func like(sender: HomeLikeButton){
        print("button pressed \(sender.superview!.superview!.tag)")
        self.events[sender.superview!.superview!.tag].likeManager.button = sender
        self.events[sender.superview!.superview!.tag].likeManager.Like()
    }
    
    func go(sender: HomeResponseButton){
        print("button pressed \(sender.superview!.superview!.tag)")
        self.events[sender.superview!.superview!.tag].goManager.button = sender
        self.events[sender.superview!.superview!.tag].goManager.Going()
        
    }
    
    func share(sender: HomeShareButton){
        print("button pressed \(sender.superview!.superview!.tag)")
        self.events[sender.superview!.superview!.tag].shareManager.button = sender
        self.events[sender.superview!.superview!.tag].shareManager.Share()
        
    }
    func more(sender: HomeMoreButton){
        //        print("more pressed \(sender.superview!.superview!.tag)")
        //        eventsManager.More((sender.superview!.superview!.tag), button: sender)
        let row = sender.tag
        print(row)
        self.events[row].moreManager.showInView(self.view ,event:self.events[row],row: row, handler: {
            (result:String,error:NSError!) -> Void in
            if result == "Deleting" {
                
            } else if result == "FailedToDelete" {
                
            } else if result == "Deleted" {
                self.events.removeAtIndex(row)
                dispatch_async(dispatch_get_main_queue(), {
                    () -> Void in
                    self.tableView.beginUpdates()
                    self.tableView.deleteRowsAtIndexPaths([NSIndexPath(forRow: row, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Automatic)
                    self.tableView.endUpdates()
                    self.collectionView.performBatchUpdates({ () -> Void in
                        self.collectionView.deleteItemsAtIndexPaths([NSIndexPath(forItem: row, inSection: 0)])
                        }, completion: nil)
                })
            }
        })
    }
    
    func refresh(sender: UIButton){
        (sender.superview! as! EProgressView).updateProgress(0)
        let tag = sender.superview!.superview!.superview!.tag
        EventsManager().loadPictureForEvent(&self.events[tag], completionHandler: {
            (error:NSError!) -> Void in
            let cells = self.tableView.visibleCells
            for cell in cells{
                if (cell.tag == tag){
                    (cell as! HomeEventTableViewCell).UpdateEventPicture(self.events[tag], row: tag)
                }
            }
        })
    }
    
    func eventDeleted(atIndex: Int) {
        tableView.deleteSections(NSIndexSet(index: atIndex), withRowAnimation: UITableViewRowAnimation.Automatic)
    }
    
    
    func pushSettings(){
        let VC:SettingsViewController = self.storyboard?.instantiateViewControllerWithIdentifier("SettingsViewController") as! SettingsViewController
        self.navigationController?.pushViewController(VC, animated: true)

    }
    
    func pushLikes(sender:UIButton){
        let selectedRow = sender.superview!.superview!.tag
        
        let VC:UserListViewController = self.storyboard?.instantiateViewControllerWithIdentifier("UserListViewController") as! UserListViewController
        VC.event = events[selectedRow].eventOriginal!
        VC.Target = "Likers"
        
        self.navigationController?.pushViewController(VC, animated: true)
    }
    func pushGoing(sender:UIButton){
        let selectedRow = sender.superview!.superview!.tag
        
        let VC:UserListViewController = self.storyboard?.instantiateViewControllerWithIdentifier("UserListViewController") as! UserListViewController
        VC.event = events[selectedRow].eventOriginal!
        VC.Target = "Accepted"
        
        self.navigationController?.pushViewController(VC, animated: true)
    }
    func pushShares(sender:UIButton){
        let selectedRow = sender.superview!.superview!.tag
        
        let VC:UserListViewController = self.storyboard?.instantiateViewControllerWithIdentifier("UserListViewController") as! UserListViewController
        VC.event = events[selectedRow].eventOriginal!
        VC.Target = "Shares"
        
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    func pushComments(sender:UITapGestureRecognizer){
        let ViewSender:UILabel = sender.view! as! UILabel
        let SelectedIndexPath:NSIndexPath = NSIndexPath(forRow: ViewSender.tag, inSection: 0)
        
        let VC:UserListViewController = self.storyboard?.instantiateViewControllerWithIdentifier("UserListViewController") as! UserListViewController
        VC.event = events[SelectedIndexPath.row].eventOriginal!
        VC.Target = "Likers"
        
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    
    
    
    
    func pushEvent(sender:UITapGestureRecognizer)->Void{
        
        let ViewSender = sender.view!
        let SelectedIndexPath:NSIndexPath = NSIndexPath(forRow: ViewSender.tag, inSection: 0)
        let VC:EventViewController = self.storyboard?.instantiateViewControllerWithIdentifier("EventViewController") as! EventViewController
        VC.event = events[SelectedIndexPath.row]

        
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    func pushUser(sender:UITapGestureRecognizer){
        let ViewSender = sender.view!
        let SelectedIndexPath:NSIndexPath = NSIndexPath(forRow: ViewSender.tag, inSection: 0)
        if (events[SelectedIndexPath.row].author!.userId == KCSUser.activeUser().userId as NSString){ //clicked on myself
            
            let VC:MyProfileViewController = self.storyboard?.instantiateViewControllerWithIdentifier("MyProfileViewController") as! MyProfileViewController
            self.navigationController?.pushViewController(VC, animated: true)
            
        }else{ //clicked on someone else
            
            let VC:UserProfileViewController = self.storyboard?.instantiateViewControllerWithIdentifier("UserProfileViewController") as! UserProfileViewController
            VC.user = events[SelectedIndexPath.row].author!
            self.navigationController?.pushViewController(VC, animated: true)
            
        }
    }

    func editProfile(){
        let VC:EditProfileViewController = self.storyboard?.instantiateViewControllerWithIdentifier("EditProfileViewController") as! EditProfileViewController
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    
    func pushFollowers(){
        let VC:UserListViewController = self.storyboard?.instantiateViewControllerWithIdentifier("UserListViewController") as! UserListViewController
        VC.Target = "Followers"
        VC.user = KCSUser.activeUser()
        self.navigationController?.pushViewController(VC, animated: true)
        
    }
    
    func Push_Following_List(){
        let VC:UserListViewController = self.storyboard?.instantiateViewControllerWithIdentifier("UserListViewController") as! UserListViewController
        VC.Target = "Following"
        VC.user = KCSUser.activeUser()
        self.navigationController?.pushViewController(VC, animated: true)
        
    }
    

    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return events.count
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let Cell:ExploreCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("collection Cell", forIndexPath: indexPath) as! ExploreCollectionViewCell
        
        Cell.tag = indexPath.row
        Cell.UpdateEventPicture(self.events[indexPath.item], row: indexPath.row)
        
        // Set Event Name
        
        Cell.eventNameLabel.text = self.events[indexPath.item].name as String
        var frame = Cell.eventNameLabel.frame
        Cell.eventNameLabel.sizeToFit()
        frame.size.height = Cell.eventNameLabel.frame.size.height
        let maxHeight = (collectionCellHeight-collectionCellWidth-8)
        if frame.size.height > maxHeight {
            frame.size.height = maxHeight
        }
        Cell.eventNameLabel.frame = frame
        Cell.contentView.tag = indexPath.row
        Cell.contentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "PushEventViewController:"))
        
        // remove year word
        let shortenedString:NSAttributedString = self.events[indexPath.row].smallEventDateText
        Cell.eventDateLabel.attributedText = shortenedString
        Cell.UpdateEventPicture(self.events[indexPath.row], row: indexPath.row)
        return Cell
        
    }
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(collectionCellWidth, collectionCellHeight)
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 1
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 0, 0, 0)
    }
    var collectionHeader = CollectionHeaderView()
    var collectionFooter = CollectionHeaderView()
    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        if kind == UICollectionElementKindSectionHeader {
            let header = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionHeader, withReuseIdentifier: "header", forIndexPath: indexPath) as! CollectionHeaderView
            collectionHeader = header
            updateHeader()
            return header
        }else{
            let footer = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionFooter, withReuseIdentifier: "footer", forIndexPath: indexPath) as! CollectionHeaderView
            collectionFooter = footer
            updateFooter()
            return footer
            
        }
        
    }
    func updateHeader(){
        collectionHeader.frame = self.tableHeaderView.frame
        if (selectedView == 1){
            collectionHeader.addSubview(tableHeaderView)
        }
        collectionHeader.setNeedsDisplay()
    }
    
    func updateFooter(){
        
        if self.end {
            collectionFooter.frame = CGRectZero
            tableView.tableFooterView = nil
            footerView.removeFromSuperview()
            flowLayout.footerReferenceSize = CGSizeZero
            collectionFooter.setNeedsDisplay()
            print("remove footer")
        } else {
            if (selectedView == 1){
                tableView.tableFooterView = nil
                collectionFooter.frame.size = footerView.frame.size
                collectionFooter.addSubview(footerView)
                flowLayout.footerReferenceSize = self.footerView.frame.size
                collectionFooter.setNeedsDisplay()
                
            }else if (selectedView == 2){
                footerView.removeFromSuperview()
                flowLayout.footerReferenceSize = CGSizeZero
                tableView.tableFooterView = footerView
            }
            print("display footer")
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
    
    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        if (indexPath.row == self.events.count-4){
            if (!end){
                loadMoreEvents()
            }
        }
    }
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if (indexPath.row == self.events.count-2){
            if (!end){
                loadMoreEvents()
            }
        }
    }
}
