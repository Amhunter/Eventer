//
//  UserProfileViewController.swift
//  Eventer
//
//  Created by Grisha on 18/12/2014.
//  Copyright (c) 2014 Grisha. All rights reserved.
//

import UIKit

class UserProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate,UICollectionViewDataSource, UICollectionViewDelegate, UserFollowDelegate, TTTAttributedLabelDelegate {
    var screenWidth = UIScreen.mainScreen().bounds.width
    var screenHeight = UIScreen.mainScreen().bounds.height
    var TimelineData:[FetchedEvent] = []
    
    //!----Profile Data-------------------//
    
    var mainUserDataLoaded:Bool = false
    var additionalUserDataLoaded:Bool = false
    var user:KCSUser!
    var fetcheduser:FetchedUser!
    var username:String!
    var followManager:UserFollowManager = UserFollowManager()
    var profilePictureID:String = String()
    var profilePictureProgress:Double = 0
    var profilePicture:UIImage = UIImage()
    
    var numberOfFollowers:Int = Int()
    var numberOfFollowing:Int = Int()
    var numberOfEvents:Int = Int()
    
    var tableHeaderView:UIView = UIView()
    
    var bioLabel:UILabel = UILabel()
    var fullNameLabel:UILabel = UILabel()
    var websiteLabel:TTTAttributedLabel = TTTAttributedLabel(frame: CGRectZero)
    var followButton:UserFollowButton = UserFollowButton()
    
    
    var numberOfEventsLabel:TTTAttributedLabel = TTTAttributedLabel(frame: CGRectZero)
    var numberOfFollowersLabel:TTTAttributedLabel = TTTAttributedLabel(frame: CGRectZero)
    var numberOfFollowingLabel:TTTAttributedLabel = TTTAttributedLabel(frame: CGRectZero)
    var profilePictureImageView:UIImageView = UIImageView()
    
    
    var collectionCellWidth = (UIScreen.mainScreen().bounds.width-2)/3
    var collectionCellHeight = (UIScreen.mainScreen().bounds.width-2)/2
    var flowLayout:ProfileGridViewLayout = ProfileGridViewLayout()
    
    var gridButton:UIButton = UIButton()
    var tableButton:UIButton = UIButton()
    
