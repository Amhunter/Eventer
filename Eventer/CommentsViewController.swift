//
//  CommentsViewController.swift
//  Eventer
//
//  Created by Grisha on 10/04/2015.
//  Copyright (c) 2015 Grisha. All rights reserved.
//

import UIKit

class CommentsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource,UITextViewDelegate, MentionsViewControllerDelegate , HashtagsViewControllerDelegate,TTTAttributedLabelDelegate, UIGestureRecognizerDelegate, UIScrollViewDelegate {
    var screenWidth = UIScreen.mainScreen().bounds.width
    var screenHeight = UIScreen.mainScreen().bounds.height
    
    var viewFrame:CGRect = CGRect()

    var tableView:UITableView = UITableView()
    //Toolbar
    var PostCommentView:UIView = UIView()
    var InputTextView:CommentTextView = CommentTextView(frame: CGRectMake(10, 10, 240, 30))
    var postButton:UIButton = UIButton(frame: CGRectMake(260,10,50,30))
    var CurrentKeyboardHeight:CGFloat = CGFloat() // crucial
    var KeyBoardActive:Bool! // when app becomes active from background , it's somewhy resizes view.frame, that's why we ll put it back

    
    var PreviousHeight:CGFloat!
    var PreviousNumberOfLines:CGFloat = CGFloat()
    var shownComments:Int! // how many comments to skip in order to
    var NotAllCommentsShown:Bool!

    var event:FetchedEvent!
    var Comments:[FetchedActivityUnit] = []
    var end:Bool = false // all comments loaded
    
