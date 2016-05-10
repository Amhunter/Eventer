//
//  DayViewController.swift
//  Eventer
//
//  Created by Grisha on 26/10/2014.
//  Copyright (c) 2014 Grisha. All rights reserved.
//


import UIKit
import CoreData
class DayViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate{

    @IBOutlet var EventTable: HomeEventTableView!
    var SelectedDay:Int = Int()
    var SelectedMonth:Int = Int()
    var SelectedYear:Int = Int()
    
    var TimelineData:NSMutableArray = NSMutableArray() //events retrieved
    var AuthorsData:NSMutableArray = NSMutableArray() // Authors retrieved for these event ,we load more data at once,but we save on 1 request per time,we use these PFOBjects to retrieve data from User class
    var EventImages:NSMutableArray = NSMutableArray() // pictures to events


    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    override func viewDidAppear(animated: Bool) {

        self.title = String(SelectedDay) + " " + String(SelectedMonth) + " " + String(SelectedYear)

        //tableView.reloadData()
        LoadData()
    
    }
    
    func LoadData(){
        EventImages.removeAllObjects()
        TimelineData.removeAllObjects()
        AuthorsData.removeAllObjects()

        //Create two dates for this morning at 12:00am and tonight at 11:59pm
        //We do that to make PFQuery which will get events for particular day
        let DateForInitialization:NSDate = NSDate()
        let calendar:NSCalendar = NSCalendar.currentCalendar()
        let DateComponents:NSDateComponents = calendar.components([NSCalendarUnit.Year, NSCalendarUnit.Month, NSCalendarUnit.Day, NSCalendarUnit.Hour, NSCalendarUnit.Minute, NSCalendarUnit.Second], fromDate: DateForInitialization)
        DateComponents.hour = 0
        DateComponents.minute = 0
        DateComponents.second = 0
        DateComponents.day = self.SelectedDay
        DateComponents.month = self.SelectedMonth
        DateComponents.year = self.SelectedYear
        let StartOfTheDay:NSDate = calendar.dateFromComponents(DateComponents)!
        
        DateComponents.hour = 23
        DateComponents.minute = 59
        DateComponents.second = 59
        DateComponents.day = self.SelectedDay
        DateComponents.month = self.SelectedMonth
        DateComponents.year = self.SelectedYear
        let EndOfTheDay:NSDate = calendar.dateFromComponents(DateComponents)!
    
        
        //query to find all events
        
        let store = KCSAppdataStore.storeWithOptions([
            KCSStoreKeyCollectionName : "Events",
            KCSStoreKeyCollectionTemplateClass : Event.self
            ])
        
        let dateRangeQuery = KCSQuery(onField: "date", usingConditionalPairs: [
            KCSQueryConditional.KCSGreaterThan.rawValue, StartOfTheDay,
            KCSQueryConditional.KCSLessThan.rawValue, EndOfTheDay
            ])
        let query:KCSQuery = dateRangeQuery
        store.queryWithQuery(query,withCompletionBlock: {
            (objects: [AnyObject]!, error: NSError!) -> Void in
            if (error == nil){
                let events = objects as! [Event]
                for event in events{
                    self.TimelineData.addObject(event)
                    //self.EventImages.addObject(event.picture!) //
                }
                self.EventTable.reloadData()
                print("\(self.TimelineData.count)")

            }else{
                print("\(error.description)")
            }
            },
            withProgressBlock: nil
        )
        
    }
    
    
    
    
    
    //-------------------Table-Part--------------------//
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.TimelineData.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let EventCell:HomeEventTableViewCell = EventTable.dequeueReusableCellWithIdentifier("EventCell", forIndexPath: indexPath) as! HomeEventTableViewCell
        
        EventCell.eventNameLabel.text = self.TimelineData[indexPath.row]["eventName"] as? String
        EventCell.eventDescriptionLabel.text = self.TimelineData[indexPath.row]["description"] as? String
        EventCell.pictureImageView.image = self.EventImages[indexPath.row] as? UIImage
        
        let EventDateFormatter = NSDateFormatter()
        EventDateFormatter.dateFormat = "HH:mm"
        let EventDate:NSDate = self.TimelineData[indexPath.row]["date"] as! NSDate
        EventCell.eventDateLabel.text = EventDateFormatter.stringFromDate(EventDate)
        
        // click on EventName will push another view controller
        EventCell.eventNameLabel.tag = indexPath.row // this is to remember in which cell we clicked the label
        EventCell.eventNameLabel.userInteractionEnabled = true
        let EventNameTapRecognizer:UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.PushEventViewController(_:))) // we put : if called func has arguments
        EventCell.eventNameLabel.addGestureRecognizer(EventNameTapRecognizer)

        return EventCell
    }
    //-------------------------------------------------//
    
    
    
    
    // Event Name Pushed//
    func PushEventViewController(sender:UITapGestureRecognizer)->Void{
        
//        let ViewSender:UIView = sender.view! as UIView
//        let SelectedIndexPath:NSIndexPath = NSIndexPath(forRow: ViewSender.tag, inSection: 0)
        //let EventCell:HomeEventTableViewCell = TimelineEventTable.cellForRowAtIndexPath(SelectedIndexPath) as HomeEventTableViewCell
        
        let VC:EventViewController = self.storyboard?.instantiateViewControllerWithIdentifier("EventViewController") as! EventViewController
        //VC.event = TimelineData[SelectedIndexPath.row] as PFObject
        //VC.author = self.AuthorsData[SelectedIndexPath.row] as PFUser
        
        self.navigationController?.pushViewController(VC, animated: true)
    }
    
    //------------User--Name-Tapped-----------------------//
    func PushUserProfileViewController(sender:UITapGestureRecognizer){
        let ViewSender:UIView = sender.view! as UIView
        let SelectedIndexPath:NSIndexPath = NSIndexPath(forRow: ViewSender.tag, inSection: 0)
        //let SelectedIndexPath:NSIndexPath = NSIndexPath(forRow: LabelSender.tag, inSection: 0)
        if (AuthorsData[SelectedIndexPath.row]["_id"] as! NSString == KCSUser.activeUser().userId as NSString){ //clicked on myself
            
            let VC:MyProfileViewController = self.storyboard?.instantiateViewControllerWithIdentifier("MyProfileViewController") as! MyProfileViewController
            //VC.user = AuthorsData[SelectedIndexPath.row] as! KCSUser
            //VC.user = KCSUser.activeUser()
            self.navigationController?.pushViewController(VC, animated: true)
            
        }else{ //clicked on someone else
            
            let VC:UserProfileViewController = self.storyboard?.instantiateViewControllerWithIdentifier("UserProfileViewController") as! UserProfileViewController
            VC.user = AuthorsData[SelectedIndexPath.row] as! KCSUser
            self.navigationController?.pushViewController(VC, animated: true)
            
        }
    }
    //----------------------------------------------------//
    

    
    //just to change back button icon
    @IBAction func BackButtonPressed(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }
    
}


