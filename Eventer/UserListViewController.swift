//
//  UserListViewController.swift
//  Eventer
//
//  Created by Grisha on 04/02/2015.
//  Copyright (c) 2015 Grisha. All rights reserved.    
//

import UIKit

class UserListViewController: UIViewController,UITableViewDelegate, UITableViewDataSource, UIGestureRecognizerDelegate, TTTAttributedLabelDelegate {
    var screenWidth = UIScreen.mainScreen().bounds.width
    var screenHeight = UIScreen.mainScreen().bounds.height
    var tableView: UITableView = UITableView()
    
    var Data:[FetchedActivityUnit] = [] //always declare like that or it will crash

    var tableLoaded:Bool!
    var Target:String! //can be followers , following or likers list
    
    var user:KCSUser! // the user we get information about
    var event:Event! // event we trying to get likes list for
    var option = FileDownloadOption.fromUserPicture
    var navBar:UINavigationBar!
    

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        Utility.dropShadow(navBar, offset: 0, opacity: 0)
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
        self.navBar = self.navigationController!.navigationBar
        
        Utility.dropShadow(self.navigationController!.navigationBar, offset: 1, opacity: 0.25)
        
        
        let titleLabel:UILabel = UILabel()
        titleLabel.numberOfLines = 1
        titleLabel.text = self.Target.uppercaseString
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.textAlignment = NSTextAlignment.Center
        titleLabel.font = UIFont(name: "Lato-Semibold", size: 18)
        self.navigationItem.titleView = titleLabel
        titleLabel.sizeToFit()
        
