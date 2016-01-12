//
//  FollowManager.swift
//  Eventer
//
//  Created by Grisha on 26/07/2015.
//  Copyright (c) 2015 Grisha. All rights reserved.
//

import UIKit



class FollowManager {
    var row:Int!
    var button:ExploreFollowButton!
    var user:KCSUser!
    var numberOfFollows:Int = 0
    
    var isFollowing:Bool = false //isFollowing
    var isActuallyFollowing:Bool = false
    var wasInitiallyFollowing:Bool = false
    var actualFollowObject:ActivityUnit!
    var attempts:Int = 0 //attempts to save or delete
    
    var isBusy:Bool = false // if processing a query
    var tab:forTab!
    
    func initialize(user:KCSUser,isFollowing:Bool, row:Int, tab:forTab){
        self.user = user
        self.wasInitiallyFollowing = isFollowing
        self.isFollowing = isFollowing
        self.row = row
        self.tab = tab
    }
    
    func Follow(){
        //println(isBusy)
        if (Reachability.isConnectedToNetwork()){
            if (isBusy){ //just visual change
                if (isFollowing == true){
                    isFollowing = false
                }else{
                    isFollowing = true
                }
                Display_Changes()
                
            }else{
                Save_Follow(buttonWasPressed: true)
            }
            
        }else{
            //Unhighlight()
            print("no connection")
        }
        
        
    }
    
    func Save_Follow(buttonWasPressed wasPressed:Bool){
        
        isBusy = true
        
        let store = KCSLinkedAppdataStore.storeWithOptions([
            KCSStoreKeyCollectionName : "Activity",
            KCSStoreKeyCollectionTemplateClass : ActivityUnit.self
            ])
        
        let query:KCSQuery = KCSQuery()
        query.addQueryOnField("type", withExactMatchForValue: "follow")
        query.addQueryOnField("toUser._id", withExactMatchForValue: self.user.userId!)
        query.addQueryOnField("fromUser._id", withExactMatchForValue: KCSUser.activeUser().userId)
        	
        //  in case if we need to store or remove
        let Follow:ActivityUnit = ActivityUnit()
        
        Follow.entityId = "f-\(KCSUser.activeUser().userId!)-\(user.userId!)"
        Follow.fromUser = KCSUser.activeUser()
        Follow.type = "follow"
        if (self.user.getValueForAttribute("access") == nil){
            Follow.content = "accepted"
        }else{
            if (self.user.getValueForAttribute("access") as! NSString == "private"){
                Follow.content = "request"
            }else{
                Follow.content = "accepted"
            }
        }

        Follow.toUser = self.user
        //  visual check
        if ((isFollowing) == false){  // visually you havent Followd it yet
            //button.wasPressedAtLeastOnce = true
            self.isFollowing = true
            if (wasPressed == true){
                self.Display_Changes()
            }
            //update
            
            store.saveObject(Follow, withCompletionBlock: { //save 1
                (objects:[AnyObject]!, error:NSError!) -> Void in
                if (error == nil){
                    print("saved")
                    self.actualFollowObject = objects[0] as! ActivityUnit
                    
                    self.isActuallyFollowing = true
                    self.checkIfVisualValueMatchesActualValue()
                    
                }else{
                    print("Error: " + error.description)
                    self.checkIfVisualValueMatchesActualValue()
                    
                }
                }, withProgressBlock: nil)
            
            
        }else{ // to unFollow
            
            // visual unFollow
            //button.wasPressedAtLeastOnce = true
            self.isFollowing = false
            if (wasPressed == true){
                self.Display_Changes()
            }
            
            if (actualFollowObject != nil){
                store.removeObject(actualFollowObject.entityId, withCompletionBlock: {
                    (number:UInt, error:NSError!) -> Void in
                    if (error == nil){
                        
                        print("deleted")
                        self.isActuallyFollowing = false
                        self.checkIfVisualValueMatchesActualValue()
                        
                    }else{
                        
                        print("Error: " + error.description)
                        self.checkIfVisualValueMatchesActualValue()
                        
                    }
                }, withProgressBlock: nil)
            }else{
                store.removeObject(Follow.entityId, withCompletionBlock: {
                    (number:UInt, error:NSError!) -> Void in
                    if (error == nil){
                        
                        print("deleted")
                        self.isActuallyFollowing = false
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
        if (isFollowing == true){
            
            button.setImage(UIImage(named: "following.png"), forState: UIControlState.Normal)
            button.setImage(UIImage(named: "follow.png"), forState: UIControlState.Highlighted)
            self.numberOfFollows++
        }else{
            button.setImage(UIImage(named: "follow.png"), forState: UIControlState.Normal)
            button.setImage(UIImage(named: "following.png"), forState: UIControlState.Highlighted)
            self.numberOfFollows--
        }
//        if (self.tab == forTab.Profile){
//            if (self.event.pictureID == ""){
//                (self.button.superview!.superview! as! HomeEventNoPictureCell).numberOfFollowsLabel.text = "\(self.numberOfFollows)"
//            }else{
//                (self.button.superview!.superview! as! HomeEventTableViewCell).numberOfFollowsLabel.text = "\(self.numberOfFollows)"
//                
//            }
//        }else{ // profile
//            if (self.event.pictureID == ""){
//                (self.button.superview!.superview! as! ProfileNoPictureTableViewCell).numberOfFollowsLabel.text = "\(self.numberOfFollows)"
//            }else{
//                (self.button.superview!.superview! as! ProfileEventTableViewCell).numberOfFollowsLabel.text = "\(self.numberOfFollows)"
//                
//            }
//        }
        
        
    }
    
    
    
    func checkIfVisualValueMatchesActualValue(){
        if (isActuallyFollowing != isFollowing){
            isFollowing = isActuallyFollowing
            if (attempts>0){
                attempts = 0
                isBusy = false
                Display_Changes()
            }else{
                attempts++
                Save_Follow(buttonWasPressed: false)
            }
            
            
        }else{
            var text:String
            if (self.isFollowing){ text = "saved" }else{
                text = "deleted"
            }
            print("\(text) Follow for \(self.row)")
            attempts = 0
            isBusy = false
        }
    }
}
