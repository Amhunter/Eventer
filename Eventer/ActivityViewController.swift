//
//  NotificationsViewController.swift
//  Eventer
//
//  Created by Grisha on 15/02/2015.
//  Copyright (c) 2015 Grisha. All rights reserved.
//

import UIKit
extension UILabel {
    
    func autoresize() {
        if let textNSString: NSString = self.text {
            let rect = textNSString.boundingRectWithSize(CGSizeMake(self.frame.size.width, CGFloat.max),
                options: NSStringDrawingOptions.UsesLineFragmentOrigin,
                attributes: [NSFontAttributeName: self.font],
                context: nil)
            self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, rect.height)
        }
    }
    
}
class ActivityViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,TTTAttributedLabelDelegate,UIScrollViewDelegate {
    
    var screenWidth = UIScreen.mainScreen().bounds.width
    var screenHeight = UIScreen.mainScreen().bounds.height
    
    
    var scrollView:UIScrollView = UIScrollView(frame: CGRectMake(0,104,UIScreen.mainScreen().bounds.width,UIScreen.mainScreen().bounds.height-40))
    var segmentView:UIView = UIView()
    var segmentChanging:Bool = false
    var segmentIndicator:UIView = UIView()
    var segmentLabel1:UIButton = UIButton()
    var segmentLabel2:UIButton = UIButton()
    var segmentLabel3:UIButton = UIButton()
    var selectedSegment:Int = 1

    
    
