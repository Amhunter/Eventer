//
//  ActivityButton.swift
//  Eventer
//
//  Created by Grisha on 08/06/2015.
//  Copyright (c) 2015 Grisha. All rights reserved.
//

import UIKit
protocol ActivityButtonDelegate{
    func didGetNumberOfObjects(button:ActivityButton , numberOfObjects:UInt, error:NSError!)
    func didFinishSavingOrDeletingObject(button:ActivityButton,visualnumberOfObjects:UInt, error:NSError!)
    
}
class ActivityButton: UIButton {
    var delegate:ActivityButtonDelegate! = nil
    var size:NSString = "small" // small or big size
    var queriesActive:Int = 0
    
    var event:FetchedEvent!
    
    var isActive:Bool = false //isActive
    var isActuallyActive:Bool = false
    var actualLikeObject:ActivityUnit!

    var wasPressedAtLeastOnce:Bool = false
    var wasInitiallyActive = false
    
    var content:NSString = "" // yes no maybe
    var attempts:Int = 0 //attempts to save or delete
    
    var numberOfActivity:UInt = 0
    var isBusy:Bool = false // if processing a query
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    init(forEvent:FetchedEvent,type:NSString,content:NSString,size:NSString){
        super.init(frame: CGRectMake(0,0,0,0))
        self.layer.cornerRadius = 5
        self.layer.borderColor = UIColor.grayColor().CGColor
        self.backgroundColor = UIColor.groupTableViewBackgroundColor()
        self.titleLabel?.font = UIFont(name: "Helvetica", size: 13)
        self.size = size
        self.event = forEvent
        self.addTarget(self, action: "Like", forControlEvents: UIControlEvents.TouchUpInside)
        self.addTarget(self, action: "Unhighlight", forControlEvents: UIControlEvents.TouchDragOutside)
        self.addTarget(self, action: "Highlight", forControlEvents: UIControlEvents.TouchDragInside)
        self.addTarget(self, action: "Highlight", forControlEvents: UIControlEvents.TouchDown)
    }
    
    func Highlight(){
        if (isActive == true){
            self.backgroundColor = UIColor.grayColor()
            self.setTitle("Like", forState: UIControlState.Normal)
        }else{
            self.backgroundColor = UIColor.redColor()
            self.setTitle("Liked", forState: UIControlState.Normal)
        }
    }
    func Unhighlight(){
        if (isActive == true){
            self.backgroundColor = UIColor.redColor()
            self.setTitle("Liked", forState: UIControlState.Normal)
        }else{
            self.backgroundColor = UIColor.grayColor()
            self.setTitle("Like", forState: UIControlState.Normal)
        }
    }

    func Like(){

        if (isBusy){ //just visual change
            if (isActive == true){
                isActive = false
            }else{
                isActive = true
            }
            Display_Changes(nil)

        }else{
            Save_Like(buttonWasPressed: true)
        }
    }
    
    func Get_Likes(){
        print("Get_Likes")
        //sBusy = true
        //check if I liked it or not
        
        
        let store = KCSLinkedAppdataStore.storeWithOptions([
            KCSStoreKeyCollectionName : "Activity",
            KCSStoreKeyCollectionTemplateClass : ActivityUnit.self
            ])
        
        let query:KCSQuery = KCSQuery()
        query.addQueryOnField("type", withExactMatchForValue: "like")
        query.addQueryOnField("event._id", withExactMatchForValue: self.event!.eventOriginal!.entityId!)
        //query.addQueryOnField("toUser._id", withExactMatchForValue: self.event!.author!.userId)
        query.addQueryOnField("fromUser._id", withExactMatchForValue: KCSUser.activeUser().userId)
        
        store.queryWithQuery(query, withCompletionBlock: {
            (objects:[AnyObject]!, error:NSError!) -> Void in
            if (error == nil){
                
                if (objects.count > 1){
                    self.actualLikeObject = objects[0] as! ActivityUnit

                    self.isActive = true
                    self.isActuallyActive = true
                    
                    // deleting excessive components
                    var objectsToRemove = objects
                    objectsToRemove.removeRange(Range(start: 1, end: objects.count-1))
                    print("more than one response detected, fixing...")
                    
                    let idsToRemove:NSMutableArray = NSMutableArray()
                    for obj in objectsToRemove{
                        idsToRemove.addObject((obj as! ActivityUnit).entityId!)
                    }
                    
                    store.removeObject(NSArray(array: idsToRemove), withCompletionBlock: {
                        (number:UInt, error:NSError!) -> Void in
                        if (error == nil){
                            print("fixed")
                        }else{
                            print("couldnt fix")
                        }
                        }, withProgressBlock: nil)
                    
                }else if (objects.count == 1){
                    self.actualLikeObject = objects[0] as! ActivityUnit

                    self.isActive = true
                    self.isActuallyActive = true
                }else{
                    self.isActive = false
                    self.isActuallyActive = false
                }
                self.wasInitiallyActive = self.isActive
                self.Display_Changes(nil)
                
                let subquery:KCSQuery = KCSQuery()
                subquery.addQueryOnField("type", withExactMatchForValue: "like")
                subquery.addQueryOnField("event._id", withExactMatchForValue: self.event!.eventOriginal!.entityId)
                
                store.countWithQuery(subquery, completion: {
                    (number:UInt, error:NSError!) -> Void in
                    if (error == nil){
                        self.numberOfActivity = number
                        self.delegate.didGetNumberOfObjects(self, numberOfObjects: self.numberOfActivity, error: nil)
                    }else{
                        self.delegate.didGetNumberOfObjects(self, numberOfObjects: self.numberOfActivity, error: error)
                        print("Error:" + error.description)
                    }
                })
            }else{
                print("Error:" + error.description)
            }
            }, withProgressBlock: nil)
        
    }
    
    
    
