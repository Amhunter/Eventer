//
//  LikeManager.swift
//  Eventer
//
//  Created by Grisha on 16/07/2015.
//  Copyright (c) 2015 Grisha. All rights reserved.
//

import UIKit
enum TargetView: Int {
    case Home = 0
    case Explore
    case Activity
    case Profile
    case EventView
}

class LikeManager {
    var row:Int!
    var button:UIButton!
    var event:FetchedEvent!
    var numberOfLikes:Int = 0

    var isLiked:Bool = false //isLiked
    var isActuallyLiked:Bool = false
    var wasInitiallyLiked:Bool = false
    var actualLikeObject:ActivityUnit!
    var attempts:Int = 0 //attempts to save or delete
    
    var isBusy:Bool = false // if processing a query
    var tab:TargetView!
    
    func initialize(event:FetchedEvent,isLiked:Bool, row:Int, tab:TargetView){
        self.event = event
        self.wasInitiallyLiked = isLiked
        self.isLiked = isLiked
        self.row = row
        self.tab = tab
    }

    func Like(){
        //println(isBusy)
        if (Reachability.isConnectedToNetwork()){
            if (isBusy){ //just visual change
                if (isLiked == true){
                    isLiked = false
                }else{
                    isLiked = true
                }
                Display_Changes()
                
            }else{
                Save_Like(buttonWasPressed: true)
            }
            
        }else{
            //Unhighlight()
            print("no connection")
        }
        
        
    }
    
    func Save_Like(buttonWasPressed wasPressed:Bool){
        
        isBusy = true
        
        let store = KCSLinkedAppdataStore.storeWithOptions([
            KCSStoreKeyCollectionName : "Activity",
            KCSStoreKeyCollectionTemplateClass : ActivityUnit.self
            ])
        
        let query:KCSQuery = KCSQuery()
        query.addQueryOnField("type", withExactMatchForValue: "like")
        query.addQueryOnField("event._id", withExactMatchForValue: self.event!.eventOriginal!.entityId!)
        query.addQueryOnField("toUser._id", withExactMatchForValue: self.event!.metadata?.creatorId())
        query.addQueryOnField("fromUser._id", withExactMatchForValue: KCSUser.activeUser().userId)
        
        //  in case if we need to store or remove
        let like:ActivityUnit = ActivityUnit()
        
        like.entityId = "l-\(KCSUser.activeUser().userId!)-\(event.eventOriginal!.entityId!)"
        if (KCSUser.activeUser().userId == event.metadata!.creatorId()){
            like.addit = "s"
        }
        like.event = self.event!.eventOriginal
        like.fromUser = KCSUser.activeUser()
        like.type = "like"
        like.content = "l"
        let toUser = KCSUser()
        toUser.userId = self.event!.metadata?.creatorId()
        like.toUser = self.event!.author
        //  visual check
        if ((isLiked) == false){  // visually you havent liked it yet
            //button.wasPressedAtLeastOnce = true
            self.isLiked = true
            if (wasPressed == true){
                self.Display_Changes()
            }
            //update
            
            store.saveObject(like, withCompletionBlock: { //save 1
                (objects:[AnyObject]!, error:NSError!) -> Void in
                if (error == nil){
                    print("saved")
                    self.actualLikeObject = objects[0] as! ActivityUnit
                    
                    self.isActuallyLiked = true
                    self.checkIfVisualValueMatchesActualValue()
                    
                }else{
                    print("Error: " + error.description)
                    self.checkIfVisualValueMatchesActualValue()
                    
                }
            }, withProgressBlock: nil)
            
            
        }else{ // to unlike
            
            // visual unlike
            //button.wasPressedAtLeastOnce = true
            self.isLiked = false
            if (wasPressed == true){
                self.Display_Changes()
            }
            
            if (actualLikeObject != nil){
                store.removeObject(actualLikeObject.entityId, withCompletionBlock: {
                    (number:UInt, error:NSError!) -> Void in
                    if (error == nil){
                        
                        print("deleted")
                        self.isActuallyLiked = false
                        self.checkIfVisualValueMatchesActualValue()
                        
                    }else{
                        
                        print("Error: " + error.description)
                        self.checkIfVisualValueMatchesActualValue()
                        
                    }
                }, withProgressBlock: nil)
            }else{
                store.removeObject(like.entityId, withCompletionBlock: {
                    (number:UInt, error:NSError!) -> Void in
                    if (error == nil){
                        
                        print("deleted")
                        self.isActuallyLiked = false
                        self.checkIfVisualValueMatchesActualValue()
                        
                    }else{
                        
                        print("Error: " + error.description)
                        self.checkIfVisualValueMatchesActualValue()
                        
                    }
                }, withProgressBlock: nil)
            }
        }
    }
    
    
    
    func Display_Changes(){
        
        isLiked ? (numberOfLikes += 1) : (numberOfLikes -= 1)
        
        switch self.tab! {
        case .Home:
            (self.button as! ETableViewCellButton).setState(isLiked)
            (self.button as! ETableViewCellButton).setLabelNumber(numberOfLikes)
        case .EventView:
            (self.button as! HomeLikeButton).initialize(isLiked)
        default:
            break
        }
        
    }
    
    
    
    func checkIfVisualValueMatchesActualValue(){
        if (isActuallyLiked != isLiked){
            isLiked = isActuallyLiked
            if (attempts>0){
                attempts = 0
                isBusy = false
                Display_Changes()
            }else{
                attempts += 1
                Save_Like(buttonWasPressed: false)
            }
            
            
        }else{
            var text:String
            if (self.isLiked){ text = "saved" }else{
                text = "deleted"
            }
            print("\(text) like for \(self.row)")
            attempts = 0
            isBusy = false
        }
    }
}
