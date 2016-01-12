//
//  InvitePeopleViewController.swift
//  Eventer
//
//  Created by Grisha on 07/04/2015.
//  Copyright (c) 2015 Grisha. All rights reserved.
//

import UIKit

//now some skilled protocolz shet
protocol InvitePeopleViewControllerDelegate{
//    func didAddOrRemoveInvitedPeople(controller:InvitePeopleViewController,InvitedUsers:NSMutableArray)
    func dismissInvitedView()
}

class InvitePeopleViewController: UIViewController,UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate,UISearchControllerDelegate, UISearchBarDelegate,UISearchDisplayDelegate {
    var ScreenWidth = UIScreen.mainScreen().bounds.width
    var ScreenHeight = UIScreen.mainScreen().bounds.height
    //var navBar:UINavigationBar = UINavigationBar(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, 44))
    //var navItem:UINavigationItem = UINavigationItem(title: "Invite People")
    //!----Search----//
    //var searchbar: UISearchBar = UISearchBar(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, 20))
    
    var searchBar = UISearchBar()
    var tableView:UITableView = UITableView()
    var searchTableView:UITableView = UITableView()
    
    var Count:Int!
    
    var followers:[InviteUserUnit] = [] // all users
    var searchResultIndexes:[Int] = []
    var invitedPeople:[Int] = [] // invited ones

//    var followers:[InviteUserUnit] = [] // copy list, used for tableview, has key "isSelected"
    var searchResults:[InviteUserUnit] = [] //filtered results

    
    var delegate:InvitePeopleViewControllerDelegate! = nil
    var active = false
    var refreshButton = UIButton()
    var refreshIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadSubviews()
        loadUsers()
    }
    func back(){
        delegate.dismissInvitedView()
    }
    func clear(){
        dispatch_async(dispatch_get_main_queue()) {
            () -> Void in
            self.invitedPeople = []
            for follower in self.followers {
                follower.isSelected = false
            }
            self.tableView.reloadData()
            self.searchTableView.reloadData()
        }

    }
    func loadSubviews(){
        navigationController!.navigationBar.barStyle = UIBarStyle.Black
        navigationController!.navigationBar.barTintColor = UIColor.blackColor()
        navigationController!.navigationBar.tintColor = UIColor.whiteColor()

        let titleLabel:UILabel = UILabel()
        titleLabel.numberOfLines = 1
        titleLabel.text = "INVITE PEOPLE"
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.textAlignment = NSTextAlignment.Center
        titleLabel.font = UIFont(name: "Lato-Semibold", size: 18)
        self.navigationItem.titleView = titleLabel
        titleLabel.sizeToFit()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "DONE", style: UIBarButtonItemStyle.Plain, target: self, action: "back")
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "CLEAR", style: UIBarButtonItemStyle.Plain, target: self, action: "clear")

        self.view.addSubview(tableView)
        self.view.addSubview(searchTableView)
        self.view.addSubview(searchBar)
        //self.view.addSubview(refreshButton)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        searchBar.translatesAutoresizingMaskIntoConstraints = false
        //refreshButton.translatesAutoresizingMaskIntoConstraints = false
        let views = [
            "tableView" : tableView,
            //"refreshButton": refreshButton,
            "searchBar": searchBar
        ]
        
        let H_Constraints0 = NSLayoutConstraint.constraintsWithVisualFormat("H:|[searchBar]|", options: [NSLayoutFormatOptions.AlignAllCenterY, NSLayoutFormatOptions.AlignAllTop, NSLayoutFormatOptions.AlignAllBottom], metrics: nil, views: views)
        let H_Constraints1 = NSLayoutConstraint.constraintsWithVisualFormat("H:|[tableView]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views)
        let V_Constraints0 = NSLayoutConstraint.constraintsWithVisualFormat("V:|[searchBar(50)][tableView(>=0@999)]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views)
        self.view.addConstraints(H_Constraints0)
        self.view.addConstraints(H_Constraints1)
        self.view.addConstraints(V_Constraints0)
        
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
        self.searchTableView.frame = self.tableView.frame
        self.searchTableView.hidden = true
        //self.edgesForExtendedLayout = UIRectEdge.None // fixes searchbar autoresize after pressed

        // search Bar
        searchBar.backgroundColor = ColorFromCode.tabBackgroundColor()
        searchBar.backgroundImage = UIImage()
        searchBar.placeholder = "People that follow you."
        searchBar.delegate = self
        searchBar.enablesReturnKeyAutomatically = false
        
        // Set tableViews
        tableView.registerClass(InvitePeopleTableViewCell.self, forCellReuseIdentifier: "User Cell")
        tableView.tableFooterView = UIView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 50, bottom: 0, right: 5) // move separator line
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        tableView.estimatedRowHeight = 100
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.tag = 0
        
        searchTableView.registerClass(InvitePeopleTableViewCell.self, forCellReuseIdentifier: "User Cell")
        searchTableView.tableFooterView = UIView()
        searchTableView.delegate = self
        searchTableView.dataSource = self
        searchTableView.allowsSelection = false
        searchTableView.separatorInset = UIEdgeInsets(top: 0, left: 50, bottom: 0, right: 5) // move separator line
        searchTableView.tag = 1
        searchTableView.separatorStyle = UITableViewCellSeparatorStyle.None
        searchTableView.estimatedRowHeight = 100
        searchTableView.rowHeight = UITableViewAutomaticDimension
        // Activity Indicator
        refreshIndicator.hidesWhenStopped = true
        self.tableView.addSubview(refreshIndicator)
        refreshIndicator.center = CGPointMake(tableView.frame.width/2,tableView.frame.height/2-50)
        refreshIndicator.startAnimating()
        
    }
