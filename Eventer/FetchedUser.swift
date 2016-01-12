//
//  FetchedUser.swift
//  Eventer
//
//  Created by Grisha on 29/06/2015.
//  Copyright (c) 2015 Grisha. All rights reserved.
//

import UIKit

class FetchedUser {
    var user:KCSUser!
    var userId:String!
    var username:String = String()
    var fullname:String = String()
    var website:String = String()
    var bio:String = String()
    var access:String = String()
    var pictureId:String = String()
    var pictureProgress:Double = -99
    var picture:UIImage!
    var followManager:ActivityFollowManager = ActivityFollowManager()
    var byUsername:Bool = false
    init(forUser:KCSUser!, username:String!){
        if (username == nil){
            byUsername = false
            self.user = forUser
            self.userId = forUser.userId
            self.username = forUser.username
            
            if (forUser.givenName != nil){
                self.fullname = forUser.givenName
                
            }
            
            if (forUser.getValueForAttribute("pictureId") as! String! != nil){
                self.pictureId = forUser!.getValueForAttribute("pictureId") as! String!
            }else{
                self.pictureId = ""
            }
            
            if (forUser.getValueForAttribute("bio") as! String! != nil){
                self.bio = forUser.getValueForAttribute("bio") as! String!
            }else{
                self.bio = ""
            }
            if (forUser.getValueForAttribute("website") as! String! != nil){
                self.website = forUser.getValueForAttribute("website") as! String!
            }else{
                self.website = ""
            }
            if (forUser.getValueForAttribute("access") as! String! != nil){
                self.access = forUser.getValueForAttribute("access") as! String!
            }else{
                self.access = "public"
            }
        }else{
            self.username = username
            byUsername = true
        }
        
    }
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
    // Drawing code
    }
    */
    
}
