//
//  ExploreViewController.swift
//  Eventer
//
//  Created by Grisha on 01/12/2014.
//  Copyright (c) 2014 Grisha. All rights reserved.
//
import UIKit

class ExploreViewController: UIViewController, UITableViewDataSource,UITableViewDelegate,UICollectionViewDelegateFlowLayout,UICollectionViewDataSource, UISearchDisplayDelegate, UISearchBarDelegate, UIScrollViewDelegate, UISearchControllerDelegate{
    var row:Int = Int()
    var screenWidth = UIScreen.mainScreen().bounds.width
    var screenHeight = UIScreen.mainScreen().bounds.height
    
    var scrollView:UIScrollView = UIScrollView()
    
    var eventsCollectionViewRefreshControl:UIRefreshControl = UIRefreshControl()
    var eventsCollectionView:UICollectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: UICollectionViewFlowLayout())
    var collectionCellWidth = (UIScreen.mainScreen().bounds.width-2)/3
    var collectionCellHeight = (UIScreen.mainScreen().bounds.width-2)/2
    var eventsCollectionViewData:[FetchedEvent] = []
    var collectionEnd:Bool = false
    var collectionFooterView = TableFooterRefreshView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, 100))
    var collectionLoadingView = LoadingIndicatorView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, 100))

    
    var usersTableViewData:[KCSUserWith3Events] = []
    var usersTableViewRefreshControl:UIRefreshControl = UIRefreshControl()
    var usersTableView:UITableView = UITableView()
    var usersIdsToLoad:[String] = []
    var usersLoaded:Bool = false
    var tableLoadingView = LoadingIndicatorView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, 100))

    
    
    var segmentView:UIView = UIView()
    var segmentChanging:Bool = false
    var segmentIndicator:UIView = UIView()
    var segmentLabel1:UIButton = UIButton()
    var segmentLabel2:UIButton = UIButton()
    var randomEventData:[FetchedEvent] = []
    var randomUsersData:[KCSUser] = []

    
    //!-------Search Events Data-------------------//
    var searchEventsResults:Int = -1 //events retrieved
    var searchEventsIndicatorView = LoadingIndicatorView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, 100))
    
    var searchUsersResults:[FetchedUser] = [] //users retrieved
    var searchUsersIndicatorView = LoadingIndicatorView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, 100))
    var searchUsersEnd = false // if no more users to load
    
    //--------Search Users Data-------------------//

    var searchBar:UISearchBar = UISearchBar()
    var searchDisplay:SearchDisplayView = SearchDisplayView()
    
    var isSearching:Bool!
    var Cancel_Query:Bool!
    
    var TestView:UITableView = UITableView()
    var searchWasActive = false

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didBecomeActive", name: UIApplicationDidBecomeActiveNotification, object: nil)
        if searchWasActive {
            self.setVisible(true,animated: false)
        } else {
            self.setVisible(false,animated: false)
        }
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        searchWasActive = searchDisplay.alpha == 1
        self.setVisible(false,animated: false)
        self.moveNavBar(1000, animated: false)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIApplicationDidBecomeActiveNotification, object: nil)
    }
    func didBecomeActive(){
        let time:NSTimeInterval = Utility.SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO("8.0") ? 0 : 0.1
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64)(time*Double(NSEC_PER_SEC))),dispatch_get_main_queue()) {
            () -> Void in
            self.moveNavBar(1000, animated: true)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Set_Subviews()
        setCollectionAndTableViews()
        loadCollectionView()
    }
    func back(){
        self.navigationController!.popViewControllerAnimated(true)
    }
    
    func Set_Subviews(){
        let backButton = UIBarButtonItem(image: UIImage(named: "back.png"), style: UIBarButtonItemStyle.Plain, target: self, action: "back")
        backButton.tintColor = UIColor.whiteColor()
        if (self.navigationController!.viewControllers.count > 1){
            self.navigationItem.leftBarButtonItem = backButton
        }
        
        self.view.addSubview(scrollView)
        self.view.addSubview(segmentView)
        
        self.scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.segmentView.translatesAutoresizingMaskIntoConstraints = false
        
        let subviews = [
            "segment": segmentView,
            "scrollView": scrollView,
        ]
        let H_Constraint0 = NSLayoutConstraint.constraintsWithVisualFormat("H:|[segment]|", options: [], metrics: nil, views: subviews)
        let H_Constraint1 = NSLayoutConstraint.constraintsWithVisualFormat("H:|[scrollView]|", options: [], metrics: nil, views: subviews)
        let V_Constraint0 = NSLayoutConstraint.constraintsWithVisualFormat("V:|[segment(44.5)][scrollView]|", options: [], metrics: nil, views: subviews)
        
        self.view.addConstraints(H_Constraint0)
        self.view.addConstraints(H_Constraint1)
        self.view.addConstraints(V_Constraint0)
        
        // to calculate new frames
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
        
        
        // Scroll View Autolayout

        let offset = self.navigationController!.navigationBar.frame.height + Utility.statusBarHeight() + self.tabBarController!.tabBar.frame.height
        
        eventsCollectionView.frame = CGRectMake(0, 0, screenWidth, self.scrollView.frame.height)
        eventsCollectionView.frame.size.height -= offset
        eventsCollectionViewRefreshControl.layer.zPosition = -1
        usersTableView.frame = CGRectMake(screenWidth, 0, screenWidth, self.scrollView.frame.height)
        usersTableView.frame.size.height -= offset
        
        let contr1 = UITableViewController() // just for refresh control
        self.addChildViewController(contr1)
        contr1.refreshControl = usersTableViewRefreshControl
        contr1.tableView = usersTableView
        contr1.tableView.separatorStyle = UITableViewCellSeparatorStyle.None

        eventsCollectionView.addSubview(eventsCollectionViewRefreshControl)
        self.scrollView.addSubview(eventsCollectionView)
        self.scrollView.addSubview(contr1.tableView)
        
        self.scrollView.showsHorizontalScrollIndicator = false
        self.scrollView.showsVerticalScrollIndicator = false
        self.scrollView.contentSize = CGSizeMake(screenWidth*2, 1)
        
        // Set Scroll View and subviews
        self.scrollView.scrollEnabled = true
        self.scrollView.pagingEnabled = true
        self.automaticallyAdjustsScrollViewInsets = false
        self.scrollView.delegate = self
        
        // Segment View Autolayout
        self.segmentLabel1.setTitle("EVENTS", forState: UIControlState.Normal)
        self.segmentLabel2.setTitle("USERS", forState: UIControlState.Normal)
        self.segmentLabel1.adjustsImageWhenDisabled = false
        self.segmentLabel2.adjustsImageWhenDisabled = false
        self.segmentLabel1.titleLabel?.font = UIFont(name: "Lato-Bold", size: 15)
        self.segmentLabel2.titleLabel?.font = UIFont(name: "Lato-Bold", size: 15)
        self.segmentLabel1.tag = 1
        self.segmentLabel2.tag = 2
        self.segmentLabel1.setTitleColor(ColorFromCode.tabForegroundColor(), forState: UIControlState.Normal)
        self.segmentLabel2.setTitleColor(ColorFromCode.tabForegroundColor(), forState: UIControlState.Normal)
        self.segmentLabel1.setTitleColor(ColorFromCode.colorWithHexString("#0087D9"), forState: UIControlState.Highlighted)
        self.segmentLabel2.setTitleColor(ColorFromCode.colorWithHexString("#0087D9"), forState: UIControlState.Highlighted)

        self.segmentLabel1.titleLabel?.textAlignment = NSTextAlignment.Center
        self.segmentLabel2.titleLabel?.textAlignment = NSTextAlignment.Center
        self.segmentLabel1.addTarget(self, action: "switchSegment:", forControlEvents: UIControlEvents.TouchUpInside)
        self.segmentLabel2.addTarget(self, action: "switchSegment:", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.segmentIndicator.backgroundColor = ColorFromCode.colorWithHexString("#0087D9")
        
        self.segmentView.addSubview(segmentLabel1)
        self.segmentView.addSubview(segmentLabel2)
        self.segmentView.addSubview(segmentIndicator)
        //self.segmentView.addSubview(greysep)
        let border:CGFloat = 41.5
        self.segmentLabel1.frame = CGRectMake(0,0,screenWidth/2,border)
        self.segmentLabel2.frame = CGRectMake(screenWidth/2,0,screenWidth/2,border)
        self.segmentIndicator.frame = CGRectMake(0,border,screenWidth/2,3)
        self.segmentView.layer.addSublayer(Utility.gradientLayer(segmentView.frame, height: 2, alpha: 0.3))
        self.selectSegment(1)
        
        
        // Search Display Controller
        searchDisplay = SearchDisplayView(frame: self.view.frame)
        self.view.addSubview(searchDisplay)
        


        
          // Set searchEventsTableView

        // Search Bar
        self.searchBar.delegate = self
        self.searchBar.enablesReturnKeyAutomatically = false
        self.navigationItem.titleView = searchBar
        
        self.setSearchBarActive(false)
        self.view.bringSubviewToFront(self.scrollView)
        self.navigationController?.navigationBar.barTintColor = ColorFromCode.colorWithHexString("#02A8F3")
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        self.navigationController?.navigationBar.barStyle = UIBarStyle.Black
        self.searchDisplay.alpha = 0
        self.segmentView.alpha = 1
        self.scrollView.alpha = 1
    }

    var flowLayout:ExploreCollectionCustomLayout = ExploreCollectionCustomLayout()
    func setCollectionAndTableViews(){
        // Set Collection View
        self.eventsCollectionView.collectionViewLayout = flowLayout
        self.eventsCollectionViewRefreshControl.addTarget(self, action: "loadCollectionView", forControlEvents: UIControlEvents.ValueChanged)
        self.eventsCollectionView.scrollsToTop = true
        self.eventsCollectionView.backgroundColor = UIColor.whiteColor()
        self.eventsCollectionView.alwaysBounceVertical = true
        self.eventsCollectionView.bounces = true
        self.eventsCollectionView.delegate = self
        self.eventsCollectionView.dataSource = self
        self.eventsCollectionView.tag = 0
        self.eventsCollectionView.registerClass(ExploreCollectionViewCell.self, forCellWithReuseIdentifier: "collection Cell")
        self.collectionFooterView.button.addTarget(self, action: "loadMoreCollectionView", forControlEvents: UIControlEvents.TouchUpInside)
        eventsCollectionView.registerClass(CollectionHeaderView.self, forSupplementaryViewOfKind: UICollectionElementKindSectionFooter, withReuseIdentifier: "footer")
        eventsCollectionView.addSubview(collectionLoadingView)
        collectionLoadingView.center = CGPointMake(eventsCollectionView.frame.width/2, eventsCollectionView.frame.height/2)
        collectionLoadingView.startAnimating()
        // Set Table View

        self.usersTableViewRefreshControl.addTarget(self, action: "loadUsersTableView", forControlEvents: UIControlEvents.ValueChanged)
        self.usersTableView.allowsSelection = false
        self.usersTableView.estimatedRowHeight = 100
        self.usersTableView.rowHeight = UITableViewAutomaticDimension
        self.usersTableView.delegate = self
        self.usersTableView.dataSource = self
        self.usersTableView.tag = 1
        self.usersTableView.registerClass(ExploreTableViewCell.self, forCellReuseIdentifier: "User Cell")
        self.usersTableView.bounces = true
        usersTableView.addSubview(tableLoadingView)
        tableLoadingView.center = CGPointMake(usersTableView.frame.width/2, usersTableView.frame.height/2)
        tableLoadingView.startAnimating()
        
        
        self.searchDisplay.hashtagsTableView.allowsSelection = false
        self.searchDisplay.hashtagsTableView.estimatedRowHeight = 100
        self.searchDisplay.hashtagsTableView.rowHeight = UITableViewAutomaticDimension
        self.searchDisplay.hashtagsTableView.delegate = self
        self.searchDisplay.hashtagsTableView.dataSource = self
        self.searchDisplay.hashtagsTableView.registerClass(SearchEventsTableViewCell.self, forCellReuseIdentifier: "Search Cell")
        self.searchDisplay.hashtagsTableView.bounces = true
        // Indicator for search events tableview
        self.searchDisplay.hashtagsTableView.addSubview(self.searchEventsIndicatorView)
        self.searchEventsIndicatorView.center = CGPointMake(searchEventsIndicatorView.frame.width/2, searchEventsIndicatorView.frame.height/2)
        self.searchEventsIndicatorView.button.addTarget(self, action: "searchEvents", forControlEvents: UIControlEvents.TouchUpInside)
        self.searchEventsIndicatorView.disableAfterFirstTime = false

        
        self.searchDisplay.usersTableView.allowsSelection = false
        self.searchDisplay.usersTableView.estimatedRowHeight = 100
        self.searchDisplay.usersTableView.rowHeight = UITableViewAutomaticDimension
        self.searchDisplay.usersTableView.delegate = self
        self.searchDisplay.usersTableView.dataSource = self
        self.searchDisplay.usersTableView.registerClass(SearchUsersTableViewCell.self, forCellReuseIdentifier: "Search Cell")
        self.searchDisplay.usersTableView.bounces = true
        // Indicator for search users tableview
        self.searchDisplay.usersTableView.addSubview(self.searchUsersIndicatorView)
        self.searchUsersIndicatorView.center = CGPointMake(searchUsersIndicatorView.frame.width/2, searchUsersIndicatorView.frame.height/2)
        self.searchUsersIndicatorView.button.addTarget(self, action: "searchUsers", forControlEvents: UIControlEvents.TouchUpInside)
        self.searchUsersIndicatorView.disableAfterFirstTime = false

    }
    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return UIStatusBarStyle.Default
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func filterContentsForSearch(searchString:String){
        //FindDataQuery.cancel()
//        print(searchDisplay.selectedSegment)

        if (searchDisplay.selectedSegment == 1){
//            print("Events Searching")
            searchEvents()
        }else if (searchDisplay.selectedSegment == 2){
            searchUsers()
//            print("Users Searching")
        }
    }
    func setVisible(visible:Bool, animated:Bool){
        var targetAlpha:CGFloat
        if (visible){
            targetAlpha = 1
        }else{
            targetAlpha = 0
        }
        
        UIView.animateWithDuration(animated ? 0.1 : 0,
            delay: 0,
            options: UIViewAnimationOptions.AllowUserInteraction,
            animations: {
                () -> Void in
                self.setSearchBarActive(visible)

                if (visible){
                    self.view.bringSubviewToFront(self.searchDisplay)
                    self.navigationController?.navigationBar.barTintColor = UIColor.whiteColor()
                    self.navigationController!.navigationBar.barStyle = UIBarStyle.Default
                    self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.blackColor(), NSBackgroundColorAttributeName : UIColor.blackColor()]
                }else{
                    self.view.bringSubviewToFront(self.scrollView)

                    self.navigationController?.navigationBar.barTintColor = ColorFromCode.colorWithHexString("#02A8F3")
                    self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
                    self.navigationController?.navigationBar.barStyle = UIBarStyle.Black

                }
                self.searchDisplay.alpha = targetAlpha
                self.segmentView.alpha = 1 - targetAlpha
                self.scrollView.alpha = 1 - targetAlpha
                
                
            },completion: nil)
        
        
    }
    
    func loadUsersTableView(){
        self.usersLoaded = true
        EventsManager().loadEventsForExploreTableView {
            (downloadedUsersArray:[KCSUserWith3Events]!, error:NSError!) -> Void in
            self.usersTableViewRefreshControl.endRefreshing()
            self.tableLoadingView.stopAnimating(error == nil)
            if (error == nil){
                self.usersTableViewData = downloadedUsersArray
                self.usersTableView.reloadData()
                self.usersTableView.setContentOffset(CGPointZero, animated: false)
                // load pictures
                
                for (index,user) in self.usersTableViewData.enumerate(){
                    for (idx,_) in user.events.enumerate(){
                        EventsManager().loadPictureForEvent(&self.usersTableViewData[index].events[idx], completionHandler: {
                            (error:NSError!) -> Void in
                            if (error == nil){
                                let cells = self.usersTableView.visibleCells
                                for cell in cells{
                                    if (cell.tag == index){
                                        (cell as! ExploreTableViewCell).UpdateEventPicture(self.usersTableViewData[index].events[idx], atIndex: idx, cellRow: index)
                                    }
                                }
                                print("\(index) event picture progress \(self.self.usersTableViewData[index].events[idx].pictureProgress) %")
                                
                            }else{
                                print("Error:" + error.description)
                            }
                        })
                    }
                    
                    EventsManager().loadProfilePictureForUser(&self.usersTableViewData[index], completionHandler: {
                        (error:NSError!) -> Void in
                        if (error == nil){
                            let cells = self.usersTableView.visibleCells
                            for cell in cells{
                                if (cell.tag == index){
                                    (cell as! ExploreTableViewCell).UpdateProfilePicture(self.usersTableViewData[index])
                                }
                            }
                        }else{
                            print("Error:" + error.description)

                        }
                    })
                }
                
                
                
            }else{
                print("Error: " + error.description)
                self.usersLoaded = false
            }

        }
    }


    func loadCollectionView(){
        EventsManager().loadEventsForExploreCollectionView(nil ,completionHandler: {
            (downloadedEventsArray:[FetchedEvent], error:NSError!) -> Void in
            self.eventsCollectionViewRefreshControl.endRefreshing()
            self.collectionLoadingView.stopAnimating(error == nil)
            if (error == nil){
                var temp = downloadedEventsArray
                
                if (temp.count < 19){
                    self.collectionEnd = true
                }else{
                    temp.removeLast()
                    self.collectionEnd = false
                }
                self.eventsCollectionViewData = temp
                self.eventsCollectionView.reloadData()
                self.eventsCollectionView.setContentOffset(CGPointZero, animated: false)
                self.updateFooter()
                
                //load pictures
                
                for (index,_) in self.eventsCollectionViewData.enumerate(){
                    EventsManager().loadPictureForEvent(&self.eventsCollectionViewData[index], completionHandler: {
                        (error:NSError!) -> Void in
                        if (error == nil){
                            let cells = self.eventsCollectionView.visibleCells()
                            for cell in cells{
                                if (cell.tag == index){
                                    (cell as! ExploreCollectionViewCell).UpdateEventPicture(self.eventsCollectionViewData[index], row: index)
                                }
                                
                            }
                            //println("\(index) event picture progress \(self.eventsCollectionViewData[index].pictureProgress) %")
                            
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
    func loadMoreCollectionView(){
        print("loadmore")
        if collectionFooterView.isAnimating {
            return
        }
        collectionFooterView.startAnimating()
        EventsManager().loadEventsForExploreCollectionView(self.eventsCollectionViewData.last ,completionHandler: {
            (downloadedEventsArray:[FetchedEvent], error:NSError!) -> Void in
            self.collectionFooterView.stopAnimating((error == nil) ? true : false)

            if (error == nil){
                var temp = downloadedEventsArray
                
                if (temp.count < 19){
                    self.collectionEnd = true
                }else{
                    temp.removeLast()
                    self.collectionEnd = false
                }
                self.eventsCollectionViewData += temp
                self.eventsCollectionView.reloadData()
                self.updateFooter()
                print(self.collectionEnd)
                //load pictures
                
                for (index,_) in self.eventsCollectionViewData.enumerate(){
                    EventsManager().loadPictureForEvent(&self.eventsCollectionViewData[index], completionHandler: {
                        (error:NSError!) -> Void in
                        if (error == nil){
                            let cells = self.eventsCollectionView.visibleCells()
                            for cell in cells{
                                if (cell.tag == index){
                                    (cell as! ExploreCollectionViewCell).UpdateEventPicture(self.eventsCollectionViewData[index], row: index)
                                }
                                
                            }
                            //println("\(index) event picture progress \(self.eventsCollectionViewData[index].pictureProgress) %")
                            
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

    func searchBarTextDidBeginEditing(searchBar: UISearchBar) {
        self.moveNavBar(1000, animated: false)
        self.setVisible(true,animated: true)
        searchBar.setShowsCancelButton(true, animated: true)
        self.eventsCollectionView.setContentOffset(self.eventsCollectionView.contentOffset, animated: false)
        self.usersTableView.setContentOffset(self.usersTableView.contentOffset, animated: false)
        self.scrollView.setContentOffset(self.scrollView.contentOffset, animated: false)
        // just preventing scrolling when switching  to search
    }
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {

 

    }
    
    func setSearchBarActive(active:Bool){
        if (active){
            let textFieldInsideSearchBar = self.searchBar.valueForKey("searchField") as? UITextField
            searchBar.setImage(nil, forSearchBarIcon: UISearchBarIcon.Search, state: UIControlState.Normal)
            textFieldInsideSearchBar?.textColor = UIColor.blackColor()
            textFieldInsideSearchBar?.backgroundColor = ColorFromCode.colorWithHexString("#EBECEE")
            textFieldInsideSearchBar!.attributedPlaceholder = NSAttributedString(string:"Search",attributes:[NSForegroundColorAttributeName: UIColor.darkGrayColor()])
            searchBar.tintColor = UIColor.blackColor()
        }else{
            let textFieldInsideSearchBar = self.searchBar.valueForKey("searchField") as? UITextField
            self.searchBar.setImage(UIImage(named: "search.png"), forSearchBarIcon: UISearchBarIcon.Search, state: UIControlState.Normal)
            textFieldInsideSearchBar?.textColor = UIColor.whiteColor()
            textFieldInsideSearchBar?.backgroundColor = ColorFromCode.colorWithHexString("#0087D9")
            textFieldInsideSearchBar!.attributedPlaceholder = NSAttributedString(string:"Search",attributes:[NSForegroundColorAttributeName: UIColor.whiteColor()])
            searchBar.tintColor = UIColor.blackColor()


        }
        
    }
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        self.setVisible(false,animated: true)
        searchBar.text = ""
        searchBar.setShowsCancelButton(false, animated: true)
        self.moveNavBar(1000, animated: false)
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        setSearchBarActive(true)
    }

    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if (searchText.characters.count == 0){
            searchEventsResults = -1
            self.searchDisplay.hashtagsTableView.reloadData()
        }else{
            filterContentsForSearch(searchText)
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (tableView == usersTableView){
            return usersTableViewData.count
        }else if (tableView == searchDisplay.hashtagsTableView){
            if searchEventsResults < 0 {
                return 0
            }
            return 1
        } else if (tableView == searchDisplay.usersTableView) {
            if self.needsToHideCells {
                return 0
            } else if searchUsersResults.count == 0 {
                return 1
            } else {
                return searchUsersResults.count
            }
        } else {
            return 0
        }
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if (tableView == usersTableView){
            let Cell:ExploreTableViewCell = tableView.dequeueReusableCellWithIdentifier("User Cell", forIndexPath: indexPath) as! ExploreTableViewCell
            Cell.tag = indexPath.row
            // Set Event Picture
            Cell.usernameLabel.text = usersTableViewData[indexPath.row].username
            Cell.UpdateProfilePicture(usersTableViewData[indexPath.row])
            Cell.UpdateEventPictures(usersTableViewData[indexPath.row].events, cellRow: indexPath.row)
            Cell.showEventNames(usersTableViewData[indexPath.row].events, cellRow: indexPath.row)
            Cell.followButton.initialize(self.usersTableViewData[indexPath.row].followManager.isFollowing, isLoaded: true)
            Cell.followButton.addTarget(self, action: "follow:", forControlEvents: UIControlEvents.TouchUpInside)
            Cell.followButton.tag = indexPath.row
            Cell.profileView.tag = indexPath.row
            Cell.profileView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "pushExploreTableViewUser:"))
            Cell.contentView.tag = indexPath.row
            for imageView in Cell.eventPictures{
                imageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "pushExploreTableViewEvent:"))
            }
            if (usersTableViewData[indexPath.row].userId == KCSUser.activeUser().userId){
                Cell.followButton.hidden = true
            }else{
                Cell.followButton.hidden = false
            }
            
            return Cell
        }else if (tableView == searchDisplay.hashtagsTableView){
            let Cell = tableView.dequeueReusableCellWithIdentifier("Search Cell", forIndexPath: indexPath) as! SearchEventsTableViewCell
            if self.searchEventsResults == 0 {
                Cell.resultsLabel.text = "No results found"
                Cell.viewResultsButton.hidden = true
            } else {
                Cell.viewResultsButton.hidden = false
                Cell.viewResultsButton.addTarget(self, action: "pushSearchEventResults", forControlEvents: UIControlEvents.TouchUpInside)
                Cell.resultsLabel.text = "\(self.searchBar.text!) : \(searchEventsResults) results"
            }

            return Cell
        } else if (tableView == searchDisplay.usersTableView) {
            if searchUsersResults.count == 0 {
                let Cell:UITableViewCell = UITableViewCell()
                Cell.textLabel!.numberOfLines = 0
                Cell.textLabel!.font = UIFont(name: "Lato-Semibold", size: 19)
                Cell.textLabel!.textColor = ColorFromCode.tabForegroundColor()
                Cell.textLabel!.textAlignment = NSTextAlignment.Center
                Cell.textLabel!.text = "No matching users found"

                return Cell
            } else {
                let username:String = searchUsersResults[indexPath.row].username
                let fullname:String = searchUsersResults[indexPath.row].fullname
                
                let Cell = tableView.dequeueReusableCellWithIdentifier("Search Cell", forIndexPath: indexPath) as! SearchUsersTableViewCell
                Cell.tag = indexPath.row
                
                
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.lineSpacing = 1
                
                var attrs = [NSFontAttributeName : Cell.usernameFont!, NSForegroundColorAttributeName: ColorFromCode.colorWithHexString("#9A9A9A")]
                let usernameString = NSMutableAttributedString(string: username, attributes:attrs)
                
                let finalString = NSMutableAttributedString()
                if (fullname != ""){
                    attrs = [NSFontAttributeName : Cell.fullnameFont!, NSForegroundColorAttributeName: ColorFromCode.orangeFollowColor()]
                    let fullnameString = NSMutableAttributedString(string: "\(fullname)\n", attributes:attrs)
                    finalString.appendAttributedString(fullnameString)
                }
                finalString.appendAttributedString(usernameString)
                finalString.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, finalString.length))
                
                
                
                Cell.UpdatePictures(self.searchUsersResults[Cell.tag], row: Cell.tag)
                Cell.label.attributedText = finalString
                
                let rec = UITapGestureRecognizer(target: self, action: "pushSearchUser:")
                Cell.userInteractionEnabled = true
                Cell.addGestureRecognizer(rec)
                
                return Cell
            }
        } else {
            let Cell:UITableViewCell = UITableViewCell()
            return Cell
        }
    }
    func pushSearchEventResults(){
        let VC = self.storyboard?.instantiateViewControllerWithIdentifier("EventListViewController") as! EventListViewController
        VC.Target = "Search"
        VC.AdditionalInfo = self.searchBar.text!
        self.navigationController?.pushViewController(VC, animated: true)
    }
    func pushSearchUser(sender: UITapGestureRecognizer){
        let tag = sender.view!.tag
        if (searchUsersResults[tag].userId == KCSUser.activeUser().userId){ //clicked on myself
            let VC:MyProfileViewController = self.storyboard?.instantiateViewControllerWithIdentifier("MyProfileViewController") as! MyProfileViewController
            self.navigationController?.pushViewController(VC, animated: true)
        }else{ //clicked on someone else
            let VC:UserProfileViewController = self.storyboard?.instantiateViewControllerWithIdentifier("UserProfileViewController") as! UserProfileViewController
            VC.user = searchUsersResults[tag].user!
            self.navigationController?.pushViewController(VC, animated: true)
        }
    }
    func pushExploreTableViewUser(sender: UITapGestureRecognizer){
        let tag = sender.view!.tag
        if (usersTableViewData[tag].userId == KCSUser.activeUser().userId){ //clicked on myself
            let VC:MyProfileViewController = self.storyboard?.instantiateViewControllerWithIdentifier("MyProfileViewController") as! MyProfileViewController
            self.navigationController?.pushViewController(VC, animated: true)
        }else{ //clicked on someone else
            let VC:UserProfileViewController = self.storyboard?.instantiateViewControllerWithIdentifier("UserProfileViewController") as! UserProfileViewController
            VC.user = usersTableViewData[tag].user!
            self.navigationController?.pushViewController(VC, animated: true)
        }
    }
    // Event Name Pushed//
    func pushExploreTableViewEvent(sender:UITapGestureRecognizer){
        let eventTag = sender.view!.tag
        let userTag = sender.view!.superview!.tag
        let VC:EventViewController = self.storyboard?.instantiateViewControllerWithIdentifier("EventViewController") as! EventViewController
        VC.event = self.usersTableViewData[userTag].events[eventTag]
        self.navigationController?.pushViewController(VC, animated: true)
    }
    func pushExploreCollectionViewEvent(sender:UITapGestureRecognizer){
        let eventTag = sender.view!.tag
        let VC:EventViewController = self.storyboard?.instantiateViewControllerWithIdentifier("EventViewController") as! EventViewController
        VC.event = self.eventsCollectionViewData[eventTag]
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    
    func follow(sender: ExploreFollowButton){
//        print("follow pressed \(sender.tag)")
        self.usersTableViewData[sender.tag].followManager.button = sender
        self.usersTableViewData[sender.tag].followManager.Follow()
    }
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
//    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
//        return CGSizeMake(collectionCellWidth, collectionCellHeight)
//    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 1
    }
    
    
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let Cell:ExploreCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("collection Cell", forIndexPath: indexPath) as! ExploreCollectionViewCell
        
        Cell.tag = indexPath.row
        Cell.UpdateEventPicture(self.eventsCollectionViewData[indexPath.item], row: indexPath.row)
        
        // Set Event Name
        
        Cell.eventNameLabel.text = self.eventsCollectionViewData[indexPath.item].name as String
        var frame = Cell.eventNameLabel.frame
        Cell.eventNameLabel.sizeToFit()
        frame.size.height = Cell.eventNameLabel.frame.size.height
        Cell.eventNameLabel.frame = frame
        Cell.contentView.tag = indexPath.row
        Cell.contentView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "pushExploreCollectionViewEvent:"))
        
        // remove year word
        let shortenedString:NSAttributedString = self.eventsCollectionViewData[indexPath.row].eventDateText
        Cell.eventDateLabel.attributedText = shortenedString
        Cell.UpdateEventPicture(self.eventsCollectionViewData[indexPath.row], row: indexPath.row)
        

        return Cell
    }
    
    var collectionFooter = CollectionHeaderView()
    
    func collectionView(collectionView: UICollectionView, willDisplayCell cell: UICollectionViewCell, forItemAtIndexPath indexPath: NSIndexPath) {
        if (indexPath.row == self.eventsCollectionViewData.count-4){
            if (!collectionEnd){
                loadMoreCollectionView()
            }
        }
    }

    
    func collectionView(collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionReusableView {
        let footer = collectionView.dequeueReusableSupplementaryViewOfKind(UICollectionElementKindSectionFooter, withReuseIdentifier: "footer", forIndexPath: indexPath) as! CollectionHeaderView
        collectionFooter = footer
        updateFooter()
        return footer
    }

    func updateFooter(){
        if self.collectionEnd {
            collectionFooter.frame = CGRectZero
            collectionFooterView.removeFromSuperview()
            flowLayout.footerReferenceSize = CGSizeZero
            //print("remove")
        } else {
            //collectionFooter.frame.origin = CGPointMake(0, eventsCollectionView.contentSize.height)
            collectionFooter.frame.size = collectionFooterView.frame.size
            collectionFooter.addSubview(collectionFooterView)
            flowLayout.footerReferenceSize = self.collectionFooterView.frame.size
            //print("display")
        }
        
        collectionFooter.setNeedsDisplay()
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
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (collectionView == self.eventsCollectionView){

            return eventsCollectionViewData.count
        }else{
            return 0
        }
    }
    //-------------------------------------------------//

    
    //------------User--Name-Tapped-----------------------//
    func PushUserProfileViewController(sender:UITapGestureRecognizer){
//        var SelectedIndexPath:NSIndexPath
        if (searchDisplay.selectedSegment == 1){
        
        }else if (searchDisplay.selectedSegment == 2){

        }
    }
    //----------------------------------------------------//
    var currentEventRequests:[KCSRequest] = []
    func searchEvents(){
        let searchString = self.searchBar.text!
//        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            for request in self.currentEventRequests {
                request.cancel()
            }
//        }

        searchEventsIndicatorView.startAnimating()
        searchEventsResults = -1
        self.searchDisplay.hashtagsTableView.reloadData()
        currentEventRequests = [KCSRequest()]
        ActivityManager.countEventsThatContainString(searchString,request: &currentEventRequests[0]) {
            (number:UInt!, error:NSError!) -> Void in
            self.searchEventsIndicatorView.stopAnimating(error == nil)
            if error == nil {
                if self.searchBar.text! == searchString {
                    self.searchEventsResults = Int(number)
                    self.searchDisplay.hashtagsTableView.reloadData()
                }
            } else {
                print(error.description)
            }
        }

    }
    var currentUserRequests:[KCSRequest] = []
    var needsToHideCells = true
    func searchUsers(){
        let searchString = self.searchBar.text!
        dispatch_async(dispatch_get_main_queue()) { () -> Void in
            for request in self.currentEventRequests {
                request.cancel()
            }
        }
    
        searchUsersIndicatorView.startAnimating()
        self.needsToHideCells = true
        self.searchDisplay.usersTableView.reloadData()
        self.needsToHideCells = false
        currentUserRequests = [KCSRequest()]
        let limit = 15
        ActivityManager.searchUsersByRegexAndUsername(nil ,limit: limit, containsString: searchString, request: &currentUserRequests[0], handler: {
            (users:[FetchedUser]!, error:NSError!) -> Void in
            self.searchUsersIndicatorView.stopAnimating(error == nil)
            if self.searchBar.text! != searchString {
                return
            }
            var temp = users
            if (temp.count < limit + 1){
                self.searchUsersEnd = true
            }else{
                temp.removeLast()
                self.searchUsersEnd = false
            }
            print(temp.count)
            self.searchUsersResults = temp
            self.searchDisplay.usersTableView.reloadData()
            self.updateFooter()
            
            for (index,_) in self.searchUsersResults.enumerate() {
                
                // Download Picture
                self.currentUserRequests.append(ActivityManager.loadPictureForUser(&self.searchUsersResults[index], completionHandler: {
                    (error:NSError!) -> Void in
                    if self.searchBar.text! != searchString {
                        return
                    }
                    if error == nil {
                        let cells = self.searchDisplay.usersTableView.visibleCells
                        for cell in cells{
                            if (cell.tag == index){
                                dispatch_async(dispatch_get_main_queue(), {
                                    () -> Void in
                                    (cell as! SearchUsersTableViewCell).UpdatePictures(self.searchUsersResults[index], row: index)
                                })
                            }
                        }
                    } else {
                        print(error.description)
                    }
                }))
            }
        })
    }
    func loadMoreUsers(){
        
    }
    

    var scrollValue:CGFloat = 0 // previous offset
    var scrollCount:CGFloat = 0
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if (scrollView == self.scrollView){
            self.segmentIndicator.frame.origin.x = scrollView.contentOffset.x/2
            if (scrollView.contentOffset.x < screenWidth/2){ // page 1
                selectSegment(1)
            }else{ // page 2
                selectSegment(2)
            }
        }else{
            let h:CGFloat = scrollView.contentSize.height
            
            if (scrollView.contentOffset.y > 0 && ((h-scrollView.contentOffset.y) > scrollView.bounds.height)){
                let thresholdDistance:CGFloat = 50 // before that header always high
                if (scrollView.contentOffset.y < thresholdDistance){
                    moveNavBar(1000, animated: true)
                }else{
                    let bigDistance:CGFloat = 500
                    scrollCount += (scrollView.contentOffset.y - scrollValue) // difference
                    if (scrollCount > bigDistance){ // hide
                        moveNavBar((scrollValue - scrollView.contentOffset.y), animated: false)
                    }else if (scrollCount < -bigDistance){ // expand
                        moveNavBar((scrollValue - scrollView.contentOffset.y), animated: false)
                    }
                }
                scrollValue = scrollView.contentOffset.y
            }
        }
    }
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        self.navigationController!.navigationBar.userInteractionEnabled = false
    }
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.navigationController!.navigationBar.userInteractionEnabled = true
    }
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        scrollCount = 0
        checkNavBar()
    }
    func moveNavBar(delta:CGFloat, animated:Bool){
        
        let currentBarOrigin = self.navigationController!.navigationBar.frame.origin.y
        var targetOrigin = currentBarOrigin + delta
        if (targetOrigin > 20){ // 20 for status bar
            targetOrigin = 20
        }
        if (targetOrigin < (20 - self.navigationController!.navigationBar.frame.height)){
            targetOrigin = (20 - self.navigationController!.navigationBar.frame.height)
        }
        
        //println("target origin \(targetOrigin)")
        
        UIView.animateWithDuration(animated ? 0.2 : 0, delay: 0, options: UIViewAnimationOptions.AllowUserInteraction, animations: {
            () -> Void in
            // all animations here
            self.navigationController!.navigationBar.frame.origin.y = targetOrigin
            self.view.frame.origin.y = targetOrigin + self.navigationController!.navigationBar.frame.height
            self.view.frame.size.height = self.screenHeight - targetOrigin - self.navigationController!.navigationBar.frame.height
            self.scrollView.frame.size.height = self.screenHeight - targetOrigin - self.navigationController!.navigationBar.frame.height - self.tabBarController!.tabBar.frame.height - self.segmentView.frame.height
            self.usersTableView.frame.size.height = self.screenHeight - targetOrigin - self.navigationController!.navigationBar.frame.height - self.tabBarController!.tabBar.frame.height - self.segmentView.frame.height
            self.eventsCollectionView.frame.size.height = self.screenHeight - targetOrigin - self.navigationController!.navigationBar.frame.height - self.tabBarController!.tabBar.frame.height - self.segmentView.frame.height
            self.updateBarButtonItems(
                (targetOrigin - 20 + self.navigationController!.navigationBar.frame.height)/(-20 + self.navigationController!.navigationBar.frame.height))
            self.searchDisplay.frame.origin.y = 0
            self.searchDisplay.frame.size.height = self.screenHeight - targetOrigin - self.navigationController!.navigationBar.frame.height

            }, completion: nil)
        
    }
    
    func checkNavBar(){
        let currentBarOrigin = self.navigationController!.navigationBar.frame.origin.y
        if ((currentBarOrigin != 20) && (currentBarOrigin != 20-self.navigationController!.navigationBar.frame.height)){
            let margin = self.navigationController!.navigationBar.frame.height/2 - 20 // status bar
            if (currentBarOrigin < margin){
                moveNavBar(-self.navigationController!.navigationBar.frame.height, animated: true)
            }else{
                moveNavBar(self.navigationController!.navigationBar.frame.height, animated: true)
            }
        }
    }
    func updateBarButtonItems(alpha: CGFloat) {
        for view in self.navigationController!.navigationBar.subviews as [AnyObject] {
            let className:String = Utility.classNameAsString(view)
            if ((className != "_UINavigationBarBackground") && (className != "_UINavigationBarBackIndicatorView")){
                (view as! UIView).alpha = alpha
            }
        }
    }

    func selectSegment(index:Int){
        self.moveNavBar(1000, animated: true)
        if (index == 1){
            
            self.segmentLabel1.highlighted = true
            self.segmentLabel2.highlighted = false
            
            self.segmentLabel1.enabled = false
            self.segmentLabel2.enabled = true

        }else if (index == 2){
            if !usersLoaded {
                self.usersTableViewRefreshControl.beginRefreshing()
                self.loadUsersTableView()
            }
            
            self.segmentLabel1.highlighted = false
            self.segmentLabel2.highlighted = true
            
            self.segmentLabel1.enabled = true
            self.segmentLabel2.enabled = false
            
        }
    }
    func switchSegment(sender:UIButton){
        if (sender.tag == 1){ //Segment Changing boolean is just to remove flickering when we press segment
            segmentChanging = true
            self.segmentLabel1.enabled = false
            scrollView.setContentOffset(CGPointMake(0,scrollView.contentOffset.y), animated: true)
            self.segmentLabel1.enabled = true
            segmentChanging = false
        }else if (sender.tag == 2){
            segmentChanging = true
            self.segmentLabel2.enabled = false
            scrollView.setContentOffset(CGPointMake(screenWidth, scrollView.contentOffset.y), animated: true)
            self.segmentLabel2.enabled = true
            segmentChanging = false
        }
    }
}

