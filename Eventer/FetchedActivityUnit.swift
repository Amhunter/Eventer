//
//  FetchedActivityUnit.swift
//  Eventer
//
//  Created by Grisha on 27/05/2015.
//  Copyright (c) 2015 Grisha. All rights reserved.
//

import UIKit

class FetchedActivityUnit{
    var entityId:NSString = NSString()
    var event:FetchedEvent!
    var fromUser: KCSUser?
    var fromUserFullname:NSString = NSString()
    var fromUserProfilePictureID:NSString = NSString()
    var fromUserProfilePicture:UIImage = UIImage()
    var fromUserPictureProgress:Double = -99
    
    var toUser: KCSUser?
    var toUserFullname:NSString = NSString()
    var toUserProfilePictureID:NSString = NSString()
    var toUserProfilePicture:UIImage = UIImage()
    var toUserPictureProgress:Double = -99
    var followManager:ActivityFollowManager = ActivityFollowManager()
//    var eventAuthor:KCSUser?
//    var authorProfilePictureID:NSString = NSString()
//    var authorProfilePicture:UIImage = UIImage()
//    var authorPictureProgress:Double = -99
    var e:Event!
    var unit:ActivityUnit!
    var type:NSString = NSString()
    var content:NSString = NSString()
    var addit:NSString = NSString()
    var createdAtText:String = String()
    var createdAt:NSDate = NSDate()
    var metadata: KCSMetadata? //Kinvey metadata, optional

    
    init(fromUnit unit:ActivityUnit){
        self.unit = unit
        if (unit.event != nil){
            self.event = FetchedEvent(forActivity: unit.event!)
        }

        self.fromUser = unit.fromUser
        if fromUser!.givenName != nil {
            self.fromUserFullname = fromUser!.givenName
            
        }
        if (self.fromUser?.getValueForAttribute("pictureId") as! NSString! != nil){
            self.fromUserProfilePictureID = unit.fromUser!.getValueForAttribute("pictureId") as! NSString!
        }else{
            self.fromUserProfilePictureID = ""
        }

        if unit.toUser != nil {
            self.toUser = unit.toUser
            if toUser!.givenName != nil {
                self.toUserFullname  = toUser!.givenName
                
            }
        }

        if (unit.toUser?.getValueForAttribute("pictureId") as! NSString! != nil){
            self.toUserProfilePictureID = unit.toUser!.getValueForAttribute("pictureId") as! NSString!
        }else{
            self.toUserProfilePictureID = ""
        }



        self.entityId = unit.entityId!
        if (unit.type != nil){
            self.type = unit.type!
        }
        if (unit.content != nil){
            self.content = unit.content!
        }
        if (unit.addit != nil){
            self.addit = unit.addit!
        }
        if (unit.createdAt != nil){
            self.createdAt = unit.createdAt!
            
        }

        if (unit.metadata != nil){
            self.metadata = unit.metadata!
            createdAtText = DateToStringConverter.getCreatedAtString(unit.metadata!.creationTime(), tab: forTab.Explore)

        }
        
    }
    

}
