
//  MonthViewController.swift
//  GCalendar
//
//  Created by Grisha on 05/11/2014.
//  Copyright (c) 2014 Grisha. All rights reserved.
//

import UIKit
import CoreData
extension UITableView {
    func reloadData(completion: ()->()) {
        UIView.animateWithDuration(0, animations: { self.reloadData() })
            { _ in completion() }
    }
}
class MonthViewController: UIViewController , UICollectionViewDataSource, UICollectionViewDelegate , UICollectionViewDelegateFlowLayout, UIScrollViewDelegate, UITableViewDataSource, UITableViewDelegate,EventsManagerDelegate,TTTAttributedLabelDelegate

{
    var screenWidth = UIScreen.mainScreen().bounds.width
    var screenHeight = UIScreen.mainScreen().bounds.height

    


    //referencing outlets
    @IBOutlet var SwitchButton: UIBarButtonItem!
    
    
    var events:[FetchedEvent] = []
    var calendarView: CalendarCollectionView = CalendarCollectionView(frame: CGRectMake(0,0,0,0), collectionViewLayout: MonthCustomLayout())
    var calendarSuperView: UITableView = UITableView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width
        , UIScreen.mainScreen().bounds.height))//for attaching refresh control to calendar
    var MonthLabel: UILabel = UILabel()

    
    var tableView:UITableView = UITableView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width
        , UIScreen.mainScreen().bounds.height))
    var end:Bool = false // end when loaded all
    
    var nsDatesForAllEvents:NSMutableArray = NSMutableArray() // saving objects with key "date" of every event here
    var numberOfEventsForCollectionView:NSMutableArray = NSMutableArray() // this is to display on day cells how many events are there
    var eventsManager:EventsManager = EventsManager() //events retrieved
    //var sectionHeaders:[eventHeaderView] = []


    var SelectedMonth:Int = Int()
    var SelectedDay:Int = Int()
    var SelectedYear:Int = Int()
    
    var CurrentMonth:Int = Int()
    var CurrentDay:Int = Int() // today
    var CurrentYear:Int = Int()
    
    //----Skipped-Days----------//
    var SkippedDays0:Int = Int()    //skipped days are used for making a different offset for different
    var SkippedDays1:Int = Int()    //months, because their first weekdays are different
    var SkippedDays2:Int = Int()    //number in the end represents section
    //-for infinite scrolling---//
    var PageWidth:CGFloat = CGFloat()
    var previousPage:CGFloat = CGFloat()
    var TargetContentOffsetChanged:Bool = Bool()
    var TargetOffset:CGPoint = CGPoint()
    //--------------------------//
    var TitleView:UIView = UIView()
    var TitleLabel:UILabel = UILabel()
    var JustPaged:Bool = Bool()
    //-----Refresh Controls------//
    var refreshControlForCalendar:RefreshControl = RefreshControl()
    var refreshControlForTimeLine:RefreshControl = RefreshControl()
    
    
    var footerView = TableFooterRefreshView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, 100))

    var logoView:UIImageView =  UIImageView()
    var indicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
    var cellHeights:[CGFloat] = []
    func back(){
        self.navigationController!.popViewControllerAnimated(true)
    }
    
    func Set_Subviews(){
        let backButton = UIBarButtonItem(image: UIImage(named: "back.png"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(MonthViewController.back))
        backButton.tintColor = UIColor.whiteColor()
        if (self.navigationController!.viewControllers.count > 1){
            self.navigationItem.leftBarButtonItem = backButton
        }
        let logoImage = UIImage(CGImage: UIImage(named: "logo.png")!.CGImage!, scale: 4, orientation: UIImageOrientation.Up)
        logoView = UIImageView(image: logoImage)
        self.navigationItem.titleView = logoView
        logoView.frame.origin.y -= 30
        let offset = self.navigationController!.navigationBar.frame.height + UIApplication.sharedApplication().statusBarFrame.height + self.tabBarController!.tabBar.frame.height
        self.view.addSubview(calendarSuperView)
        self.view.addSubview(tableView)
        // Select Table View and load icon
        
        let ButtonIcon:UIImage = UIImage(named: "calendar.png")!
        SwitchButton.image = ButtonIcon
        calendarSuperView.hidden = true
        tableView.hidden = false
        self.view.bringSubviewToFront(tableView)
        

        //UIApplication.sharedApplication().status
        
        //!----Set Calendar as Initial View----//
        calendarSuperView.hidden = true
        tableView.hidden = false
        //self.view.bringSubviewToFront(calendarSuperView)
        //-----Set Calendar as Initial View----//

        
        //!----CalendarView------//
        calendarSuperView.addSubview(MonthLabel)
        calendarSuperView.addSubview(calendarView)
        
        MonthLabel.frame = CGRectMake(0, 5, screenWidth, 20)
        MonthLabel.textAlignment = NSTextAlignment.Center
        let TapRec:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(MonthViewController.Jump_To_Month))
        MonthLabel.addGestureRecognizer(TapRec)
        MonthLabel.userInteractionEnabled = true
        
        calendarSuperView.frame = CGRectMake(0, topLayoutGuide.length,screenWidth, screenHeight-topLayoutGuide.length)
        calendarView.frame = CGRectMake(0, 25,screenWidth, calendarSuperView.bounds.height-20)
        
        calendarView.delegate = self
        calendarView.dataSource = self
        calendarView.backgroundColor = UIColor.whiteColor()
        calendarView.collectionViewLayout = MonthCustomLayout()
        calendarView.registerClass(WeekDayCollectionViewCell.self, forCellWithReuseIdentifier: "Weekday Cell")
        calendarView.registerClass(DayCollectionViewCell.self, forCellWithReuseIdentifier: "Day Cell")
        calendarView.registerClass(TransparentDayCollectionViewCell.self, forCellWithReuseIdentifier: "Transparent Cell")
        
        refreshControlForCalendar.addTarget(self, action: "countNumberOfEventsForSelectedMonth", forControlEvents: UIControlEvents.ValueChanged)
        calendarSuperView.addSubview(refreshControlForCalendar)
        calendarSuperView.alwaysBounceVertical = true
        calendarSuperView.separatorStyle = UITableViewCellSeparatorStyle.None //just removing that annoying black line
        //-----CalendarView------//
        
        //!----TableView---------//


        eventsManager.delegate = self
        tableView.allowsSelection = false
        tableView.delegate = self
        tableView.dataSource = self
//        tableView.canCancelContentTouches = false
        tableView.registerClass(HomeEventTableViewCell.self, forCellReuseIdentifier: "Event Cell")
        tableView.registerClass(eventHeaderView.self, forHeaderFooterViewReuseIdentifier: "header")
        tableView.frame = CGRectMake(0, 0, screenWidth, self.view.frame.height-offset)
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        //tableView.contentInset.top = refreshControlForTimeLine.frame.height
        //tableView.estimatedRowHeight = 600
        footerView.button.addTarget(self, action: "loadMore", forControlEvents: UIControlEvents.TouchUpInside)
        tableView.rowHeight = UITableViewAutomaticDimension
        
        let tableViewController = UITableViewController()
        self.addChildViewController(tableViewController)
        tableViewController.refreshControl = refreshControlForTimeLine
        tableViewController.refreshControl!.addTarget(self, action: "loadTimeline", forControlEvents: UIControlEvents.ValueChanged)
        tableViewController.tableView = tableView
        self.view.addSubview(tableViewController.tableView)
        
        self.tableView.addSubview(indicator)
        indicator.center = tableView.center
        indicator.hidesWhenStopped = true
        indicator.startAnimating()
        
        //-----TableView---------//

        //!----------Current-Date----------//
        let calendar:NSCalendar = NSCalendar.currentCalendar()
        let Today:NSDate = NSDate() //default constructor gets current date if I get it right
        let TodayDateComponents:NSDateComponents = calendar.components([NSCalendarUnit.Year, NSCalendarUnit.Month, NSCalendarUnit.Day, NSCalendarUnit.Hour, NSCalendarUnit.Minute, NSCalendarUnit.Second], fromDate: Today)
        self.SelectedDay = TodayDateComponents.day
        self.SelectedMonth = TodayDateComponents.month
        self.SelectedYear = TodayDateComponents.year
        //set current date
        self.CurrentDay = TodayDateComponents.day
        self.CurrentMonth = TodayDateComponents.month
        self.CurrentYear = TodayDateComponents.year
        //-----------Current-Date----------//
        
    }
    func attachFooterView(attach:Bool){
        if attach {
            tableView.tableFooterView = footerView
        }else{
            tableView.tableFooterView = nil
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Utility.dropShadow(self.navigationController!.navigationBar, offset: -1, opacity: 0.25)
        Set_Subviews()
        loadTimeline()
        CalculateSkippedDays() //calculating
        SetNewMonthLabel()
        StartScroll()
        //self.followScrollView(self.tableView, withDelay: 400)
        //self.setUseSuperview(true)

    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        self.calendarView.reloadData()
        //self.setUseSuperview(false)
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "didBecomeActive", name: UIApplicationDidBecomeActiveNotification, object: nil)
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.moveNavBar(1000, animated: false)
        Utility.dropShadow(self.navigationController!.navigationBar, offset: 0, opacity: 0)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIApplicationDidBecomeActiveNotification, object: nil)
    }

    func didBecomeActive(){

        let time:NSTimeInterval = Utility.SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO("8.0") ? 0 : 0.1
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (Int64)(time*Double(NSEC_PER_SEC))),dispatch_get_main_queue()) {
            () -> Void in
            self.moveNavBar(1000, animated: true)
        }
    }

    var scrollValue:CGFloat = 0 // previous offset
    var scrollCount:CGFloat = 0
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let h:CGFloat = scrollView.contentSize.height
        
        if (scrollView.contentOffset.y > 0 && ((h-scrollView.contentOffset.y) > tableView.bounds.height)){
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
            self.tableView.frame.size.height = self.screenHeight - targetOrigin - self.navigationController!.navigationBar.frame.height - self.tabBarController!.tabBar.frame.height
            self.updateBarButtonItems(
                (targetOrigin - 20 + self.navigationController!.navigationBar.frame.height)/(-20 + self.navigationController!.navigationBar.frame.height))
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
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        self.navigationController!.navigationBar.userInteractionEnabled = false
    }
    func scrollViewDidEndDragging(scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.navigationController!.navigationBar.userInteractionEnabled = true
        self.PageWidth = ((calendarView.contentSize.width)/3)
        let RawPageValue:CGFloat = (CGFloat(calendarView.contentOffset.x)/self.PageWidth)
        //println("\(RawPageValue)")
        if (calendarView.StillDecellerates){
            if (RawPageValue > 2.25){
                TargetContentOffsetChanged = true
                TargetOffset = CGPointMake(((self.PageWidth)+(self.PageWidth/4)),self.calendarView.contentOffset.y)
            }
            else if (RawPageValue < 0){
                TargetContentOffsetChanged = true
                TargetOffset = CGPointMake(self.PageWidth,self.calendarView.contentOffset.y)
            }//else{
             //   TargetContentOffsetChanged = false
            //}
        }
    }
    
    func scrollViewWillBeginDecelerating(scrollView: UIScrollView) {
        calendarView.StillDecellerates = true
        
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        scrollCount = 0
        checkNavBar()
        var CurrentPage:CGFloat = round(self.calendarView.contentOffset.x/self.PageWidth)
        self.PageWidth = calendarView.contentSize.width/3
//        println("\(CurrentPage)")
//        println("\(PageWidth)")
//        println("\(self.CurrentMonth.contentOffset.x)")
//        428.5 page width
        if (self.previousPage != CurrentPage) {
            if (CurrentPage > self.previousPage){   // changed to next month
                CurrentPage = 1
                if (self.SelectedMonth == 12){
                    self.SelectedYear++
                    self.SelectedMonth = 1
                }else{
                    self.SelectedMonth++
                }
                
                if (TargetContentOffsetChanged){ //checks if we try to scroll again while it still decellerates in case if we need to change target contentoffset depending where was the second scroll
                    
                    self.numberOfEventsForCollectionView.removeAllObjects()
                    CalculateSkippedDays()
                    calendarView.reloadData()
                    self.calendarView.setContentOffset(TargetOffset, animated: false)
                    
                    //countNumberOfEventsForSelectedMonth() //includes LoadData function
                    TargetContentOffsetChanged = false
                }else{
                    
                    self.numberOfEventsForCollectionView.removeAllObjects()
                    CalculateSkippedDays()
                    calendarView.reloadData()
                    self.calendarView.setContentOffset(CGPointMake(self.calendarView.contentOffset.x-428.5,self.calendarView.contentOffset.y),animated: false)
                    
                    //countNumberOfEventsForSelectedMonth() //includes LoadData function

                }

            }else{
                CurrentPage = 1
                if (self.SelectedMonth == 1){
                    self.SelectedYear--
                    self.SelectedMonth = 12
                }else{
                    self.SelectedMonth--
                }

                if (TargetContentOffsetChanged){ //checks whether we try to scroll again while it still decellerates in case if we need to change target contentoffset depending where was the second scroll
                    
                    self.numberOfEventsForCollectionView.removeAllObjects()
                    CalculateSkippedDays()
                    calendarView.reloadData()
                    self.calendarView.setContentOffset(TargetOffset, animated: false)
                    
                    //countNumberOfEventsForSelectedMonth() //includes LoadData function
                    TargetContentOffsetChanged = false
                }else{
                    
                    self.numberOfEventsForCollectionView.removeAllObjects()
                    CalculateSkippedDays()
                    calendarView.reloadData()
                    self.calendarView.setContentOffset(CGPointMake(self.calendarView.contentOffset.x+428.5,self.calendarView.contentOffset.y),animated: false)
                    //countNumberOfEventsForSelectedMonth() //includes LoadData function

                }
            }
        }

        //---now call function with switch case ,labels for each month id-----------------------//
        SetNewMonthLabel()
        //--------------------------------------------------------------------------------------//
        previousPage = CurrentPage;
        calendarView.StillDecellerates = false
            
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 3;
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var SkippedDays:Int
        if (section == 0){
            SkippedDays = SkippedDays0
        }else if (section == 1){
            SkippedDays = SkippedDays1
        }else if (section == 2){
            SkippedDays = SkippedDays2
        }else{
            SkippedDays = 0 //not supposed to happen
        }
        //Set up selected Month, for that we will initialize NSDate object
        let DateForInitialization:NSDate = NSDate()
        let calendar:NSCalendar = NSCalendar.currentCalendar()
        let DateComponents:NSDateComponents = calendar.components([NSCalendarUnit.Year, NSCalendarUnit.Month, NSCalendarUnit.Day, NSCalendarUnit.Hour, NSCalendarUnit.Minute, NSCalendarUnit.Second], fromDate: DateForInitialization)
        DateComponents.month = (self.SelectedMonth-1)+section
        DateComponents.year = self.SelectedYear
        let Date:NSDate = calendar.dateFromComponents(DateComponents)!
        //Now Use this Date to get number of days in this month
        let Calendar:NSCalendar = NSCalendar.currentCalendar()
        let Range:NSRange = Calendar.rangeOfUnit(NSCalendarUnit.Day, inUnit: NSCalendarUnit.Month, forDate: Date)
        let numberOfDaysInMonth:Int = Range.length;
        return numberOfDaysInMonth+7+SkippedDays;//days in a week ,1 for month
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        var SkippedDays:Int
            if (indexPath.section == 0){
                SkippedDays = SkippedDays0
            }else if (indexPath.section == 1){
                SkippedDays = SkippedDays1
            }else if (indexPath.section == 2){
                SkippedDays = SkippedDays2
            }else{
                SkippedDays = 0 //not supposed to happen
            }
            if(indexPath.item<7){
                
                let WeekDayCell:WeekDayCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("Weekday Cell", forIndexPath: indexPath) as! WeekDayCollectionViewCell
                //enum to simplify and practise too
                switch (indexPath.item){
                    
                case(0):
                    WeekDayCell.Day.text = "Mon"
                case(1):
                    WeekDayCell.Day.text = "Tue"
                case(2):
                    WeekDayCell.Day.text = "Wed"
                case(3):
                    WeekDayCell.Day.text = "Thu"
                case(4):
                    WeekDayCell.Day.text = "Fri"
                case(5):
                    WeekDayCell.Day.text = "Sat"
                case(6):
                    WeekDayCell.Day.text = "Sun"
                default:
                    WeekDayCell.Day.text = "Undefined"
                
            }
                //this increases perfomance, cornerradius slows app down hardly, we set corner radius in the cell class file
                WeekDayCell.layer.masksToBounds = false
                WeekDayCell.layer.shouldRasterize = true
                WeekDayCell.layer.rasterizationScale = UIScreen.mainScreen().scale
                return WeekDayCell;
            }else{
        
            // case when we create a cell for a day itself or transparent cell
                if (indexPath.item < (7+SkippedDays)){
                    let TransparentCell:TransparentDayCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("Transparent Cell", forIndexPath: indexPath) as! TransparentDayCollectionViewCell
                    return TransparentCell
                }else{
                    
                    let DayCell:DayCollectionViewCell = collectionView.dequeueReusableCellWithReuseIdentifier("Day Cell", forIndexPath: indexPath) as! DayCollectionViewCell
                    
                    
                    DayCell.day = indexPath.item + 1 - 7 - SkippedDays
                    DayCell.month = (self.SelectedMonth-1)+indexPath.section
                    DayCell.year = self.SelectedYear
                    
                    DayCell.dayLabel.text = String(DayCell.day) // day in a month
                    DayCell.NumberOfEvents.text = ""
                    DayCell.newEventCircle.hidden = true
                    if (indexPath.section == 1){
                        if ((self.numberOfEventsForCollectionView.count > 0)){
                            if (Int(self.numberOfEventsForCollectionView[DayCell.day-1] as! Int) > 0){
                                DayCell.newEventCircle.hidden = false
                                DayCell.NumberOfEvents.text = ("\(self.numberOfEventsForCollectionView[DayCell.day-1]) events")
                            }
                        }
                    }


                
                    //this increases perfomance, cornerradius slows app down hardly, we set corner radius in the cell class file
                    DayCell.layer.masksToBounds = false;
                    DayCell.layer.shouldRasterize = true;
                    DayCell.layer.rasterizationScale = UIScreen.mainScreen().scale
                    //if it's current day cell, then we ll high light it
                    DayCell.layer.borderWidth = 0
                    
                    if ((self.SelectedMonth == 12) && (self.CurrentMonth == 1)){ // case when current day is in next year
                        if (((DayCell.day) == self.CurrentDay) && (indexPath.section == 2) && (self.SelectedYear + 1 == self.CurrentYear)){
                            DayCell.layer.borderColor = UIColor.blackColor().CGColor
                            DayCell.layer.borderWidth = 1
                        }
                        
                    }else if ((self.SelectedMonth == 1) && (self.CurrentMonth == 12)){ // case when current day is in previous year
                        if (((DayCell.day) == self.CurrentDay) && (indexPath.section == 0) && (self.SelectedYear - 1 == self.CurrentYear)){
                            DayCell.layer.borderColor = UIColor.blackColor().CGColor
                            DayCell.layer.borderWidth = 1
                        }
                        
                    }else{
                        if (((DayCell.day) == self.CurrentDay) && (((self.SelectedMonth-1)+indexPath.section) == self.CurrentMonth) && (self.SelectedYear == self.CurrentYear)){
                            DayCell.layer.borderColor = UIColor.blackColor().CGColor
                            DayCell.layer.borderWidth = 1
                        }
                    }
                    
                    let tapRecognizer:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "chooseDay:")
                    DayCell.addGestureRecognizer(tapRecognizer)
                    
                    return DayCell
                }
            }
        
        
    }

    func chooseDay(sender:UITapGestureRecognizer){
        let _:DayCollectionViewCell = sender.view as! DayCollectionViewCell
        
        let VC = self.storyboard?.instantiateViewControllerWithIdentifier("EventListViewController") as! EventListViewController
//        VC.SelectedDay = Cell.day
//        VC.SelectedMonth = Cell.month
//        VC.SelectedYear = Cell.year
        
        self.navigationController?.pushViewController(VC, animated: true)
    }
    func SetNewMonthLabel(){
        //Handling animation,when another month scrolled, new Month name will appear with fade
        let animation:CATransition = CATransition()
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        animation.duration = 0.25
        self.MonthLabel.layer.addAnimation(animation, forKey: "kCATransitionFade")
        //--------------------------------------------------------------------------------------//
        self.MonthLabel.text = DateToStringConverter.monthInText(SelectedMonth, shorten: false) + " \(SelectedYear)"
    }
    func CalculateSkippedDays(){         //------calculating skipped days,i.e offset we need to set up for month cells in collectionview
        
        //now we put day to 1 ,to get the first weekday in order to choose offset for day cells
        // IMPORTANT --- in gregorian calendar 1 - Sunday, 2 - Monday, etc.
        let calendar:NSCalendar = NSCalendar.currentCalendar()
        var Date:NSDate = NSDate()
        let DateComponents:NSDateComponents = calendar.components([NSCalendarUnit.Year, NSCalendarUnit.Month, NSCalendarUnit.Day, NSCalendarUnit.Hour, NSCalendarUnit.Minute, NSCalendarUnit.Second], fromDate: Date)
        DateComponents.day = 1
        DateComponents.month = SelectedMonth - 1
        DateComponents.year = SelectedYear
        Date = calendar.dateFromComponents(DateComponents)!
        self.SkippedDays0 = calendar.components(NSCalendarUnit.Weekday, fromDate: Date).weekday - 2
        if (SkippedDays0 == -1){ //in case of sunday we want it to be 6 instead of -1
            SkippedDays0 = 6
        }
        
        DateComponents.day = 1
        DateComponents.month = SelectedMonth
        DateComponents.year = SelectedYear
        Date = calendar.dateFromComponents(DateComponents)!
        self.SkippedDays1 = calendar.components(NSCalendarUnit.Weekday, fromDate: Date).weekday - 2
        if (SkippedDays1 == -1){ //in case of sunday we want it to be 6 instead of -1
            SkippedDays1 = 6
        }
        DateComponents.day = 1
        DateComponents.month = SelectedMonth + 1
        Date = calendar.dateFromComponents(DateComponents)!
        self.SkippedDays2 = calendar.components(NSCalendarUnit.Weekday, fromDate: Date).weekday - 2
        if (SkippedDays2 == -1){ //in case of sunday we want it to be 6 instead of -1
            SkippedDays2 = 6
        }
        //---------------------------------//
    }
    func StartScroll(){
        calendarView.setContentOffset(CGPointMake(428.5, 0), animated: false)
        self.previousPage = 1
    }

    
    //-------------------Table-Part--------------------//

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return events.count
    }
    func tableView(tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        var header:eventHeaderView = tableView.dequeueReusableHeaderFooterViewWithIdentifier("header") as! eventHeaderView
        header = eventHeaderView(event: self.events[section])
        header.tag = section
        header.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "pushUser:"))
        return header
        