    func Save_Like(buttonWasPressed wasPressed:Bool){
        isBusy = true

        let store = KCSLinkedAppdataStore.storeWithOptions([
            KCSStoreKeyCollectionName : "Activity",
            KCSStoreKeyCollectionTemplateClass : ActivityUnit.self
            ])
        
        let query:KCSQuery = KCSQuery()
        query.addQueryOnField("event._id", withExactMatchForValue: self.event!.eventOriginal!.entityId!)
        query.addQueryOnField("type", withExactMatchForValue: "like")
        query.addQueryOnField("toUser._id", withExactMatchForValue: self.event!.author!.userId)
        query.addQueryOnField("fromUser._id", withExactMatchForValue: KCSUser.activeUser().userId)
        
        //  in case if we need to store or remove
        let like:ActivityUnit = ActivityUnit()
        
        if (actualLikeObject != nil){
            like.entityId = actualLikeObject.entityId
        }
        like.event = self.event!.eventOriginal
        like.fromUser = KCSUser.activeUser()
        like.toUser = self.event!.author
        like.type = "like"
        like.content = self.content
        like.toUser = self.event!.author
        
        //  visual check
        if ((isActive) == false){  // visually you havent liked it yet
            self.wasPressedAtLeastOnce = true
            self.isActive = true
            
            if (wasPressed == true){
                self.Display_Changes(nil)
            }
            //update
            
            store.saveObject(like, withCompletionBlock: { //save 1
                (objects:[AnyObject]!, error:NSError!) -> Void in
                if (error == nil){
                    print("saved")
                    self.actualLikeObject = objects[0] as! ActivityUnit
                    
                    self.isActuallyActive = true
                    self.checkIfVisualValueMatchesActualValue()
                    
                }else{
                    print("Error: " + error.description)
                    self.checkIfVisualValueMatchesActualValue()
                    
                }
            }, withProgressBlock: nil)
  
            
        }else{ // to unlike
            
            // visual unlike
            self.wasPressedAtLeastOnce = true
            self.isActive = false
            if (wasPressed == true){
                self.Display_Changes(nil)
            }
            
            store.removeObject(like.entityId, withCompletionBlock: {
                (number:UInt, error:NSError!) -> Void in
                if (error == nil){
                    
                    print("deleted")
                    self.isActuallyActive = false
                    self.checkIfVisualValueMatchesActualValue()
                    
                }else{
                    
                    print("Error: " + error.description)
                    self.checkIfVisualValueMatchesActualValue()
                    
                }
            }, withProgressBlock: nil)
            
        }
    }
    
    
    
    func Display_Changes(error:NSError!){

            if (isActive == true){
                self.backgroundColor = UIColor.redColor()
                self.setTitle("Liked", forState: UIControlState.Normal)
                if (wasInitiallyActive == true){
                    delegate.didFinishSavingOrDeletingObject(self, visualnumberOfObjects: self.numberOfActivity, error: error)
                }else{
                    delegate.didFinishSavingOrDeletingObject(self, visualnumberOfObjects: self.numberOfActivity+1, error: error)
                }
            }else{
                self.backgroundColor = UIColor.grayColor()
                self.setTitle("Like", forState: UIControlState.Normal)
                if (wasPressedAtLeastOnce == true){
                    if (wasInitiallyActive == false){
                        delegate.didFinishSavingOrDeletingObject(self, visualnumberOfObjects: self.numberOfActivity, error: error)
                    }else{
                        delegate.didFinishSavingOrDeletingObject(self, visualnumberOfObjects: self.numberOfActivity-1, error: error)
                    }
                }
            }
  
    }

    

    func checkIfVisualValueMatchesActualValue(){
        if (isActuallyActive != isActive){
            isActive = isActuallyActive

            if (attempts>1){
                attempts = 0
                isBusy = false
                Display_Changes(nil)
            }else{
                attempts++
                Save_Like(buttonWasPressed: false)
            }
            

        }else{
            attempts = 0
            isBusy = false
        }
    }
    
}

