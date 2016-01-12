//
//  Event.swift
//  Eventer
//
//  Created by Grisha on 05/05/2015.
//  Copyright (c) 2015 Grisha. All rights reserved.
//

import UIKit

class Event: NSObject  {
    var entityId: NSString? //Kinvey entity _id
    
    var author: KCSUser?
    var authorId: NSString?
    var name: NSString?
    var details: NSString?
    var pictureId: NSString?
    var date: NSDate?
    var location: NSString?
    var access:NSString?
    var createdAt: NSDate?

    var hidden:NSString?
    var sharedID:NSString?
    
    var metadata: KCSMetadata? //Kinvey metadata, optional
    override init(){
        super.init()
        author = KCSUser.activeUser()

    }
    
    internal override func hostToKinveyPropertyMapping() -> [NSObject : AnyObject]! {
        return [
            "entityId" : KCSEntityKeyId, //the required _id field
            "author" : "author",
            "name" : "name",
            "details" : "details",
            "pictureId" : "pictureId",
            "authorId" : "authorId",
            "date" : "date",
            "location" : "location",
            "access" : "access",
            "hidden" : "hidden",
            "createdAt": "createdAt",
            "sharedID" : "sharedID",
            "metadata" : KCSEntityKeyMetadata //optional _metadata field
        ]
    }
    
    internal class override func kinveyPropertyToCollectionMapping() -> [NSObject : AnyObject]! {
        return [
            "author" : KCSUserCollectionName,
        ]
    }

}
