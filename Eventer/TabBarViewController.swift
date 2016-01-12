//
//  TabBarViewController.swift
//  Eventer
//
//  Created by Grisha on 01/12/2014.
//  Copyright (c) 2014 Grisha. All rights reserved.
//

import UIKit

class TabBarViewController: UITabBarController,UITabBarControllerDelegate,EventCreationNotificationDelegate {
    
    var homeButton:UIButton = UIButton()
    var homeButtonView:UIView = UIView()
    
    var exploreButton:UIButton = UIButton()
    var exploreButtonView:UIView = UIView()
    
    var createButton:UIButton = UIButton()
    var createButtonView:UIView = UIView()
    
    var activityButton:UIButton = UIButton()
    var activityButtonView:UIView = UIView()
    
    var profileButton:UIButton = UIButton()
    var profileButtonView:UIView = UIView()
    
    var tabBarView = UIView()
    var initialTabViewHeight:CGFloat = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(tabBarView)
//        var tabBarHeight = tabBar.frame.size.height
        initialTabViewHeight = self.view.frame.height
        tabBarView.translatesAutoresizingMaskIntoConstraints = false
        let metrics = [
            "height": tabBar.frame.size.height
        ]
        let TH_Constraints0 = NSLayoutConstraint.constraintsWithVisualFormat("H:|[tabBarView]|", options: [], metrics: nil, views: ["tabBarView" : tabBarView])
        let TV_Constraints0 = NSLayoutConstraint.constraintsWithVisualFormat("V:|->=0-[tabBarView(height@999)]|", options: [], metrics: metrics, views: ["tabBarView" : tabBarView])

