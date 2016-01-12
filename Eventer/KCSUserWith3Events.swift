//
//  KCSUserWith3Events.swift
//  Eventer
//
//  Created by Grisha on 23/06/2015.
//  Copyright (c) 2015 Grisha. All rights reserved.
//

import UIKit

class KCSUserWith3Events {
    var user:KCSUser?
    var userId:String = String()
    var username:String = String()
    var fullname:String = String()
    var eventsDownloaded:Int = -1 // -1 fail , 0 - still downloading , 1 - success
    
    var profilePictureID:String = String()
    var profilePicture:UIImage = UIImage()
    var profilePictureProgress:Double = -99
    var followManager:FollowManager = FollowManager()
    var events:[FetchedEvent] = []
    
    init(forUser:KCSUser){
        self.user = forUser
        
        self.userId = forUser.userId
        self.username = forUser.username
        
        
        if (forUser.getValueForAttribute("pictureId") as! NSString! != nil){
            self.profilePictureID = forUser.getValueForAttribute("pictureId") as! String
        }else{
            self.profilePictureID = ""
        }
        
        
    }
   
}