    var NowDate:NSDate = NSDate() //default constructor gets current date if I get it right
    var tableView: UITableView = UITableView()
    var collectionView: UICollectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: UICollectionViewFlowLayout())
    var tableViewRefreshControl:UIRefreshControl = UIRefreshControl()
    var collectionViewRefreshControl:UIRefreshControl = UIRefreshControl()
    
    var gridUnderline = UIView()
    var tableUnderline = UIView()
    var selectedView:Int = 0
    var t1 = UITableViewController()
    
    var footerView = TableFooterRefreshView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, 100))
    var end = false
    var cellHeights:[CGFloat] = []
    func back(){
        self.navigationController!.popViewControllerAnimated(true)
    }

    func Set_Subviews(){
        let backButton = UIBarButtonItem(image: UIImage(named: "back.png"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(back))
        backButton.tintColor = UIColor.whiteColor()
        if (self.navigationController!.viewControllers.count > 1){
            self.navigationItem.leftBarButtonItem = backButton
        }

        // refresh controls
        t1.refreshControl = tableViewRefreshControl
        collectionView.addSubview(collectionViewRefreshControl)
        tableViewRefreshControl.layer.zPosition = -1
        collectionViewRefreshControl.layer.zPosition = -1
        tableViewRefreshControl.addTarget(self, action: #selector(Refresh), forControlEvents: UIControlEvents.ValueChanged)
        collectionViewRefreshControl.addTarget(self, action: #selector(Refresh), forControlEvents: UIControlEvents.ValueChanged)
        footerView.button.addTarget(self, action: #selector(LoadMoreEvents), forControlEvents: UIControlEvents.TouchUpInside)

        //!----TableView---------//
        
        let offset = self.navigationController!.navigationBar.frame.height + UIApplication.sharedApplication().statusBarFrame.height + self.tabBarController!.tabBar.frame.height
        tableView.allowsSelection = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerClass(ProfileEventTableViewCell.self, forCellReuseIdentifier: "Event Cell")
        tableView.registerClass(ProfileNoPictureTableViewCell.self, forCellReuseIdentifier: "EventNoPic Cell")
        tableView.frame = CGRectMake(0, 0, screenWidth, self.view.frame.height-offset)
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        //tableView.estimatedRowHeight = 100
        //tableView.rowHeight = UITableViewAutomaticDimension
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
        
        numberOfFollowersLabel.textAlignment = NSTextAlignment.Center
        numberOfFollowersLabel.numberOfLines = 2
        numberOfFollowingLabel.textAlignment = NSTextAlignment.Center
        numberOfFollowingLabel.numberOfLines = 2
        numberOfEventsLabel.textAlignment = NSTextAlignment.Center
        numberOfEventsLabel.numberOfLines = 2
        
        
        gridButton.tag = 1
        tableButton.tag = 2
        gridButton.enabled = false
        tableButton.enabled = false
        gridButton.addTarget(self, action: #selector(switchBtnPressed(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        tableButton.addTarget(self, action: #selector(switchBtnPressed(_:)), forControlEvents: UIControlEvents.TouchUpInside)
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
        fullNameLabel.numberOfLines = 1
        
        bioLabel.font = UIFont(name: "Lato-Regular", size: 13)
        bioLabel.textAlignment = NSTextAlignment.Left
        bioLabel.textColor = UIColor.darkGrayColor()
        bioLabel.numberOfLines = 0
        
        websiteLabel.font = UIFont(name: "Lato-Regular", size: 13)
        websiteLabel.textAlignment = NSTextAlignment.Left
        websiteLabel.textColor = UIColor.darkGrayColor()
        websiteLabel.numberOfLines = 0
        
        profilePictureImageView.backgroundColor = UIColor.groupTableViewBackgroundColor()
        profilePictureImageView.layer.cornerRadius = 8
        profilePictureImageView.layer.masksToBounds = true // otherwise the corner radius doesnt work
        
        
        //Refresh control
        //self.tableView.addSubview(tableViewRefreshControl)
        //
        //
        
        //Show Followers Button
        let ShowFollowersTapRecognizer:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(Push_Followers_List))
        numberOfFollowersLabel.addGestureRecognizer(ShowFollowersTapRecognizer)
        numberOfFollowersLabel.userInteractionEnabled = true
        
        
        //Show Following Button
        let ShowFollowingTapRecognizer:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(Push_Following_List))
        numberOfFollowingLabel.addGestureRecognizer(ShowFollowingTapRecognizer)
        numberOfFollowingLabel.userInteractionEnabled = true
        
        
        
        
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
    func Make_AutoLayout(){
        
        
        //!---Set Header View
        tableHeaderView.addSubview(profilePictureImageView)
        tableHeaderView.addSubview(numberOfEventsLabel)
        tableHeaderView.addSubview(numberOfFollowingLabel)
        tableHeaderView.addSubview(numberOfFollowersLabel)
        tableHeaderView.addSubview(followButton)
        tableHeaderView.addSubview(fullNameLabel)
        tableHeaderView.addSubview(bioLabel)
        tableHeaderView.addSubview(websiteLabel)
        tableHeaderView.addSubview(gridButton)
        tableHeaderView.addSubview(tableButton)
        //tableView.setTranslatesAutoresizingMaskIntoConstraints(false)
        //tableHeaderView.setTranslatesAutoresizingMaskIntoConstraints(false)
        profilePictureImageView.translatesAutoresizingMaskIntoConstraints = false
        numberOfEventsLabel.translatesAutoresizingMaskIntoConstraints = false
        numberOfFollowingLabel.translatesAutoresizingMaskIntoConstraints = false
        numberOfFollowersLabel.translatesAutoresizingMaskIntoConstraints = false
        followButton.translatesAutoresizingMaskIntoConstraints = false
        fullNameLabel.translatesAutoresizingMaskIntoConstraints = false
        bioLabel.translatesAutoresizingMaskIntoConstraints = false
        websiteLabel.translatesAutoresizingMaskIntoConstraints = false
        
        gridButton.translatesAutoresizingMaskIntoConstraints = false
        tableButton.translatesAutoresizingMaskIntoConstraints = false
        
        //!---Constraints
        let border:UIView = UIView()
        border.translatesAutoresizingMaskIntoConstraints = false
        border.backgroundColor = ColorFromCode.colorWithHexString("#DAE4E7")
        tableHeaderView.addSubview(border)
        
        gridUnderline.translatesAutoresizingMaskIntoConstraints = false
        self.tableHeaderView.addSubview(gridUnderline)
        
        tableUnderline.translatesAutoresizingMaskIntoConstraints = false
        self.tableHeaderView.addSubview(tableUnderline)
        let views =
        [
            "pp": profilePictureImageView,
            "ne": numberOfEventsLabel,
            "nfws": numberOfFollowersLabel,
            "nfwg": numberOfFollowingLabel,
            "followbtn": followButton,
            "biolbl": bioLabel,
            "fullnamelbl": fullNameLabel,
            "websitelbl": websiteLabel,
            "border": border,
            "gridButton": gridButton,
            "tableButton": tableButton,
            "gridUnderline": gridUnderline,
            "tableUnderline": tableUnderline
        ]
        let metrics = [
            "o" : 15
        ]
        let H_Constraint0 = NSLayoutConstraint(item: profilePictureImageView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self.tableHeaderView, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
        let H_Constraint1 = NSLayoutConstraint.constraintsWithVisualFormat("H:|-60@999-[ne(==nfws)][nfws(==nfwg)][nfwg(==ne)]-60@999-|", options: [], metrics: metrics, views: views)
        let H_Constraint2 = NSLayoutConstraint.constraintsWithVisualFormat("H:|-30-[followbtn]-30@999-|", options: [], metrics: metrics, views: views)
        let H_Constraint3 = NSLayoutConstraint.constraintsWithVisualFormat("H:|-o-[fullnamelbl]-10@999-|", options: [], metrics: metrics, views: views)
        let H_Constraint4 = NSLayoutConstraint.constraintsWithVisualFormat("H:|-o-[biolbl]-10@999-|", options: [], metrics: metrics, views: views)
        let H_Constraint5 = NSLayoutConstraint.constraintsWithVisualFormat("H:|-o-[websitelbl]-10@999-|", options: [], metrics: metrics, views: views)
        let H_Constraint6 = NSLayoutConstraint.constraintsWithVisualFormat("H:|[gridButton(==tableButton)][tableButton]|", options: [], metrics: metrics, views: views)
        let H_Constraint7 = NSLayoutConstraint.constraintsWithVisualFormat("H:|[border]|", options: [], metrics: metrics, views: views)
        let H_Constraint8 = NSLayoutConstraint.constraintsWithVisualFormat("H:|[gridUnderline(==tableUnderline)][tableUnderline]|", options: [], metrics: metrics, views: views)
        
        
        
        let V_Constraint0 = NSLayoutConstraint.constraintsWithVisualFormat("V:|-10-[pp(100)]-5-[fullnamelbl]-4-[ne(>=0@999)]-8-[followbtn(25)]-8-[biolbl(>=0@999)]-2-[websitelbl]-10-[border(0.5)]-13-[tableButton]-13-[tableUnderline(2)]->=0@999-|", options: [], metrics: metrics, views: views)
        let V_Constraint1 = NSLayoutConstraint.constraintsWithVisualFormat("V:|-10-[pp(100)]-5-[fullnamelbl]-4-[nfws(>=0@999)]-8-[followbtn(25)]-8-[biolbl(>=0@999)]-2-[websitelbl]-10-[border(0.5)]-13-[gridButton]-13-[gridUnderline(2)]->=0@999-|", options: [], metrics: metrics, views: views)
        let V_Constraint2 = NSLayoutConstraint.constraintsWithVisualFormat("V:|-10-[pp(100)]-5-[fullnamelbl]-4-[nfwg(>=0@999)]-8-[followbtn(25)]-8-[biolbl(>=0@999)]-2-[websitelbl]-10-[border(0.5)]-13-[tableButton]-13-[tableUnderline(2)]->=0@999-|", options: [], metrics: metrics, views: views)
        let squarePictureConstraint = NSLayoutConstraint(item: profilePictureImageView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: profilePictureImageView, attribute: NSLayoutAttribute.Height, multiplier: 1, constant: 0)

        self.tableHeaderView.addConstraint(H_Constraint0)
        self.tableHeaderView.addConstraints(H_Constraint1)
        self.tableHeaderView.addConstraints(H_Constraint2)
        self.tableHeaderView.addConstraints(H_Constraint3)
        self.tableHeaderView.addConstraints(H_Constraint4)
        self.tableHeaderView.addConstraints(H_Constraint5)
        self.tableHeaderView.addConstraints(H_Constraint6)
        self.tableHeaderView.addConstraints(H_Constraint7)
        self.tableHeaderView.addConstraints(H_Constraint8)

        self.tableHeaderView.addConstraints(V_Constraint0)
        self.tableHeaderView.addConstraints(V_Constraint1)
        self.tableHeaderView.addConstraints(V_Constraint2)
        self.tableHeaderView.addConstraint(squarePictureConstraint)

        self.tableHeaderView.setNeedsLayout()
        self.tableHeaderView.layoutIfNeeded()
        
        sizeHeaderToFit(true)
        //        gridUnderline.layer.addSublayer(Utility.gradientLayer(gridUnderline.frame, height: 2, alpha: 0.3))
        //        tableUnderline.layer.addSublayer(Utility.gradientLayer(tableUnderline.frame, height: 2, alpha: 0.3))
        
        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Utility.checkForBeingActive()
        Set_Subviews()
        Make_AutoLayout()
        switchToView(1)
        selectedView = 0
        Set_Profile_Data()
        Refresh()
        selectedView = 1
        
    }
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
    }
    func dictionaryOfNames(arr:UIView...) -> Dictionary<String,UIView> {
        var d = Dictionary<String,UIView>()
        for (ix,v) in arr.enumerate() {
            d["v\(ix+1)"] = v
        }
        return d
    }
    override func viewDidAppear(animated: Bool) {
        
    }
    override func viewWillAppear(animated: Bool) {
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func Refresh(){
        self.mainUserDataLoaded = false
        self.additionalUserDataLoaded = false
        if (selectedView == 1){ // put table refresh
            self.tableViewRefreshControl.beginRefreshing()
            self.tableView.setContentOffset(CGPointMake(0, -tableViewRefreshControl.frame.size.height), animated: false)
        }else if (selectedView == 2){ // put calendar refresh
            self.collectionViewRefreshControl.beginRefreshing()
            self.collectionView.setContentOffset(CGPointMake(0, -collectionViewRefreshControl.frame.size.height), animated: false)
        }
        Utility.checkForBeingActive()
        NowDate = NSDate()
        Load_Profile_Data()
    }
    func Load_Profile_Data(){
        if (user == nil){
            loadUserByUsername()
        }else{
            loadUserByPassedObject()
            checkFollow()
            Load_Events()

        }
    }
    

    func checkFollow(){
        followManager.checkFollow(self.user.userId, completionBlock: {
            (isFollowing:Bool, error:NSError!) -> Void in
            if (error == nil){
                self.followManager.isFollowing = isFollowing
                if (self.additionalUserDataLoaded){
                    self.followManager.initialize(self.user, isFollowing: isFollowing, button: self.followButton, delegate: self)
                    self.followButton.addTarget(self, action: #selector(self.follow), forControlEvents: UIControlEvents.TouchUpInside)
                }

            }else{
                print("Error " + error.description)
            }
        })
    }
    func follow() {
        self.followManager.Follow()
    }
    func followCallback(followed:Bool){
        let text = NSMutableAttributedString()
        if (followed){
            numberOfFollowers += 1
        }else{
            numberOfFollowers -= 1
        }
        var attrs = [NSFontAttributeName : UIFont(name: "Lato-Medium", size: 21)!, NSForegroundColorAttributeName: ColorFromCode.colorWithHexString("#0087D9")]
        var content = NSMutableAttributedString(string: "\(numberOfFollowers)", attributes: attrs)
        text.appendAttributedString(content)
        
        attrs = [NSFontAttributeName : UIFont(name: "Lato-Regular", size: 13)!, NSForegroundColorAttributeName: ColorFromCode.colorWithHexString("#747474")]
        content = NSMutableAttributedString(string: "\nfollowers", attributes: attrs)
        text.appendAttributedString(content)
        numberOfFollowersLabel.attributedText = text

    }
    
    func loadUserByPassedObject(){
        let store = KCSLinkedAppdataStore.storeWithOptions([
            KCSStoreKeyCollectionName : KCSUserCollectionName,
            KCSStoreKeyCollectionTemplateClass : KCSUser.self
            ])

        var Done:Bool = false
        if (mainUserDataLoaded == false){
            
            
            let query = KCSQuery(onField: KCSEntityKeyId, withExactMatchForValue: self.user.userId!)
            store.queryWithQuery(query, withCompletionBlock: {
                (objects:[AnyObject]!, error:NSError!) -> Void in
                if (error == nil){
                    self.fetcheduser = FetchedUser(forUser: objects[0] as! KCSUser, username: nil)
                    
                    if (self.additionalUserDataLoaded && !Done){
                        Done = true
                        self.mainUserDataLoaded = true
                        self.Set_Profile_Data()
                    }
                    self.mainUserDataLoaded = true
                    self.loadProfilePicture()

                    
                }else{
                    print("Error: " + error.description)
                }
            }, withProgressBlock: nil)
            
        }else{
            
            self.fetcheduser = FetchedUser(forUser: self.user, username: nil)
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
            let query:KCSQuery = KCSQuery(onField: "fromUser._id", withExactMatchForValue: self.user.userId)
            query.addQueryOnField("type", withExactMatchForValue: "follow")
            query.addQueryOnField("content", withExactMatchForValue: "accepted")
            
            store.countWithQuery(query, completion: {
                (number:UInt, error:NSError!) -> Void in
                if (error == nil){
                    self.numberOfFollowing = Int(number)
                    if (followersLoaded && eventsLoaded && !folDone){ // check
                        folDone = true
                        if (self.mainUserDataLoaded && !Done){
                            Done = true
                            self.additionalUserDataLoaded = true
                            self.Set_Profile_Data()
                        }
                        self.additionalUserDataLoaded = true
                    }
                    followingLoaded = true
                    
                }else{
                    print("Error: " + error.description)
                }
            })
            
            // followers
            let query1:KCSQuery = KCSQuery(onField: "toUser._id", withExactMatchForValue: self.user.userId)
            query1.addQueryOnField("type", withExactMatchForValue: "follow")
            query1.addQueryOnField("content", withExactMatchForValue: "accepted")
            store.countWithQuery(query1, completion: {
                (number:UInt, error:NSError!) -> Void in
                if (error == nil){
                    self.numberOfFollowers = Int(number)
                    if (followingLoaded && eventsLoaded && !folDone){ // check
                        folDone = true
                        if (self.mainUserDataLoaded && !Done){
                            Done = true
                            self.additionalUserDataLoaded = true
                            self.Set_Profile_Data()
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
            
            let query2:KCSQuery = KCSQuery(onField: "author._id", withExactMatchForValue: self.user.userId)
            
            eventstore.countWithQuery(query2, completion: {
                (number:UInt, error:NSError!) -> Void in
                if (error == nil){
                    self.numberOfEvents = Int(number)
                    if (followingLoaded && followersLoaded && !folDone){ // check
                        folDone = true
                        if (self.mainUserDataLoaded && !Done){
                            Done = true
                            self.additionalUserDataLoaded = true
                            self.Set_Profile_Data()
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
        if ((self.user.getValueForAttribute("pictureId") != nil) && (self.user.getValueForAttribute("pictureId") as! String != "")){
            self.profilePictureID = self.user.getValueForAttribute("pictureId") as! String
            
            _ = KCSQuery(onField: KCSEntityKeyId, withExactMatchForValue: self.profilePictureID)
            
            FileDownloadManager.downloadImage(self.profilePictureID, completionBlock: {
                (images:[UIImage]!, error:NSError!) -> Void in
                if (error == nil){
                    if (images.count > 0){

                        self.profilePicture = images[0]
                        self.profilePictureProgress = 1
                    }else{
                        self.profilePictureProgress = -1
                        print("Error: object not found")
                    }
                    
                }else{
                    print("Error: " + error.description)
                }
                self.Set_Profile_Picture()
            }, progressBlock: {
                (objects:[AnyObject]!, percentComplete:Double) -> Void in
                self.profilePictureProgress = percentComplete
                if (self.profilePictureProgress == 1){
                    self.Set_Profile_Picture()
                }
            })
            
        }else{
            self.profilePictureID = ""
            self.Set_Profile_Picture()
            
        }
    }
    
    func loadUserByUsername(){
        let store = KCSLinkedAppdataStore.storeWithOptions([
            KCSStoreKeyCollectionName : KCSUserCollectionName,
            KCSStoreKeyCollectionTemplateClass : KCSUser.self
            ])
        if (mainUserDataLoaded == false){
            
            
            let query = KCSQuery(onField: KCSUserAttributeUsername, withExactMatchForValue: self.username)
            store.queryWithQuery(query, withCompletionBlock: {
                (objects:[AnyObject]!, error:NSError!) -> Void in
                print(error == nil)
                if (error == nil){
                    if !(objects.count > 0) {
                        self.followButton.setTitle("user not found", forState: UIControlState.Normal)
                        
                        return
                    }
                    self.fetcheduser = FetchedUser(forUser: objects[0] as! KCSUser, username: nil)
                    self.user = objects[0] as! KCSUser
                    self.mainUserDataLoaded = true
                    self.Set_Profile_Data()
                    self.checkFollow()
                    self.loadProfilePicture()
                    
                    // load events
                    self.Load_Events()
                    
                    // load following/followers
                    
                    let store = KCSLinkedAppdataStore.storeWithOptions([
                        KCSStoreKeyCollectionName : "Activity",
                        KCSStoreKeyCollectionTemplateClass : ActivityUnit.self
                        ])
                    var followersLoaded = false
                    var followingLoaded = false
                    var eventsLoaded = false

                    var folDone = false
                    
                    // following
                    let query:KCSQuery = KCSQuery(onField: "fromUser._id", withExactMatchForValue: self.user.userId)
                    query.addQueryOnField("type", withExactMatchForValue: "follow")
                    query.addQueryOnField("content", withExactMatchForValue: "accepted")
                    
                    
                    store.countWithQuery(query, completion: {
                        (number:UInt, error:NSError!) -> Void in
                        if (error == nil){
                            self.numberOfFollowing = Int(number)
                            if (followersLoaded && eventsLoaded && !folDone){ // check
                                folDone = true
                                self.additionalUserDataLoaded = true
                                self.Set_Profile_Data()
                            }
                            followingLoaded = true
                            
                        }else{
                            print("Error: " + error.description)
                        }
                    })
                    
                    // followers
                    let query1:KCSQuery = KCSQuery(onField: "fromUser._id", withExactMatchForValue: self.user.userId)
                    query1.addQueryOnField("type", withExactMatchForValue: "follow")
                    query1.addQueryOnField("content", withExactMatchForValue: "accepted")
                    store.countWithQuery(query1, completion: {
                        (number:UInt, error:NSError!) -> Void in
                        if (error == nil){
                            self.numberOfFollowers = Int(number)
                            if (followingLoaded && eventsLoaded && !folDone){ // check
                                folDone = true
                                self.additionalUserDataLoaded = true
                                self.Set_Profile_Data()
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
                    
                    let query2:KCSQuery = KCSQuery(onField: "author._id", withExactMatchForValue: self.user.userId)
                    
                    eventstore.countWithQuery(query2, completion: {
                        (number:UInt, error:NSError!) -> Void in
                        if (error == nil){
                            self.numberOfEvents = Int(number)
                            if (followingLoaded && followersLoaded && !folDone){ // check
                                folDone = true
                                self.additionalUserDataLoaded = true
                                self.Set_Profile_Data()

                            }
                            eventsLoaded = true
                        }else{
                            print("Error: " + error.description)
                        }
                    })

                }else{
                    print("Error: " + error.description)
                }
            }, withProgressBlock: nil)
            
        }
        if (additionalUserDataLoaded == false){

        }
    }

    
    func Set_Profile_Picture(){
        if (self.profilePictureID == ""){//no picture
            self.profilePictureImageView.image = UIImage(named: "defaultPicture.png")!
        }else{
            if (self.profilePictureProgress < 1){ //picture is loading
                
            }else{ //picture is loaded
                self.profilePictureImageView.image = self.profilePicture
                let cells = self.tableView.visibleCells
                for cell in cells{
                    if (cell.isKindOfClass(ProfileEventTableViewCell)){
                        if (TimelineData[cell.tag].author!.userId == self.user.userId){
                            (cell as! ProfileEventTableViewCell).ProfilePicture.image = self.profilePicture
                        }
                    }else{
                        if (TimelineData[cell.tag].author!.userId == self.user.userId){
                            (cell as! ProfileNoPictureTableViewCell).ProfilePicture.image = self.profilePicture
                        }
                    }
                }
            }
        }
        
    }
    
    func Set_Profile_Data(){
        // title
        let titleLabel:UILabel = UILabel()
        titleLabel.numberOfLines = 1
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.textAlignment = NSTextAlignment.Center
        titleLabel.font = UIFont(name: "Lato-Semibold", size: 18)
        self.navigationItem.titleView = titleLabel
        if (self.user != nil){
            titleLabel.text = self.user.username.uppercaseString
        }else{
            titleLabel.text = self.username.uppercaseString
        }
        titleLabel.sizeToFit()

        if (mainUserDataLoaded){
            if (self.fetcheduser == nil){
                self.fetcheduser = FetchedUser(forUser: self.user, username: nil)
            }
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

        }
        if (additionalUserDataLoaded){
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
            
            if (self.followManager.loaded){
                self.followManager.initialize(self.user, isFollowing: self.followManager.isFollowing, button: self.followButton, delegate: self)
                self.followButton.addTarget(self, action: #selector(follow), forControlEvents: UIControlEvents.TouchUpInside)

            }
            Set_Events()
        }
        sizeHeaderToFit(true)

        
    }
    
    func Load_Events(){
        
        EventsManager().loadEventsForProfileView(nil,forUserId: self.user.userId, completionHandler: {
            (downloadedEventsArray:[FetchedEvent], error:NSError!) -> Void in
            self.tableViewRefreshControl.endRefreshing()
            self.collectionViewRefreshControl.endRefreshing()
            self.gridButton.enabled = true
            self.tableButton.enabled = true
            if (error == nil){
                var temp = downloadedEventsArray
                
                if (temp.count < 19){
                    self.end = true
                }else{
                    temp.removeLast()
                    self.end = false
                }
                self.TimelineData = temp
                for _ in temp {
                    self.cellHeights.append(0)
                }
                self.tableView.reloadData()
                self.collectionView.reloadData()
                self.updateFooter()
                //load pictures

                
                for (index,_) in self.TimelineData.enumerate(){
                    EventsManager().loadPictureForEvent(&self.TimelineData[index], completionHandler: {
                        (error:NSError!) -> Void in
                        if (error == nil){
                            let cells = self.tableView.visibleCells
                            for cell in cells{
                                if (cell.tag == index){
                                    (cell as! ProfileEventTableViewCell).UpdateEventPicture(self.TimelineData[index], row: index)
                                }
                                
                            }
                            let ccells = self.collectionView.visibleCells()
                            for cell in ccells{
                                if (cell.tag == index){
                                    (cell as! ExploreCollectionViewCell).UpdateEventPicture(self.TimelineData[index], row: index)
                                }
                                
                            }
                            //println("\(index) event picture progress \(self.TimelineData[index].pictureProgress) %")
                            
                        }else{
                            print("Error:" + error.description)
                        }
                    })
                    if (self.TimelineData[index].author!.userId! != self.user.userId){
                        EventsManager().loadProfilePictureForEvent(&self.TimelineData[index], completionHandler: {
                            (error:NSError!) -> Void in
                            if (error == nil){
                                let cells = self.tableView.visibleCells
                                for cell in cells{
                                    if (cell.isKindOfClass(ProfileEventTableViewCell)){
                                        if (cell.tag == index){
                                            (cell as! ProfileEventTableViewCell).UpdateProfilePicture(self.TimelineData[index].profilePictureID as String,
                                                progress: self.TimelineData[index].profilePictureProgress,
                                                image: self.TimelineData[index].profilePicture, row: index)
                                        }
                                    }else{
                                        if (cell.tag == index){
                                            (cell as! ProfileNoPictureTableViewCell).UpdateProfilePicture(self.TimelineData[index].profilePictureID as String,
                                                progress: self.TimelineData[index].profilePictureProgress,
                                                image: self.TimelineData[index].profilePicture, row: index)
                                        }
                                    }
                                }
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
    
    func LoadMoreEvents(){
        print("loadmore")
        if footerView.isAnimating {
            return
        }
        footerView.startAnimating()

        EventsManager().loadEventsForProfileView(self.TimelineData.last,forUserId: self.user.userId, completionHandler: {
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
                self.TimelineData += temp
                for _ in temp {
                    self.cellHeights.append(0)
                }
                self.tableView.reloadData()
                self.collectionView.reloadData()
                self.updateFooter()
                //load pictures
                
                
                for (index,_) in self.TimelineData.enumerate(){
                    EventsManager().loadPictureForEvent(&self.TimelineData[index], completionHandler: {
                        (error:NSError!) -> Void in
                        if (error == nil){
                            let cells = self.tableView.visibleCells
                            for cell in cells{
                                if (cell.tag == index){
                                    (cell as! ProfileEventTableViewCell).UpdateEventPicture(self.TimelineData[index], row: index)
                                }
                                
                            }
                            let ccells = self.collectionView.visibleCells()
                            for cell in ccells{
                                if (cell.tag == index){
                                    (cell as! ExploreCollectionViewCell).UpdateEventPicture(self.TimelineData[index], row: index)
                                }
                                
                            }
                            //println("\(index) event picture progress \(self.TimelineData[index].pictureProgress) %")
                            
                        }else{
                            print("Error:" + error.description)
                        }
                    })
                    if (self.TimelineData[index].author!.userId! != self.user.userId){
                        EventsManager().loadProfilePictureForEvent(&self.TimelineData[index], completionHandler: {
                            (error:NSError!) -> Void in
                            if (error == nil){
                                let cells = self.tableView.visibleCells
                                for cell in cells{
                                    if (cell.isKindOfClass(ProfileEventTableViewCell)){
                                        if (cell.tag == index){
                                            (cell as! ProfileEventTableViewCell).UpdateProfilePicture(self.TimelineData[index].profilePictureID as String,
                                                progress: self.TimelineData[index].profilePictureProgress,
                                                image: self.TimelineData[index].profilePicture, row: index)
                                        }
                                    }else{
                                        if (cell.tag == index){
                                            (cell as! ProfileNoPictureTableViewCell).UpdateProfilePicture(self.TimelineData[index].profilePictureID as String,
                                                progress: self.TimelineData[index].profilePictureProgress,
                                                image: self.TimelineData[index].profilePicture, row: index)
                                        }
                                    }
                                }
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

    func Set_Events(){
        
        let events:NSMutableAttributedString = NSMutableAttributedString()
        
        var attrs = [NSFontAttributeName : UIFont(name: "Lato-Medium", size: 21)!, NSForegroundColorAttributeName: ColorFromCode.colorWithHexString("#0087D9")]
        var content = NSMutableAttributedString(string: "\(numberOfEvents)", attributes: attrs)
        events.appendAttributedString(content)
        
        attrs = [NSFontAttributeName : UIFont(name: "Lato-Regular", size: 13)!, NSForegroundColorAttributeName: ColorFromCode.colorWithHexString("#747474")]
        content = NSMutableAttributedString(string: "\nevents", attributes: attrs)
        events.appendAttributedString(content)
        numberOfEventsLabel.attributedText = events
    }
    
    
    
    //-------------------Table-Part--------------------//
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.TimelineData.count //first cell is profile cell
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // prepare content
        let authorNameText = self.TimelineData[indexPath.row].author!.username
        let eventNameText = self.TimelineData[indexPath.row].name as String
        let eventDateText = self.TimelineData[indexPath.row].eventDateText
        let createdAtText = self.TimelineData[indexPath.row].createdAtText as String
        
        // details
        let eventDetailsText = NSMutableAttributedString()
        if (self.TimelineData[indexPath.row].details != ""){
            var attrs = [NSFontAttributeName : UIFont(name: "Lato-Medium", size: 14)!, NSForegroundColorAttributeName: ColorFromCode.randomBlueColorFromNumber(3)]
            var content = NSMutableAttributedString(string: "\(authorNameText)", attributes: attrs)
            eventDetailsText.appendAttributedString(content)
            attrs = [NSFontAttributeName : UIFont(name: "Lato-Regular", size: 14)!, NSForegroundColorAttributeName: UIColor.blackColor()]
            content = NSMutableAttributedString(string: " \(self.TimelineData[indexPath.row].details)", attributes: attrs)
            eventDetailsText.appendAttributedString(content)
        }
        let eventTimeAndLocationText = NSMutableAttributedString()
        // time
        var attrs = [NSFontAttributeName : UIFont(name: "Lato-Regular", size: 16)!, NSForegroundColorAttributeName: ColorFromCode.randomBlueColorFromNumber(3)]
        var content = NSMutableAttributedString(string: "\(self.TimelineData[indexPath.row].timeString) ", attributes:attrs)
        eventTimeAndLocationText.appendAttributedString(content)
        
        
        if (self.TimelineData[indexPath.row].location != ""){
            attrs = [NSFontAttributeName : UIFont(name: "Lato-Regular", size: 16)!, NSForegroundColorAttributeName: UIColor.darkGrayColor()]
            content = NSMutableAttributedString(string: " at ", attributes: attrs)
            eventTimeAndLocationText.appendAttributedString(content)
            attrs = [NSFontAttributeName : UIFont(name: "Lato-Regular", size: 16)!, NSForegroundColorAttributeName: ColorFromCode.colorWithHexString("#C78B14")]
            content = NSMutableAttributedString(string: "\(self.TimelineData[indexPath.row].location)", attributes: attrs)
            eventTimeAndLocationText.appendAttributedString(content)
            
        }
        
        
        if (self.TimelineData[indexPath.row].pictureId != ""){ // Image with Cell
            
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
            if (self.TimelineData[indexPath.row].details != ""){
                let url:NSURL = NSURL(scheme: "pushAuthor", host: "", path: "/")!
                Cell.EventDescription.addLinkToURL(url, withRange:NSRange(location: 0,length: (authorNameText as NSString).length))
                Cell.EventDescription.delegate = self
                Cell.EventDescription.tag = indexPath.row
            }
            
            // clickable location
            if (self.TimelineData[indexPath.row].location != ""){
                let url:NSURL = NSURL(scheme: "pushLocation", host: "", path: "/")!
                let range = NSRange(location: (eventTimeAndLocationText.length-self.TimelineData[indexPath.row].location.length),length: self.TimelineData[indexPath.row].location.length)
                Cell.timeLocationLabel.addLinkToURL(url, withRange: range)
                Cell.timeLocationLabel.delegate = self
                Cell.timeLocationLabel.tag = indexPath.row
            }
            Cell.timeLocationLabel.attributedText = eventTimeAndLocationText
            Cell.EventDescription.attributedText = eventDetailsText
            
            if (self.TimelineData[indexPath.row].date.timeIntervalSinceNow < 0){
                Cell.EventDate.backgroundColor = UIColor.redColor()
            }else{
                Cell.EventDate.backgroundColor = ColorFromCode.standardBlueColor()
            }
            
            Cell.Set_Numbers(self.TimelineData[indexPath.row].goManager.numberOfGoing,
                likes: self.TimelineData[indexPath.row].likeManager.numberOfLikes,
                comments: self.TimelineData[indexPath.row].numberOfComments,
                shares: self.TimelineData[indexPath.row].shareManager.numberOfShares)
            
            // Set Buttons
            Cell.LikeButton.initialize(self.TimelineData[indexPath.row].likeManager.isLiked)
            Cell.LikeButton.addTarget(self, action: #selector(like(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            Cell.GoButton.initialize(self.TimelineData[indexPath.row].goManager.isGoing)
            Cell.GoButton.addTarget(self, action: #selector(go(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            Cell.ShareButton.initialize(self.TimelineData[indexPath.row].shareManager.isShared)
            Cell.ShareButton.addTarget(self, action: #selector(share(_:)), forControlEvents: UIControlEvents.TouchUpInside)
//            Cell.MoreButton.initialize()
//            Cell.MoreButton.addTarget(self, action: "more:", forControlEvents: UIControlEvents.TouchUpInside)
            Cell.ProgressView.progressCircle.addTarget(self, action: #selector(refresh(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            
            
            // Update profile picture
            if (self.TimelineData[indexPath.row].author!.userId == self.user.userId){
                Cell.UpdateProfilePicture(self.profilePictureID, progress: self.profilePictureProgress, image: profilePicture, row: indexPath.row)
            }else{
                EventsManager().loadProfilePictureForEvent(&self.TimelineData[indexPath.row], completionHandler: {
                    (error:NSError!) -> Void in
                    let index = Cell.tag
                    Cell.UpdateProfilePicture(self.TimelineData[indexPath.row].profilePictureID as String,
                        progress: self.TimelineData[indexPath.row].profilePictureProgress,
                        image: self.TimelineData[indexPath.row].profilePicture, row: index)
                })
            }
            
            Cell.UpdateEventPicture(self.TimelineData[indexPath.row], row: indexPath.row)
            
            Cell.contentView.userInteractionEnabled = true
            let pushEventRec1:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(PushEventViewController(_:)))
            let pushEventRec2:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(PushEventViewController(_:)))
            Cell.EventPicture.userInteractionEnabled = true
            Cell.EventPicture.tag = indexPath.row
            Cell.EventPicture.addGestureRecognizer(pushEventRec1)
            Cell.ProgressView.addGestureRecognizer(pushEventRec2)
            
            Cell.likesbtn.addTarget(self, action: #selector(PushLikes(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            Cell.goingbtn.addTarget(self, action: #selector(PushGoing(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            Cell.sharesbtn.addTarget(self, action: #selector(PushShares(_:)), forControlEvents: UIControlEvents.TouchUpInside)
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
            if (self.TimelineData[indexPath.row].details != ""){
                let url:NSURL = NSURL(scheme: "pushAuthor", host: "", path: "/")!
                Cell.EventDescription.addLinkToURL(url, withRange:NSRange(location: 0,length: (authorNameText as NSString).length))
                Cell.EventDescription.delegate = self
                Cell.EventDescription.tag = indexPath.row
            }
            
            // clickable location
            if (self.TimelineData[indexPath.row].location != ""){
                let url:NSURL = NSURL(scheme: "pushLocation", host: "", path: "/")!
                let range = NSRange(location: (eventTimeAndLocationText.length-self.TimelineData[indexPath.row].location.length),length: self.TimelineData[indexPath.row].location.length)
                Cell.timeLocationLabel.addLinkToURL(url, withRange: range)
                Cell.timeLocationLabel.delegate = self
                Cell.timeLocationLabel.tag = indexPath.row
            }
            Cell.timeLocationLabel.attributedText = eventTimeAndLocationText
            Cell.EventDescription.attributedText = eventDetailsText
            
            
            if (self.TimelineData[indexPath.row].date.timeIntervalSinceNow < 0){
                Cell.EventDate.backgroundColor = UIColor.redColor()
            }else{
                Cell.EventDate.backgroundColor = ColorFromCode.standardBlueColor()
            }
            
            // Update profile picture
            if (self.TimelineData[indexPath.row].author!.userId == self.user.userId){
                Cell.UpdateProfilePicture(self.profilePictureID, progress: self.profilePictureProgress, image: profilePicture, row: indexPath.row)
            }else{
                EventsManager().loadProfilePictureForEvent(&self.TimelineData[indexPath.row], completionHandler: {
                    (error:NSError!) -> Void in
                    let index = Cell.tag
                    Cell.UpdateProfilePicture(self.TimelineData[indexPath.row].profilePictureID as String,
                        progress: self.TimelineData[indexPath.row].profilePictureProgress,
                        image: self.TimelineData[indexPath.row].profilePicture, row: index)
                })
            }
            
            
            Cell.Set_Numbers(self.TimelineData[indexPath.row].goManager.numberOfGoing,
                likes: self.TimelineData[indexPath.row].likeManager.numberOfLikes,
                comments: self.TimelineData[indexPath.row].numberOfComments,
                shares: self.TimelineData[indexPath.row].shareManager.numberOfShares)
            
            Cell.LikeButton.initialize(self.TimelineData[indexPath.row].likeManager.isLiked)
            Cell.LikeButton.addTarget(self, action: #selector(like(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            Cell.GoButton.initialize(self.TimelineData[indexPath.row].goManager.isGoing)
            Cell.GoButton.addTarget(self, action: #selector(go(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            Cell.ShareButton.initialize(self.TimelineData[indexPath.row].shareManager.isShared)
            Cell.ShareButton.addTarget(self, action: #selector(share(_:)), forControlEvents: UIControlEvents.TouchUpInside)
//            Cell.MoreButton.initialize()
//            Cell.MoreButton.addTarget(self, action: "more:", forControlEvents: UIControlEvents.TouchUpInside)
            
            Cell.contentView.userInteractionEnabled = true
            let EventNameTapRecognizer:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(PushEventViewController(_:)))
            Cell.EventView.userInteractionEnabled = true
            Cell.EventView.tag = indexPath.row
            Cell.EventView.addGestureRecognizer(EventNameTapRecognizer)
            Cell.likesbtn.addTarget(self, action: #selector(PushLikes(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            Cell.goingbtn.addTarget(self, action: #selector(PushGoing(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            Cell.sharesbtn.addTarget(self, action: #selector(PushShares(_:)), forControlEvents: UIControlEvents.TouchUpInside)
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
    func like(sender: HomeLikeButton){
        print("button pressed \(sender.superview!.superview!.tag)")
        self.TimelineData[sender.superview!.superview!.tag].likeManager.button = sender
        self.TimelineData[sender.superview!.superview!.tag].likeManager.Like()
    }
    
    func go(sender: HomeResponseButton){
        print("button pressed \(sender.superview!.superview!.tag)")
        self.TimelineData[sender.superview!.superview!.tag].goManager.button = sender
        self.TimelineData[sender.superview!.superview!.tag].goManager.Going()
        
    }
    
    func share(sender: HomeShareButton){
        print("button pressed \(sender.superview!.superview!.tag)")
        self.TimelineData[sender.superview!.superview!.tag].shareManager.button = sender
        self.TimelineData[sender.superview!.superview!.tag].shareManager.Share()
        
    }
    
    func refresh(sender: UIButton){
        (sender.superview! as! EProgressView).updateProgress(0)
        let tag = sender.superview!.superview!.superview!.tag
        EventsManager().loadPictureForEvent(&self.TimelineData[tag], completionHandler: {
            (error:NSError!) -> Void in
            let cells = self.tableView.visibleCells
            for cell in cells{
                if (cell.tag == tag){
                    (cell as! HomeEventTableViewCell).UpdateEventPicture(self.TimelineData[tag], row: tag)
                }
            }
        })
    }
    
    func PushLikes(sender:UIButton){
        let selectedRow = sender.superview!.superview!.tag
        
        let VC:UserListViewController = self.storyboard?.instantiateViewControllerWithIdentifier("UserListViewController") as! UserListViewController
        VC.event = TimelineData[selectedRow].eventOriginal!
        VC.Target = "Likers"
        
        self.navigationController?.pushViewController(VC, animated: true)
    }
    func PushGoing(sender:UIButton){
        let selectedRow = sender.superview!.superview!.tag
        
        let VC:UserListViewController = self.storyboard?.instantiateViewControllerWithIdentifier("UserListViewController") as! UserListViewController
        VC.event = TimelineData[selectedRow].eventOriginal!
        VC.Target = "Accepted"
        
        self.navigationController?.pushViewController(VC, animated: true)
    }
    func PushShares(sender:UIButton){
        let selectedRow = sender.superview!.superview!.tag
        
        let VC:UserListViewController = self.storyboard?.instantiateViewControllerWithIdentifier("UserListViewController") as! UserListViewController
        VC.event = TimelineData[selectedRow].eventOriginal!
        VC.Target = "Shares"
        
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    func PushComments(sender:UITapGestureRecognizer){
        let ViewSender:UILabel = sender.view! as! UILabel
        let SelectedIndexPath:NSIndexPath = NSIndexPath(forRow: ViewSender.tag, inSection: 0)
        
        let VC:UserListViewController = self.storyboard?.instantiateViewControllerWithIdentifier("UserListViewController") as! UserListViewController
        VC.event = TimelineData[SelectedIndexPath.row].eventOriginal!
        VC.Target = "Likers"
        
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    
    // Event Name Pushed//
    func PushEventViewController(sender:UITapGestureRecognizer)->Void{
        
        let LabelSender:UILabel = sender.view as! UILabel
        let SelectedIndexPath:NSIndexPath = NSIndexPath(forRow: LabelSender.tag, inSection: 0)
        _ = tableView.cellForRowAtIndexPath(SelectedIndexPath) as! ProfileEventTableViewCell
        
        let VC:EventViewController = self.storyboard?.instantiateViewControllerWithIdentifier("EventViewController") as! EventViewController
        VC.event = TimelineData[SelectedIndexPath.row]
        //VC.author = self.user as KCSUser
        
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    
    func Push_Followers_List(){
        let VC:UserListViewController = self.storyboard?.instantiateViewControllerWithIdentifier("UserListViewController") as! UserListViewController
        VC.Target = "Followers"
        VC.user = self.user
        self.navigationController?.pushViewController(VC, animated: true)
        
    }
    
    func Push_Following_List(){
        let VC:UserListViewController = self.storyboard?.instantiateViewControllerWithIdentifier("UserListViewController") as! UserListViewController
        VC.Target = "Following"
        VC.user = self.user
        self.navigationController?.pushViewController(VC, animated: true)
        
    }
    
    
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let Cell:ExploreCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("collection Cell", forIndexPath: indexPath) as! ExploreCollectionViewCell
        
        Cell.tag = indexPath.row
        Cell.UpdateEventPicture(self.TimelineData[indexPath.item], row: indexPath.row)
        
        // Set Event Name
        
        Cell.eventNameLabel.text = self.TimelineData[indexPath.item].name as String
        var frame = Cell.eventNameLabel.frame
        Cell.eventNameLabel.sizeToFit()
        frame.size.height = Cell.eventNameLabel.frame.size.height
        Cell.eventNameLabel.frame = frame
        Cell.contentView.tag = indexPath.row
        Cell.contentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(PushEventViewController(_:))))
        
        // remove year word
        let shortenedString:NSAttributedString = self.TimelineData[indexPath.row].smallEventDateText
        Cell.eventDateLabel.attributedText = shortenedString
        Cell.UpdateEventPicture(self.TimelineData[indexPath.row], row: indexPath.row)
        
        
        return Cell
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
            print("remove")
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
            print("display")
        }
    }
    

    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (collectionView == self.collectionView){
            return TimelineData.count
        }else{
            return 0
        }
    }
    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        if (indexPath.row == self.TimelineData.count-4){
            if (!end){
                LoadMoreEvents()
            }
        }
    }
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if (indexPath.row == self.TimelineData.count-2){
            if (!end){
                LoadMoreEvents()
            }
        }
    }
}
