//
//  MentionsViewController.swift
//  Eventer
//
//  Created by Grisha on 15/04/2015.
//  Copyright (c) 2015 Grisha. All rights reserved.
//

import UIKit
protocol MentionsViewControllerDelegate{
    func didChooseUser(controller:MentionsViewController,Username:String,textRange:NSRange)
}

class MentionsViewController: UIViewController,UITableViewDelegate, UITableViewDataSource {

    var delegate:MentionsViewControllerDelegate! = nil
    var textRange:NSRange! // range we looking at
    
    var filterString:NSString!
    var firstLetterOfString:NSString!
    var previousFirstLetterOfString:NSString!
    
    var users:[FetchedUser] = []  //always declare like that or it will crash
    
    var filteredUsers:[FetchedUser] = [] //always declare like that or it will crash
    
    var tableView:UITableView = UITableView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.height))
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(tableView)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        self.tableView.allowsSelection = false
        self.tableView.registerClass(UserListViewCell.self, forCellReuseIdentifier: "User Cell")
        self.previousFirstLetterOfString = ""
        self.tableView.frame.size = self.view.frame.size
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func Load_User_List(){
        //first letter, let's load all users starting from it
        if (filterString.isEqualToString("")){
            print("Empty string")
            firstLetterOfString = ""
            previousFirstLetterOfString = firstLetterOfString
            //Load_Users()
        }else if (filterString.length == 1){
            firstLetterOfString = filterString.substringToIndex(1)
            if (firstLetterOfString == previousFirstLetterOfString){ //filter same list
                filterContentsForSearch(filterString as String)
                self.tableView.reloadData()
                print("Filter Users")
            }else{ //refresh and get another users
                print("Load Users")
                loadUsers()
            }
            previousFirstLetterOfString = firstLetterOfString
        }else{
            firstLetterOfString = filterString.substringToIndex(1)
            if (firstLetterOfString == previousFirstLetterOfString){ //filter same list
                print("Filter Users")
                filterContentsForSearch(filterString as String!)
            }else{ //refresh and get another users
                loadUsers()
                print("Load Users")
            }
            previousFirstLetterOfString = firstLetterOfString

        }

    }
    var lastRequest:KCSRequest = KCSRequest()
    func loadUsers(){
//        var tempArray:NSMutableArray = NSMutableArray()
//        var tempPictures:NSMutableArray = NSMutableArray()
        
        lastRequest.cancel()
//        ActivityManager.getUserIdsOfPeopleYouFollow {
//            (regexString:String!, error:NSError!) -> Void in
//            if error == nil {
//                ActivityManager.searchUsersByRegexAndUsername(regexString, containsString: self.filterString as String, request: &self.lastRequest, users: &self.users, handler: {
//                    (error:NSError!) -> Void in
//                    if error == nil {
//                        self.tableView.reloadData()
//                    } else {
//                        print(error.description)
//                    }
//                }, progressHandler: {
//                    (imageAtIndexUpdated:Int) -> Void in
//                    let cells = self.tableView.visibleCells
//                    for cell in cells{
//                        if (cell.tag == imageAtIndexUpdated){
//                            dispatch_async(dispatch_get_main_queue(), {
//                                () -> Void in
//
//                            })
//                            
////                            dispatch_async(dispatch_get_main_queue(), {
////                                () -> Void in
////                                (cell as! UserListViewCell).UpdatePictures(self.users[imageAtIndexUpdated], row: imageAtIndexUpdated, option: FileDownloadOption.toUserPicture)
////                            })
//                        }
//                    }
//                })
//            } else {
//                
//            }
//        }
//        ActivityManager.getUsersByQuery(query, completionHandler: {
//            (downloadedData:[FetchedActivityUnit]!, error:NSError!) -> Void in
//            if (error == nil){
//                self.users = downloadedData
//                
//                // load pics
//                for (index,object) in enumerate(self.users){
//                    ActivityManager.loadPictureForActivity(&self.users[index], row: index, option: FileDownloadOption.toUserPicture,completionHandler: {
//                        (row:Int, error:NSError!) -> Void in
//                        var cells = self.tableView.visibleCells()
//                        for cell in cells{
//                            if (cell.tag == index){
//                                (cell as! UserListViewCell).UpdatePictures(self.Data[index], row: row, option: self.option)
//                            }
//                        }
//                    })
//                }
//            }else{
//                println("Error: " + error.description)
//            }
//        })
//
//            store.queryWithQuery(
//            query,
//            withCompletionBlock: {
//                (objects: [AnyObject]!, error: NSError!) -> Void in
//                if (error == nil){
//                    var FollowEntities = objects as! [FollowEntity]
//                    
//                    for entity in FollowEntities{
//                        tempArray.addObject(entity.toUser!)
//                    }
//                    
//                    //Sort alphabetically
//                    var AlphabetOrder:NSSortDescriptor = NSSortDescriptor(key: "username", ascending: false)
//                    var Array:NSArray = NSArray(object: AlphabetOrder)
//                    tempArray.sortedArrayUsingDescriptors(Array as [AnyObject])
//                    
//                    for entity in tempArray {
//                        var user:KCSUser = (entity as! KCSUser)
//                        tempPictures.addObject(user.getValueForAttribute("picture") as! UIImage)
//                    }
//                    
//                    self.users = tempArray
//                    self.UserPictures = tempPictures
//                    
//                    self.filteredUsers = tempArray
//                    self.FilteredUserPictures = tempPictures
//                    self.filterContentsForSearch(self.filterString as! String)
//                    
//                }else{
//                    println("error" + error.description)
//                }
//                
//            },
//            withProgressBlock: nil
//        )
    }
    func filterContentsForSearch(searchString:String){
        let tempArray:[FetchedUser] = users
        
        let filteredArray = tempArray.filter {
            (user) -> Bool in
            (user.user.username as NSString).containsString(searchString) ||
            (user.user.givenName as NSString).containsString(searchString)
        }
        
        filteredUsers = filteredArray
        
        print("\(filteredUsers.count)")
        self.tableView.reloadData()
        
    }
    

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredUsers.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let Cell:UserListViewCell = self.tableView.dequeueReusableCellWithIdentifier("User Cell", forIndexPath: indexPath) as! UserListViewCell
        Cell.tag = indexPath.row
