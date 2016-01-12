//
//  EventDatePickerView.swift
//  Eventer
//
//  Created by Grisha on 14/09/2015.
//  Copyright (c) 2015 Grisha. All rights reserved.
//

import UIKit
protocol EventDatePickerViewDelegate {
    func didPickDate(date:NSDate)
}
class EventDatePickerView: UIView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate {
    var screenWidth = UIScreen.mainScreen().bounds.width
    var delegate:EventDatePickerViewDelegate!
    
    // Date Variables
    var today = NSDate()
    var calendar = NSCalendar.currentCalendar()
    var active = false
    
    // Week View
    var weekCollectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: EventDatePickerViewLayout())
    var weekLayout = EventDatePickerViewLayout()
    var monthBeginning = NSDate()
    var numberOfDaysInSelectedMonth = 0
    var weekDayWidth:CGFloat = 0
    var weekDayHeight:CGFloat = 0
    var cellsLoadedSimultaneously = 80
    var startingIndexpath = (80*3/8)

    // Calendar View
    var monthCollectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: EventDatePickerCalendarLayout())
    var skippedDays:[Int] = [0,0,0]
    var monthLayout = EventDatePickerCalendarLayout()
    var lastMonth = NSDate()
    var thisMonth = NSDate()
    var nextMonth = NSDate()
    var numberOfDaysInMonth:[Int] = [0,0,0] // [0] - last , [1] - this , [2] next

    // Other
    var monthLabel = UILabel()
    var switchToCalendarButton = UIButton()
    var todayButton = UIButton()
    
    // Time Picker View
    var timePickerSuperview = UIView()
    var timePicker = UIDatePicker()
    var selectedDayLabel = UILabel()
    var backToDateButton = UIButton()
    var doneButton = UIButton()
    
    var selectedDate = NSDate()
    
    func initializeView(weekDaySize:CGSize) {
        self.frame.size.width = screenWidth
        weekDayWidth = weekDaySize.width
        weekDayHeight = weekDaySize.height
        let frameWidth = self.frame.width
        _ = self.frame.height
        
        self.addSubview(weekCollectionView)
        self.addSubview(monthCollectionView)
        self.addSubview(monthLabel)
        self.addSubview(switchToCalendarButton)
        self.addSubview(todayButton)
        let labelAndButtonHeight:CGFloat = 60
        
        // Frames
        let buttonWidth:CGFloat = 70
        todayButton.frame = CGRectMake(0, 0, buttonWidth, labelAndButtonHeight)
        monthLabel.frame = CGRectMake(buttonWidth, 0, frameWidth-(2*buttonWidth), labelAndButtonHeight)
        switchToCalendarButton.frame = CGRectMake(frameWidth-buttonWidth, 0, buttonWidth, labelAndButtonHeight)
        weekCollectionView.frame = CGRectMake(0,labelAndButtonHeight, screenWidth, weekDaySize.height)
        monthCollectionView.frame = CGRectMake(0,labelAndButtonHeight, screenWidth, CGFloat(Int(screenWidth-5)))
        weekCollectionView.hidden = false
        monthCollectionView.hidden = true
        
        // Customize View
        self.backgroundColor = UIColor.groupTableViewBackgroundColor()
        
        // Month Collection View
        weekCollectionView.collectionViewLayout = weekLayout
        weekLayout.itemSize = weekDaySize
        weekLayout.minimumLineSpacing = 0
        weekCollectionView.delegate = self
        weekCollectionView.dataSource = self
        weekCollectionView.tag = 0
        weekCollectionView.showsHorizontalScrollIndicator = false
        weekCollectionView.registerClass(EventDatePickerViewCell.self, forCellWithReuseIdentifier: "Weekday Cell")
        weekCollectionView.backgroundColor = UIColor.whiteColor()
        
        // Week Collection View
        monthCollectionView.tag = 1
        monthCollectionView.collectionViewLayout = monthLayout
        monthCollectionView.pagingEnabled = true
        monthCollectionView.scrollEnabled = true
        monthCollectionView.delegate = self
        monthCollectionView.dataSource = self
        monthCollectionView.showsHorizontalScrollIndicator = false
        monthCollectionView.registerClass(EventDatePickerCalendarWeekdayCell.self, forCellWithReuseIdentifier: "Weekday Cell")
        monthCollectionView.registerClass(EventDatePickerCalendarCell.self, forCellWithReuseIdentifier: "Day Cell")
        monthCollectionView.backgroundColor = UIColor.groupTableViewBackgroundColor()
        monthCollectionView.reloadData()
        monthLabel.textColor = ColorFromCode.randomBlueColorFromNumber(3)
        monthLabel.font = UIFont(name: "Lato-Semibold", size: 16)
        monthLabel.textAlignment = NSTextAlignment.Center
        
        let ButtonIcon:UIImage = UIImage(named: "calendar.png")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        switchToCalendarButton.setImage(ButtonIcon, forState: UIControlState.Normal)
        switchToCalendarButton.tintColor = ColorFromCode.standardBlueColor()
        switchToCalendarButton.addTarget(self, action: "switchViews", forControlEvents: UIControlEvents.TouchUpInside)

        
        todayButton.setTitle("TODAY", forState: UIControlState.Normal)
        todayButton.setTitleColor(ColorFromCode.randomBlueColorFromNumber(3), forState: UIControlState.Normal)
        todayButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Highlighted)
        todayButton.titleLabel!.font = UIFont(name: "Lato-Semibold", size: 12)
        todayButton.titleLabel!.numberOfLines = 0
        todayButton.addTarget(self, action: "backToToday", forControlEvents: UIControlEvents.TouchUpInside)

        // Setting Dates
        let todayComponents = calendar.components([NSCalendarUnit.Year, NSCalendarUnit.Month, NSCalendarUnit.Day], fromDate: NSDate())
        today = calendar.dateFromComponents(todayComponents)!
        let beginningOfTheMonthComponents = calendar.components([NSCalendarUnit.Year, NSCalendarUnit.Month], fromDate: NSDate())
        monthBeginning = calendar.dateFromComponents(beginningOfTheMonthComponents)!
        numberOfDaysInSelectedMonth = calendar.rangeOfUnit(NSCalendarUnit.Day, inUnit: NSCalendarUnit.Month, forDate: today).length
        let monthString = DateToStringConverter.monthInText(calendar.component(NSCalendarUnit.Month, fromDate: monthBeginning), shorten: false)
        let yearString = (calendar.component(NSCalendarUnit.Year, fromDate: monthBeginning))
        self.monthLabel.text = "\(monthString) \(yearString)"

        weekCollectionView.reloadData()
        weekCollectionView.scrollToItemAtIndexPath(NSIndexPath(forRow: startingIndexpath+todayComponents.day-1, inSection: 0), atScrollPosition: UICollectionViewScrollPosition.Left, animated: false)
        
        // Set Calendar View
        thisMonth = monthBeginning
        calculateForMonthChange()
        monthCollectionView.reloadData()
        monthCollectionView.contentOffset = CGPointMake(screenWidth, 0)
        
        self.frame.size.height = labelAndButtonHeight + self.weekCollectionView.frame.size.height
        initializeTimePicker()
    }
    
    func initializeTimePicker(){
        self.addSubview(timePickerSuperview)
        
        timePickerSuperview.hidden = true
        timePickerSuperview.backgroundColor = UIColor.whiteColor()
        
        timePickerSuperview.frame.size = self.frame.size
        timePickerSuperview.addSubview(timePicker)
        timePickerSuperview.addSubview(selectedDayLabel)
        timePickerSuperview.addSubview(backToDateButton)
        timePickerSuperview.addSubview(doneButton)

        
        let backImage = UIImage(named: "back.png")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        backToDateButton.setImage(backImage, forState: UIControlState.Normal)
        backToDateButton.tintColor = UIColor.blackColor()
        backToDateButton.sizeToFit()
        backToDateButton.frame.size.width = 50
        backToDateButton.addTarget(self, action: "backToDate", forControlEvents: UIControlEvents.TouchUpInside)
        let buttonWidth = backToDateButton.frame.size.width
        let buttonHeight = backToDateButton.frame.size.height
        
        doneButton.setTitle("Done", forState: UIControlState.Normal)
        doneButton.setTitleColor(ColorFromCode.randomBlueColorFromNumber(3), forState: UIControlState.Normal)
        doneButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Highlighted)
        doneButton.titleLabel!.font = UIFont(name: "Lato-Semibold", size: 17)
        doneButton.addTarget(self, action: "done", forControlEvents: UIControlEvents.TouchUpInside)
        doneButton.frame.size.width = buttonWidth
        doneButton.frame.size.height = backToDateButton.frame.height
        doneButton.frame.origin.x = screenWidth-buttonWidth-20 // 20 for offset

        selectedDayLabel.frame.origin.x = buttonWidth
        selectedDayLabel.frame.size = CGSizeMake(screenWidth-(2*buttonWidth), buttonHeight)
        let attString = NSMutableAttributedString(string: "", attributes: [NSForegroundColorAttributeName: UIColor.blackColor(), NSFontAttributeName : UIFont(name: "Lato-Semibold", size: 16)!])
        attString.appendAttributedString(NSAttributedString(string: "23 September", attributes: [NSForegroundColorAttributeName: ColorFromCode.randomBlueColorFromNumber(3), NSFontAttributeName : UIFont(name: "Lato-Semibold", size: 17)!]))
        selectedDayLabel.attributedText = attString
        //selectedDayLabel.font = UIFont(name: "Lato-Semibold", size: 18)
        selectedDayLabel.textAlignment = NSTextAlignment.Center
        
        timePicker.frame.size = CGSizeMake(screenWidth, 50)
        timePicker.sizeToFit()