    var mainView = UIView()//just to replace self.view in order to fix bug
    var loadMoreView = TableFooterRefreshView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, 50))
    var MVC:MentionsViewController!
    var HVC:HashtagsViewController!
    var indicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
    var errorButton = UIButton()
    var scrollOffsetY:CGFloat = 0
    override func viewDidLoad() {
        super.viewDidLoad()

        setSubviews()
        loadComments()

    }
    override func viewWillAppear(animated: Bool) {
        self.Add_Keyboard_Observers()
        (self.tabBarController as! TabBarViewController).setTabBarVisible(false, animated: true)

    }
    func back(){
        self.navigationController!.popViewControllerAnimated(true)
    }
    func setSubviews(){
        self.view.frame.size.height = screenHeight - self.navigationController!.navigationBar.frame.height - UIApplication.sharedApplication().statusBarFrame.height
        mainView.frame = self.view.frame
        self.view.addSubview(mainView)
        
        let backButton = UIBarButtonItem(image: UIImage(named: "back.png"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(back))
        backButton.tintColor = UIColor.whiteColor()
        if (self.navigationController!.viewControllers.count > 1){
            self.navigationItem.leftBarButtonItem = backButton
        }
        
        let titleLabel:UILabel = UILabel()
        titleLabel.numberOfLines = 1
        titleLabel.text = "Comments"
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.textAlignment = NSTextAlignment.Center
        titleLabel.font = UIFont(name: "Lato-Semibold", size: 18)
        self.navigationItem.titleView = titleLabel
        titleLabel.sizeToFit()
//        var offset = self.navigationController!.navigationBar.frame.height + UIApplication.sharedApplication().statusBarFrame.height
        
        
        InputTextView.frame.size.height = InputTextView.sizeThatFits(CGSizeMake(InputTextView.frame.size.width, 200)).height
        PostCommentView.frame = CGRectMake(0, mainView.frame.height-50, screenWidth, InputTextView.frame.height+20)
        tableView.frame = CGRectMake(0, 0, screenWidth, mainView.frame.height-50)

        
        self.mainView.addSubview(tableView)
        self.mainView.addSubview(PostCommentView)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.autoresizesSubviews = true
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        self.tableView.registerClass(CommentTableViewCell.self, forCellReuseIdentifier: "Comment Cell")
        self.tableView.allowsSelection = false
        self.tableView.estimatedRowHeight = 100
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.addSubview(indicator)
        indicator.center = tableView.center
        indicator.hidesWhenStopped = true
        indicator.startAnimating()
  
    
        
        self.tableView.addSubview(errorButton)
        errorButton.setImage(UIImage(named: "refresh")!, forState: UIControlState.Normal)
        errorButton.center = tableView.center
        
        

        loadMoreView.button.addTarget(self, action: #selector(loadMoreComments), forControlEvents: UIControlEvents.TouchUpInside)
        loadMoreView.button.setTitle("Load more comments", forState: UIControlState.Normal)
        loadMoreView.button.frame.size.height = 37.5
        loadMoreView.button.center = loadMoreView.center

        loadMoreView.stopAnimating(false)
        //!---------Setting PostCommentView---------------------//
        self.KeyBoardActive = false
        PostCommentView.addSubview(InputTextView)
        PostCommentView.addSubview(postButton)
        PostCommentView.backgroundColor = UIColor.groupTableViewBackgroundColor()
        InputTextView.scrollEnabled = false
        postButton.backgroundColor = UIColor.whiteColor()
        postButton.layer.cornerRadius = 3
        InputTextView.delegate = self
        
        //placeholder hack for uitextview
        PreviousNumberOfLines = InputTextView.contentSize.height / InputTextView.font!.lineHeight
        
        //resize everything according textview height

        postButton.frame.size.height = InputTextView.frame.size.height
//        let yOffset:CGFloat = 10
//        var twiceYoffset = yOffset*2
        postButton.setTitle("Send", forState: UIControlState.Normal)
        postButton.setTitleColor(ColorFromCode.colorWithHexString("#0087D9"), forState: UIControlState.Normal)
        postButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Highlighted)
        postButton.backgroundColor = ColorFromCode.colorWithHexString("#EBF0F2")
        postButton.titleLabel!.font = UIFont(name: "Lato-Semibold", size: 14)
        postButton.layer.cornerRadius = 5
        postButton.addTarget(self, action: #selector(postComment), forControlEvents: UIControlEvents.TouchUpInside)
        //----------Setting PostCommentView---------------------//
        
        
        //!----Container view for Mentions------------------------//
        self.MVC = self.storyboard?.instantiateViewControllerWithIdentifier("MentionsView") as! MentionsViewController
        
        self.addChildViewController(MVC)
        self.MVC.didMoveToParentViewController(self)
        self.MVC.delegate = self
        self.view.addSubview(MVC.view)
        self.MVC.view.frame = self.tableView.frame
        self.MVC.view.hidden = true
        //--------------------------------------------------------//
        
        //!----Container view for Hashtags------------------------//
        self.HVC = self.storyboard?.instantiateViewControllerWithIdentifier("HashtagsView") as! HashtagsViewController
        
        self.addChildViewController(HVC)
        self.HVC.didMoveToParentViewController(self)
        self.HVC.delegate = self
        self.view.addSubview(HVC.view)
        self.HVC.view.frame = self.tableView.frame
        self.HVC.view.hidden = true
        //--------------------------------------------------------//
        
        let TapRecognizer:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(HideKeyboard))
        TapRecognizer.delegate = self
        self.mainView.addGestureRecognizer(TapRecognizer)

    }
    func loadComments(){
        ActivityManager.loadComments(nil, event: event.eventOriginal, limit: 15, handler: {
            (data:[FetchedActivityUnit]!, error:NSError!) -> Void in
            self.indicator.stopAnimating()
            if error == nil {
                self.errorButton.removeFromSuperview()
                var temp = data
                
                self.end = !(temp.count > 15)
                self.showLoadMoreView(!self.end)
                if temp.count > 15 {
                    temp.removeLast()
                }

                self.Comments = Array(temp.reverse())

                for (index,_) in self.Comments.enumerate() {
                    ActivityManager.loadPictureForActivity(&self.Comments[index], row: index, option: FileDownloadOption.fromUserPicture, completionHandler: {
                        (row:Int, error:NSError!) -> Void in
                        let cells = self.tableView.visibleCells as! [CommentTableViewCell]
                        for cell in cells{
                            if (cell.tag == index){
                                cell.UpdateProfilePicture(self.Comments[index].fromUserProfilePictureID as String,
                                    progress: self.Comments[index].fromUserPictureProgress, image: self.Comments[index].fromUserProfilePicture, row: index)
                            }
                        }
                    })
                }
                
                self.tableView.reloadData()
                //self.tableView.scrollToRowAtIndexPath(NSIndexPath(forRow: self.Comments.count-1, inSection: 0), atScrollPosition: UITableViewScrollPosition.Bottom, animated: false)
            }else{
                self.tableView.addSubview(self.errorButton)
                print(error.description)
            }
        })
    }
    
    func showLoadMoreView(show:Bool){
        if show {
            tableView.tableHeaderView = self.loadMoreView
        } else {
            tableView.tableHeaderView = nil
        }
    }
    
    func loadMoreComments(){
        self.loadMoreView.startAnimating()
        ActivityManager.loadComments(Comments[0], event: event.eventOriginal, limit: 15, handler: {
            (data:[FetchedActivityUnit]!, error:NSError!) -> Void in
            self.indicator.stopAnimating()
            if error == nil {
                self.errorButton.removeFromSuperview()
                var temp = data
                
                self.end = !(temp.count > 15)
                self.showLoadMoreView(!self.end)
                self.loadMoreView.stopAnimating(self.end)
                if temp.count > 15 {
                    temp.removeLast()
                }
                self.Comments = Array(temp.reverse()) + self.Comments
                
                for (index,_) in self.Comments.enumerate() {
                    ActivityManager.loadPictureForActivity(&self.Comments[index], row: index, option: FileDownloadOption.fromUserPicture, completionHandler: {
                        (row:Int, error:NSError!) -> Void in
                        let cells = self.tableView.visibleCells as! [CommentTableViewCell]
                        for cell in cells{
                            if (cell.tag == index){
                                cell.UpdateProfilePicture(self.Comments[index].fromUserProfilePictureID as String,
                                    progress: self.Comments[index].fromUserPictureProgress, image: self.Comments[index].fromUserProfilePicture, row: index)
                            }
                        }
                    })
                }
                
                self.tableView.reloadData()
            }else{
                self.tableView.addSubview(self.errorButton)
                self.loadMoreView.stopAnimating(false)
                print(error.description)
            }
        })
    }
    func Reload_Comments(){ //not all but all the pages which are shown
//        var tempComments:NSMutableArray = NSMutableArray()
//        var tempCommentors:NSMutableArray = NSMutableArray()
//        var tempCommentorsPictures:NSMutableArray = NSMutableArray()
//        var FindDataQuery:PFQuery = PFQuery(className: "Activity", predicate: NSPredicate(format: "Type == %@ AND event == %@", "Comment", self.event))
//        FindDataQuery.includeKey("fromUser")
//        FindDataQuery.addDescendingOrder("createdAt")
//        FindDataQuery.limit = shownComments
//        FindDataQuery.findObjectsInBackgroundWithBlock {
//            (objects:[AnyObject]!, error:NSError!) -> Void in
//            if (error == nil){
//                for object in objects {
//                    tempComments.addObject(object as PFObject)
//                    tempCommentors.addObject(object["fromUser"] as PFObject) //this is retrieved object from class User
//                    var Author:PFObject = object["fromUser"] as PFObject
//                    let ImageFile:PFFile = Author["picture"] as PFFile
//                    tempCommentorsPictures.addObject(UIImage(data: ImageFile.getData())!) //synchronous , bad
//                }
//                
//                if objects.count > 10{
//                    self.NotAllCommentsShown = true
//                    self.shownComments = self.shownComments + 10
//                    tempComments.removeLastObject()
//                    tempCommentorsPictures.removeLastObject()
//                    tempCommentors.removeLastObject()
//                }else{
//                    self.NotAllCommentsShown = false
//                    self.shownComments = self.shownComments + objects.count
//                }
//                self.Comments.addObjectsFromArray(tempComments)
//                self.Commentors.addObjectsFromArray(tempCommentors)
//                self.CommentorsPictures.addObjectsFromArray(tempCommentorsPictures)
//                
//                println("Loaded \(self.shownComments)")
//                self.Set_Comments()
//                
//            }else{
//                println("\(error.description)")
//                
//            }
//        }
    }

    
    func postComment(){
        //println(InputTextView.isEmpty)
        
        let comment:ActivityUnit = ActivityUnit()
        comment.entityId = ""
        comment.event = event.eventOriginal
        comment.fromUser = KCSUser.activeUser()
        comment.type = "comment"
        comment.content = InputTextView.text
        comment.toUser = event.author
        let commentRendered = FetchedActivityUnit(fromUnit: comment)
        commentRendered.createdAtText = DateToStringConverter.getCreatedAtString(NSDate(), tab: TargetView.Explore)
        Comments.append(commentRendered)
        let insertedIndex = Comments.count-1
        self.tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: insertedIndex, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Automatic)

        if (InputTextView.isEmpty == false){
            self.postButton.enabled = false
            self.view.endEditing(true) // will hide keyboard, works like switch
            
            ActivityManager.postComment(InputTextView.text, event: self.event, handler: {
                (object:FetchedActivityUnit! ,error:NSError!) -> Void in
                if error == nil {
                    print("saved")
                    self.postButton.enabled = true

                    self.Comments.last?.entityId = object.entityId
                    self.Comments.last?.unit.entityId = object.entityId
                    //self.Comments[insertedIndex] = object
                } else {
                    self.postButton.enabled = true
                    self.tableView.deleteRowsAtIndexPaths([NSIndexPath(forRow: insertedIndex, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Automatic)
                    print("error" + error.description)
                }
            })
            
            self.InputTextView.text.removeAll(keepCapacity: false)
            self.Resize_TextView(self.InputTextView)
            self.InputTextView.putPlaceHolder()
//            let store = KCSLinkedAppdataStore.storeWithOptions([
//                KCSStoreKeyCollectionName : "Activity",
//                KCSStoreKeyCollectionTemplateClass : ActivityUnit.self
//                ])
//            
//            var comment:ActivityUnit = ActivityUnit()
//            comment.event = self.event.eventOriginal
//            comment.fromUser = KCSUser.activeUser()
//            comment.type = "comment"
//            comment.content = InputTextView.text
//            comment.toUser = self.event.author
//            
//            store.saveObject(comment, withCompletionBlock: {
//                (object:[AnyObject]!, error:NSError!) -> Void in
//                if (error == nil){
//                    println("saved")
//                    self.postButton.enabled = true
//                    self.InputTextView.text.removeAll(keepCapacity: false)
//                    self.Resize_TextView(self.InputTextView)
//                    self.InputTextView.putPlaceHolder()
//                    self.Reload_Comments()
//                }else{
//                    self.postButton.enabled = true
//                    println("error" + error.description)
//                }
//            }, withProgressBlock: nil)
        }
    }
    
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        if Comments[indexPath.row].fromUser!.userId == KCSUser.activeUser().userId {
            return true
        } else {
            return false
        }
        
    }
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == UITableViewCellEditingStyle.Delete {
            let comment = Comments[indexPath.row]
            self.Comments.removeAtIndex(indexPath.row)
            
            dispatch_async(dispatch_get_main_queue(), {
                () -> Void in
                tableView.beginUpdates()
                tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
                tableView.endUpdates()
            })

            ActivityManager.deleteComment(comment, handler: {
                (error:NSError!) -> Void in
                if error == nil {
                } else {
                    print(error.description)
                    tableView.beginUpdates()
                    self.Comments.insert(comment, atIndex: indexPath.row)
                    tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Automatic)
                    tableView.endUpdates()
                }
            })
        }
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Comments.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let Cell = tableView.dequeueReusableCellWithIdentifier("Comment Cell", forIndexPath: indexPath) as! CommentTableViewCell
        let rec = UITapGestureRecognizer(target: self, action: #selector(imagePressed(_:)))
        rec.delegate = self
        Cell.pictureImageView.addGestureRecognizer(rec)
        Cell.pictureImageView.tag = indexPath.row

        Cell.tag = indexPath.row
        Cell.userInteractionEnabled = true
        Cell.contentView.userInteractionEnabled = true
        Cell.createdAtLabel.text = Comments[indexPath.row].createdAtText
        Cell.UpdateProfilePicture(Comments[indexPath.row].fromUserProfilePictureID as String,
            progress: Comments[indexPath.row].fromUserPictureProgress, image: Comments[indexPath.row].fromUserProfilePicture, row: indexPath.row)
        let commentText = NSMutableAttributedString(string: Comments[indexPath.row].content as String, attributes: [NSFontAttributeName: Cell.textFont!])
        Utility.highlightHashtagsInString(commentText, withColor: ColorFromCode.randomBlueColorFromNumber(3), inLabel: Cell.commentLabel)
        Utility.highlightMentionsInString(commentText, withColor: ColorFromCode.randomBlueColorFromNumber(3), inLabel: Cell.commentLabel)
        Cell.commentLabel.delegate = self

        
        ActivityManager.loadPictureForActivity(&self.Comments[Cell.tag], row: Cell.tag, option: FileDownloadOption.fromUserPicture, completionHandler: {
            (row:Int, error:NSError!) -> Void in
            if (error == nil){
                Cell.UpdateProfilePicture(self.Comments[indexPath.row].fromUserProfilePictureID as String,
                    progress: self.Comments[indexPath.row].fromUserPictureProgress, image: self.Comments[indexPath.row].fromUserProfilePicture, row: row)
            }
        })

        // clickable author name
        let url:NSURL = NSURL(scheme: "pushUser", host: "", path: "/")!
        let usernameString = NSAttributedString(string: Comments[indexPath.row].fromUser!.username, attributes: [NSFontAttributeName: Cell.usernameFont!, NSForegroundColorAttributeName : ColorFromCode.randomBlueColorFromNumber(3)])
        Cell.usernameLabel.addLinkToURL(url, withRange:NSRange(location: 0,length: usernameString.length))
        Cell.usernameLabel.tag = indexPath.row
        Cell.usernameLabel.attributedText = usernameString
        Cell.usernameLabel.delegate = self

        return Cell

    }

    func attributedLabel(label: TTTAttributedLabel!, didSelectLinkWithURL url: NSURL!) {
        print("1")
        switch url.scheme {
        case "mention": pushUserByUsername(url.host!)
        case "hashtag": return
        case "pushUser": pushUserByUserObject(Comments[label.tag].fromUser!)
        default: return
        }
    }
    
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        return !(touch.view!.isKindOfClass(TTTAttributedLabel) || touch.view!.isKindOfClass(CommentTextView))
    }
    func imagePressed(sender: UITapGestureRecognizer){
        pushUserByUserObject(Comments[sender.view!.tag].fromUser!)
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
    func scrollViewDidScroll(scrollView: UIScrollView) {
//        println("scrolled: \(scrollView.contentOffset.y)")
        scrollOffsetY = scrollView.contentOffset.y
    }
    
    func Add_Keyboard_Observers(){
        //initial view frame
        //self.tabBarHeight = 0 //because here its hidden, we dont need its value
        //self.tabBarHeight = self.tabBarController?.tabBar.frame.height
        

        
        let TapRecognizer:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(HideKeyboard))
        TapRecognizer.cancelsTouchesInView = false
        self.view.addGestureRecognizer(TapRecognizer)
        
        //make trigger when keyboard displayed/changed
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        
        //when keyboard is hidden
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)


    }

    func HideKeyboard(){
        //self.view.endEditing(true) // will hide keyboard, works like switch
        self.InputTextView.resignFirstResponder()
        
    }
    
    func keyboardWillShow(notification: NSNotification) {
        let info:NSDictionary = notification.userInfo!
        let keyboardSize = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        let keyboardHeight:CGFloat = keyboardSize.height
        let movement:CGFloat = keyboardHeight
        
        self.CurrentKeyboardHeight = movement

        let animationDuration = (info[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
//        var futurePostCommentViewframe:CGRect = CGRectMake(0, self.view.frame.height-self.PostCommentView.frame.height-movement, PostCommentView.frame.width, PostCommentView.frame.height)
//        var futureTableViewframe:CGRect = CGRectMake(0, 0, self.view.frame.width,futurePostCommentViewframe.origin.y+self.navBarheight)
//        println("\(futurePostCommentViewframe.origin.y)")
        
        UIView.animateWithDuration(animationDuration, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            self.PostCommentView.frame.origin.y = self.mainView.frame.height-self.PostCommentView.frame.height-movement
            if (self.scrollOffsetY + movement < self.tableView.contentSize.height){
                self.scrollOffsetY += movement
                self.tableView.contentOffset.y = self.scrollOffsetY
            } else {
                self.tableView.contentOffset.y = self.tableView.contentSize.height - (self.mainView.frame.height-self.PostCommentView.frame.height-movement)
            }
            self.tableView.frame.size.height = self.mainView.frame.height-self.PostCommentView.frame.height-movement
        }, completion: nil)

    }
    
    func keyboardWillHide(notification: NSNotification) {
        let info:NSDictionary = notification.userInfo!
        let keyboardSize = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        let keyboardHeight:CGFloat = keyboardSize.height
        
        let movement:CGFloat = keyboardHeight

        self.CurrentKeyboardHeight = 0
        
        let animationDuration = (info[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        UIView.animateWithDuration(animationDuration, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            self.PostCommentView.frame.origin.y = self.mainView.frame.height-self.PostCommentView.frame.height
            if (self.scrollOffsetY - movement > 0){
                self.scrollOffsetY -= movement
            } else  {
                self.scrollOffsetY = 0
            }
            self.tableView.contentOffset = CGPointMake(0, self.scrollOffsetY)
            self.tableView.frame.size.height = self.mainView.frame.height-self.PostCommentView.frame.height
        }, completion: nil)

    }
    override func viewWillDisappear(animated: Bool) {
        (self.tabBarController as! TabBarViewController).setTabBarVisible(true, animated: false)
        HideKeyboard()
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)

    }


    func textViewDidBeginEditing(textView: UITextView) { //for placeholder
        if textView.textColor == UIColor.lightGrayColor() {
            textView.text = ""
            textView.textColor = UIColor.blackColor()
        }
    }

    func textViewDidChange(textView: UITextView) {
        if ((textView as! CommentTextView).text.isEmpty){
            (textView as! CommentTextView).isEmpty = true
            postButton.enabled = false
            (textView as! CommentTextView).newNumberOfLines = 1
        }else{
            (textView as! CommentTextView).isEmpty = false
            (textView as! CommentTextView).newNumberOfLines = textView.contentSize.height / textView.font!.lineHeight
            print((textView as! CommentTextView).newNumberOfLines)
            postButton.enabled = true
            detectHashtagsOrMentions((textView as! CommentTextView))
        }
        Resize_TextView((textView as! CommentTextView))

    }
    
    func Resize_TextView(textView:CommentTextView){
        let yOffset:CGFloat = 10
        let twiceYoffset = yOffset*2
        
        if (textView.newNumberOfLines < 6){
            let height:CGFloat = textView.sizeThatFits(CGSizeMake(textView.frame.size.width, 200)).height
            let PostCommentViewFrame = CGRectMake(0, self.mainView.frame.height-20-height-self.CurrentKeyboardHeight, self.screenWidth, height+twiceYoffset)
            let futureButtonOriginY:CGFloat = PostCommentViewFrame.height - self.postButton.frame.height - 10
            let futureTableViewHeight:CGFloat = PostCommentViewFrame.origin.y
            UIView.animateWithDuration(0.1, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
                self.InputTextView.setContentOffset(CGPointZero, animated: false)
                self.PostCommentView.frame = PostCommentViewFrame
                self.postButton.frame.origin.y = futureButtonOriginY
                self.tableView.frame.size.height = futureTableViewHeight
                self.resizeMentionView()
                self.resizeHashtagView()
                textView.frame.size.height = height
                
                }, completion: nil)
            textView.scrollEnabled = false
        }else{ //if 5 lines or more
            //scroll to bottom
            textView.scrollEnabled = true
            let bottomOffset:CGPoint = CGPointMake(0, textView.contentSize.height - textView.bounds.size.height)
            textView.setContentOffset(bottomOffset, animated: false)
        }
        
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        if textView.text.isEmpty {
            (textView as! CommentTextView).putPlaceHolder()
            postButton.enabled = false
        }else{
            (textView as! CommentTextView).isEmpty = false
            postButton.enabled = true
        }
    }
    
    func detectHashtagsOrMentions(textView:CommentTextView) {
        //identify the word we are on
        let insertionLocation:Int = textView.selectedRange.location
        let regex:NSRegularExpression = try! NSRegularExpression(pattern: "\\b[@#\\w]+\\b", options: NSRegularExpressionOptions.UseUnicodeWordBoundaries)
        var word:NSString = NSString()
        var range:NSRange = NSMakeRange(NSNotFound, 0)
        regex.enumerateMatchesInString(textView.text, options: [], range: NSMakeRange(0, (textView.text as NSString).length)) {
            (result:NSTextCheckingResult?, flags:NSMatchingFlags, stop:UnsafeMutablePointer<ObjCBool>) -> Void in
            if (result!.range.location <= insertionLocation && result!.range.location+result!.range.length >= insertionLocation){
                word = (textView.text as NSString).substringWithRange(result!.range)
                range = result!.range
                stop.memory = true
            }
        }
        
        
        // if word doesnt degenerate
        if (word.length >= 1 && range.location != NSNotFound){
            let first:NSString = word.substringToIndex(1) //
            let rest:NSString = word.substringFromIndex(1) //actual word
            range.location += 1  // to avoid replacing @ or #
            if (first.isEqualToString("@")){
                if (rest.length > 0){
                    //call our method and pass rest
                    self.MVC.textRange = range
                    self.MVC.filterString = rest
                    self.MVC.Load_User_List()
                    
                    self.showMentionView()
                    print("@")
                }else{
                    self.hideViews()
                }
            }else if (first.isEqualToString("#")){
                if (rest.length > 0){
                    //call our method and pass rest
                    self.HVC.textRange = range
                    self.HVC.filterString = rest
                    self.HVC.Load_Hashtags()
                    
                    self.showHashtagView()
                    print("@")
                }else{
                    self.hideViews()
                }
                print("#")
            }else{
                self.hideViews()
            }
            // else if didfinish word
            //println("\(self.tableView.frame.origin.y)"+"_"+"\(self.tableView	.frame.height)")

            //println("\(self.MentionsContainerView.frame.origin.y)"+"_"+"\(self.MentionsContainerView.frame.height)")
        }
        //source https://github.com/bogardon/GGHashtagMentionController/blob/master/GGHashtagMentionController/src/GGHashtagMentionController.m
    }
    func showMentionView(){ //dont ask why these rects, just a fix
        self.resizeMentionView()
        self.MVC.view.hidden = false
    }
    func resizeMentionView(){ //dont ask why these rects, just a fix
        self.MVC.view.frame = CGRectMake(0, topLayoutGuide.length, self.tableView.frame.width, self.PostCommentView.frame.origin.y-self.topLayoutGuide.length)
        self.MVC.tableView.frame.size = self.MVC.view.frame.size

    }
    
    func showHashtagView(){ //dont ask why these rects, just a fix
        self.resizeHashtagView()
        self.HVC.view.hidden = false
    }
    func resizeHashtagView(){ //dont ask why these rects, just a fix
        self.HVC.view.frame = CGRectMake(0, topLayoutGuide.length, self.tableView.frame.width, self.PostCommentView.frame.origin.y-self.topLayoutGuide.length)
        self.HVC.tableView.frame.size = self.MVC.view.frame.size
        
    }
    

    func hideViews(){
        self.MVC.view.hidden = true
        self.HVC.view.hidden = true
    }
    func didChooseUser(controller: MentionsViewController, Username: String, textRange:NSRange) {
        self.InputTextView.selectedRange = textRange
        self.InputTextView.replaceRange(InputTextView.selectedTextRange!, withText: Username+" ")
        //println("location \(textRange.location) and length = \(textRange.length)")
        self.tableView.hidden = false
        controller.view.hidden = true
    }
    func didChooseHashtag(controller: HashtagsViewController, Hashtag: String, textRange: NSRange) {
        self.InputTextView.selectedRange = textRange
        self.InputTextView.replaceRange(InputTextView.selectedTextRange!, withText: Hashtag+" ")
        //println("location \(textRange.location) and length = \(textRange.length)")
        self.tableView.hidden = false
        controller.view.hidden = true
    }	


}
