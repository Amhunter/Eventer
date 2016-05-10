//
//  ActivityFollowManager.swift
//  Eventer
//
//  Created by Grisha on 04/08/2015.
//  Copyright (c) 2015 Grisha. All rights reserved.
//

import UIKit

class ActivityFollowManager {
    var row:Int!
    var button:ActivityFollowButton!
    var user:KCSUser!
    var numberOfFollows:Int = 0
    var loaded:Bool = false
    var isFollowing:Bool = false //isFollowing
    var isActuallyFollowing:Bool = false
    var actualFollowObject:ActivityUnit!
    var attempts:Int = 0 //attempts to save or delete
    
    var isBusy:Bool = false // if processing a query
    var tab:TargetView!
    
    func initialize(user:KCSUser,isFollowing:Bool,row:Int, tab:TargetView){
        self.user = user
        self.isFollowing = isFollowing
        self.row = row
        self.tab = tab
        self.loaded = true
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
        if (self.user.userId! == KCSUser.activeUser().userId){
            return
        }
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
        
        Follow.entityId = "f-\(KCSUser.activeUser().userId!)-\(self.user.userId!)"
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
        button.setActive(isFollowing)
    }

    func checkIfVisualValueMatchesActualValue(){
        if (isActuallyFollowing != isFollowing){
            isFollowing = isActuallyFollowing
            if (attempts>0){
                attempts = 0
                isBusy = false
                Display_Changes()
            }else{
                attempts += 1
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
    
    func checkFollow(userId:String, row:Int, completionBlock: (isFollowing:Bool,error:NSError!) -> Void){
        if (userId == KCSUser.activeUser().userId){
            return 
        }
        let string = "f-\(KCSUser.activeUser().userId!)-\(userId)"
        GeneralDownloadManager.loadObjectWithId(string, tableName: "Activity", completionBlock: {
            (objects:[AnyObject]!, error:NSError!) -> Void in
            if (error == nil){
                if (objects.count > 0){
                    if (objects.count > 1){
                        print("detected more than one")
                        let cut = Array(objects[1...(objects.count-1)])
                        GeneralDownloadManager.deleteObjectWithId(cut, tableName: "Activity", completionBlock: {
                            (number:UInt, error:NSError!) -> Void in
                            if (error == nil){
                                print("couldn't delete extra")
                            }else{
                                print("deleted extra")
                            }
                            self.loaded = true
                            completionBlock(isFollowing: true, error: nil)
                            
                        }, progressBlock: nil)
                    }else{
                        self.loaded = true
                        completionBlock(isFollowing: true, error: nil)
                    }
                }else{
                    self.loaded = true
                    completionBlock(isFollowing: false, error: nil)
                }
            }else{
                if error.code == 404 {
                    //not found , no error
                    self.loaded = true
                    completionBlock(isFollowing: false, error: nil)
                }else{
                    self.loaded = false
                    completionBlock(isFollowing: false, error: error)
                }
            }
        }, progressBlock: nil)

    }
    
}

class ActivityFollowButton: UIButton {
    var activeColor = ColorFromCode.redFollowColor()
    
    init(){
        super.init(frame: CGRectZero)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func initialize(isLoaded:Bool,isFollowing:Bool){
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 3
        self.layer.borderColor = UIColor.groupTableViewBackgroundColor().CGColor
        if isLoaded {
            setActive(isFollowing)
        }else{
            print("disable")
            self.enabled = false
            self.backgroundColor = UIColor.groupTableViewBackgroundColor()
            self.setTitle("Loading", forState: UIControlState.Normal)
            self.setTitleColor(UIColor.lightGrayColor(), forState: UIControlState.Normal)
            self.setImage(nil, forState: UIControlState.Normal)
            self.titleLabel!.font = UIFont(name: "Lato-Regular", size: 13)
        }
    }
    
    func setActive(active:Bool){
        self.enabled = true
        self.setTitle(nil, forState: UIControlState.Normal)
        if (active){
            self.setImage(UIImage(named: "following-button.png"), forState: UIControlState.Normal)
            self.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            self.backgroundColor = activeColor
            self.layer.borderColor = activeColor.CGColor
        }else{
            self.setImage(UIImage(named: "follow.png"), forState: UIControlState.Normal)
            self.setTitleColor(ColorFromCode.colorWithHexString("#00AAFC"), forState: UIControlState.Normal)
            self.backgroundColor = UIColor.whiteColor()
            self.layer.borderColor = ColorFromCode.colorWithHexString("#00AAFC").CGColor
        }
    }
    func setOrangeActiveColor(orange:Bool){
        if orange {
            activeColor = ColorFromCode.orangeFollowColor()
        }else{
            activeColor = ColorFromCode.redFollowColor()
        }
        
    }
    
}
