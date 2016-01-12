//
//  ActivityUnit.swift
//  Eventer
//
//  Created by Grisha on 07/05/2015.
//  Copyright (c) 2015 Grisha. All rights reserved.
//

import UIKit

class ActivityUnit: NSObject {
    var entityId: NSString? //Kinvey entity _id
    
    var fromUser: KCSUser?
    var toUser: KCSUser?
    var event: Event?
    //var eventAuthor: KCSUser?
    var createdAt: NSDate?

    var type:NSString?
    var content:NSString?
    var addit:NSString? // additional
    var metadata: KCSMetadata? //Kinvey metadata, optional
    override init(){
        super.init()
    }
    
    internal override func hostToKinveyPropertyMapping() -> [NSObject : AnyObject]! {
        return [
            "entityId" : KCSEntityKeyId, //the required _id field
            
            "fromUser" : "fromUser",
            "toUser" : "toUser",
            "event" : "event",
            "createdAt": "createdAt",
            "type" : "type",
            "content" : "content",
            "addit" : "addit",
            "metadata" : KCSEntityKeyMetadata //optional _metadata field
        ]
    }
    
    internal class override func kinveyPropertyToCollectionMapping() -> [NSObject : AnyObject]! {
        return [
            "fromUser" : KCSUserCollectionName,
            "toUser" : KCSUserCollectionName,
            //"eventAuthor" : KCSUserCollectionName,
            "event" : "Events"
            
        ]
    }
    

}