//        let username:String!
//        let fullname:String!

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 1
//        
//        var attrs = [NSFontAttributeName : Cell.usernameFont!, NSForegroundColorAttributeName: ColorFromCode.colorWithHexString("#9A9A9A")]
//        let usernameString = NSMutableAttributedString(string: username, attributes:attrs)
//        
//        let finalString = NSMutableAttributedString()
//        if (fullname != "") && (fullname != nil){
//            attrs = [NSFontAttributeName : Cell.fullnameFont!, NSForegroundColorAttributeName: ColorFromCode.colorWithHexString("#0087D9")]
//            let fullnameString = NSMutableAttributedString(string: "\(fullname)\n", attributes:attrs)
//            finalString.appendAttributedString(fullnameString)
//        }
//        finalString.appendAttributedString(usernameString)
//        finalString.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, finalString.length))
////        
//        ActivityManager.loadPictureForActivity(&self.filteredUsers[Cell.tag], row: Cell.tag, option: FileDownloadOption.toUserPicture, completionHandler: {
//            (row:Int, error:NSError!) -> Void in
//            if (error == nil){
//                Cell.UpdatePictures(self.filteredUsers[row], row: row, option: FileDownloadOption.toUserPicture)
//            }
//        })
        //Cell.UpdatePictures(self.filteredUsers[Cell.tag], row: Cell.tag, option: FileDownloadOption.toUserPicture)

        Cell.followButton.hidden = true
        
//        Cell.label.attributedText = finalString
        
        let rec = UITapGestureRecognizer(target: self, action: #selector(selectUser(_:)))
        Cell.addGestureRecognizer(rec)
        return Cell
    }
    
    func selectUser(sender:UITapGestureRecognizer) {
        let tag = sender.view!.tag
        let username:NSString = filteredUsers[tag].username
        delegate.didChooseUser(self, Username: username as String, textRange: self.textRange)
    }


}
