//
//  InviteUserUnit.swift
//  Eventer
//
//  Created by Grisha on 01/10/2015.
//  Copyright © 2015 Grisha. All rights reserved.
//

import UIKit

class InviteUserUnit:NSObject {
    var user:KCSUser!
    
    var username:String = String()
    var fullname:String = String()
    var website:String = String()
    var bio:String = String()
    var access:String = String()
    var pictureId:String!
    var pictureProgress:Double = -99
    var picture:UIImage!
    var isSelected = false
    init(forUser:KCSUser!){
        self.user = forUser
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
    }
}