//        var pickerHeight = timePicker.frame.height
        timePicker.frame.origin.y = selectedDayLabel.frame.height
        timePicker.datePickerMode = UIDatePickerMode.Time
    }
    
    
    
    func showTimePicker(show:Bool){
        if show {
            timePickerSuperview.hidden = false
            self.frame.origin.y = self.superview!.frame.height-self.timePickerSuperview.frame.height
            self.frame.size.height = self.timePickerSuperview.frame.height
        } else {
            timePickerSuperview.hidden = true
            if weekCollectionView.hidden == true {
                self.frame.size.height = 60 + self.monthCollectionView.frame.size.height
            } else {
                self.frame.size.height = 60 + self.weekCollectionView.frame.size.height
            }
            self.frame.origin.y = self.superview!.frame.height-self.frame.height
        }
    }
    func done(){
        let temp = calendar.components([NSCalendarUnit.Hour,NSCalendarUnit.Minute], fromDate: timePicker.date)
        let components = calendar.components([NSCalendarUnit.Year,NSCalendarUnit.Month,NSCalendarUnit.Day], fromDate: selectedDate)
        components.hour = temp.hour
        components.minute = temp.minute
        let modifiedDate = calendar.dateFromComponents(components)
        delegate.didPickDate(modifiedDate!)
    }
    func backToDate(){
        showTimePicker(false)
    }
    
    var switchingViews = false
    func switchViews(){
        //let heightDifference = self.monthCollectionView.frame.height - self.weekCollectionView.frame.height
        if switchingViews {
            return
        }
        switchingViews = true
        if weekCollectionView.hidden == true {
            
            weekCollectionView.hidden = false // show month
            monthCollectionView.hidden = true
            let monthString = DateToStringConverter.monthInText(calendar.component(NSCalendarUnit.Month, fromDate: monthBeginning), shorten: false)
            let yearString = (calendar.component(NSCalendarUnit.Year, fromDate: monthBeginning))
            self.monthLabel.text = "\(monthString) \(yearString)"
            
            let buttonIcon:UIImage = UIImage(named: "calendar.png")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
            switchToCalendarButton.setImage(buttonIcon, forState: UIControlState.Normal)
            switchToCalendarButton.transform = CGAffineTransformIdentity
            self.frame.size.height = 60 + self.weekCollectionView.frame.size.height
            self.frame.origin.y = self.superview!.frame.height - self.frame.size.height
            
        } else {
            
            weekCollectionView.hidden = true // show month
            monthCollectionView.hidden = false
            let monthString = DateToStringConverter.monthInText(calendar.component(NSCalendarUnit.Month, fromDate: thisMonth), shorten: false)
            let yearString = (calendar.component(NSCalendarUnit.Year, fromDate: thisMonth))
            self.monthLabel.text = "\(monthString) \(yearString)"
            
            let buttonIcon:UIImage = UIImage(named: "iconTable.png")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
            switchToCalendarButton.setImage(buttonIcon, forState: UIControlState.Normal)
            switchToCalendarButton.transform = CGAffineTransformMakeScale(0.75, 0.75)
            self.frame.size.height = 60 + self.monthCollectionView.frame.size.height
            self.frame.origin.y = self.superview!.frame.height - self.frame.size.height
        }
        switchingViews = false
    }
    func backToToday(){
        
        if weekCollectionView.hidden == false {
            // Setting Dates
            let todayComponents = calendar.components([NSCalendarUnit.Year, NSCalendarUnit.Month, NSCalendarUnit.Day], fromDate: NSDate())
            today = calendar.dateFromComponents(todayComponents)!
            let beginningOfTheMonthComponents = calendar.components([NSCalendarUnit.Year, NSCalendarUnit.Month], fromDate: NSDate())
            monthBeginning = calendar.dateFromComponents(beginningOfTheMonthComponents)!
            numberOfDaysInSelectedMonth = calendar.rangeOfUnit(NSCalendarUnit.Day, inUnit: NSCalendarUnit.Month, forDate: today).length
            let monthString = DateToStringConverter.monthInText(calendar.component(NSCalendarUnit.Month, fromDate: monthBeginning), shorten: false)
            let yearString = (calendar.component(NSCalendarUnit.Year, fromDate: monthBeginning))
            self.monthLabel.text = "\(monthString) \(yearString)"
            
            weekCollectionView.reloadData()
            weekCollectionView.scrollToItemAtIndexPath(NSIndexPath(forRow: startingIndexpath+todayComponents.day-1, inSection: 0), atScrollPosition: UICollectionViewScrollPosition.Left, animated: false)
        } else {
            // Setting Dates
            let todayComponents = calendar.components([NSCalendarUnit.Year, NSCalendarUnit.Month, NSCalendarUnit.Day], fromDate: NSDate())
            today = calendar.dateFromComponents(todayComponents)!
            let beginningOfTheMonthComponents = calendar.components([NSCalendarUnit.Year, NSCalendarUnit.Month], fromDate: NSDate())
            thisMonth = calendar.dateFromComponents(beginningOfTheMonthComponents)!
            calculateForMonthChange()
            let monthString = DateToStringConverter.monthInText(calendar.component(NSCalendarUnit.Month, fromDate: thisMonth), shorten: false)
            let yearString = (calendar.component(NSCalendarUnit.Year, fromDate: thisMonth))
            self.monthLabel.text = "\(monthString) \(yearString)"
            
            self.monthCollectionView.contentOffset = CGPointMake(screenWidth, 0)
            self.monthCollectionView.reloadData()
        }

    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    init(){
        super.init(frame: CGRectZero)
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        if collectionView.tag == 1 {
            return 3
        } else {
            return 1
        }
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if (collectionView.tag == 0) {
            return cellsLoadedSimultaneously // for infinite scrolling
            // initial cell displayed is 30
        } else {
            return 7+skippedDays[section]+self.numberOfDaysInMonth[section]
        }
    }

    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if collectionView.tag == 0 {
            let Cell = collectionView.dequeueReusableCellWithReuseIdentifier("Weekday Cell", forIndexPath: indexPath) as! EventDatePickerViewCell
            let indexPath = NSIndexPath(forRow: indexPath.row-startingIndexpath, inSection: indexPath.section)
            let date = monthBeginning.dateByAddingTimeInterval(Double(3600*24*indexPath.row))
            let month = calendar.component(NSCalendarUnit.Month, fromDate: date)
            let monthString = DateToStringConverter.monthInText(month, shorten: true)
            Cell.dayLabel.text = "\(monthString) \(calendar.component(NSCalendarUnit.Day, fromDate: date))"
            Cell.weekDayLabel.text = DateToStringConverter.getWeekdayFromDate(date)
            Cell.backgroundColor = ColorFromCode.randomBlueColorFromNumber(month)
            if Cell.weekDayLabel.text == "Today" {
                Cell.backgroundColor = UIColor.blackColor()
            }
            return Cell
        } else {
            if indexPath.row < 7 {
                let Cell = collectionView.dequeueReusableCellWithReuseIdentifier("Weekday Cell", forIndexPath: indexPath) as! EventDatePickerCalendarWeekdayCell
                Cell.setWeekDay(indexPath.row)
                Cell.backgroundColor = ColorFromCode.tabForegroundColor()
                return Cell
            } else {
                let Cell = collectionView.dequeueReusableCellWithReuseIdentifier("Day Cell", forIndexPath: indexPath) as! EventDatePickerCalendarCell
                if indexPath.row-7 < self.skippedDays[indexPath.section]{
                    Cell.hidden = true
                } else {
                    Cell.hidden = false
                    let month = calendar.component(NSCalendarUnit.Month, fromDate: thisMonth)
                    Cell.dayLabel.text = "\(indexPath.row-skippedDays[indexPath.section]+1-7)"
                    Cell.backgroundColor = ColorFromCode.randomBlueColorFromNumber(month+indexPath.section)
                }
                return Cell
            }

        }

    }
    
    
    var monthChanging = false
    var calendarChanging = false
    var previousDayDisplayed:Int = 0
    var shift:Int = 0
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView.tag == 0 {
            let beginningOfTheMonth = self.weekDayWidth*CGFloat(self.startingIndexpath)
            let endOfTheMonth = beginningOfTheMonth+(self.weekDayWidth*CGFloat(self.numberOfDaysInSelectedMonth))
            //println(scrollView.contentOffset.x)
            let currentOffsetX = self.weekCollectionView.contentOffset.x
            if !monthChanging {
                if (currentOffsetX >= endOfTheMonth) {
                    // increment
                    
                    monthChanging = true
                    //println("increment month")
                    // Composing NSDate for nextMonth
                    
                    let numberOfDaysInPreviousMonth = calendar.rangeOfUnit(NSCalendarUnit.Day, inUnit: NSCalendarUnit.Month, forDate: monthBeginning).length
                    
                    monthBeginning = calendar.dateByAddingUnit(NSCalendarUnit.Month, value: 1, toDate: monthBeginning, options: [])!
                    numberOfDaysInSelectedMonth = calendar.rangeOfUnit(NSCalendarUnit.Day, inUnit: NSCalendarUnit.Month, forDate: monthBeginning).length
                    // Prepare Strings
                    let monthString = DateToStringConverter.monthInText(calendar.component(NSCalendarUnit.Month, fromDate: monthBeginning), shorten: false)
                    let yearString = (calendar.component(NSCalendarUnit.Year, fromDate: monthBeginning))
                    self.monthLabel.text = "\(monthString) \(yearString)"
                    // Update CollectionView and prepare content
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        var futureOffsetX:CGFloat = 0
                        self.shift = numberOfDaysInPreviousMonth
                        futureOffsetX = currentOffsetX-(self.weekDayWidth*CGFloat(numberOfDaysInPreviousMonth))
                        self.weekCollectionView.contentOffset = CGPointMake(futureOffsetX, 0)
                        self.weekCollectionView.reloadData()
                        self.monthChanging = false
                    })
                } else if (currentOffsetX <= beginningOfTheMonth) {
                    // decrement
                    
                    monthChanging = true
                    //println("decrement month")
                    // Composing NSDate for nextMonth
                    
//                    var numberOfDaysInPreviousMonth = calendar.rangeOfUnit(NSCalendarUnit.Day, inUnit: NSCalendarUnit.Month, forDate: monthBeginning).length
                    
                    monthBeginning = calendar.dateByAddingUnit(NSCalendarUnit.Month, value: -1, toDate: monthBeginning, options: [])!
                    numberOfDaysInSelectedMonth = calendar.rangeOfUnit(NSCalendarUnit.Day, inUnit: NSCalendarUnit.Month, forDate: monthBeginning).length
                    // Prepare Strings
                    let monthString = DateToStringConverter.monthInText(calendar.component(NSCalendarUnit.Month, fromDate: monthBeginning), shorten: false)
                    let yearString = (calendar.component(NSCalendarUnit.Year, fromDate: monthBeginning))
                    self.monthLabel.text = "\(monthString) \(yearString)"
                    // Update CollectionView and prepare content
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        var futureOffsetX:CGFloat = 0
                        futureOffsetX = currentOffsetX+(self.weekDayWidth*CGFloat(self.numberOfDaysInSelectedMonth))
                        self.weekCollectionView.contentOffset = CGPointMake(futureOffsetX, 0)
                        self.weekCollectionView.reloadData()
                        self.monthChanging = false
                    })
                }
            }
        } else if scrollView.tag == 1 {
            let currentOffsetX = scrollView.contentOffset.x
            if !calendarChanging {
                if (currentOffsetX >= screenWidth*2) { // next month
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.calendarChanging = true
                        self.thisMonth = self.calendar.dateByAddingUnit(NSCalendarUnit.Month, value: 1, toDate: self.thisMonth, options: [])!
                        // Prepare Strings
                        let monthString = DateToStringConverter.monthInText(self.calendar.component(NSCalendarUnit.Month, fromDate: self.thisMonth), shorten: false)
                        let yearString = (self.calendar.component(NSCalendarUnit.Year, fromDate: self.thisMonth))
                        self.monthLabel.text = "\(monthString) \(yearString)"
                        self.calculateForMonthChange()
                        var futureOffsetX:CGFloat = 0
                        futureOffsetX = self.screenWidth
                        self.monthCollectionView.contentOffset = CGPointMake(futureOffsetX, 0)
                        self.monthCollectionView.reloadData()
                        self.calendarChanging = false
                    })
                } else if (currentOffsetX <= 0) {
                    calendarChanging = true
                    thisMonth = calendar.dateByAddingUnit(NSCalendarUnit.Month, value: -1, toDate: thisMonth, options: [])!
                    // Prepare Strings
                    let monthString = DateToStringConverter.monthInText(calendar.component(NSCalendarUnit.Month, fromDate: thisMonth), shorten: false)
                    let yearString = (calendar.component(NSCalendarUnit.Year, fromDate: thisMonth))
                    self.monthLabel.text = "\(monthString) \(yearString)"
                    self.calculateForMonthChange()
                    
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        var futureOffsetX:CGFloat = 0
                        futureOffsetX = self.screenWidth
                        self.monthCollectionView.contentOffset = CGPointMake(futureOffsetX, 0)
                        self.monthCollectionView.reloadData()
                        self.calendarChanging = false
                    })

                }
            }

        }
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let attributes = [NSForegroundColorAttributeName: ColorFromCode.randomBlueColorFromNumber(3), NSFontAttributeName : UIFont(name: "Lato-Medium", size: 17.5)!]
        let attString = NSMutableAttributedString(string: "", attributes: attributes)

        if collectionView.tag == 0 {
            
            let indexPath = NSIndexPath(forRow: indexPath.row-startingIndexpath, inSection: indexPath.section)
            let date = monthBeginning.dateByAddingTimeInterval(Double(3600*24*indexPath.row))
            let month = calendar.component(NSCalendarUnit.Month, fromDate: date)
            let monthString = DateToStringConverter.monthInText(month, shorten: false)
            let dayString = "\(calendar.component(NSCalendarUnit.Day, fromDate: date)) "
            let year = calendar.component(NSCalendarUnit.Year, fromDate: date)
            
            attString.appendAttributedString(NSAttributedString(string: dayString, attributes: attributes))
            attString.appendAttributedString(NSAttributedString(string: monthString, attributes: attributes))

            if year != calendar.component(NSCalendarUnit.Year, fromDate: today) {
                attString.appendAttributedString(NSAttributedString(string: " \(year)", attributes: attributes))
            }
            selectedDayLabel.attributedText = attString
            
            // save date
            let dateComponents = NSDateComponents()
            dateComponents.year = year
            dateComponents.month = month
            dateComponents.day = calendar.component(NSCalendarUnit.Day, fromDate: date)
            selectedDate = calendar.dateFromComponents(dateComponents)!
            
            showTimePicker(true)
        } else {
            var date = thisMonth
            if (indexPath.section == 0){
                date = lastMonth
            } else if (indexPath.section == 2){
                date = nextMonth
            }
            let month = calendar.component(NSCalendarUnit.Month, fromDate: date)
            let monthString = DateToStringConverter.monthInText(month, shorten: false)
            let dayString = "\(indexPath.row-skippedDays[indexPath.section]+1-7) "
            let year = calendar.component(NSCalendarUnit.Year, fromDate: date)
            
            attString.appendAttributedString(NSAttributedString(string: dayString, attributes: attributes))
            attString.appendAttributedString(NSAttributedString(string: monthString, attributes: attributes))
            
            if year != calendar.component(NSCalendarUnit.Year, fromDate: today) {
                attString.appendAttributedString(NSAttributedString(string: " \(year)", attributes: attributes))
            }
            selectedDayLabel.attributedText = attString
            
            // save date
            let dateComponents = NSDateComponents()
            dateComponents.year = year
            dateComponents.month = month
            dateComponents.day = indexPath.row-skippedDays[indexPath.section]+1-7
            selectedDate = calendar.dateFromComponents(dateComponents)!
            showTimePicker(true)
        }
    }
    
    func calculateForMonthChange(){
        //------calculating skipped days,i.e offset we need to set up for month cells in collectionview
        //now we put day to 1 ,to get the first weekday in order to choose offset for day cells
        // IMPORTANT --- in gregorian calendar 1 - Sunday, 2 - Monday, etc.


        lastMonth = calendar.dateByAddingUnit(NSCalendarUnit.Month, value: -1, toDate: thisMonth, options: [])!
        nextMonth = calendar.dateByAddingUnit(NSCalendarUnit.Month, value: 1, toDate: thisMonth, options: [])!
        self.skippedDays[0] = calendar.components(NSCalendarUnit.Weekday, fromDate: lastMonth).weekday - 2
        if (skippedDays[0] == -1){ //in case of sunday we want it to be 6 instead of -1
            skippedDays[0] = 6
        }
        
        self.skippedDays[1] = calendar.components(NSCalendarUnit.Weekday, fromDate: thisMonth).weekday - 2
        if (skippedDays[1] == -1){ //in case of sunday we want it to be 6 instead of -1
            skippedDays[1] = 6
        }
        
        self.skippedDays[2] = calendar.components(NSCalendarUnit.Weekday, fromDate: nextMonth).weekday - 2
        if (skippedDays[2] == -1){ //in case of sunday we want it to be 6 instead of -1
            skippedDays[2] = 6
        }
        
        numberOfDaysInMonth[0] = calendar.rangeOfUnit(NSCalendarUnit.Day, inUnit: NSCalendarUnit.Month, forDate: lastMonth).length
        numberOfDaysInMonth[1] = calendar.rangeOfUnit(NSCalendarUnit.Day, inUnit: NSCalendarUnit.Month, forDate: thisMonth).length
        numberOfDaysInMonth[2] = calendar.rangeOfUnit(NSCalendarUnit.Day, inUnit: NSCalendarUnit.Month, forDate: nextMonth).length
    }


}