    //!-------'Me'  Segment------------------------------//
    var meTableView:UITableView = UITableView(frame: CGRectMake(0, 0, 320, UIScreen.mainScreen().bounds.height-40))
    var meData:[FetchedActivityUnit] = []
    var meLoadingView = LoadingIndicatorView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, 100))
    var meRefreshControl:UIRefreshControl = UIRefreshControl()

    //--------'Me'  Segment------------------------------//

    //!-------'YOU' Segment------------------------------//
    var youTableView:UITableView = UITableView(frame: CGRectMake(UIScreen.mainScreen().bounds.width, 0, 320, UIScreen.mainScreen().bounds.height-40))
    var youData:[FetchedActivityUnit] = []
    var youLoadingView = LoadingIndicatorView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, 100))
    var youRefreshControl:UIRefreshControl = UIRefreshControl()
    //--------'YOU' Segment------------------------------//
    
    
    //!-------Following Segment------------------------------//
    var followingTableView:UITableView = UITableView(frame: CGRectMake(UIScreen.mainScreen().bounds.width, 0, 320, UIScreen.mainScreen().bounds.height-40))
    var followingData:[FetchedActivityUnit] = []
    var followingLoadingView = LoadingIndicatorView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, 100))
    var followingRefreshControl:UIRefreshControl = UIRefreshControl()
    
    //--------Following Segment------------------------------//

    
    override func viewDidLoad() {
        super.viewDidLoad()
        Set_Subviews()
        
        
        self.youLoadingView.startAnimating()
        Get_You_Data()
        
    }
    
    func back(){
        self.navigationController!.popViewControllerAnimated(true)
    }
    
    func Set_Subviews(){
        let backButton = UIBarButtonItem(image: UIImage(named: "back.png"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(back))
        backButton.tintColor = UIColor.whiteColor()
        if (self.navigationController!.viewControllers.count > 1){
            self.navigationItem.leftBarButtonItem = backButton
        }
        let titleLabel:UILabel = UILabel()
        titleLabel.numberOfLines = 1
        titleLabel.text = "ACTIVITY"
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.textAlignment = NSTextAlignment.Center
        titleLabel.font = UIFont(name: "Lato-Semibold", size: 18)
        self.navigationItem.titleView = titleLabel
        titleLabel.sizeToFit()

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
        
        
        //!--------Set the scrollView------------------//
        // Scroll View Autolayout
        self.scrollView.addSubview(meTableView)
        self.scrollView.addSubview(youTableView)
        self.scrollView.addSubview(followingTableView)

        let offset = self.navigationController!.navigationBar.frame.height + Utility.statusBarHeight() + self.tabBarController!.tabBar.frame.height
        
        meTableView.frame = CGRectMake(0, 0, screenWidth, self.scrollView.frame.height)
        meTableView.frame.size.height -= offset
        
        youTableView.frame = CGRectMake(screenWidth, 0, screenWidth, self.scrollView.frame.height)
        youTableView.frame.size.height -= offset
        
        followingTableView.frame = CGRectMake(screenWidth*2, 0, screenWidth, self.scrollView.frame.height)
        followingTableView.frame.size.height -= offset
        
        self.scrollView.contentSize = CGSizeMake(screenWidth*3, 1)
        self.scrollView.showsHorizontalScrollIndicator = false
        self.scrollView.showsVerticalScrollIndicator = false
        self.scrollView.scrollEnabled = true
        self.scrollView.pagingEnabled = true
        self.automaticallyAdjustsScrollViewInsets = false
        self.scrollView.delegate = self
        //---------Set the scrollView------------------//

        // Segment View Autolayout
        self.segmentLabel1.setTitle("ACCEPTED", forState: UIControlState.Normal)
        self.segmentLabel2.setTitle("YOU", forState: UIControlState.Normal)
        self.segmentLabel3.setTitle("FRIENDS", forState: UIControlState.Normal)
        self.segmentLabel1.adjustsImageWhenDisabled = false
        self.segmentLabel2.adjustsImageWhenDisabled = false
        self.segmentLabel3.adjustsImageWhenDisabled = false
        self.segmentLabel1.titleLabel?.font = UIFont(name: "Lato-Bold", size: 15)
        self.segmentLabel2.titleLabel?.font = UIFont(name: "Lato-Bold", size: 15)
        self.segmentLabel3.titleLabel?.font = UIFont(name: "Lato-Bold", size: 15)
        self.segmentLabel1.tag = 1
        self.segmentLabel2.tag = 2
        self.segmentLabel3.tag = 3
        self.segmentLabel1.setTitleColor(ColorFromCode.tabForegroundColor(), forState: UIControlState.Normal)
        self.segmentLabel2.setTitleColor(ColorFromCode.tabForegroundColor(), forState: UIControlState.Normal)
        self.segmentLabel3.setTitleColor(ColorFromCode.tabForegroundColor(), forState: UIControlState.Normal)

        self.segmentLabel1.setTitleColor(ColorFromCode.colorWithHexString("#0087D9"), forState: UIControlState.Highlighted)
        self.segmentLabel2.setTitleColor(ColorFromCode.colorWithHexString("#0087D9"), forState: UIControlState.Highlighted)
        self.segmentLabel3.setTitleColor(ColorFromCode.colorWithHexString("#0087D9"), forState: UIControlState.Highlighted)

        
        self.segmentLabel1.titleLabel?.textAlignment = NSTextAlignment.Center
        self.segmentLabel2.titleLabel?.textAlignment = NSTextAlignment.Center
        self.segmentLabel3.titleLabel?.textAlignment = NSTextAlignment.Center

        self.segmentLabel1.addTarget(self, action: #selector(switchSegment(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.segmentLabel2.addTarget(self, action: #selector(switchSegment(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.segmentLabel3.addTarget(self, action: #selector(switchSegment(_:)), forControlEvents: UIControlEvents.TouchUpInside)

        
        self.segmentIndicator.backgroundColor = ColorFromCode.colorWithHexString("#0087D9")
        
        self.segmentView.addSubview(segmentLabel1)
        self.segmentView.addSubview(segmentLabel2)
        self.segmentView.addSubview(segmentLabel3)
        self.segmentView.addSubview(segmentIndicator)
        //self.segmentView.addSubview(greysep)
        let border:CGFloat = 42.5
        self.segmentLabel1.frame = CGRectMake(0,0,screenWidth/3,border)
        self.segmentLabel2.frame = CGRectMake(screenWidth/3,0,screenWidth/3,border)
        self.segmentLabel3.frame = CGRectMake(2*screenWidth/3,0,screenWidth/3,border)
        self.segmentIndicator.frame = CGRectMake(screenWidth/3,border,screenWidth/3,2)
        self.segmentView.layer.addSublayer(Utility.gradientLayer(segmentView.frame, height: 2, alpha: 0.3))
        self.scrollView.setContentOffset(CGPointMake(screenWidth, self.scrollView.contentOffset.y), animated: false)
        self.selectSegment(2)
        
        //!--------Set meTableView-------------------------//
        meTableView.delegate = self
        meTableView.dataSource = self
        meTableView.allowsSelection = false
        meTableView.bounces = true
        meTableView.estimatedRowHeight = 100
        meTableView.rowHeight = UITableViewAutomaticDimension
        meTableView.registerClass(MyResponseNFTableViewCell.self, forCellReuseIdentifier: "MyResponse Cell")
        meTableView.separatorStyle = UITableViewCellSeparatorStyle.None
        meTableView.tableFooterView = UIView()
        let t1 = UITableViewController()
        self.addChildViewController(t1)
        t1.refreshControl = meRefreshControl
        t1.refreshControl!.layer.zPosition = -1
        t1.refreshControl!.addTarget(self, action: #selector(Get_Me_Data), forControlEvents: UIControlEvents.ValueChanged)
        t1.tableView = meTableView
        self.scrollView.addSubview(t1.tableView)
        
        meTableView.addSubview(meLoadingView)
        meLoadingView.center = CGPointMake(meTableView.frame.width/2, meTableView.frame.height/2)
        //---------Set meTableView-------------------------//

        //!--------Set youTableView------------------------//
        youTableView.delegate = self
        youTableView.dataSource = self
        youTableView.allowsSelection = false
        youTableView.bounces = true
        youTableView.estimatedRowHeight = 100
        youTableView.rowHeight = UITableViewAutomaticDimension
        youTableView.registerClass(CommentNFTableViewCell.self, forCellReuseIdentifier: "Comment Cell")
        youTableView.registerClass(LikeNFTableViewCell.self, forCellReuseIdentifier: "Like Cell")
        youTableView.registerClass(ResponseNFTableViewCell.self, forCellReuseIdentifier: "Response Cell")
        youTableView.registerClass(FollowNFTableViewCell.self, forCellReuseIdentifier: "Follow Cell")
        youTableView.separatorStyle = UITableViewCellSeparatorStyle.None
        youTableView.tableFooterView = UIView()
        let t2 = UITableViewController()
        self.addChildViewController(t2)
        t2.refreshControl = youRefreshControl
        t2.refreshControl!.layer.zPosition = -1
        t2.refreshControl!.addTarget(self, action: #selector(Get_You_Data), forControlEvents: UIControlEvents.ValueChanged)
        t2.tableView = youTableView
        self.scrollView.addSubview(t2.tableView)
        
        youTableView.addSubview(youLoadingView)
        youLoadingView.center = CGPointMake(youTableView.frame.width/2, youTableView.frame.height/2)
        youLoadingView.startAnimating()

        //!--------Set youTableView------------------------//
        
        
        //!--------Set followingTableView------------------------//
        followingTableView.delegate = self
        followingTableView.dataSource = self
        followingTableView.allowsSelection = false
        followingTableView.bounces = true
        followingTableView.estimatedRowHeight = 100
        followingTableView.rowHeight = UITableViewAutomaticDimension
        followingTableView.registerClass(LikeNFTableViewCell.self, forCellReuseIdentifier: "Like Cell")
        followingTableView.registerClass(fromUserToUserFollowNFCell.self, forCellReuseIdentifier: "Follow Cell")
        followingTableView.separatorInset = UIEdgeInsets(top: 0, left: 50, bottom: 0, right: 5) // move separator line
        followingTableView.separatorStyle = UITableViewCellSeparatorStyle.None
        followingTableView.tableFooterView = UIView()
        let t3 = UITableViewController()
        self.addChildViewController(t3)
        t3.refreshControl = followingRefreshControl
        t3.refreshControl!.layer.zPosition = -1
        t3.refreshControl!.addTarget(self, action: #selector(Get_Following_Data), forControlEvents: UIControlEvents.ValueChanged)
        t3.tableView = followingTableView
        self.scrollView.addSubview(t3.tableView)
        
        followingTableView.addSubview(followingLoadingView)
        followingLoadingView.center = CGPointMake(followingTableView.frame.width/2, followingTableView.frame.height/2)
        // Do any additional setup after loading the view.
    }
    func Make_Autolayout(){
        
        youTableView.translatesAutoresizingMaskIntoConstraints = false
        meTableView.translatesAutoresizingMaskIntoConstraints = false
        followingTableView.translatesAutoresizingMaskIntoConstraints = false
        
        meTableView.estimatedRowHeight = 70
        meTableView.rowHeight = UITableViewAutomaticDimension
        
//        youTableView.estimatedRowHeight = 70
//        youTableView.rowHeight = UITableViewAutomaticDimension
        
        followingTableView.estimatedRowHeight = 70
        followingTableView.rowHeight = UITableViewAutomaticDimension
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func Get_Me_Data(){
        ActivityManager.GetMeData {
            (downloadedData:[FetchedActivityUnit], error:NSError!) -> Void in
            self.meLoadingView.stopAnimating(error == nil)
            if (error == nil){
                self.meData = downloadedData
                self.meRefreshControl.endRefreshing()
                self.meTableView.reloadData()
                // load pics
                for (index,unit) in self.meData.enumerate(){
                    
                    ActivityManager.loadPictureForActivity(&self.meData[index], row: index, option: FileDownloadOption.toUserPicture, completionHandler: {
                        (row:Int, error:NSError!) -> Void in
                        let cells = self.meTableView.visibleCells
                        for cell in cells{
                            if (cell.tag == index){
                                switch self.meData[index].type{
//                                case "follow":
//                                    (cell as! FollowNFTableViewCell).UpdatePictures(self.youData[index], row: row)
                                case "response":
                                    (cell as! MyResponseNFTableViewCell).UpdatePictures(self.meData[index], row: row)
                                default:
                                    AnyObject.self // useless shit
                                }
                            }
                        }
                    })
                    if (unit.type != "follow"){
                        ActivityManager.loadPictureForActivity(&self.meData[index], row: index, option: FileDownloadOption.eventPicture, completionHandler: {
                            (row:Int, error:NSError!) -> Void in
                            let cells = self.meTableView.visibleCells
                            for cell in cells{
                                if (cell.tag == index){
                                    switch self.meData[index].type{
                                    case "response":
                                        (cell as! MyResponseNFTableViewCell).UpdatePictures(self.meData[index], row: row)
                                    default:
                                        AnyObject.self // useless shit
                                    }
                                }
                            }
                        })
                    }
                }
            }else{
                print("Error: " + error.description)
            }
        }
    }

    func Get_You_Data(){
        ActivityManager.GetYouData {
            (downloadedData:[FetchedActivityUnit], error:NSError!) -> Void in
            self.youLoadingView.stopAnimating(error == nil)
            if (error == nil){
                self.youData = downloadedData
                self.youRefreshControl.endRefreshing()
                self.youTableView.reloadData()

                // load pics
                for (index,unit) in self.youData.enumerate(){
                    
                    ActivityManager.loadPictureForActivity(&self.youData[index], row: index, option: FileDownloadOption.fromUserPicture, completionHandler: {
                        (row:Int, error:NSError!) -> Void in
                        let cells = self.youTableView.visibleCells
                        for cell in cells{
                            if (cell.tag == index){
                                switch self.youData[index].type{
                                case "follow":
                                    (cell as! FollowNFTableViewCell).UpdatePictures(self.youData[index], row: row)
                                case "like":
                                    (cell as! LikeNFTableViewCell).UpdatePictures(self.youData[index], row: row)
                                case "share":
                                    (cell as! LikeNFTableViewCell).UpdatePictures(self.youData[index], row: row)
                                case "response":
                                    (cell as! ResponseNFTableViewCell).UpdatePictures(self.youData[index], row: row)
                                case "comment":
                                    (cell as! CommentNFTableViewCell).UpdatePictures(self.youData[index], row: row)
                                default:
                                    AnyObject.self // useless shit
                                }
                            }
                        }
                    })
                    if (unit.type != "follow"){
                        ActivityManager.loadPictureForActivity(&self.youData[index], row: index, option: FileDownloadOption.eventPicture, completionHandler: {
                            (row:Int, error:NSError!) -> Void in
                            let cells = self.youTableView.visibleCells
                            for cell in cells{
                                if (cell.tag == index){
                                    switch self.youData[index].type{
                                    case "follow":
                                        (cell as! FollowNFTableViewCell).UpdatePictures(self.youData[index], row: row)
                                    case "like":
                                        (cell as! LikeNFTableViewCell).UpdatePictures(self.youData[index], row: row)
                                    case "share":
                                        (cell as! LikeNFTableViewCell).UpdatePictures(self.youData[index], row: row)
                                    case "response":
                                        (cell as! ResponseNFTableViewCell).UpdatePictures(self.youData[index], row: row)
                                    case "comment":
                                        (cell as! CommentNFTableViewCell).UpdatePictures(self.youData[index], row: row)
                                    default:
                                        AnyObject.self // useless shit
                                    }
                                }
                            }
                        })
                    }else{
                        if (unit.type == "follow"){
                            self.youData[index].followManager.checkFollow(unit.fromUser!.userId, row: index, completionBlock: {
                                (isFollowing:Bool, error:NSError!) -> Void in
                                if (error == nil){
                                    self.youData[index].followManager.initialize(unit.fromUser!, isFollowing: isFollowing, row: index, tab: TargetView.Activity)
//                                    println(isFollowing)
//                                    println(self.youData[index].followManager.loaded)
                                    let cells = self.youTableView.visibleCells
                                    for cell in cells{
                                        if (cell.tag == index){
                                            dispatch_async(dispatch_get_main_queue(), {
                                                () -> Void in
                                                (cell as! FollowNFTableViewCell).followButton.initialize(self.youData[index].followManager.loaded, isFollowing: self.youData[index].followManager.isFollowing)
                                            })
                                        }
                                    }
                                }else{
                                    print("Error " + error.description)
                                }
                            })
                        }
                    }
                }
            }else{
                print("Error: " + error.description)
            }
        }
    }
    
    func Get_Following_Data(){
        ActivityManager.GetFollowingData {
            (downloadedData:[FetchedActivityUnit]!, error:NSError!) -> Void in
            self.followingLoadingView.stopAnimating(error == nil)
            if (error == nil){
                self.followingData = downloadedData
                self.followingRefreshControl.endRefreshing()
                self.followingTableView.reloadData()
                
                // load pics
                for (index,unit) in self.followingData.enumerate(){
                    
                    ActivityManager.loadPictureForActivity(&self.followingData[index], row: index, option: FileDownloadOption.fromUserPicture, completionHandler: {
                        (row:Int, error:NSError!) -> Void in
                        let cells = self.followingTableView.visibleCells
                        for cell in cells{
                            if (cell.tag == index){
                                let type = self.followingData[index].type
                                if ((type == "like") || (type == "response") || (type == "share")){
                                    (cell as! LikeNFTableViewCell).UpdatePictures(self.followingData[index], row: row)
                                }else if (type == "follow"){
                                    (cell as! fromUserToUserFollowNFCell).UpdatePictures(self.followingData[index], row: row)
                                }
                            }
                        }
                    })
                    var target:FileDownloadOption
                    if (unit.type == "follow"){
                        target = FileDownloadOption.toUserPicture
                    }else{
                        target = FileDownloadOption.eventPicture
                    }
                    ActivityManager.loadPictureForActivity(&self.followingData[index], row: index, option: target, completionHandler: {
                        (row:Int, error:NSError!) -> Void in
                        let cells = self.followingTableView.visibleCells
                        for cell in cells{
                            if (cell.tag == index){
                                let type = self.followingData[index].type
                                if ((type == "like") || (type == "response") || (type == "share")){
                                    (cell as! LikeNFTableViewCell).UpdatePictures(self.followingData[index], row: row)
                                }else if (type == "follow"){
                                    (cell as! fromUserToUserFollowNFCell).UpdatePictures(self.followingData[index], row: row)
                                }
                            }
                        }
                    })
                }
                
            }else{
                print("Error: " + error.description)
            }
        }
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (tableView == self.youTableView){
            return youData.count
        }else if (tableView == self.meTableView){
            return meData.count
        }else if (tableView == self.followingTableView){
            return followingData.count
        }else{
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let userFont = UIFont(name: "Lato-Semibold", size: 14)!
        if (tableView == self.youTableView){
        
            let CompareText:String? = youData[indexPath.row].type as String
            let createdAtText = youData[indexPath.row].createdAtText
            var eventDateText:NSAttributedString = NSAttributedString()
            var eventName = NSString()
            var cellColor:UIColor = UIColor()
            if (CompareText != "follow"){
                eventDateText = youData[indexPath.row].event.eventDateText
                cellColor = ColorFromCode.randomBlueColorFromNumber(indexPath.row)
                eventName = youData[indexPath.row].event.name
            }
            
            if (CompareText == "comment"){
                let Cell:CommentNFTableViewCell = self.youTableView.dequeueReusableCellWithIdentifier("Comment Cell", forIndexPath: indexPath) as! CommentNFTableViewCell
                Cell.tag = indexPath.row

                // Labels
                
                let attributedString:NSMutableAttributedString = NSMutableAttributedString()
                
                var fromUserString:NSMutableAttributedString = NSMutableAttributedString()
                var attrs = [NSFontAttributeName : userFont,  NSForegroundColorAttributeName: ColorFromCode.colorWithHexString("#0087D9")]
                fromUserString = NSMutableAttributedString(string: youData[indexPath.row].fromUser!.username!, attributes:attrs)
                attributedString.appendAttributedString(fromUserString)
                
                let url:NSURL = NSURL(scheme: "pushuser", host: fromUserString.string, path: "/")!
                Cell.commentLabel.addLinkToURL(url, withRange: NSRange(location: 0,length: fromUserString.length))
                Cell.commentLabel.delegate = self
                Cell.commentLabel.tag = indexPath.row
                
                var content:NSMutableAttributedString = NSMutableAttributedString()
                attrs = [NSFontAttributeName : Cell.textFont!, NSForegroundColorAttributeName: UIColor.blackColor()]
                content = NSMutableAttributedString(string: " has commented on your event: " + (youData[indexPath.row].content as String) + " ", attributes:attrs)
                attributedString.appendAttributedString(content)
                
                // Pictures Check/Load
                ActivityManager.loadPictureForActivity(&self.youData[Cell.tag], row: Cell.tag, option: FileDownloadOption.fromUserPicture, completionHandler: {
                    (row:Int, error:NSError!) -> Void in
                    if (error == nil){
                        Cell.UpdatePictures(self.youData[indexPath.row], row: Cell.tag)
                    }
                })
                ActivityManager.loadPictureForActivity(&self.youData[Cell.tag], row: Cell.tag, option: FileDownloadOption.eventPicture, completionHandler: {
                    (row:Int, error:NSError!) -> Void in
                    if (error == nil){
                        Cell.UpdatePictures(self.youData[indexPath.row], row: Cell.tag)
                    }
                })
                Cell.UpdatePictures(self.youData[indexPath.row], row: Cell.tag)
                Cell.profilePicture.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(pushFromUserByPicture(_:))))

                // Date
                Cell.dateLabel.attributedText = eventDateText
                Cell.dateLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(pushEvent(_:))))
                Cell.eventPicture.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(pushEvent(_:))))
                
                var dateString:NSMutableAttributedString = NSMutableAttributedString()
                attrs = [NSFontAttributeName : Cell.textFont!, NSForegroundColorAttributeName: UIColor.lightGrayColor()]
                dateString = NSMutableAttributedString(string: createdAtText, attributes:attrs)
                attributedString.appendAttributedString(dateString)


                
                Cell.highlightMentionsInString(attributedString, withColor: ColorFromCode.randomBlueColorFromNumber(3))
                Cell.highlightHashtagsInString(attributedString, withColor: ColorFromCode.randomBlueColorFromNumber(3))
                
                return Cell
            }else if (CompareText == "like"){
                
                
                let Cell:LikeNFTableViewCell = self.youTableView.dequeueReusableCellWithIdentifier("Like Cell", forIndexPath: indexPath) as! LikeNFTableViewCell
                Cell.tag = indexPath.row
                // Labels
                
                let attributedString:NSMutableAttributedString = NSMutableAttributedString()
                
                var fromUserString:NSMutableAttributedString = NSMutableAttributedString()
                var attrs = [NSFontAttributeName : userFont, NSForegroundColorAttributeName: ColorFromCode.colorWithHexString("#0087D9")]
                fromUserString = NSMutableAttributedString(string: youData[indexPath.row].fromUser!.username!, attributes:attrs)
                attributedString.appendAttributedString(fromUserString)
                
                let url:NSURL = NSURL(scheme: "pushuser", host: fromUserString.string, path: "/")!
                Cell.likeLabel.addLinkToURL(url, withRange: NSRange(location: 0,length: fromUserString.length))
                Cell.likeLabel.delegate = self
                Cell.likeLabel.tag = indexPath.row
                
                var content:NSMutableAttributedString = NSMutableAttributedString()
                attrs = [NSFontAttributeName : Cell.textFont!, NSForegroundColorAttributeName: UIColor.blackColor()]
                content = NSMutableAttributedString(string: " has liked your event '\(eventName)'. ", attributes:attrs)
                attributedString.appendAttributedString(content)
                
                // Set Event Picture

                Cell.UpdatePictures(self.youData[indexPath.row], row: indexPath.row)
                Cell.dateLabel.attributedText = eventDateText
                Cell.dateLabel.backgroundColor = cellColor
                Cell.dateLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(pushEvent(_:))))
                Cell.eventPicture.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(pushEvent(_:))))
                Cell.profilePicture.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(pushFromUserByPicture(_:))))

                var dateString:NSMutableAttributedString = NSMutableAttributedString()
                attrs = [NSFontAttributeName : Cell.textFont!, NSForegroundColorAttributeName: UIColor.lightGrayColor()]
                dateString = NSMutableAttributedString(string: createdAtText, attributes:attrs)
                attributedString.appendAttributedString(dateString)
                
                
                Cell.highlightMentionsInString(attributedString, withColor: ColorFromCode.randomBlueColorFromNumber(3))
                Cell.highlightHashtagsInString(attributedString, withColor: ColorFromCode.randomBlueColorFromNumber(3))
                //Cell.updateConstraints()
                return Cell
                
                
            }else if (CompareText == "response"){
                let Cell:ResponseNFTableViewCell = self.youTableView.dequeueReusableCellWithIdentifier("Response Cell", forIndexPath: indexPath) as!
                ResponseNFTableViewCell

                Cell.tag = indexPath.row
                // Labels
                
                let attributedString:NSMutableAttributedString = NSMutableAttributedString()
                
                var fromUserString:NSMutableAttributedString = NSMutableAttributedString()
                var attrs = [NSFontAttributeName : userFont, NSForegroundColorAttributeName: ColorFromCode.colorWithHexString("#0087D9")]
                //println(youData[indexPath.row].fromUser!.username!)
                fromUserString = NSMutableAttributedString(string: youData[indexPath.row].fromUser!.username!, attributes:attrs)
                attributedString.appendAttributedString(fromUserString)
                
                let url:NSURL = NSURL(scheme: "pushuser", host: fromUserString.string, path: "/")!
                Cell.responseLabel.addLinkToURL(url, withRange: NSRange(location: 0,length: fromUserString.length))
                Cell.responseLabel.delegate = self
                Cell.responseLabel.tag = indexPath.row
                
                var text:String
                switch (youData[indexPath.row].content){
                case "yes":
                    text = " is going for your event"
                case "no":
                    text = " is not going for your event"
                case "maybe":
                    text = " is not sure about going for your event"
                default:
                    text = " response"
                    
                }
                var content:NSMutableAttributedString = NSMutableAttributedString()
                attrs = [NSFontAttributeName : Cell.textFont!, NSForegroundColorAttributeName: UIColor.blackColor()]
                content = NSMutableAttributedString(string: "\(text) '\(eventName)'. ", attributes:attrs)
                attributedString.appendAttributedString(content)
                
                // Pictures Check/Load
                ActivityManager.loadPictureForActivity(&self.youData[Cell.tag], row: Cell.tag, option: FileDownloadOption.fromUserPicture, completionHandler: {
                    (row:Int, error:NSError!) -> Void in
                    if (error == nil){
                        Cell.UpdatePictures(self.youData[indexPath.row], row: Cell.tag)
                    }
                })
                ActivityManager.loadPictureForActivity(&self.youData[Cell.tag], row: Cell.tag, option: FileDownloadOption.eventPicture, completionHandler: {
                    (row:Int, error:NSError!) -> Void in
                    if (error == nil){
                        Cell.UpdatePictures(self.youData[row], row: row)
                    }
                })
                Cell.UpdatePictures(self.youData[indexPath.row], row: indexPath.row)
                
                // Event Date

                Cell.dateLabel.attributedText = eventDateText
                Cell.dateLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(pushEvent(_:))))
                Cell.eventPicture.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(pushEvent(_:))))
                Cell.profilePicture.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(pushFromUserByPicture(_:))))

                var dateString:NSMutableAttributedString = NSMutableAttributedString()
                attrs = [NSFontAttributeName : Cell.textFont!, NSForegroundColorAttributeName: UIColor.lightGrayColor()]
                dateString = NSMutableAttributedString(string: createdAtText, attributes:attrs)
                attributedString.appendAttributedString(dateString)
                
                Cell.highlightMentionsInString(attributedString, withColor: ColorFromCode.randomBlueColorFromNumber(3))
                Cell.highlightHashtagsInString(attributedString, withColor: ColorFromCode.randomBlueColorFromNumber(3))
                
                return Cell
            }else if (CompareText == "follow"){
                
                let Cell:FollowNFTableViewCell = self.youTableView.dequeueReusableCellWithIdentifier("Follow Cell", forIndexPath: indexPath) as! FollowNFTableViewCell
                
                Cell.tag = indexPath.row
                // Labels
                
                let attributedString:NSMutableAttributedString = NSMutableAttributedString()
                
                var fromUserString:NSMutableAttributedString = NSMutableAttributedString()
                var attrs = [NSFontAttributeName : userFont, NSForegroundColorAttributeName: ColorFromCode.colorWithHexString("#0087D9")]
                fromUserString = NSMutableAttributedString(string: youData[indexPath.row].fromUser!.username!, attributes:attrs)
                attributedString.appendAttributedString(fromUserString)
                
                let url:NSURL = NSURL(scheme: "pushuser", host: fromUserString.string, path: "/")!
                Cell.followLabel.addLinkToURL(url, withRange: NSRange(location: 0,length: fromUserString.length))
                Cell.followLabel.delegate = self
                Cell.followLabel.tag = indexPath.row
                var content:NSMutableAttributedString = NSMutableAttributedString()
                attrs = [NSFontAttributeName : Cell.textFont!, NSForegroundColorAttributeName: UIColor.blackColor()]
                content = NSMutableAttributedString(string: " has started following you. ", attributes:attrs)
                attributedString.appendAttributedString(content)
                
                // Pictures Check/Load
                ActivityManager.loadPictureForActivity(&self.youData[Cell.tag], row: Cell.tag, option: FileDownloadOption.fromUserPicture, completionHandler: {
                    (row:Int, error:NSError!) -> Void in
                    if (error == nil){
                        Cell.UpdatePictures(self.youData[row], row: row)
                    }
                })
                ActivityManager.loadPictureForActivity(&self.youData[Cell.tag], row: Cell.tag, option: FileDownloadOption.toUserPicture, completionHandler: {
                    (row:Int, error:NSError!) -> Void in
                    if (error == nil){
                        Cell.UpdatePictures(self.youData[row], row: row)
                    }
                })
                Cell.UpdatePictures(self.youData[indexPath.row], row: Cell.tag)
                Cell.followButton.addTarget(self, action: #selector(follow(_:)), forControlEvents: UIControlEvents.TouchUpInside)
                Cell.followButton.initialize(self.youData[indexPath.row].followManager.loaded, isFollowing: self.youData[indexPath.row].followManager.isFollowing)
                Cell.fromUserImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(pushFromUserByPicture(_:))))

                
                var dateString:NSMutableAttributedString = NSMutableAttributedString()
                attrs = [NSFontAttributeName : Cell.textFont!, NSForegroundColorAttributeName: UIColor.lightGrayColor()]
                dateString = NSMutableAttributedString(string: createdAtText, attributes:attrs)
                attributedString.appendAttributedString(dateString)
                Cell.followLabel.attributedText = attributedString
                return Cell
                
            }else if (CompareText == "share"){
                let Cell:LikeNFTableViewCell = self.youTableView.dequeueReusableCellWithIdentifier("Like Cell", forIndexPath: indexPath) as! LikeNFTableViewCell
                
                Cell.tag = indexPath.row
                // Labels
                
                let attributedString:NSMutableAttributedString = NSMutableAttributedString()
                
                var fromUserString:NSMutableAttributedString = NSMutableAttributedString()
                var attrs = [NSFontAttributeName : userFont, NSForegroundColorAttributeName: ColorFromCode.colorWithHexString("#0087D9")]
                fromUserString = NSMutableAttributedString(string: youData[indexPath.row].fromUser!.username!, attributes:attrs)
                attributedString.appendAttributedString(fromUserString)
                
                let url:NSURL = NSURL(scheme: "pushuser", host: fromUserString.string, path: "/")!
                Cell.likeLabel.addLinkToURL(url, withRange: NSRange(location: 0,length: fromUserString.length))
                Cell.likeLabel.delegate = self
                Cell.likeLabel.tag = indexPath.row
                
                var content:NSMutableAttributedString = NSMutableAttributedString()
                attrs = [NSFontAttributeName : Cell.textFont!, NSForegroundColorAttributeName: UIColor.blackColor()]
                content = NSMutableAttributedString(string: " has shared your event '\(eventName)'. ", attributes:attrs)
                attributedString.appendAttributedString(content)
                
                // Pictures Check/Load
                ActivityManager.loadPictureForActivity(&self.youData[Cell.tag], row: Cell.tag, option: FileDownloadOption.fromUserPicture, completionHandler: {
                    (row:Int, error:NSError!) -> Void in
                    if (error == nil){
                        Cell.UpdatePictures(self.youData[indexPath.row], row: Cell.tag)
                    }
                })
                ActivityManager.loadPictureForActivity(&self.youData[Cell.tag], row: Cell.tag, option: FileDownloadOption.eventPicture, completionHandler: {
                    (row:Int, error:NSError!) -> Void in
                    if (error == nil){
                        Cell.UpdatePictures(self.youData[indexPath.row], row: Cell.tag)
                    }
                })
                Cell.UpdatePictures(self.youData[indexPath.row], row: Cell.tag)
                
                // Event Date
                
                Cell.dateLabel.attributedText = eventDateText
                
                var dateString:NSMutableAttributedString = NSMutableAttributedString()
                attrs = [NSFontAttributeName : Cell.textFont!, NSForegroundColorAttributeName: UIColor.lightGrayColor()]
                dateString = NSMutableAttributedString(string: createdAtText, attributes:attrs)
                attributedString.appendAttributedString(dateString)
                
                Cell.profilePicture.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(pushFromUserByPicture(_:))))
                Cell.highlightMentionsInString(attributedString, withColor: ColorFromCode.randomBlueColorFromNumber(3))
                Cell.highlightHashtagsInString(attributedString, withColor: ColorFromCode.randomBlueColorFromNumber(3))
                //Cell.updateConstraints()
                return Cell
            }else{
                let Cell:UITableViewCell = UITableViewCell()
                Cell.textLabel?.text = ("Error: " + CompareText!)
                return Cell
            }
        }
        else if (tableView == self.meTableView){
            
//            let CompareText:String? = meData[indexPath.row].type as String
            let createdAtText = meData[indexPath.row].createdAtText
            let eventDateText:NSAttributedString = NSAttributedString()
//            var eventName = NSString()
//            var cellColor:UIColor = UIColor()
//            if (CompareText != "follow"){
//                eventDateText = meData[indexPath.row].event.eventDateText
//                cellColor = ColorFromCode.randomBlueColorFromNumber(indexPath.row)
//                eventName = meData[indexPath.row].event.name
//            }

            let Cell:MyResponseNFTableViewCell = self.meTableView.dequeueReusableCellWithIdentifier("MyResponse Cell", forIndexPath: indexPath) as!
            MyResponseNFTableViewCell
            Cell.tag = indexPath.row
            // Labels
            
            let attributedString:NSMutableAttributedString = NSMutableAttributedString()
            
            var content:NSMutableAttributedString = NSMutableAttributedString()
            var attrs = [NSFontAttributeName : Cell.textFont!, NSForegroundColorAttributeName: UIColor.blackColor()]
            content = NSMutableAttributedString(string: "You have confirmed ", attributes:attrs)
            attributedString.appendAttributedString(content)
            
            attrs = [NSFontAttributeName : userFont, NSForegroundColorAttributeName: ColorFromCode.colorWithHexString("#0087D9")]
            let toUserString = NSMutableAttributedString(string: meData[indexPath.row].toUser!.username!, attributes:attrs)
            attributedString.appendAttributedString(toUserString)
            let url:NSURL = NSURL(scheme: "pushuser", host: toUserString.string, path: "/")!
            Cell.responseLabel.addLinkToURL(url, withRange: NSRange(location: content.length,length: toUserString.length))
            Cell.responseLabel.delegate = self
            Cell.responseLabel.tag = indexPath.row
            
            var postcontent:NSMutableAttributedString = NSMutableAttributedString()
            attrs = [NSFontAttributeName : UIFont.systemFontOfSize(14.0), NSForegroundColorAttributeName: UIColor.blackColor()]
            postcontent = NSMutableAttributedString(string: "'s event. ", attributes:attrs)
            attributedString.appendAttributedString(postcontent)
            
            // Pictures Check/Load
            ActivityManager.loadPictureForActivity(&self.meData[Cell.tag], row: Cell.tag, option: FileDownloadOption.toUserPicture, completionHandler: {
                (row:Int, error:NSError!) -> Void in
                if (error == nil){
                    Cell.UpdatePictures(self.meData[row], row: row)
                }
            })
            ActivityManager.loadPictureForActivity(&self.meData[Cell.tag], row: Cell.tag, option: FileDownloadOption.eventPicture, completionHandler: {
                (row:Int, error:NSError!) -> Void in
                if (error == nil){
                    Cell.UpdatePictures(self.meData[row], row: row)
                }
            })
            Cell.UpdatePictures(self.meData[indexPath.row], row: indexPath.row)
            Cell.profilePicture.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(pushToUserByPicture(_:))))
            Cell.dateLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(pushEvent(_:))))
            Cell.eventPicture.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(pushEvent(_:))))
            // Event Date
        
            Cell.dateLabel.attributedText = eventDateText
            
            var dateString:NSMutableAttributedString = NSMutableAttributedString()
            attrs = [NSFontAttributeName : Cell.textFont!, NSForegroundColorAttributeName: UIColor.lightGrayColor()]
            dateString = NSMutableAttributedString(string: createdAtText, attributes:attrs)
            attributedString.appendAttributedString(dateString)
            
            Cell.highlightMentionsInString(attributedString, withColor: ColorFromCode.randomBlueColorFromNumber(3))
            Cell.highlightHashtagsInString(attributedString, withColor: ColorFromCode.randomBlueColorFromNumber(3))
            
            

            return Cell
        }else if(tableView == self.followingTableView){
            let CompareText:String? = followingData[indexPath.row].type as String
            let createdAtText = followingData[indexPath.row].createdAtText
            var eventDateText:NSAttributedString = NSAttributedString()
            //var eventName = NSString()
            var cellColor:UIColor = UIColor()
            if (CompareText != "follow"){
                eventDateText = followingData[indexPath.row].event.eventDateText
                cellColor = ColorFromCode.randomBlueColorFromNumber(indexPath.row)
                //eventName = followingData[indexPath.row].event.name
            }
            

            
            if ((CompareText == "like") || (CompareText == "response") || (CompareText == "share")){
                let Cell:LikeNFTableViewCell = self.followingTableView.dequeueReusableCellWithIdentifier("Like Cell", forIndexPath: indexPath) as! LikeNFTableViewCell
                Cell.tag = indexPath.row
                
                // Setup attributed Label
                let attributedString:NSMutableAttributedString = NSMutableAttributedString()
                
                var attrs = [NSFontAttributeName : userFont, NSForegroundColorAttributeName: ColorFromCode.colorWithHexString("#0087D9")]
                let fromUserString = NSMutableAttributedString(string: followingData[indexPath.row].fromUser!.username!, attributes:attrs)
                attributedString.appendAttributedString(fromUserString)
                
                // user 1
                var url:NSURL = NSURL(scheme: "pushuser", host: fromUserString.string, path: "/fromUser")!
                Cell.likeLabel.addLinkToURL(url, withRange: NSRange(location: 0,length: fromUserString.length))
                Cell.likeLabel.delegate = self
                Cell.likeLabel.tag = indexPath.row
                
                // has liked
                var content:NSMutableAttributedString = NSMutableAttributedString()
                attrs = [NSFontAttributeName : Cell.textFont!, NSForegroundColorAttributeName: UIColor.blackColor()]
                if (CompareText == "like"){
                    content = NSMutableAttributedString(string: " has liked ", attributes:attrs)
                }else if (CompareText == "response"){
                    content = NSMutableAttributedString(string: " is going for ", attributes:attrs)
                }else if (CompareText == "share"){
                    content = NSMutableAttributedString(string: " has shared ", attributes:attrs)
                }
                attributedString.appendAttributedString(content)
                
                // user 2
                attrs = [NSFontAttributeName : userFont, NSForegroundColorAttributeName: ColorFromCode.colorWithHexString("#0087D9")]
                let toUserString = NSMutableAttributedString(string: followingData[indexPath.row].toUser!.username!, attributes:attrs)
                url = NSURL(scheme: "pushuser", host: toUserString.string, path: "/toUser")!
                Cell.likeLabel.addLinkToURL(url, withRange: NSRange(location: attributedString.length,length: toUserString.length))
                Cell.likeLabel.delegate = self
                Cell.likeLabel.tag = indexPath.row
                attributedString.appendAttributedString(toUserString)
                
                // 's event
                attrs = [NSFontAttributeName : Cell.textFont!, NSForegroundColorAttributeName: UIColor.blackColor()]
                content = NSMutableAttributedString(string: "'s event. ", attributes:attrs)
                attributedString.appendAttributedString(content)
                
                // created At
                attrs = [NSFontAttributeName : Cell.textFont!, NSForegroundColorAttributeName: UIColor.lightGrayColor()]
                let dateString = NSMutableAttributedString(string: createdAtText, attributes:attrs)
                attributedString.appendAttributedString(dateString)
                
                // Pictures Check/Load
                ActivityManager.loadPictureForActivity(&self.followingData[Cell.tag], row: Cell.tag, option: FileDownloadOption.fromUserPicture, completionHandler: {
                    (row:Int, error:NSError!) -> Void in
                    if (error == nil){
                        Cell.UpdatePictures(self.followingData[indexPath.row], row: Cell.tag)
                    }
                })
                ActivityManager.loadPictureForActivity(&self.followingData[Cell.tag], row: Cell.tag, option: FileDownloadOption.eventPicture, completionHandler: {
                    (row:Int, error:NSError!) -> Void in
                    if (error == nil){
                        Cell.UpdatePictures(self.followingData[indexPath.row], row: Cell.tag)
                    }
                })
                Cell.UpdatePictures(self.followingData[indexPath.row], row: Cell.tag)
                
                Cell.dateLabel.attributedText = eventDateText
                Cell.dateLabel.backgroundColor = cellColor
                Cell.dateLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(pushEvent(_:))))
                Cell.eventPicture.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(pushEvent(_:))))
                Cell.profilePicture.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(pushFromUserByPicture(_:))))

                Cell.highlightMentionsInString(attributedString, withColor: ColorFromCode.randomBlueColorFromNumber(3))
                Cell.highlightHashtagsInString(attributedString, withColor: ColorFromCode.randomBlueColorFromNumber(3))
                return Cell
            }else if (CompareText == "follow"){
                let Cell:fromUserToUserFollowNFCell = self.followingTableView.dequeueReusableCellWithIdentifier("Follow Cell", forIndexPath: indexPath) as! fromUserToUserFollowNFCell
                Cell.tag = indexPath.row
                
                // Setup attributed Label
                let attributedString:NSMutableAttributedString = NSMutableAttributedString()
                
                var attrs = [NSFontAttributeName : userFont, NSForegroundColorAttributeName: ColorFromCode.colorWithHexString("#0087D9")]
                let fromUserString = NSMutableAttributedString(string: followingData[indexPath.row].fromUser!.username!, attributes:attrs)
                attributedString.appendAttributedString(fromUserString)
                
                // user 1
                var url:NSURL = NSURL(scheme: "pushuser", host: fromUserString.string, path: "/fromUser")!
                Cell.followLabel.addLinkToURL(url, withRange: NSRange(location: 0,length: fromUserString.length))
                Cell.followLabel.delegate = self
                Cell.followLabel.tag = indexPath.row
                
                // has started following
                var content:NSMutableAttributedString = NSMutableAttributedString()
                attrs = [NSFontAttributeName : Cell.textFont!, NSForegroundColorAttributeName: UIColor.blackColor()]
                content = NSMutableAttributedString(string: " has started following ", attributes:attrs)

                attributedString.appendAttributedString(content)
                
                // user 2
                attrs = [NSFontAttributeName : userFont, NSForegroundColorAttributeName: ColorFromCode.colorWithHexString("#0087D9")]
                let toUserString = NSMutableAttributedString(string: followingData[indexPath.row].toUser!.username!, attributes:attrs)
                url = NSURL(scheme: "pushuser", host: toUserString.string, path: "/toUser")!
                Cell.followLabel.addLinkToURL(url, withRange: NSRange(location: attributedString.length,length: toUserString.length))
                Cell.followLabel.delegate = self
                Cell.followLabel.tag = indexPath.row
                attributedString.appendAttributedString(toUserString)
                
                // created At
                attrs = [NSFontAttributeName : Cell.textFont!, NSForegroundColorAttributeName: UIColor.lightGrayColor()]
                let dateString = NSMutableAttributedString(string: ". \(createdAtText)", attributes:attrs)
                attributedString.appendAttributedString(dateString)
                
                // Pictures Check/Load
                ActivityManager.loadPictureForActivity(&self.followingData[Cell.tag], row: Cell.tag, option: FileDownloadOption.fromUserPicture, completionHandler: {
                    (row:Int, error:NSError!) -> Void in
                    if (error == nil){
                        Cell.UpdatePictures(self.followingData[indexPath.row], row: Cell.tag)
                    }
                })
                ActivityManager.loadPictureForActivity(&self.followingData[Cell.tag], row: Cell.tag, option: FileDownloadOption.toUserPicture, completionHandler: {
                    (row:Int, error:NSError!) -> Void in
                    if (error == nil){
                        Cell.UpdatePictures(self.followingData[indexPath.row], row: Cell.tag)
                    }
                })
                Cell.UpdatePictures(self.followingData[indexPath.row], row: Cell.tag)
                Cell.fromUserImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(pushFromUserByPicture(_:))))
                Cell.toUserImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(pushToUserByPicture(_:))))

                Cell.highlightMentionsInString(attributedString, withColor: ColorFromCode.randomBlueColorFromNumber(3))
                Cell.highlightHashtagsInString(attributedString, withColor: ColorFromCode.randomBlueColorFromNumber(3))
                return Cell

            }else{
                let Cell:UITableViewCell = UITableViewCell()
                Cell.textLabel?.text = ("Some bad thing happened!")
                return Cell
            }
        }else{
            let Cell:UITableViewCell = UITableViewCell()
            Cell.textLabel?.text = ("Some bad thing happened!")
            return Cell
        }
    }
    func follow(sender:ActivityFollowButton){
        print("follow pressed \(sender.superview!.superview!.tag)")
        self.youData[sender.superview!.superview!.tag].followManager.button = sender
        self.youData[sender.superview!.superview!.tag].followManager.Follow()
    }


    func attributedLabel(label: TTTAttributedLabel!, didSelectLinkWithURL url: NSURL!) {
        let tag = label.tag
        print(url.scheme)
        if (url.scheme == "pushuser"){ // url = "scheme://host" , host is username
            
            switch selectedSegment{
            case 1:
                pushUserByUserObject(meData[tag].toUser!)
            case 2:
                pushUserByUserObject(youData[tag].fromUser!)
            case 3:
                if (url.path == "/fromUser"){
                    pushUserByUserObject(followingData[tag].fromUser!)
                }else if (url.path == "/toUser"){
                    pushUserByUserObject(followingData[tag].toUser!)
                }
            default:
                print("error")
            }
            
        }else if (url.scheme == "mention"){
            print("mention pressed")
            switch selectedSegment{
            case 1:
                
                if (meData[tag].toUser!.username == url.host!){
                    pushUserByUserObject(meData[tag].toUser!)
                }else{
                    pushUserByUsername(url.host!)
                }
                
            case 2:
                
                if (youData[tag].fromUser!.username == url.host!){
                    pushUserByUserObject(youData[tag].fromUser!)
                }else{
                    pushUserByUsername(url.host!)
                }
                
            case 3:
                print("for later")
            default:
                print("error")
            }
            
        }else if (url.scheme == "hashtag"){
            print("hashtag pressed")
        }
    }
    func pushFromUserByPicture(sender:UITapGestureRecognizer){
        let tag = sender.view!.superview!.superview!.tag
        var user:KCSUser!
        if (selectedSegment == 1){
            user = self.meData[tag].fromUser
        }else if (selectedSegment == 2){
            user = self.youData[tag].fromUser
        }else if (selectedSegment == 3){
            user = self.followingData[tag].fromUser
        }
        
        if (user.userId == KCSUser.activeUser().userId){
            
            let VC:MyProfileViewController = self.storyboard?.instantiateViewControllerWithIdentifier("MyProfileViewController") as! MyProfileViewController
            self.navigationController?.pushViewController(VC, animated: true)
            
        }else{
            
            let VC:UserProfileViewController = self.storyboard?.instantiateViewControllerWithIdentifier("UserProfileViewController") as! UserProfileViewController
            VC.user = user
            self.navigationController?.pushViewController(VC, animated: true)
        }
    }
    
    func pushToUserByPicture(sender:UITapGestureRecognizer){
        let tag = sender.view!.superview!.superview!.tag
        var user:KCSUser!
        if (selectedSegment == 1){
            user = self.meData[tag].toUser
        }else if (selectedSegment == 2){
            user = self.youData[tag].toUser
        }else if (selectedSegment == 3){
            user = self.followingData[tag].toUser
        }
        
        if (user.userId == KCSUser.activeUser().userId){
            
            let VC:MyProfileViewController = self.storyboard?.instantiateViewControllerWithIdentifier("MyProfileViewController") as! MyProfileViewController
            self.navigationController?.pushViewController(VC, animated: true)
            
        }else{
            
            let VC:UserProfileViewController = self.storyboard?.instantiateViewControllerWithIdentifier("UserProfileViewController") as! UserProfileViewController
            VC.user = user
            self.navigationController?.pushViewController(VC, animated: true)
        }
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
    func pushEvent(sender:UITapGestureRecognizer){
        let eventTag = sender.view!.superview!.superview!.tag
        print(eventTag)
        print(selectedSegment)
        var event:FetchedEvent!
        if (selectedSegment == 1){
            event = self.meData[eventTag].event!
        }else if (selectedSegment == 2){
            event = self.youData[eventTag].event!
        }else if (selectedSegment == 3){
            event = self.followingData[eventTag].event!
        }
        let VC:EventViewController = self.storyboard?.instantiateViewControllerWithIdentifier("EventViewController") as! EventViewController

        VC.event = event
        VC.loadedFromActivity = true

        self.navigationController?.pushViewController(VC, animated: true)
        print("assign")

    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) { // make scrollView only horizontal scrolling
        if (scrollView == self.scrollView){
            self.segmentIndicator.frame.origin.x = scrollView.contentOffset.x/3
            if (scrollView.contentOffset.x < screenWidth/2){ // page 1
                selectSegment(1)
            }else if(scrollView.contentOffset.x < screenWidth*1.5){ // page 2
                selectSegment(2)
            }else{
                selectSegment(3)
            }
        }
    }
    
    func selectSegment(index:Int){

        if (index == 1){
            if !meLoadingView.usedMoreThan1Time {
                meLoadingView.startAnimating()
                if !meLoadingView.didAnimateBefore {
                    meLoadingView.didAnimateBefore = true
                    Get_Me_Data()
                }
            }
            self.segmentLabel1.highlighted = true
            self.segmentLabel2.highlighted = false
            self.segmentLabel3.highlighted = false
            
            self.segmentLabel1.enabled = false
            self.segmentLabel2.enabled = true
            self.segmentLabel3.enabled = true
            self.selectedSegment = 1

        }else if (index == 2){
            self.segmentLabel1.highlighted = false
            self.segmentLabel2.highlighted = true
            self.segmentLabel3.highlighted = false
            
            self.segmentLabel1.enabled = true
            self.segmentLabel2.enabled = false
            self.segmentLabel3.enabled = true
            self.selectedSegment = 2

        }else if (index == 3){
            if !followingLoadingView.usedMoreThan1Time {
                followingLoadingView.startAnimating()
                if !followingLoadingView.didAnimateBefore {
                    followingLoadingView.didAnimateBefore = true
                    Get_Following_Data()
                }

            }
            self.segmentLabel1.highlighted = false
            self.segmentLabel2.highlighted = false
            self.segmentLabel3.highlighted = true
            
            self.segmentLabel1.enabled = true
            self.segmentLabel2.enabled = true
            self.segmentLabel3.enabled = false
            self.selectedSegment = 3

        }
    }
    
    func switchSegment(sender:UIButton){
        selectSegment(sender.tag)
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
        }else if (sender.tag == 3){
            segmentChanging = true
            self.segmentLabel3.enabled = false
            scrollView.setContentOffset(CGPointMake(screenWidth*2, scrollView.contentOffset.y), animated: true)
            self.segmentLabel3.enabled = true
            segmentChanging = false
        }
    }

}