//        Cell.ProfileView.tag = indexPath.row // this is to remember in which cell we clicked the label
//        Cell.ProfileView.userInteractionEnabled = true
//        let ProfileNameTapRecognizer:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "PushUserProfileViewController:")
//        Cell.ProfileView.addGestureRecognizer(ProfileNameTapRecognizer)
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 60
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        

        // prepare content
        let authorNameText = self.events[indexPath.section].author!.username
        let eventNameText = self.events[indexPath.section].name as String
        let eventDateText = self.events[indexPath.section].eventDateText
        
        // details
        let eventDetailsText = NSMutableAttributedString()
        if (self.events[indexPath.section].details != ""){
            var attrs = [NSFontAttributeName : UIFont(name: "Lato-Medium", size: 14)!, NSForegroundColorAttributeName: ColorFromCode.randomBlueColorFromNumber(3)]
            var content = NSMutableAttributedString(string: "\(authorNameText)", attributes: attrs)
            eventDetailsText.appendAttributedString(content)
            attrs = [NSFontAttributeName : UIFont(name: "Lato-Regular", size: 14)!, NSForegroundColorAttributeName: UIColor.blackColor()]
            content = NSMutableAttributedString(string: " \(self.events[indexPath.section].shortDescription)", attributes: attrs)
            eventDetailsText.appendAttributedString(content)
        }
        
        let eventTimeAndLocationText = NSMutableAttributedString()
        // time
        var attrs = [NSFontAttributeName : UIFont(name: "Lato-Semibold", size: 14)!, NSForegroundColorAttributeName: UIColor.blackColor()]
        var content = NSMutableAttributedString(string: "\(self.events[indexPath.section].timeString) ", attributes:attrs)
        eventTimeAndLocationText.appendAttributedString(content)
        attrs = [NSFontAttributeName : UIFont(name: "Lato-Semibold", size: 12)!, NSForegroundColorAttributeName: ColorFromCode.colorWithHexString("#9497A3")]
        content = NSMutableAttributedString(string: "\nin 2 hours", attributes: attrs)
        eventTimeAndLocationText.appendAttributedString(content)

        if (self.events[indexPath.section].location != ""){
            attrs = [NSFontAttributeName : UIFont(name: "Lato-Regular", size: 16)!, NSForegroundColorAttributeName: UIColor.darkGrayColor()]
            content = NSMutableAttributedString(string: " at ", attributes: attrs)
            eventTimeAndLocationText.appendAttributedString(content)
            attrs = [NSFontAttributeName : UIFont(name: "Lato-Regular", size: 16)!, NSForegroundColorAttributeName: ColorFromCode.colorWithHexString("#C78B14")]
            content = NSMutableAttributedString(string: "\(self.events[indexPath.section].location)", attributes: attrs)
            eventTimeAndLocationText.appendAttributedString(content)

        }
        
        
        let Cell:HomeEventTableViewCell = tableView.dequeueReusableCellWithIdentifier("Event Cell", forIndexPath: indexPath) as! HomeEventTableViewCell
        Cell.tag = indexPath.section
        // set main labels
        Cell.eventNameLabel.text = eventNameText
        Cell.eventDescriptionLabel.attributedText = eventDetailsText
        Cell.timeLocationLabel.attributedText = eventTimeAndLocationText
        Cell.eventDateLabel.attributedText = eventDateText
        
        // clickable author name
        if (self.events[indexPath.section].details != ""){
            let url:NSURL = NSURL(scheme: "pushAuthor", host: "", path: "/")!
            Cell.eventDescriptionLabel.addLinkToURL(url, withRange:NSRange(location: 0,length: (authorNameText as NSString).length))
            Cell.eventDescriptionLabel.delegate = self
            Cell.eventDescriptionLabel.tag = indexPath.section
        }
        
        // clickable location
        if (self.events[indexPath.section].location != ""){
            let url:NSURL = NSURL(scheme: "pushLocation", host: "", path: "/")!
            let range = NSRange(location: (eventTimeAndLocationText.length-self.events[indexPath.section].location.length),length: self.events[indexPath.section].location.length)
            Cell.timeLocationLabel.addLinkToURL(url, withRange: range)
            Cell.timeLocationLabel.delegate = self
            Cell.timeLocationLabel.tag = indexPath.section
        }
        Cell.timeLocationLabel.attributedText = eventTimeAndLocationText
        Cell.eventDescriptionLabel.attributedText = eventDetailsText
        
        if (self.events[indexPath.section].date.timeIntervalSinceNow < 0){
            Cell.eventDateLabel.backgroundColor = ColorFromCode.orangeDateColor()
        }else{
            Cell.eventDateLabel.backgroundColor = ColorFromCode.orangeDateColor()
        }
        
        Cell.Set_Numbers(self.events[indexPath.section].goManager.numberOfGoing, likes: self.events[indexPath.section].likeManager.numberOfLikes, comments: self.events[indexPath.section].numberOfComments, shares: self.events[indexPath.section].shareManager.numberOfShares)
        
        // Set Buttons
        Cell.likeButton.setState(self.events[indexPath.section].likeManager.isLiked)
        Cell.likeButton.handleTap({ () -> Void in
            self.like(Cell.likeButton)
        })
        
        Cell.goButton.setState(self.events[indexPath.section].goManager.isGoing)
        Cell.goButton.handleTap({ () -> Void in
            self.go(Cell.goButton)
        })
        
        Cell.shareButton.setState(self.events[indexPath.section].shareManager.isShared)
        Cell.shareButton.handleTap({ () -> Void in
            self.share(Cell.shareButton)
        })