        self.view.addSubview(tableView)
        let offset = self.navigationController!.navigationBar.frame.height + UIApplication.sharedApplication().statusBarFrame.height + self.tabBarController!.tabBar.frame.height
        tableView.allowsSelection = false
        tableView.delegate = self
        tableView.dataSource = self
        self.tableView.registerClass(UserListViewCell.self, forCellReuseIdentifier: "User Cell")
        tableView.frame = CGRectMake(0, 0, screenWidth, self.view.frame.height-offset)
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        tableLoaded = false

    }

    override func viewDidLoad() {
        super.viewDidLoad()
        Set_Subviews()
        Refresh()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func Refresh(){
        var checkFollows:Bool = true
        var query:KCSQuery!
        if (Target == "Followers"){
            query = KCSQuery(onField: "toUser._id", withExactMatchForValue: self.user.userId)
            query.addQueryOnField("type", withExactMatchForValue: "follow")
            query.addQueryOnField("content", withExactMatchForValue: "accepted")

        }else if (Target == "Following"){
            query = KCSQuery(onField: "fromUser._id", withExactMatchForValue: self.user.userId)
            query.addQueryOnField("type", withExactMatchForValue: "follow")
            query.addQueryOnField("content", withExactMatchForValue: "accepted")
            if (self.user.userId == KCSUser.activeUser().userId){
                checkFollows = false
            }
            option = FileDownloadOption.toUserPicture
        }else if (Target == "Likers"){
            query = KCSQuery(onField: "event._id", withExactMatchForValue: self.event.entityId!)
            query.addQueryOnField("type", withExactMatchForValue: "like")
        }else if (Target == "Accepted"){
            query = KCSQuery(onField: "event._id", withExactMatchForValue: self.event.entityId)
            query.addQueryOnField("type", withExactMatchForValue: "response")
            query.addQueryOnField("content", withExactMatchForValue: "yes")
        }else if (Target == "Maybe"){
            query = KCSQuery(onField: "event._id", withExactMatchForValue: self.event.entityId)
            query.addQueryOnField("type", withExactMatchForValue: "response")
            query.addQueryOnField("content", withExactMatchForValue: "maybe")
        }else if (Target == "Invited"){
            query = KCSQuery(onField: "event._id", withExactMatchForValue: self.event.entityId)
            query.addQueryOnField("type", withExactMatchForValue: "response")
            query.addQueryOnField("content", withExactMatchForValue: "invite")
        }else if (Target == "Shares"){
            query = KCSQuery(onField: "event._id", withExactMatchForValue: self.event.entityId)
            query.addQueryOnField("type", withExactMatchForValue: "share")
        }
        ActivityManager.getUsersByQuery(query, completionHandler: {
            (downloadedData:[FetchedActivityUnit]!, error:NSError!) -> Void in
            if (error == nil){
                self.Data = downloadedData
                
                // load pics
                for (index,_) in self.Data.enumerate(){
                    ActivityManager.loadPictureForActivity(&self.Data[index], row: index, option: self.option, completionHandler: {
                        (row:Int, error:NSError!) -> Void in
                        let cells = self.tableView.visibleCells
                        for cell in cells{
                            if (cell.tag == index){
                                (cell as! UserListViewCell).UpdatePictures(self.Data[index], row: row, option: self.option)
                            }
                        }
                    })
                }
                
                if (checkFollows){
                    for (index,unit) in self.Data.enumerate(){
                        var user:KCSUser!
                        if self.option == FileDownloadOption.fromUserPicture {
                            user = unit.fromUser
                        }else{
                            user = unit.toUser
                        }
                        
                        if user.userId != KCSUser.activeUser().userId {
                            unit.followManager.checkFollow(user.userId, row: index, completionBlock: {
                                (isFollowing:Bool, error:NSError!) -> Void in
                                if (error == nil){
                                    unit.followManager.initialize(user, isFollowing: isFollowing, row: index, tab: forTab.Activity)
                                    let cells = self.tableView.visibleCells
                                    for cell in cells{
                                        if (cell.tag == index){
                                            dispatch_async(dispatch_get_main_queue(), {
                                                () -> Void in
                                                (cell as! UserListViewCell).followButton.initialize(unit.followManager.loaded, isFollowing: unit.followManager.isFollowing)
                                            })
                                        }
                                    }
                                }else{
                                    print("Error " + error.description)
                                }
                            })
                        }
                    }

                }else{
                    for (index,unit) in self.Data.enumerate(){
                        var user:KCSUser!
                        if self.option == FileDownloadOption.fromUserPicture {
                            user = unit.fromUser
                        }else{
                            user = unit.toUser
                        }
                        if user.userId != KCSUser.activeUser().userId {
                            unit.followManager.initialize(user, isFollowing: true, row: index, tab: forTab.Activity)
                            unit.followManager.loaded = true
                        }
                    }

                }
                self.tableView.reloadData()

            }else{
                print("Error: " + error.description)
            }
        })
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Data.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let Cell:UserListViewCell = self.tableView.dequeueReusableCellWithIdentifier("User Cell", forIndexPath: indexPath) as! UserListViewCell
        Cell.tag = indexPath.row
        var username:String!
        var fullname:String!
        if option == FileDownloadOption.fromUserPicture {
            username = Data[Cell.tag].fromUser!.username
            fullname = Data[Cell.tag].fromUserFullname as String
        }else if option == FileDownloadOption.toUserPicture {
            username = Data[Cell.tag].toUser!.username
            fullname = Data[Cell.tag].toUserFullname as String
        }
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 1
        
        var attrs = [NSFontAttributeName : Cell.usernameFont!, NSForegroundColorAttributeName: ColorFromCode.colorWithHexString("#9A9A9A")]
        let usernameString = NSMutableAttributedString(string: username, attributes:attrs)
        
        let finalString = NSMutableAttributedString()
        if (fullname != "") && (fullname != nil){
            attrs = [NSFontAttributeName : Cell.fullnameFont!, NSForegroundColorAttributeName: ColorFromCode.colorWithHexString("#0087D9")]
            let fullnameString = NSMutableAttributedString(string: "\(fullname)\n", attributes:attrs)
            finalString.appendAttributedString(fullnameString)
        }
        finalString.appendAttributedString(usernameString)
        finalString.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, finalString.length))
        
        let url:NSURL = NSURL(scheme: "pushuser", host: nil, path: "/")!
        Cell.label.delegate = self
        Cell.label.tag = indexPath.row
        
        ActivityManager.loadPictureForActivity(&self.Data[Cell.tag], row: Cell.tag, option: option, completionHandler: {
            (row:Int, error:NSError!) -> Void in
            if (error == nil){
                Cell.UpdatePictures(self.Data[row], row: row, option: self.option)
            }
        })
        Cell.UpdatePictures(self.Data[Cell.tag], row: Cell.tag, option: option)
        
        var userId:NSString!
        if self.option == FileDownloadOption.fromUserPicture {
            userId = self.Data[Cell.tag].fromUser!.userId
        }else{
            userId = self.Data[Cell.tag].toUser!.userId
        }
        if userId == KCSUser.activeUser().userId {
            Cell.followButton.hidden = true
        }else{
            Cell.followButton.hidden = false
        }
        
        Cell.label.attributedText = finalString
        Cell.label.addLinkToURL(url, withRange: NSRange(location: 0,length: finalString.length))
        Cell.label.attributedText = finalString


        Cell.followButton.initialize(self.Data[Cell.tag].followManager.loaded, isFollowing: self.Data[Cell.tag].followManager.isFollowing)
        Cell.followButton.addTarget(self, action: "follow:", forControlEvents: UIControlEvents.TouchUpInside)
        let rec = UITapGestureRecognizer(target: self, action: "pushUser:")
        Cell.profileImageView.tag = indexPath.row
        Cell.profileImageView.addGestureRecognizer(rec)
        
        return Cell
    }
    
    func follow(sender:ActivityFollowButton){
        print("follow pressed \(sender.superview!.superview!.tag)")
        self.Data[sender.superview!.superview!.tag].followManager.button = sender
        self.Data[sender.superview!.superview!.tag].followManager.Follow()
    }
    func attributedLabel(label: TTTAttributedLabel!, didSelectLinkWithURL url: NSURL!) {
        let view = UIView()
        view.tag = label.tag
        let rec = UITapGestureRecognizer()
        view.addGestureRecognizer(rec)
        pushUser(view.gestureRecognizers![0] as! UITapGestureRecognizer)
        
    }
    
    func pushUser(sender:UITapGestureRecognizer){
        let tag = sender.view!.tag
        var user:KCSUser!
        if (Target == "Followers"){
            user = Data[tag].fromUser
        }else if (Target == "Following"){
            user = Data[tag].toUser
        }else if (Target == "Likers"){
            user = Data[tag].fromUser
        }else if (Target == "Accepted"){
            user = Data[tag].fromUser
        }else if (Target == "Maybe"){
            user = Data[tag].fromUser
        }else if (Target == "Invited"){
            user = Data[tag].fromUser
        }else if (Target == "Shares"){
            user = Data[tag].fromUser
        }
        if (user.userId == KCSUser.activeUser().userId){
            //clicked on myself
            let VC:MyProfileViewController = self.storyboard?.instantiateViewControllerWithIdentifier("MyProfileViewController") as! MyProfileViewController
            self.navigationController?.pushViewController(VC, animated: true)
            
        }else{
            //clicked on someone else
            let VC:UserProfileViewController = self.storyboard?.instantiateViewControllerWithIdentifier("UserProfileViewController") as! UserProfileViewController
            VC.user = user
            self.navigationController?.pushViewController(VC, animated: true)
            
        }
    }
}
