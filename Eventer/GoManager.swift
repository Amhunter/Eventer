//
//  GoManager.swift
//  Eventer
//
//  Created by Grisha on 16/07/2015.
//  Copyright (c) 2015 Grisha. All rights reserved.
//

import UIKit

class GoManager {
    var row:Int!
    var button:UIButton!
    var event:FetchedEvent!
    var numberOfGoing:Int = 0
    var numberOfNo:UInt = 0
    var numberOfMaybe:UInt = 0
    var numberOfInvited:UInt = 0
    var isGoing:Bool = false //isGoing
    var isActuallyGoing:Bool = false
    var wasInitiallyGoing:Bool = false
    var actualResponseObject:ActivityUnit!
    var attempts:Int = 0 //attempts to save or delete
    
    var isBusy:Bool = false // if processing a query
    var tab:TargetView!
    func initialize(event:FetchedEvent,isGoing:Bool, row:Int,tab:TargetView){
        self.event = event
        self.wasInitiallyGoing = isGoing
        self.isGoing = isGoing
        self.row = row
        self.tab = tab
    }
    
    func Going(){
        //println(isBusy)
        if (Reachability.isConnectedToNetwork()){
            if (isBusy){ //just visual change
                if (isGoing == true){
                    isGoing = false
                }else{
                    isGoing = true
                }
                Display_Changes()
                
            }else{
                Save_Response(buttonWasPressed: true)
            }
            
        }else{
            //Unhighlight()
            print("no connection")
        }
    }
    
    func Save_Response(buttonWasPressed wasPressed:Bool){
        isBusy = true
        
        let store = KCSLinkedAppdataStore.storeWithOptions([
            KCSStoreKeyCollectionName : "Activity",
            KCSStoreKeyCollectionTemplateClass : ActivityUnit.self
            ])
        
        let query:KCSQuery = KCSQuery()
        query.addQueryOnField("type", withExactMatchForValue: "response")
        query.addQueryOnField("event._id", withExactMatchForValue: self.event!.eventOriginal!.entityId!)
        query.addQueryOnField("toUser._id", withExactMatchForValue: self.event!.authorId)
        query.addQueryOnField("fromUser._id", withExactMatchForValue: KCSUser.activeUser().userId)
        
        //  in case if we need to store or remove
        let Response:ActivityUnit = ActivityUnit()
        if (KCSUser.activeUser().userId == event.metadata!.creatorId()){
            Response.addit = "s"
        }
        let toUser = KCSUser()
        toUser.userId = self.event!.authorId as String

        Response.entityId = "r-\(KCSUser.activeUser().userId!)-\(event.eventOriginal!.entityId!)"
        Response.event = self.event!.eventOriginal
        Response.fromUser = KCSUser.activeUser()
        Response.type = "response"
        Response.content = "yes"
        Response.toUser = toUser
        //  visual check
        if ((isGoing) == false){  // visually you havent Responsed it yet
            //button.wasPressedAtLeastOnce = true
            self.isGoing = true

            if (wasPressed == true){
                self.Display_Changes()
            }
            //update
            
            store.saveObject(Response, withCompletionBlock: { //save 1
                (objects:[AnyObject]!, error:NSError!) -> Void in
                if (error == nil){
                    print("saved")
                    self.actualResponseObject = objects[0] as! ActivityUnit
                    
                    self.isActuallyGoing = true
                    self.checkIfVisualValueMatchesActualValue()
                    
                }else{
                    print("Error: " + error.description)
                    self.checkIfVisualValueMatchesActualValue()
                    
                }
                }, withProgressBlock: nil)
            
            
        }else{ // to unResponse
            
            // visual unResponse
            //button.wasPressedAtLeastOnce = true
            self.isGoing = false

            if (wasPressed == true){
                self.Display_Changes()
            }
            
            if (actualResponseObject != nil){
                store.removeObject(actualResponseObject.entityId, withCompletionBlock: {
                    (number:UInt, error:NSError!) -> Void in
                    if (error == nil){
                        
                        print("deleted")
                        self.isActuallyGoing = false
                        self.checkIfVisualValueMatchesActualValue()
                        
                    }else{
                        
                        print("Error: " + error.description)
                        self.checkIfVisualValueMatchesActualValue()
                        
                    }
                }, withProgressBlock: nil)
            }else{
                store.removeObject(Response.entityId, withCompletionBlock: {
                    (number:UInt, error:NSError!) -> Void in
                    if (error == nil){
                        
                        print("deleted")
                        self.isActuallyGoing = false
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
        isGoing ? (numberOfGoing += 1) : (numberOfGoing -= 1)
        
        switch self.tab! {
        case .Home:
            (self.button as! ETableViewCellButton).setState(isGoing)
            (self.button as! ETableViewCellButton).setLabelNumber(numberOfGoing)
        case .EventView:
            (self.button as! HomeResponseButton).initialize(isGoing)
        default:
            break
        }
    }
    
    
    
    func checkIfVisualValueMatchesActualValue(){
        if (isActuallyGoing != isGoing){
            isGoing = isActuallyGoing
            if (attempts>0){
                attempts = 0
                isBusy = false
                Display_Changes()
            }else{
                attempts += 1
                Save_Response(buttonWasPressed: false)
            }
            
            
        }else{
            var text:String
            if (self.isGoing){ text = "saved" }else{
                text = "deleted"
            }
            print("\(text) going for \(self.row)")
            attempts = 0
            isBusy = false
        }
    }
}