        self.view.addConstraints(TH_Constraints0)
        self.view.addConstraints(TV_Constraints0)

        
        UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: UIStatusBarAnimation.None)

        homeButton.selected = true
        
        self.tabBarView.addSubview(homeButtonView)
        self.tabBarView.addSubview(exploreButtonView)
        self.tabBarView.addSubview(createButtonView)
        self.tabBarView.addSubview(activityButtonView)
        self.tabBarView.addSubview(profileButtonView)
        
        homeButtonView.translatesAutoresizingMaskIntoConstraints = false
        exploreButtonView.translatesAutoresizingMaskIntoConstraints = false
        createButtonView.translatesAutoresizingMaskIntoConstraints = false
        activityButtonView.translatesAutoresizingMaskIntoConstraints = false
        profileButtonView.translatesAutoresizingMaskIntoConstraints = false
        let views = [
            "home": homeButtonView,
            "explore": exploreButtonView,
            "create": createButtonView,
            "activity": activityButtonView,
            "profile": profileButtonView
        ]

        let H_Constraint0 = NSLayoutConstraint.constraintsWithVisualFormat("H:|[home(==explore)][explore(==create)][create(==activity)][activity(==profile)][profile(==home)]|", options: [], metrics: nil, views: views)
        let V_Constraint0 = NSLayoutConstraint.constraintsWithVisualFormat("V:|[home]|", options: [], metrics: metrics, views: views)
        let V_Constraint1 = NSLayoutConstraint.constraintsWithVisualFormat("V:|[explore]|", options: [], metrics: metrics, views: views)
        let V_Constraint2 = NSLayoutConstraint.constraintsWithVisualFormat("V:|[create]|", options: [], metrics: metrics, views: views)
        let V_Constraint3 = NSLayoutConstraint.constraintsWithVisualFormat("V:|[activity]|", options: [], metrics: metrics, views: views)
        let V_Constraint4 = NSLayoutConstraint.constraintsWithVisualFormat("V:|[profile]|", options: [], metrics: metrics, views: views)

        self.tabBarView.addConstraints(H_Constraint0)
        self.tabBarView.addConstraints(V_Constraint0)
        self.tabBarView.addConstraints(V_Constraint1)
        self.tabBarView.addConstraints(V_Constraint2)
        self.tabBarView.addConstraints(V_Constraint3)
        self.tabBarView.addConstraints(V_Constraint4)

        
        // home
        let homeImg = UIImage(named: "tab-home.png")
        let homeActiveImg = UIImage(named: "tab-home-active.png")
        homeButtonView.backgroundColor = ColorFromCode.tabBackgroundColor()
        homeButton.translatesAutoresizingMaskIntoConstraints = false
        homeButtonView.addSubview(homeButton)
        homeButtonView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[btn]|", options: [], metrics: nil, views: ["btn":homeButton]))
        homeButtonView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[btn]|", options: [], metrics: nil, views: ["btn":homeButton]))
        homeButton.frame.size = CGSizeMake(homeImg!.size.width, homeImg!.size.height)
        homeButton.setImage(homeImg, forState: UIControlState.Normal)
        homeButton.setImage(homeActiveImg, forState: UIControlState.Highlighted)
        homeButton.setImage(homeActiveImg, forState: UIControlState.Selected)
        //createButton.backgroundColor = UIColor.clearColor()
        homeButtonView.userInteractionEnabled = true
        homeButtonView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "selectHomeTab"))
        homeButton.addTarget(self, action: "selectHomeTab", forControlEvents: UIControlEvents.TouchUpInside)
        
        // explore
        let exploreImg = UIImage(named: "tab-explore.png")
        let exploreActiveImg = UIImage(named: "tab-explore-active.png")
        exploreButtonView.backgroundColor = ColorFromCode.tabBackgroundColor()
        exploreButton.translatesAutoresizingMaskIntoConstraints = false
        exploreButtonView.addSubview(exploreButton)
        exploreButtonView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[btn]|", options: [], metrics: nil, views: ["btn":exploreButton]))
        exploreButtonView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[btn]|", options: [], metrics: nil, views: ["btn":exploreButton]))
        exploreButton.frame.size = CGSizeMake(exploreImg!.size.width, exploreImg!.size.height)
        exploreButton.setImage(exploreImg, forState: UIControlState.Normal)
        exploreButton.setImage(exploreActiveImg, forState: UIControlState.Highlighted)
        exploreButton.setImage(exploreActiveImg, forState: UIControlState.Selected)
        exploreButtonView.userInteractionEnabled = true
        exploreButtonView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "selectExploreTab"))
        exploreButton.addTarget(self, action: "selectExploreTab", forControlEvents: UIControlEvents.TouchUpInside)
        
        // create
        let createImg = UIImage(named: "tab-create.png")
        let createActiveImg = UIImage(named: "tab-create-active.png")
        createButtonView.backgroundColor = UIColor.whiteColor()
        createButton.translatesAutoresizingMaskIntoConstraints = false
        createButtonView.addSubview(createButton)
        createButtonView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[btn]|", options: [], metrics: nil, views: ["btn":createButton]))
        createButtonView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[btn]|", options: [], metrics: nil, views: ["btn":createButton]))
        createButton.frame.size = CGSizeMake(createImg!.size.width, createImg!.size.height)
        createButton.setImage(createImg, forState: UIControlState.Normal)
        createButton.setImage(createActiveImg, forState: UIControlState.Highlighted)
        createButton.setImage(createActiveImg, forState: UIControlState.Selected)
        createButtonView.center = self.tabBar.center
        createButtonView.userInteractionEnabled = true
        createButtonView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "selectCreateTab"))
        createButton.addTarget(self, action: "selectCreateTab", forControlEvents: UIControlEvents.TouchUpInside)

        // activity
        let activityImg = UIImage(named: "tab-activity.png")
        let activityActiveImg = UIImage(named: "tab-activity-active.png")
        activityButtonView.backgroundColor = ColorFromCode.tabBackgroundColor()
        activityButton.translatesAutoresizingMaskIntoConstraints = false
        activityButtonView.addSubview(activityButton)
        activityButtonView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[btn]|", options: [], metrics: nil, views: ["btn":activityButton]))
        activityButtonView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[btn]|", options: [], metrics: nil, views: ["btn":activityButton]))
        activityButton.frame.size = CGSizeMake(activityImg!.size.width, activityImg!.size.height)
        activityButton.setImage(activityImg, forState: UIControlState.Normal)
        activityButton.setImage(activityActiveImg, forState: UIControlState.Highlighted)
        activityButton.setImage(activityActiveImg, forState: UIControlState.Selected)
        activityButtonView.userInteractionEnabled = true
        activityButtonView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "selectActivityTab"))
        activityButton.addTarget(self, action: "selectActivityTab", forControlEvents: UIControlEvents.TouchUpInside)
        
        // profile
        let profileImg = UIImage(named: "tab-profile.png")
        let profileActiveImg = UIImage(named: "tab-profile-active.png")
        profileButtonView.backgroundColor = ColorFromCode.tabBackgroundColor()
        profileButton.translatesAutoresizingMaskIntoConstraints = false
        profileButtonView.addSubview(profileButton)
        profileButtonView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[btn]|", options: [], metrics: nil, views: ["btn":profileButton]))
        profileButtonView.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[btn]|", options: [], metrics: nil, views: ["btn":profileButton]))
        profileButton.frame.size = CGSizeMake(profileImg!.size.width, profileImg!.size.height)
        profileButton.setImage(profileImg, forState: UIControlState.Normal)
        profileButton.setImage(profileActiveImg, forState: UIControlState.Highlighted)
        profileButton.setImage(profileActiveImg, forState: UIControlState.Selected)
        profileButtonView.userInteractionEnabled = true
        profileButtonView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "selectProfileTab"))
        profileButton.addTarget(self, action: "selectProfileTab", forControlEvents: UIControlEvents.TouchUpInside)
        
 
    }
    func selectHomeTab(){
        if (self.selectedIndex == 0){
            
            if ((self.viewControllers![0] as! UINavigationController).viewControllers.count>1){
                (self.viewControllers![0] as! UINavigationController).popToRootViewControllerAnimated(true)
            }else{
                ((self.viewControllers![0] as! UINavigationController).viewControllers[0] as! MonthViewController).tableView.setContentOffset(CGPointZero, animated: true)
            }

        }else{
            self.selectedIndex = 0
        }
        self.homeButton.selected = true
        self.exploreButton.selected = false
        self.createButton.selected = false
        self.activityButton.selected = false
        self.profileButton.selected = false
        //println("selected home")

    }
    func selectExploreTab(){
        if (self.selectedIndex == 1){
            if ((self.viewControllers![1] as! UINavigationController).viewControllers.count>1){
                (self.viewControllers![1] as! UINavigationController).popToRootViewControllerAnimated(true)
            }else{
                ((self.viewControllers![1] as! UINavigationController).viewControllers[0] as! ExploreViewController).eventsCollectionView.setContentOffset(CGPointZero, animated: true)
                ((self.viewControllers![1] as! UINavigationController).viewControllers[0] as! ExploreViewController).usersTableView.setContentOffset(CGPointZero, animated: true)
            }
        }else{
            self.selectedIndex = 1
        }
        self.homeButton.selected = false
        self.exploreButton.selected = true
        self.createButton.selected = false
        self.activityButton.selected = false
        self.profileButton.selected = false
        //println("selected explore")
    }
    func selectCreateTab(){
        let VC = self.storyboard!.instantiateViewControllerWithIdentifier("CreateEventView") as! CreateEventViewController
        VC.delegate = self
        let NC = UINavigationController(rootViewController: VC)
        self.presentViewController(NC, animated: true, completion: nil)
//        self.homeButton.selected = false
//        self.exploreButton.selected = false
//        self.createButton.selected = true
//        self.activityButton.selected = false
//        self.profileButton.selected = false
//        self.selectedIndex = 2
        //println("selected create")
    }
    func cancelledCreatingEvent() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    func eventWasCreatedSuccessfully() {
        self.dismissViewControllerAnimated(false, completion: nil)
        selectHomeTab()
        ((self.viewControllers![0] as! UINavigationController).viewControllers[0] as! MonthViewController).tableView.setContentOffset(CGPointZero, animated: true)
        ((self.viewControllers![0] as! UINavigationController).viewControllers[0] as! MonthViewController).LoadTimeline()

    }
    func selectActivityTab(){
        if (self.selectedIndex == 3){
            if ((self.viewControllers![3] as! UINavigationController).viewControllers.count>1){
                (self.viewControllers![3] as! UINavigationController).popToRootViewControllerAnimated(true)
            }else{
                ((self.viewControllers![3] as! UINavigationController).viewControllers[0] as! ActivityViewController).meTableView.setContentOffset(CGPointZero, animated: true)
                ((self.viewControllers![3] as! UINavigationController).viewControllers[0] as! ActivityViewController).youTableView.setContentOffset(CGPointZero, animated: true)
                ((self.viewControllers![3] as! UINavigationController).viewControllers[0] as! ActivityViewController).followingTableView.setContentOffset(CGPointZero, animated: true)
            }


            
        }else{
            self.selectedIndex = 3
        }
        self.homeButton.selected = false
        self.exploreButton.selected = false
        self.createButton.selected = false
        self.activityButton.selected = true
        self.profileButton.selected = false
        
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
        //println("selected activity")
    }
    override func viewWillLayoutSubviews() {
        // firstly get rid of shitty tab bar
        //self.tabBar.frame.size.height = 0
        self.tabBar.hidden = true
        self.tabBar.removeFromSuperview()

    }
    var tabBarIsVisible = true
    func setTabBarVisible(visible:Bool, animated:Bool) {
        
        //* This cannot be called before viewDidLayoutSubviews(), because the frame is not set before this time
        
        // bail if the current state matches the desired state
        if (tabBarIsVisible == visible) { return }
        
        // get a frame calculation ready
        let frame = self.tabBarView.frame
        let height = frame.size.height
        let offsetY = (visible ? 0 : height)
        
        // zero duration means no animation
        let duration:NSTimeInterval = (animated ? 0.3 : 0.0)
        
        //  animate the tabBar
        UIView.animateWithDuration(duration) {
            self.tabBarView.frame.origin.y = self.initialTabViewHeight - self.tabBarView.frame.height + offsetY
            self.view.frame.size.height = self.initialTabViewHeight + offsetY
            self.tabBarIsVisible = !self.tabBarIsVisible
            return
        }
    }

    func selectProfileTab(){
        if (self.selectedIndex == 4){
            
            (self.viewControllers![4] as! UINavigationController).popToRootViewControllerAnimated(true)
        }else{
            self.selectedIndex = 4
        }
        self.homeButton.selected = false
        self.exploreButton.selected = false
        self.createButton.selected = false
        self.activityButton.selected = false
        self.profileButton.selected = true
        //println("selected profile")
    }
    
    func tabBarController(tabBarController: UITabBarController, didSelectViewController viewController: UIViewController) {
        if (self.selectedIndex == 2){
            self.createButton.selected = true
        }else{
            self.createButton.selected = false
        }
    }
    override func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem) {
        
        if (self.selectedIndex == 2){
            self.createButton.selected = true
        }else{
            self.createButton.selected = false
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