//    func updateSearchResultsForSearchController(searchController: UISearchController) {
//        NSString *searchString = searchController.searchBar.text;
//        [self searchForText:searchString scope:searchController.searchBar.selectedScopeButtonIndex];
//        [self.tableView reloadData];
//    }
    func endEditing(){
        self.view.endEditing(true)
    }
    func loadUsers(){
        let query = KCSQuery(onField: "toUser._id", withExactMatchForValue: KCSUser.activeUser().userId)
        query.addQueryOnField("type", withExactMatchForValue: "follow")
        query.addQueryOnField("content", withExactMatchForValue: "accepted")
        ActivityManager.getUsersByQuery(query) {
            (downloadedData:[FetchedActivityUnit]!, error:NSError!) -> Void in
            self.refreshIndicator.stopAnimating()
            if error == nil {
                print("\(downloadedData.count) users follow you")
                for unit in downloadedData {
                    self.followers.append(InviteUserUnit(forUser: unit.fromUser!))
                }
                
                //Sort alphabetically
                self.followers.sortInPlace({
                    $0.username > $1.username
                })
                
//                for (index,_) in self.followers.enumerate() {
//                    ActivityManager.loadPictureForInvitedUser(&self.followers[index], row: index, completionHandler: {
//                        (row:Int, error:NSError!) -> Void in
//                        if (error == nil){
//                            
//                            // show data
//                            var cells:[InvitePeopleTableViewCell] = []
//                            if self.tableView.hidden == false {
//                                cells = self.tableView.visibleCells as! [InvitePeopleTableViewCell]
//                                for cell in cells {
//                                    if cell.tag == row {
//                                        cell.UpdatePictures(self.followers[row], row: row)
//                                    }
//                                }
//                            } else {
//                                cells = self.searchTableView.visibleCells as! [InvitePeopleTableViewCell]
//                                for cell in cells {
//                                    for number in self.searchResultIndexes {
//                                        if number == row { // if loaded picture applies to someone in searchlist, then take the number followers[number]
//                                            if number == cell.tag {
//                                                cell.UpdatePictures(self.followers[number], row: number)
//                                            }
//                                        }
//                                    }
//                                    if cell.tag == row {
//                                        cell.UpdatePictures(self.followers[row], row: row)
//                                    }
//                                }
//                            }
//                        }
//                    })
//                }
                //just for tableview
                
//                self.followers = self.followers
                self.tableView.reloadData()
            } else {
                print(error.description)
            }
        }

    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (tableView == searchTableView){
            //println("2")
            return searchResultIndexes.count
        }else if (tableView == tableView){
            //println("3")
            return followers.count
        }else{
            return 0
        }
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var username:String!
        var fullname:String!
        var searchCell = false
        if (tableView.tag == 1){ //search results
            searchCell = true
            username = followers[searchResultIndexes[indexPath.row]].username
            fullname = followers[searchResultIndexes[indexPath.row]].fullname
        }else{
            username = followers[indexPath.row].username
            fullname = followers[indexPath.row].fullname
        }
        
        
        
        let Cell:InvitePeopleTableViewCell = tableView.dequeueReusableCellWithIdentifier("User Cell", forIndexPath: indexPath) as! InvitePeopleTableViewCell
        if searchCell {
            Cell.tag = searchResultIndexes[indexPath.row]
        } else {
            Cell.tag = indexPath.row
        }

        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 1
        
        var attrs = [NSFontAttributeName : Cell.usernameFont!, NSForegroundColorAttributeName: ColorFromCode.colorWithHexString("#9A9A9A")]
        let usernameString = NSMutableAttributedString(string: username, attributes:attrs)
        
        let finalString = NSMutableAttributedString()
        if (fullname != "") && (fullname != nil){
            attrs = [NSFontAttributeName : Cell.fullnameFont!, NSForegroundColorAttributeName: ColorFromCode.orangeFollowColor()]
            let fullnameString = NSMutableAttributedString(string: "\(fullname)\n", attributes:attrs)
            finalString.appendAttributedString(fullnameString)
        }
        finalString.appendAttributedString(usernameString)
        finalString.addAttribute(NSParagraphStyleAttributeName, value:paragraphStyle, range:NSMakeRange(0, finalString.length))
        
        
        if searchCell {
            Cell.UpdatePictures(self.followers[Cell.tag], row: Cell.tag)
            ActivityManager.loadPictureForInvitedUser(&followers[Cell.tag], row: Cell.tag, completionHandler: {
                (row:Int, error:NSError!) -> Void in
                if (error == nil){
                    Cell.UpdatePictures(self.followers[self.searchResultIndexes[row]], row: row)
                }
            })
        } else {
            Cell.UpdatePictures(self.followers[Cell.tag], row: Cell.tag)
            ActivityManager.loadPictureForInvitedUser(&self.followers[Cell.tag], row: Cell.tag, completionHandler: {
                (row:Int, error:NSError!) -> Void in
                if (error == nil){
                    Cell.UpdatePictures(self.followers[row], row: row)
                }
            })
        }
        
        Cell.label.attributedText = finalString
        Cell.displaySelected(followers[Cell.tag].isSelected, animated: false)
        
        let rec = UITapGestureRecognizer(target: self, action: "selectUser:")
        Cell.userInteractionEnabled = true
        Cell.addGestureRecognizer(rec)
        
        return Cell

    }
    
    func selectUser(sender:UITapGestureRecognizer){
        let Cell = sender.view as! InvitePeopleTableViewCell
        let index:Int = Cell.tag
        
        followers[index].isSelected = !followers[index].isSelected
        if followers[index].isSelected {
            invitedPeople.append(index)
        } else {
            for (idx,number) in invitedPeople.enumerate() {
                if number == index {
                    invitedPeople.removeAtIndex(idx)
                }
            }
        }
        Cell.displaySelected(followers[index].isSelected, animated: true)
        if Cell.superview!.superview!.tag == 1 {
            let cells = tableView.visibleCells as! [InvitePeopleTableViewCell]
            for cell in cells {
                if cell.tag == index {
                    cell.displaySelected(followers[index].isSelected, animated: true)
                }
            }
        }
    }


    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        self.endEditing()
    }
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        if (searchText.characters.count == 0){
            self.tableView.hidden = false
            self.searchTableView.hidden = true
        }else{
            if searchTableView.hidden == true {
                self.tableView.hidden = true
                self.searchTableView.hidden = false
            }
            filterContentsForSearch(searchText)
        }
    }

    func filterContentsForSearch(searchString:String){
//        self.searchResults = followers.filter( { (unit: InviteUserUnit) -> Bool in
//            return unit.username.containsString(searchString) || unit.fullname.containsString(searchString)
//        })
//        print("\(searchResults.count)")
        searchResultIndexes = []
        for (index,follower) in followers.enumerate() {
            if follower.username.containsString(searchString.lowercaseString) || follower.fullname.containsString(searchString) {
                searchResultIndexes.append(index)
            }
        }
        self.searchTableView.reloadData()
        
    }
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.endEditing(true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func BackButtonPressed(){
        self.dismissViewControllerAnimated(true, completion: nil)
    }

    
}
