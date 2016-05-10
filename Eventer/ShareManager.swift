//
//  ShareManager.swift
//  Eventer
//
//  Created by Grisha on 16/07/2015.
//  Copyright (c) 2015 Grisha. All rights reserved.
//

import UIKit

class ShareManager:NSObject,UIActionSheetDelegate{
    var row:Int!
    var button:UIButton!
    var event:FetchedEvent!
    
    var numberOfShares:Int = 0
    var isShared:Bool = false //isShared
    var isActuallyShared:Bool = false
    var wasInitiallyShared:Bool = false
    var actualShareObject:ActivityUnit!
    var attempts:Int = 0 //attempts to save or delete
    
    var isBusy:Bool = false // if processing a query
    var tab:TargetView!

    func initialize(event:FetchedEvent,isShared:Bool, row:Int, tab:TargetView){
        self.event = event
        self.wasInitiallyShared = isShared
        self.isShared = isShared
        self.row = row
        self.tab = tab
    }
    
    func Share(){
        if (Reachability.isConnectedToNetwork()){
            if (isBusy){ //just visual change
                if (isShared == true){
                    isShared = false
                }else{
                    isShared = true
                }
                Display_Changes()
                
            }else{
                // manage action sheet
//                button.highlighted = true

                var actionSheet:UIActionSheet
                if (isShared == true){
                    actionSheet = UIActionSheet(title: "You want to stop sharing this event: " + (self.event.name as String), delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: "Unshare")
                    actionSheet.tag = 0
                    
                }else{
                    actionSheet = UIActionSheet(title: "You want to share event: " + (self.event.name as String), delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil)
                    actionSheet.tag = 1
                    actionSheet.addButtonWithTitle("Share")
                    
                }
                actionSheet.showInView(button.superview!.superview!.superview!.superview!) // button-content-cell-table-view
            }
            
        }else{
            //Unhighlight()
            print("no connection")
        }
    }
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
//        button.highlighted = false
        if (actionSheet.tag == 0){ // unshare confirmation
            if (buttonIndex == 0){
                Save_Share(buttonWasPressed: true)
            }else{
                switch self.tab! {
                case .Home:
                    (self.button as! ETableViewCellButton).setState(isShared)
                case .EventView:
                    (self.button as! HomeShareButton).highlighted = false
                default:
                    break
                }
                //Unhighlight()
            }
        }else if (actionSheet.tag == 1){ // share confirmation
            if (buttonIndex == 1){
                Save_Share(buttonWasPressed: true)
            }else{
                switch self.tab! {
                case .Home:
                    (self.button as! ETableViewCellButton).setState(isShared)
                case .EventView:
                    (self.button as! HomeShareButton).highlighted = false
                default:
                    break
                }
                //Unhighlight()
            }
        }
        print(buttonIndex)
        
    }
    
    func Save_Share(buttonWasPressed wasPressed:Bool){
        isBusy = true
        
        let store = KCSLinkedAppdataStore.storeWithOptions([
            KCSStoreKeyCollectionName : "Activity",
            KCSStoreKeyCollectionTemplateClass : ActivityUnit.self
            ])
        
        let query:KCSQuery = KCSQuery()
        query.addQueryOnField("type", withExactMatchForValue: "share")
        query.addQueryOnField("event._id", withExactMatchForValue: self.event!.eventOriginal!.entityId!)
        query.addQueryOnField("toUser._id", withExactMatchForValue: self.event!.authorId)
        query.addQueryOnField("fromUser._id", withExactMatchForValue: KCSUser.activeUser().userId)
        
        //  in case if we need to store or remove
        let Share:ActivityUnit = ActivityUnit()
        if (KCSUser.activeUser().userId == event.metadata!.creatorId()){
            Share.addit = "s"
        }
        
        Share.entityId = "s-\(KCSUser.activeUser().userId!)-\(event.eventOriginal!.entityId!)"
        Share.event = self.event!.eventOriginal
        Share.fromUser = KCSUser.activeUser()
        Share.type = "share"
        Share.content = "s"
        let toUser = KCSUser()
        toUser.userId = self.event!.authorId as String
        Share.toUser = toUser
        //  visual check
        if ((isShared) == false){  // visually you havent Shared it yet
            self.isShared = true

            if (wasPressed == true){
                self.Display_Changes()
            }
            //update
            
            store.saveObject(Share, withCompletionBlock: { //save 1
                (objects:[AnyObject]!, error:NSError!) -> Void in
                if (error == nil){
                    print("saved")
                    self.actualShareObject = objects[0] as! ActivityUnit
                    
                    self.isActuallyShared = true
                    self.checkIfVisualValueMatchesActualValue()
                    
                }else{
                    print("Error: " + error.description)
                    self.checkIfVisualValueMatchesActualValue()
                    
                }
                }, withProgressBlock: nil)
            
            
        }else{ // to unShare
            
            // visual unShare
            self.isShared = false
            
            if (wasPressed == true){
                self.Display_Changes()
            }
            
            if (actualShareObject != nil){
                store.removeObject(actualShareObject.entityId, withCompletionBlock: {
                    (number:UInt, error:NSError!) -> Void in
                    if (error == nil){
                        
                        print("deleted")
                        self.isActuallyShared = false
                        self.checkIfVisualValueMatchesActualValue()
                        
                    }else{
                        
                        print("Error: " + error.description)
                        self.checkIfVisualValueMatchesActualValue()
                        
                    }
                }, withProgressBlock: nil)
            }else{
                store.removeObject(Share.entityId, withCompletionBlock: {
                    (number:UInt, error:NSError!) -> Void in
                    if (error == nil){
                        
                        print("deleted")
                        self.isActuallyShared = false
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
        isShared ? (numberOfShares += 1) : (numberOfShares -= 1)
        
        switch self.tab! {
        case .Home:
            (self.button as! ETableViewCellButton).setState(isShared)
            (self.button as! ETableViewCellButton).setLabelNumber(numberOfShares)
        case .EventView:
            (self.button as! HomeShareButton).initialize(isShared)
        default:
            break
        }
    }
    
    
    
    func checkIfVisualValueMatchesActualValue(){
        if (isActuallyShared != isShared){
            isShared = isActuallyShared
            if (attempts>0){
                attempts = 0
                isBusy = false
                Display_Changes()
            }else{
                attempts += 1
                Save_Share(buttonWasPressed: false)
            }
            
            
        }else{
            var text:String
            if (self.isShared){ text = "saved" }else{
                text = "deleted"
            }
            print("\(text) share for \(self.row)")
            attempts = 0
            isBusy = false
        }
    }
}
