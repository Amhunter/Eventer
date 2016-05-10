//
//  EventListViewController.swift
//  Eventer
//
//  Created by Grisha on 10/10/2015.
//  Copyright © 2015 Grisha. All rights reserved.
//

import UIKit

class EventListViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UITableViewDelegate, UITableViewDataSource, TTTAttributedLabelDelegate {
    
    var Target:String!
    var User:KCSUser!
    var AdditionalInfo:String!
    var Events:[FetchedEvent] = []
    
    
    var end = false
    let screenWidth = UIScreen.mainScreen().bounds.width
    let screenHeight = UIScreen.mainScreen().bounds.height
    var collectionCellWidth = (UIScreen.mainScreen().bounds.width-2)/3
    var collectionCellHeight = (UIScreen.mainScreen().bounds.width-2)/2
    var flowLayout:ProfileGridViewLayout = ProfileGridViewLayout()
    var gridButton:UIButton = UIButton()
    var tableButton:UIButton = UIButton()
    var tableView: UITableView = UITableView()
    var collectionView: UICollectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: UICollectionViewFlowLayout())
    var footerView = TableFooterRefreshView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, 100))
    var tableHeaderView = UIView()
    
    var gridUnderline = UIView()
    var tableUnderline = UIView()
    var selectedView:Int = 0
    var cellHeights:[CGFloat] = []
    
    var loadingView = LoadingIndicatorView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, 100))
    
    func back(){
        self.navigationController!.popViewControllerAnimated(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setSubviews()
        loadData()
    }
    
    func setTableHeaderView(){
        sizeHeaderToFit(false)
        self.tableHeaderView.addSubview(gridButton)
        self.tableHeaderView.addSubview(tableButton)
        self.tableHeaderView.addSubview(gridUnderline)
        self.tableHeaderView.addSubview(tableUnderline)
        
        gridButton.translatesAutoresizingMaskIntoConstraints = false
        tableButton.translatesAutoresizingMaskIntoConstraints = false
        gridUnderline.translatesAutoresizingMaskIntoConstraints = false
        tableUnderline.translatesAutoresizingMaskIntoConstraints = false
        
        let views = [
            "gridButton" : gridButton,
            "tableButton" : tableButton,
            "gridUnderline" : gridUnderline,
            "tableUnderline" : tableUnderline,
        ]
        
        let H_Constraints0 = NSLayoutConstraint.constraintsWithVisualFormat("H:|[gridButton(==tableButton)][tableButton]|", options: [], metrics: nil, views: views)
        let H_Constraints1 = NSLayoutConstraint.constraintsWithVisualFormat("H:|[gridUnderline(==tableUnderline)][tableUnderline]|", options: [], metrics: nil, views: views)
        
        let V_Constraints0 = NSLayoutConstraint.constraintsWithVisualFormat("V:|-13@999-[gridButton]-13@999-[gridUnderline(2)]-0@999-|", options: [], metrics: nil, views: views)
        let V_Constraints1 = NSLayoutConstraint.constraintsWithVisualFormat("V:|-13@999-[tableButton]-13@999-[tableUnderline(2)]-0@999-|", options: [], metrics: nil, views: views)
        
        self.tableHeaderView.addConstraints(H_Constraints0)
        self.tableHeaderView.addConstraints(H_Constraints1)
        self.tableHeaderView.addConstraints(V_Constraints0)
        self.tableHeaderView.addConstraints(V_Constraints1)
        
        self.tableHeaderView.setNeedsLayout()
        self.tableHeaderView.layoutIfNeeded()
        sizeHeaderToFit(false)
        sizeHeaderToFit(false)
    }
    
    func setSubviews(){
        let backButton = UIBarButtonItem(image: UIImage(named: "back.png"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(back))
        backButton.tintColor = UIColor.whiteColor()
        if (self.navigationController!.viewControllers.count > 1){
            self.navigationItem.leftBarButtonItem = backButton
        }
        
        let titleLabel:UILabel = UILabel()
        switch Target{
        case "Search":
            titleLabel.text = AdditionalInfo
        case "Going":
            titleLabel.text = "\(self.User.username) is going to:"
            self.AdditionalInfo = self.User.userId
        default: break
        }
        titleLabel.numberOfLines = 1
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.textAlignment = NSTextAlignment.Center
        titleLabel.font = UIFont(name: "Lato-Semibold", size: 18)
        self.navigationItem.titleView = titleLabel
        titleLabel.sizeToFit()
        
        
        // Table View
        self.view.addSubview(tableView)
        let offset = self.navigationController!.navigationBar.frame.height + UIApplication.sharedApplication().statusBarFrame.height + self.tabBarController!.tabBar.frame.height
        tableView.allowsSelection = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerClass(ProfileEventTableViewCell.self, forCellReuseIdentifier: "Event Cell")
        tableView.registerClass(ProfileNoPictureTableViewCell.self, forCellReuseIdentifier: "EventNoPic Cell")
        tableView.frame = CGRectMake(0, 0, screenWidth, self.view.frame.height-offset)
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        tableView.rowHeight = UITableViewAutomaticDimension
        
        // Collection View
        self.view.addSubview(collectionView)
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
        
        collectionView.hidden = false
        tableView.hidden = true
        
        
        gridButton.tag = 1
        tableButton.tag = 2
        gridButton.enabled = false
        tableButton.enabled = false
        gridButton.addTarget(self, action: #selector(switchBtnPressed(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        tableButton.addTarget(self, action: #selector(switchBtnPressed(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        setTableHeaderView()
        switchToView(1)
        
        
        self.view.addSubview(loadingView)
        loadingView.center = CGPointMake(collectionView.frame.width/2, collectionView.frame.height/2)
        loadingView.startAnimating()
        
        
    }
    
    func switchBtnPressed(sender:UIButton){
        switchToView(sender.tag)
        updateFooter()
    }
    
    var query:KCSQuery!
    func loadData(){
        
        EventsManager.loadEventsForTarget(nil,
            Target: Target,Addit: AdditionalInfo,
            completionHandler: {
                (downloadedEventsArray:[FetchedEvent], error:NSError!) -> Void in
                self.loadingView.stopAnimating(error == nil)
                self.gridButton.enabled = true
                self.tableButton.enabled = true
                if (error == nil){
                    var temp = downloadedEventsArray
                    
                    if (temp.count < 19){
                        self.end = true
                    }else{
                        self.end = false
                        temp.removeLast()
                    }
                    self.Events = temp
                    for _ in temp {
                        self.cellHeights.append(0)
                    }
                    self.tableView.reloadData()
                    self.collectionView.reloadData()
                    self.setData()
                    self.updateFooter()
                    //load pictures
                    
                    for (index,_) in self.Events.enumerate(){
                        EventsManager().loadPictureForEvent(&self.Events[index], completionHandler: {
                            (error:NSError!) -> Void in
                            if (error == nil){
                                let cells = self.tableView.visibleCells
                                for cell in cells{
                                    if (cell.tag == index){
                                        (cell as! ProfileEventTableViewCell).UpdateEventPicture(self.Events[index], row: index)
                                    }
                                    
                                }
                                let ccells = self.collectionView.visibleCells()
                                for cell in ccells{
                                    if (cell.tag == index){
                                        (cell as! ExploreCollectionViewCell).UpdateEventPicture(self.Events[index], row: index)
                                    }
                                    
                                }
                                //println("\(index) event picture progress \(self.Events[index].pictureProgress) %")
                                
                            }else{
                                print("Error:" + error.description)
                            }
                        })
                        EventsManager().loadProfilePictureForEvent(&self.Events[index], completionHandler: {
                            (error:NSError!) -> Void in
                            if (error == nil){
                                let cells = self.tableView.visibleCells
                                for cell in cells{
                                    if (cell.isKindOfClass(ProfileEventTableViewCell)){
                                        if (cell.tag == index){
                                            (cell as! ProfileEventTableViewCell).UpdateProfilePicture(self.Events[index].profilePictureID as String,
                                                progress: self.Events[index].profilePictureProgress,
                                                image: self.Events[index].profilePicture, row: index)
                                        }
                                    }else{
                                        if (cell.tag == index){
                                            (cell as! ProfileNoPictureTableViewCell).UpdateProfilePicture(self.Events[index].profilePictureID as String,
                                                progress: self.Events[index].profilePictureProgress,
                                                image: self.Events[index].profilePicture, row: index)
                                        }
                                    }
                                }
                                //println("\(index) profile picture loaded \(self.Events[index].profilePictureProgress) %")
                            }else{
                                print("Error:" + error.description)
                            }
                        })
                    }
                    
                    
                }else{
                    print("Error:" + error.description)
                }
        })
    }
    
    func loadMoreData(){
        print("loadmore")
        if footerView.isAnimating {
            return
        }
        footerView.startAnimating()
        EventsManager.loadEventsForTarget(Events.last,
            Target: Target,Addit: AdditionalInfo,
            completionHandler: {
                (downloadedEventsArray:[FetchedEvent], error:NSError!) -> Void in
                self.footerView.stopAnimating((error == nil) ? true : false)
                if (error == nil){
                    var temp = downloadedEventsArray
                    
                    if (temp.count < 19){
                        self.end = true
                    }else{
                        self.end = false
                        temp.removeLast()

                    }
                    
                    self.Events += temp
                    for _ in temp {
                        self.cellHeights.append(0)
                    }
                    self.tableView.reloadData()
                    self.collectionView.reloadData()
                    self.updateFooter()
                    //load pictures
                    
                    for (index,_) in self.Events.enumerate(){
                        EventsManager().loadPictureForEvent(&self.Events[index], completionHandler: {
                            (error:NSError!) -> Void in
                            if (error == nil){
                                let cells = self.tableView.visibleCells
                                for cell in cells{
                                    if (cell.tag == index){
                                        (cell as! ProfileEventTableViewCell).UpdateEventPicture(self.Events[index], row: index)
                                    }
                                    
                                }
                                let ccells = self.collectionView.visibleCells()
                                for cell in ccells{
                                    if (cell.tag == index){
                                        (cell as! ExploreCollectionViewCell).UpdateEventPicture(self.Events[index], row: index)
                                    }
                                    
                                }
                                //println("\(index) event picture progress \(self.TimelineData[index].pictureProgress) %")
                                
                            }else{
                                print("Error:" + error.description)
                            }
                        })
                        EventsManager().loadProfilePictureForEvent(&self.Events[index], completionHandler: {
                            (error:NSError!) -> Void in
                            if (error == nil){
                                let cells = self.tableView.visibleCells
                                for cell in cells{
                                    if (cell.isKindOfClass(ProfileEventTableViewCell)){
                                        if (cell.tag == index){
                                            (cell as! ProfileEventTableViewCell).UpdateProfilePicture(self.Events[index].profilePictureID as String,
                                                progress: self.Events[index].profilePictureProgress,
                                                image: self.Events[index].profilePicture, row: index)
                                        }
                                    }else{
                                        if (cell.tag == index){
                                            (cell as! ProfileNoPictureTableViewCell).UpdateProfilePicture(self.Events[index].profilePictureID as String,
                                                progress: self.Events[index].profilePictureProgress,
                                                image: self.Events[index].profilePicture, row: index)
                                        }
                                    }
                                }
                                //println("\(index) profile picture loaded \(self.TimelineData[index].profilePictureProgress) %")
                            }else{
                                print("Error:" + error.description)
                            }
                        })
                    }
                    
                    
                }else{
                    print("Error:" + error.description)
                }
        })
        
    }
    
    func setData(){
        self.collectionView.reloadData()
        self.tableView.reloadData()
    }
    
    func switchToView(tag:Int){
        updateFooter()
        if (selectedView != tag){
            if (tag == 1){ // to grid
                selectedView = 1
                tableView.hidden = true
                collectionView.hidden = false
                collectionView.setContentOffset(CGPointZero, animated: false)
                sizeHeaderToFit(false)
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
                tableView.setContentOffset(CGPointZero, animated: false)
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
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Events.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // prepare content
        let authorNameText = self.Events[indexPath.row].author!.username
        let eventNameText = self.Events[indexPath.row].name as String
        let eventDateText = self.Events[indexPath.row].eventDateText
        let createdAtText = self.Events[indexPath.row].createdAtText as String
        
        // details
        let eventDetailsText = NSMutableAttributedString()
        if (self.Events[indexPath.row].details != ""){
            var attrs = [NSFontAttributeName : UIFont(name: "Lato-Medium", size: 14)!, NSForegroundColorAttributeName: ColorFromCode.randomBlueColorFromNumber(3)]
            var content = NSMutableAttributedString(string: "\(authorNameText)", attributes: attrs)
            eventDetailsText.appendAttributedString(content)
            attrs = [NSFontAttributeName : UIFont(name: "Lato-Regular", size: 14)!, NSForegroundColorAttributeName: UIColor.blackColor()]
            content = NSMutableAttributedString(string: " \(self.Events[indexPath.row].shortDescription)", attributes: attrs)
            eventDetailsText.appendAttributedString(content)
        }
        let eventTimeAndLocationText = NSMutableAttributedString()
        // time
        var attrs = [NSFontAttributeName : UIFont(name: "Lato-Regular", size: 16)!, NSForegroundColorAttributeName: ColorFromCode.randomBlueColorFromNumber(3)]
        var content = NSMutableAttributedString(string: "\(self.Events[indexPath.row].timeString) ", attributes:attrs)
        eventTimeAndLocationText.appendAttributedString(content)
        
        
        if (self.Events[indexPath.row].location != ""){
            attrs = [NSFontAttributeName : UIFont(name: "Lato-Regular", size: 16)!, NSForegroundColorAttributeName: UIColor.darkGrayColor()]
            content = NSMutableAttributedString(string: " at ", attributes: attrs)
            eventTimeAndLocationText.appendAttributedString(content)
            attrs = [NSFontAttributeName : UIFont(name: "Lato-Regular", size: 16)!, NSForegroundColorAttributeName: ColorFromCode.colorWithHexString("#C78B14")]
            content = NSMutableAttributedString(string: "\(self.Events[indexPath.row].location)", attributes: attrs)
            eventTimeAndLocationText.appendAttributedString(content)
            
        }
        
        
        if (self.Events[indexPath.row].pictureId != ""){ // Cell with Image
            
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
            if (self.Events[indexPath.row].details != ""){
                let url:NSURL = NSURL(scheme: "pushAuthor", host: "", path: "/")!
                Cell.EventDescription.addLinkToURL(url, withRange:NSRange(location: 0,length: (authorNameText as NSString).length))
                Cell.EventDescription.delegate = self
                Cell.EventDescription.tag = indexPath.row
            }
            let pushAuthorRec:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(pushAuthor(_:)))
            Cell.ProfileView.addGestureRecognizer(pushAuthorRec)
            Cell.ProfileView.tag = Cell.tag
            // clickable location
            if (self.Events[indexPath.row].location != ""){
                let url:NSURL = NSURL(scheme: "pushLocation", host: "", path: "/")!
                let range = NSRange(location: (eventTimeAndLocationText.length-self.Events[indexPath.row].location.length),length: self.Events[indexPath.row].location.length)
                Cell.timeLocationLabel.addLinkToURL(url, withRange: range)
                Cell.timeLocationLabel.delegate = self
                Cell.timeLocationLabel.tag = indexPath.row
            }
            Cell.timeLocationLabel.attributedText = eventTimeAndLocationText
            Cell.EventDescription.attributedText = eventDetailsText
            
            if (self.Events[indexPath.row].date.timeIntervalSinceNow < 0){
                Cell.EventDate.backgroundColor = UIColor.redColor()
            }else{
                Cell.EventDate.backgroundColor = ColorFromCode.standardBlueColor()
            }
            
            Cell.Set_Numbers(self.Events[indexPath.row].goManager.numberOfGoing,
                likes: self.Events[indexPath.row].likeManager.numberOfLikes,
                comments: self.Events[indexPath.row].numberOfComments,
                shares: self.Events[indexPath.row].shareManager.numberOfShares)
            
            // Set Buttons
            Cell.LikeButton.initialize(self.Events[indexPath.row].likeManager.isLiked)
            Cell.LikeButton.addTarget(self, action: #selector(like(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            Cell.GoButton.initialize(self.Events[indexPath.row].goManager.isGoing)
            Cell.GoButton.addTarget(self, action: #selector(go(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            Cell.ShareButton.initialize(self.Events[indexPath.row].shareManager.isShared)
            Cell.ShareButton.addTarget(self, action: #selector(share(_:)), forControlEvents: UIControlEvents.TouchUpInside)
//            Cell.MoreButton.initialize()
//            Cell.MoreButton.tag = indexPath.row
//            Cell.MoreButton.addTarget(self, action: "more:", forControlEvents: UIControlEvents.TouchUpInside)
            Cell.ProgressView.progressCircle.addTarget(self, action: #selector(refresh(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            
            
            // Update profile picture
            Cell.UpdateProfilePicture(self.Events[indexPath.row].profilePictureID as String,
                progress: self.Events[indexPath.row].profilePictureProgress,
                image: self.Events[indexPath.row].profilePicture, row: indexPath.row)
            
            EventsManager().loadProfilePictureForEvent(&self.Events[indexPath.row], completionHandler: {
                (error:NSError!) -> Void in
                let index = Cell.tag
                Cell.UpdateProfilePicture(self.Events[index].profilePictureID as String,
                    progress: self.Events[index].profilePictureProgress,
                    image: self.Events[index].profilePicture, row: index)
            })
            
            Cell.UpdateEventPicture(self.Events[indexPath.row], row: indexPath.row)
            
            Cell.contentView.userInteractionEnabled = true
            let pushEventRec1:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(PushEventViewController(_:)))
            let pushEventRec2:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(PushEventViewController(_:)))
            Cell.EventPicture.userInteractionEnabled = true
            Cell.EventPicture.tag = indexPath.row
            Cell.EventPicture.addGestureRecognizer(pushEventRec1)
            Cell.ProgressView.addGestureRecognizer(pushEventRec2)
            
            Cell.likesbtn.addTarget(self, action: #selector(pushLikes(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            Cell.goingbtn.addTarget(self, action: #selector(pushGoing(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            Cell.sharesbtn.addTarget(self, action: #selector(pushShares(_:)), forControlEvents: UIControlEvents.TouchUpInside)
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
            if (self.Events[indexPath.row].details != ""){
                let url:NSURL = NSURL(scheme: "pushAuthor", host: "", path: "/")!
                Cell.EventDescription.addLinkToURL(url, withRange:NSRange(location: 0,length: (authorNameText as NSString).length))
                Cell.EventDescription.delegate = self
                Cell.EventDescription.tag = indexPath.row
            }
            let pushAuthorRec:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(pushAuthor(_:)))
            Cell.ProfileView.addGestureRecognizer(pushAuthorRec)
            Cell.ProfileView.tag = Cell.tag
            // clickable location
            if (self.Events[indexPath.row].location != ""){
                let url:NSURL = NSURL(scheme: "pushLocation", host: "", path: "/")!
                let range = NSRange(location: (eventTimeAndLocationText.length-self.Events[indexPath.row].location.length),length: self.Events[indexPath.row].location.length)
                Cell.timeLocationLabel.addLinkToURL(url, withRange: range)
                Cell.timeLocationLabel.delegate = self
                Cell.timeLocationLabel.tag = indexPath.row
            }
            Cell.timeLocationLabel.attributedText = eventTimeAndLocationText
            Cell.EventDescription.attributedText = eventDetailsText
            
            
            if (self.Events[indexPath.row].date.timeIntervalSinceNow < 0){
                Cell.EventDate.backgroundColor = UIColor.redColor()
            }else{
                Cell.EventDate.backgroundColor = ColorFromCode.standardBlueColor()
            }
            
            // Update profile picture
            Cell.UpdateProfilePicture(self.Events[indexPath.row].profilePictureID as String,
                progress: self.Events[indexPath.row].profilePictureProgress,
                image: self.Events[indexPath.row].profilePicture, row: indexPath.row)
            EventsManager().loadProfilePictureForEvent(&self.Events[indexPath.row], completionHandler: {
                (error:NSError!) -> Void in
                let index = Cell.tag
                Cell.UpdateProfilePicture(self.Events[index].profilePictureID as String,
                    progress: self.Events[index].profilePictureProgress,
                    image: self.Events[index].profilePicture, row: index)
            })
            
            
            Cell.Set_Numbers(self.Events[indexPath.row].goManager.numberOfGoing,
                likes: self.Events[indexPath.row].likeManager.numberOfLikes,
                comments: self.Events[indexPath.row].numberOfComments,
                shares: self.Events[indexPath.row].shareManager.numberOfShares)
            
            Cell.LikeButton.initialize(self.Events[indexPath.row].likeManager.isLiked)
            Cell.LikeButton.addTarget(self, action: #selector(like(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            Cell.GoButton.initialize(self.Events[indexPath.row].goManager.isGoing)
            Cell.GoButton.addTarget(self, action: #selector(go(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            
            Cell.ShareButton.initialize(self.Events[indexPath.row].shareManager.isShared)
            Cell.ShareButton.addTarget(self, action: #selector(share(_:)), forControlEvents: UIControlEvents.TouchUpInside)
//            Cell.MoreButton.initialize()
//            Cell.MoreButton.addTarget(self, action: "more:", forControlEvents: UIControlEvents.TouchUpInside)
            Cell.MoreButton.tag = indexPath.row
            
            Cell.contentView.userInteractionEnabled = true
            let EventNameTapRecognizer:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(PushEventViewController(_:)))
            Cell.EventView.userInteractionEnabled = true
            Cell.EventView.tag = indexPath.row
            Cell.EventView.addGestureRecognizer(EventNameTapRecognizer)
            Cell.likesbtn.addTarget(self, action: #selector(pushLikes(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            Cell.goingbtn.addTarget(self, action: #selector(pushGoing(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            Cell.sharesbtn.addTarget(self, action: #selector(pushShares(_:)), forControlEvents: UIControlEvents.TouchUpInside)
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
            if (Events[row].author!.userId == KCSUser.activeUser().userId as NSString){ //clicked on myself
                
                let VC:MyProfileViewController = self.storyboard?.instantiateViewControllerWithIdentifier("MyProfileViewController") as! MyProfileViewController
                self.navigationController?.pushViewController(VC, animated: true)
                
            }else{ //clicked on someone else
                
                let VC:UserProfileViewController = self.storyboard?.instantiateViewControllerWithIdentifier("UserProfileViewController") as! UserProfileViewController
                VC.user = Events[row].author!
                self.navigationController?.pushViewController(VC, animated: true)
                
            }
            
        }else if (url.scheme == "mention"){
            pushUserByUsername(url.host!)
        }
    }
    
    func like(sender: HomeLikeButton){
        print("button pressed \(sender.superview!.superview!.tag)")
        self.Events[sender.superview!.superview!.tag].likeManager.button = sender
        self.Events[sender.superview!.superview!.tag].likeManager.Like()
    }
    
    func go(sender: HomeResponseButton){
        print("button pressed \(sender.superview!.superview!.tag)")
        self.Events[sender.superview!.superview!.tag].goManager.button = sender
        self.Events[sender.superview!.superview!.tag].goManager.Going()
        
    }
    
    func share(sender: HomeShareButton){
        print("button pressed \(sender.superview!.superview!.tag)")
        self.Events[sender.superview!.superview!.tag].shareManager.button = sender
        self.Events[sender.superview!.superview!.tag].shareManager.Share()
        
    }
    func more(sender: HomeMoreButton){
        //        print("more pressed \(sender.superview!.superview!.tag)")
        //        eventsManager.More((sender.superview!.superview!.tag), button: sender)
        let row = sender.tag
        print(row)
        self.Events[row].moreManager.showInView(self.view ,event:self.Events[row],row: row, handler: {
            (result:String,error:NSError!) -> Void in
            if result == "Deleting" {
                
            } else if result == "FailedToDelete" {
                
            } else if result == "Deleted" {
                self.Events.removeAtIndex(row)
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
        EventsManager().loadPictureForEvent(&self.Events[tag], completionHandler: {
            (error:NSError!) -> Void in
            let cells = self.tableView.visibleCells
            for cell in cells{
                if (cell.tag == tag){
                    (cell as! HomeEventTableViewCell).UpdateEventPicture(self.Events[tag], row: tag)
                }
            }
        })
    }
    
    func eventDeleted(atIndex: Int) {
        tableView.deleteSections(NSIndexSet(index: atIndex), withRowAnimation: UITableViewRowAnimation.Automatic)
    }
    func pushLikes(sender:UIButton){
        let selectedRow = sender.superview!.superview!.tag
        
        let VC:UserListViewController = self.storyboard?.instantiateViewControllerWithIdentifier("UserListViewController") as! UserListViewController
        VC.event = Events[selectedRow].eventOriginal!
        VC.Target = "Likers"
        
        self.navigationController?.pushViewController(VC, animated: true)
    }
    func pushGoing(sender:UIButton){
        let selectedRow = sender.superview!.superview!.tag
        
        let VC:UserListViewController = self.storyboard?.instantiateViewControllerWithIdentifier("UserListViewController") as! UserListViewController
        VC.event = Events[selectedRow].eventOriginal!
        VC.Target = "Accepted"
        
        self.navigationController?.pushViewController(VC, animated: true)
    }
    func pushShares(sender:UIButton){
        let selectedRow = sender.superview!.superview!.tag
        
        let VC:UserListViewController = self.storyboard?.instantiateViewControllerWithIdentifier("UserListViewController") as! UserListViewController
        VC.event = Events[selectedRow].eventOriginal!
        VC.Target = "Shares"
        
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    func PushComments(sender:UITapGestureRecognizer){
        let ViewSender:UILabel = sender.view! as! UILabel
        let SelectedIndexPath:NSIndexPath = NSIndexPath(forRow: ViewSender.tag, inSection: 0)
        
        let VC:UserListViewController = self.storyboard?.instantiateViewControllerWithIdentifier("UserListViewController") as! UserListViewController
        VC.event = Events[SelectedIndexPath.row].eventOriginal!
        VC.Target = "Likers"
        
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    
    func PushEventViewController(sender:UITapGestureRecognizer)->Void{
        
        let ViewSender = sender.view!
        let SelectedIndexPath:NSIndexPath = NSIndexPath(forRow: ViewSender.tag, inSection: 0)
        //let Cell:HomeEventTableViewCell = TimelineEventTable.cellForRowAtIndexPath(SelectedIndexPath) as HomeEventTableViewCell
        
        let VC:EventViewController = self.storyboard?.instantiateViewControllerWithIdentifier("EventViewController") as! EventViewController
        VC.event = Events[SelectedIndexPath.row]
        
        
        
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    func pushAuthor(sender:UITapGestureRecognizer){
        let senderTag = sender.view!.tag
        if (Events[senderTag].author!.userId == KCSUser.activeUser().userId as NSString){ //clicked on myself
            
            let VC:MyProfileViewController = self.storyboard?.instantiateViewControllerWithIdentifier("MyProfileViewController") as! MyProfileViewController
            self.navigationController?.pushViewController(VC, animated: true)
            
        }else{ //clicked on someone else
            
            let VC:UserProfileViewController = self.storyboard?.instantiateViewControllerWithIdentifier("UserProfileViewController") as! UserProfileViewController
            VC.user = Events[senderTag].author!
            self.navigationController?.pushViewController(VC, animated: true)
            
        }
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Events.count
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let Cell:ExploreCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("collection Cell", forIndexPath: indexPath) as! ExploreCollectionViewCell
        
        Cell.tag = indexPath.row
        Cell.UpdateEventPicture(self.Events[indexPath.item], row: indexPath.row)
        
        // Set Event Name
        
        Cell.eventNameLabel.text = self.Events[indexPath.item].name as String
        var frame = Cell.eventNameLabel.frame
        Cell.eventNameLabel.sizeToFit()
        frame.size.height = Cell.eventNameLabel.frame.size.height
        let maxHeight = (collectionCellHeight-collectionCellWidth-8)
        if frame.size.height > maxHeight {
            frame.size.height = maxHeight
        }
        Cell.eventNameLabel.frame = frame
        Cell.contentView.tag = indexPath.row
        Cell.contentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(PushEventViewController(_:))))
        
        // remove year word
        let shortenedString:NSAttributedString = self.Events[indexPath.row].smallEventDateText
        Cell.eventDateLabel.attributedText = shortenedString
        Cell.UpdateEventPicture(self.Events[indexPath.row], row: indexPath.row)
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
        if (indexPath.row == self.Events.count-4){
            if (!end){
                loadMoreData()
            }
        }
    }
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if (indexPath.row == self.Events.count-2){
            if (!end){
                loadMoreData()
            }
        }
    }
}