//        Cell.commentButton
        //            Cell.likeButton.initialize(self.events[indexPath.section].likeManager.isLiked)
        //            Cell.likeButton.addTarget(self, action: "like:", forControlEvents: UIControlEvents.TouchUpInside)
        //            Cell.goButton.initialize(self.events[indexPath.section].goManager.isGoing)
        //            Cell.goButton.addTarget(self, action: "go:", forControlEvents: UIControlEvents.TouchUpInside)
        //            Cell.shareButton.initialize(self.events[indexPath.section].shareManager.isShared)
        //            Cell.shareButton.addTarget(self, action: "share:", forControlEvents: UIControlEvents.TouchUpInside)
        //            Cell.moreButton.handleTap({ () -> Void in
        //                self.more(Cell.moreButton)
        //            })
        Cell.moreButton.tag = indexPath.section
        Cell.moreButton.addTarget(self, action: "more:", forControlEvents: UIControlEvents.TouchUpInside)
//        Cell.commentButton.initialize()
        
        Cell.progressView.progressCircle.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.TouchUpInside)
        
        
        EventsManager().loadProfilePictureForEvent(&self.events[Cell.tag], completionHandler: {
            (error:NSError!) -> Void in
            let index = Cell.tag
            if (error == nil){
                if (self.tableView.headerViewForSection(index) != nil){
                    let header:eventHeaderView = self.tableView.headerViewForSection(index) as! eventHeaderView
                    header.updateProfilePicture(
                        self.events[index].profilePictureID as String,
                        progress: self.events[index].profilePictureProgress,
                        image: self.events[index].profilePicture)
                }
            }else{
                print("Error:" + error.description)
            }
        })
        Cell.UpdateEventPicture(self.events[indexPath.section], row: indexPath.section)
        
        Cell.tag = indexPath.section // this is to remember in which cell we clicked the label
        Cell.contentView.userInteractionEnabled = true
        let pushEventRec1:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "PushEventViewController:")
        let pushEventRec2:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: "PushEventViewController:")
        Cell.pictureImageView.userInteractionEnabled = true
        Cell.pictureImageView.tag = indexPath.section
        Cell.progressView.tag = indexPath.section
        Cell.pictureImageView.addGestureRecognizer(pushEventRec1)
        Cell.progressView.addGestureRecognizer(pushEventRec2)
        
        Cell.likesbtn.addTarget(self, action: "PushLikes:", forControlEvents: UIControlEvents.TouchUpInside)
        Cell.goingbtn.addTarget(self, action: "PushGoing:", forControlEvents: UIControlEvents.TouchUpInside)
        Cell.sharesbtn.addTarget(self, action: "PushShares:", forControlEvents: UIControlEvents.TouchUpInside)
        Cell.highlightMentionsInString(eventDetailsText, withColor: ColorFromCode.randomBlueColorFromNumber(3))
        Cell.highlightHashtagsInString(eventDetailsText, withColor: ColorFromCode.randomBlueColorFromNumber(3))
        
        Cell.contentView.setNeedsLayout()
        Cell.contentView.layoutIfNeeded()
        //            CGFloat labelWidth                  = superviewWidth - 30.0f;
        //            //    use the known label width with a maximum height of 100 points
        //            CGSize labelContraints              = CGSizeMake(labelWidth, 100.0f);
        //
        //            NSStringDrawingContext *context     = [[NSStringDrawingContext alloc] init];
        //
        //            CGRect labelRect                    = [ingredientLine boundingRectWithSize:labelContraints
        //            options:NSStringDrawingUsesLineFragmentOrigin
        //            attributes:nil
        //            context:context];
        
        let descrHeight = Cell.eventDescriptionLabel.sizeThatFits(CGSizeMake(Cell.eventDescriptionLabel.frame.width, 550)).height
        //let timelocHeight = Cell.timeLocationLabel.sizeThatFits(CGSizeMake(Cell.timeLocationLabel.frame.width, 100)).height
        //            let numberOfGoingHeight = Cell.numberOfGoingLabel.sizeThatFits(CGSizeMake(Cell.numberOfGoingLabel.frame.width, 100)).height
        
        //            println("time location height for \(indexPath.section) : \(Cell.timeLocationLabel.frame.height)")
        //            println("event description height for \(indexPath.section) : \(Cell.EventDescription.frame.height)")
        //            println("got height for \(indexPath.section) : \(Cell.frame.height)")
        //let V_Constraint1 = NSLayoutConstraint.constraintsWithVisualFormat("V:|[evDate(sq@999)][shareButton(sq@999)][likeButton(sq@999)][goButton(sq@999)][commentButton(sq@999)]-5-[evDescription(>=0@999)]->=0@999-|", options: [], metrics: metrics, views: views)
        let bigSquareSide = screenWidth*4/5
        let smallSquareSide = screenWidth/5
        cellHeights.insert((bigSquareSide+smallSquareSide+5+descrHeight+5), atIndex: indexPath.section)
        
        return Cell
        

        
    }
    func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        
        if (indexPath.section == self.events.count-2){
            if (!end){
                loadMore()
            }
        }
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        if cellHeights[indexPath.section] < 46 || (cellHeights[indexPath.section] == 0) {
            return UITableViewAutomaticDimension
        }else{
            return cellHeights[indexPath.section]
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

    
    func like(sender: ETableViewCellButton){
        print("button pressed \(sender.superview!.superview!.tag)")
        self.events[sender.superview!.superview!.tag].likeManager.button = sender
        self.events[sender.superview!.superview!.tag].likeManager.Like()
    }
    
    func go(sender: ETableViewCellButton){
        print("button pressed \(sender.superview!.superview!.tag)")
        self.events[sender.superview!.superview!.tag].goManager.button = sender
        self.events[sender.superview!.superview!.tag].goManager.Going()
        
    }
    
    func share(sender: ETableViewCellButton){
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
                    self.eventDeleted(row)
//                    self.collectionView.performBatchUpdates({ () -> Void in
//                        self.collectionView.deleteItemsAtIndexPaths([NSIndexPath(forItem: row, inSection: 0)])
//                        }, completion: nil)
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
    func PushLikes(sender:UIButton){
        let selectedRow = sender.superview!.superview!.tag
        
        let VC:UserListViewController = self.storyboard?.instantiateViewControllerWithIdentifier("UserListViewController") as! UserListViewController
        VC.event = events[selectedRow].eventOriginal!
        VC.Target = "Likers"
        
        self.navigationController?.pushViewController(VC, animated: true)
    }
    func PushGoing(sender:UIButton){
        let selectedRow = sender.superview!.superview!.tag
        
        let VC:UserListViewController = self.storyboard?.instantiateViewControllerWithIdentifier("UserListViewController") as! UserListViewController
        VC.event = events[selectedRow].eventOriginal!
        VC.Target = "Accepted"
        
        self.navigationController?.pushViewController(VC, animated: true)
    }
    func PushShares(sender:UIButton){
        let selectedRow = sender.superview!.superview!.tag
        
        let VC:UserListViewController = self.storyboard?.instantiateViewControllerWithIdentifier("UserListViewController") as! UserListViewController
        VC.event = events[selectedRow].eventOriginal!
        VC.Target = "Shares"
        
        self.navigationController?.pushViewController(VC, animated: true)
    }
    func PushComments(sender:UITapGestureRecognizer){
        let ViewSender:UILabel = sender.view! as! UILabel
        let SelectedIndexPath:NSIndexPath = NSIndexPath(forRow: ViewSender.tag, inSection: 0)
        
        let VC:UserListViewController = self.storyboard?.instantiateViewControllerWithIdentifier("UserListViewController") as! UserListViewController
        VC.event = events[SelectedIndexPath.row].eventOriginal!
        VC.Target = "Likers"
        
        self.navigationController?.pushViewController(VC, animated: true)
    }


    func PushEventViewController(sender:UITapGestureRecognizer)->Void{
        
        let ViewSender = sender.view!
        let selectedRow = ViewSender.tag
        //let Cell:HomeEventTableViewCell = TimelineEventTable.cellForRowAtIndexPath(SelectedIndexPath) as HomeEventTableViewCell
        
        let VC:EventViewController = self.storyboard?.instantiateViewControllerWithIdentifier("EventViewController") as! EventViewController
        VC.event = events[selectedRow]
        
        
        
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    func pushUser(sender:UITapGestureRecognizer){
        let senderTag = sender.view!.tag
        if (events[senderTag].author!.userId == KCSUser.activeUser().userId as NSString){ //clicked on myself
            
            let VC:MyProfileViewController = self.storyboard?.instantiateViewControllerWithIdentifier("MyProfileViewController") as! MyProfileViewController
            self.navigationController?.pushViewController(VC, animated: true)
            
        }else{ //clicked on someone else
            
            let VC:UserProfileViewController = self.storyboard?.instantiateViewControllerWithIdentifier("UserProfileViewController") as! UserProfileViewController
            VC.user = events[senderTag].author!
            self.navigationController?.pushViewController(VC, animated: true)

        }
    }
    
    func loadTimeline(){
        EventsManager.loadEventsForHomeTableView(nil,completionHandler: {
            (downloadedEventsArray:[FetchedEvent], error:NSError!) -> Void in
            self.refreshControlForTimeLine.endRefreshing()
            self.indicator.stopAnimating()
            if (error == nil){
                self.cellHeights = []
                var temp = downloadedEventsArray
                
                if (temp.count < 11){
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
                self.tableView.setContentOffset(CGPointZero, animated: false)
                self.attachFooterView(!self.end)
                
                //load pictures
                
                for (index,_) in self.events.enumerate(){
                    EventsManager().loadPictureForEvent(&self.events[index], completionHandler: {
                        (error:NSError!) -> Void in
                        let cells = self.tableView.visibleCells
                        for cell in cells{
                            if (cell.tag == index){
                                (cell as! HomeEventTableViewCell).UpdateEventPicture(self.events[index], row: index)
                            }
                            
                        }
                    })
                    EventsManager().loadProfilePictureForEvent(&self.events[index], completionHandler: {
                        (error:NSError!) -> Void in
                        if (error == nil){
                            if (self.tableView.headerViewForSection(index) != nil){
                                let header:eventHeaderView = self.tableView.headerViewForSection(index) as! eventHeaderView
                                header.updateProfilePicture(
                                    self.events[index].profilePictureID as String,
                                    progress: self.events[index].profilePictureProgress,
                                    image: self.events[index].profilePicture)
                            }
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
    func loadMore(){
        print("loadmore")
        if footerView.isAnimating {
            return
        }
        footerView.startAnimating()
        EventsManager.loadEventsForHomeTableView(self.events.last!,completionHandler: {
            (downloadedEventsArray:[FetchedEvent], error:NSError!) -> Void in
            
            self.footerView.stopAnimating((error == nil) ? true : false)
            if (error == nil){
                var temp = downloadedEventsArray

                if (temp.count < 11){
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
                self.attachFooterView(!self.end)
                //load pictures
                
                for (index,_) in self.events.enumerate(){
                    EventsManager().loadPictureForEvent(&self.events[index], completionHandler: {
                        (error:NSError!) -> Void in
                        let cells = self.tableView.visibleCells
                        for cell in cells{
                            if (cell.tag == index){
                                (cell as! HomeEventTableViewCell).UpdateEventPicture(self.events[index], row: index)
                            }
                            
                        }
                    })
                    EventsManager().loadProfilePictureForEvent(&self.events[index], completionHandler: {
                        (error:NSError!) -> Void in
                        if (error == nil){
                            if (self.tableView.headerViewForSection(index) != nil){
                                let header:eventHeaderView = self.tableView.headerViewForSection(index) as! eventHeaderView
                                header.updateProfilePicture(
                                    self.events[index].profilePictureID as String,
                                    progress: self.events[index].profilePictureProgress,
                                    image: self.events[index].profilePicture)
                            }
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

    @IBAction func SwitchBetweenCollectionAndTableView(sender: AnyObject) {
        if (tableView.hidden == true) //calendar up
        {
            let ButtonIcon:UIImage = UIImage(named: "calendar.png")!
            SwitchButton.image = ButtonIcon
            calendarSuperView.hidden = true
            tableView.hidden = false
            self.view.bringSubviewToFront(tableView)
        }
        else // table up
        {
            self.moveNavBar(1000, animated: false)
            self.tableView.setContentOffset(self.tableView.contentOffset, animated: false)
            let ButtonIcon:UIImage = UIImage(named: "iconTable.png")!
            SwitchButton.image = ButtonIcon
            calendarSuperView.hidden = false
            tableView.hidden = true
            self.view.bringSubviewToFront(calendarSuperView)
        }
        
    }



    func countNumberOfEventsForSelectedMonth(){
        self.calendarView.scrollEnabled = false

        self.numberOfEventsForCollectionView.removeAllObjects()
        self.nsDatesForAllEvents.removeAllObjects()

        //We do that to make PFQuery which will get events for particular day
        let DateForInitialization:NSDate = NSDate()
        let calendar:NSCalendar = NSCalendar.currentCalendar()
        var DateComponents:NSDateComponents = calendar.components([NSCalendarUnit.Year, NSCalendarUnit.Month, NSCalendarUnit.Day, NSCalendarUnit.Hour, NSCalendarUnit.Minute, NSCalendarUnit.Second], fromDate: DateForInitialization)
        
        DateComponents.hour = 0
        DateComponents.minute = 0
        DateComponents.second = 0
        DateComponents.day = 1
        DateComponents.month = self.SelectedMonth
        DateComponents.year = self.SelectedYear
        let StartOfTheMonth:NSDate = calendar.dateFromComponents(DateComponents)!
        
        //calculate number of days in a month
        let Range:NSRange = calendar.rangeOfUnit(NSCalendarUnit.Day, inUnit: NSCalendarUnit.Month, forDate: StartOfTheMonth)
        let numberOfDaysInMonth:Int = Range.length;

        DateComponents.hour = 23
        DateComponents.minute = 59
        DateComponents.second = 59
        DateComponents.day = numberOfDaysInMonth
        DateComponents.month = self.SelectedMonth
        DateComponents.year = self.SelectedYear
        let EndOfTheMonth:NSDate = calendar.dateFromComponents(DateComponents)!

        //query to find all events
        let store = KCSAppdataStore.storeWithOptions([
            KCSStoreKeyCollectionName : "Events",
            KCSStoreKeyCollectionTemplateClass : Event.self
            ])
        
        let dateRangeQuery = KCSQuery(onField: "date", usingConditionalPairs: [
            KCSQueryConditional.KCSGreaterThan.rawValue, StartOfTheMonth,
            KCSQueryConditional.KCSLessThan.rawValue, EndOfTheMonth
            ])
        let query:KCSQuery = dateRangeQuery
        store.queryWithQuery(query,withCompletionBlock: {
            (objects: [AnyObject]!, error: NSError!) -> Void in
            
            if (error == nil){
                let events = objects as! [Event]
                for event in events{
                    self.nsDatesForAllEvents.addObject(event.date!)
                }
                
                self.numberOfEventsForCollectionView.removeAllObjects()
                
                for var i = 0; i < numberOfDaysInMonth; i++ {
                    self.numberOfEventsForCollectionView.addObject(0) // from empty array to
                }

                var day:Int = Int()
                
                for date in self.nsDatesForAllEvents{
                    DateComponents = calendar.components([NSCalendarUnit.Year, NSCalendarUnit.Month, NSCalendarUnit.Day, NSCalendarUnit.Hour, NSCalendarUnit.Minute, NSCalendarUnit.Second], fromDate: date as! NSDate)
                    day = DateComponents.day
                    self.numberOfEventsForCollectionView[day-1] = (self.numberOfEventsForCollectionView[day-1] as! Int) + 1
                }

                self.refreshControlForCalendar.endRefreshing()
                self.calendarView.scrollEnabled = true
                self.CalculateSkippedDays()
                self.calendarView.reloadData()
            }else{
                self.calendarView.scrollEnabled = true
                self.refreshControlForCalendar.endRefreshing()
            }

            },
            withProgressBlock: nil
        )
        
    }
    
    func Jump_To_Month(){
        print("Hello")
    }

}
