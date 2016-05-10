//
//  ActivityManager.swift
//  Eventer
//
//  Created by Grisha on 04/08/2015.
//  Copyright (c) 2015 Grisha. All rights reserved.
//

import UIKit

class ActivityManager {
    class func loadPictureForActivity(inout unit:FetchedActivityUnit,row: Int,option: FileDownloadOption, completionHandler: ((row:Int, error:NSError!) -> Void)){
        
        switch option{
        case FileDownloadOption.fromUserPicture:
            if (unit.fromUserProfilePictureID != ""){
                if (unit.fromUserPictureProgress < 0){
                    unit.fromUserPictureProgress = 0
                    FileDownloadManager.downloadImage(unit.fromUserProfilePictureID, completionBlock: {
                        (objects:[UIImage]!, error:NSError!) -> Void in
                        if (error == nil){
                            if (objects.count > 0){
                                unit.fromUserProfilePicture = objects[0]
                                unit.fromUserPictureProgress = 1
                                completionHandler(row: row,error: nil)
                            }else{
                                unit.fromUserPictureProgress = -1
                                print("Error: object not found")
                                completionHandler(row: row,error: error)
                                
                            }
                        }else{
                            completionHandler(row: row,error: error)
                            print("Error: " + error.description)
                        }
                        // Reload Picture
                        
                        }, progressBlock: { (objects:[AnyObject]!, percentComplete:Double) -> Void in
                            unit.fromUserPictureProgress = percentComplete
                            completionHandler(row: row,error: nil)
                    })
                }
            }else{
                completionHandler(row: row,error: nil)
            }
        case FileDownloadOption.toUserPicture:
            if (unit.toUserProfilePictureID != ""){
                if (unit.toUserPictureProgress < 0){
                    unit.toUserPictureProgress = 0
                    FileDownloadManager.downloadImage(unit.toUserProfilePictureID, completionBlock: {
                        (objects:[UIImage]!, error:NSError!) -> Void in
                        if (error == nil){
                            if (objects.count > 0){
                                unit.toUserProfilePicture = objects[0]
                                unit.toUserPictureProgress = 1
                                completionHandler(row: row,error: nil)
                            }else{
                                unit.toUserPictureProgress = -1
                                print("Error: object not found")
                                completionHandler(row: row,error: error)
                                
                            }
                        }else{
                            completionHandler(row: row,error: error)
                            print("Error: " + error.description)
                        }
                        // Reload Picture
                        
                        }, progressBlock: { (objects:[AnyObject]!, percentComplete:Double) -> Void in
                            unit.toUserPictureProgress = percentComplete
                            completionHandler(row: row,error: nil)
                    })
                }
            }else{
                completionHandler(row: row,error: nil)
            }
        case FileDownloadOption.eventPicture:
            if (unit.event.pictureId != ""){
                if (unit.event.pictureProgress < 0){
                    unit.event.pictureProgress = 0
                    FileDownloadManager.downloadImage(unit.event.pictureId, completionBlock: {
                        (objects:[UIImage]!, error:NSError!) -> Void in
                        if (error == nil){
                            if (objects.count > 0){
                                unit.event.picture = objects[0]
                                unit.event.pictureProgress = 1
                                completionHandler(row: row,error: nil)
                            }else{
                                unit.event.pictureProgress = -1
                                print("Error: object not found")
                                completionHandler(row: row,error: error)
                                
                            }
                        }else{
                            completionHandler(row: row,error: error)
                            print("Error: " + error.description)
                        }
                        // Reload Picture
                        
                        }, progressBlock: { (objects:[AnyObject]!, percentComplete:Double) -> Void in
                            unit.event.pictureProgress = percentComplete
                            completionHandler(row: row,error: nil)
                    })
                }
            }else{
                completionHandler(row: row,error: nil)
            }
        }
    }
    class func loadPictureForInvitedUser(inout unit:InviteUserUnit,row: Int, completionHandler: ((row:Int, error:NSError!) -> Void)){
        if (unit.pictureId != ""){
            if (unit.pictureProgress < 0){
                unit.pictureProgress = 0
                FileDownloadManager.downloadImage(unit.pictureId, completionBlock: {
                    (objects:[UIImage]!, error:NSError!) -> Void in
                    if (error == nil){
                        if (objects.count > 0){
                            unit.picture = objects[0]
                            unit.pictureProgress = 1
                            completionHandler(row: row,error: nil)
                        }else{
                            unit.pictureProgress = -1
                            print("Error: object not found")
                            completionHandler(row: row,error: error)
                            
                        }
                    }else{
                        completionHandler(row: row,error: error)
                        print("Error: " + error.description)
                    }
                    // Reload Picture
                    
                    }, progressBlock: { (objects:[AnyObject]!, percentComplete:Double) -> Void in
                        unit.pictureProgress = percentComplete
                        completionHandler(row: row,error: nil)
                })
            }
        }else{
            completionHandler(row: row,error: nil)
        }        
    }
    class func GetYouData(completionHandler: (downloadedData: [FetchedActivityUnit], error: NSError!) -> Void){
        var temp:[FetchedActivityUnit] = []
        
        let store = KCSLinkedAppdataStore.storeWithOptions([
            KCSStoreKeyCollectionName : "Activity",
            KCSStoreKeyCollectionTemplateClass : ActivityUnit.self
            ])
        let query:KCSQuery = KCSQuery()
        query.addQueryOnField("toUser._id", withExactMatchForValue: KCSUser.activeUser().userId)
        let query1 = KCSQuery(onField: "fromUser._id", usingConditional: KCSQueryConditional.KCSNotEqual, forValue: KCSUser.activeUser().userId)
        query.addQuery(query1)
        let query2 = KCSQuery(onField: "content", usingConditional: KCSQueryConditional.KCSNotEqual, forValue: "no")
        query.addQuery(query2)
        query.limitModifer = KCSQueryLimitModifier(limit: 30)
        
        // ev | toUs & fromUs
        
        //query.limitModifer = KCSQueryLimitModifier(limit: 11)
        query.addSortModifier(KCSQuerySortModifier(field: KCSMetadataFieldCreationTime, inDirection: KCSSortDirection.Descending))
        
        
        store.queryWithQuery(query, withCompletionBlock: {
            (objects:[AnyObject]!, error:NSError!) -> Void in
            if (error == nil){
                //println(objects.count)
                
                for (index,object) in objects.enumerate(){
                    let entity:FetchedActivityUnit = FetchedActivityUnit(fromUnit: object as! ActivityUnit)
                    temp.insert(entity, atIndex: index)
                    //idArray.insert(entity.pictureID, atIndex: index) // store picture id to load it after
                    
                }
                completionHandler(downloadedData: temp, error: nil)
                
                
            }else{
                print("Error:" + error.description)
                completionHandler(downloadedData: temp, error: error)
            }
        }, withProgressBlock: nil)
    }
    
    class func GetMeData(completionHandler: (downloadedData: [FetchedActivityUnit], error: NSError!) -> Void){
        var temp:[FetchedActivityUnit] = []
        let store = KCSLinkedAppdataStore.storeWithOptions([
            KCSStoreKeyCollectionName : "Activity",
            KCSStoreKeyCollectionTemplateClass : ActivityUnit.self
            ])
        
        let query1:KCSQuery = KCSQuery(onField: "fromUser._id", withExactMatchForValue: KCSUser.activeUser().userId)
        let query2 = KCSQuery(onField: "toUser._id", usingConditional: KCSQueryConditional.KCSNotEqual, forValue: KCSUser.activeUser().userId)
        let query3:KCSQuery = KCSQuery(onField: "type", withExactMatchForValue: "response")
        let query4:KCSQuery = KCSQuery(onField: "content", withExactMatchForValue: "yes")
        
        let query:KCSQuery = KCSQuery()
        query.addQuery(query1)
        query.addQuery(query2)
        query.addQuery(query3)
        query.addQuery(query4)
        
        store.queryWithQuery(query, withCompletionBlock: {
            (objects:[AnyObject]!, error:NSError!) -> Void in
            if (error == nil){
                print(objects.count)
                
                for (index,object) in objects.enumerate(){
                    let entity:FetchedActivityUnit = FetchedActivityUnit(fromUnit: object as! ActivityUnit)
                    temp.insert(entity, atIndex: index)
                    //idArray.insert(entity.pictureID, atIndex: index) // store picture id to load it after
                    
                }
                completionHandler(downloadedData: temp, error: nil)
                
            }else{
                completionHandler(downloadedData: temp, error: error)
            }
        }, withProgressBlock: nil)
    }
    
    
    class func getLikesAndSharesForEvent(inout event:FetchedEvent, handler: (error:NSError!) -> Void){

        var isLikedByYou = false
        var isSharedByYou = false
        
        let yourLikeAndShareIds = [
            "l-\(KCSUser.activeUser().userId!)-\(event.eventOriginal!.entityId!)",
            "s-\(KCSUser.activeUser().userId!)-\(event.eventOriginal!.entityId!)"
        ]
        var yourLikeAndShareLoaded = false
        var numbersOfLikesAndSharesLoaded = false
        var Done = false

        
        // Query 1 -- get your data if you liked or shared this event
        GeneralDownloadManager.loadObjectWithId(yourLikeAndShareIds, tableName: "Activity", completionBlock: {
            (objects:[AnyObject]!, error:NSError!) -> Void in
            if error == nil {
                for object in objects {
                    if (object as! ActivityUnit).type == "like" {
                        isLikedByYou = true
                    }
                    if (object as! ActivityUnit).type == "share" {
                        isSharedByYou = true
                    }
                    event.likeManager.initialize(event, isLiked: isLikedByYou, row: 0, tab: TargetView.EventView)
                    event.shareManager.initialize(event, isShared: isSharedByYou, row: 0, tab: TargetView.EventView)

                    if (numbersOfLikesAndSharesLoaded && !Done){
                        Done = true
                        handler(error: nil)
                    }
                    yourLikeAndShareLoaded = true
                }
            } else {
                if error.code == 404 { // not found ,no error
                    event.likeManager.initialize(event, isLiked: isLikedByYou, row: 0, tab: TargetView.EventView)
                    event.shareManager.initialize(event, isShared: isSharedByYou, row: 0, tab: TargetView.EventView)
                    
                    if (numbersOfLikesAndSharesLoaded && !Done){
                        Done = true
                        handler(error: nil)
                    }
                    yourLikeAndShareLoaded = true
                } else { // actual error
                    handler(error: error)
                }
            }
        }, progressBlock: nil)
        
        // Query 2 -- get numbers of likes and shares for this event
        let store = KCSLinkedAppdataStore.storeWithOptions([
            KCSStoreKeyCollectionName : "Activity",
            KCSStoreKeyCollectionTemplateClass : ActivityUnit.self
            ])
        
        let query:KCSQuery = KCSQuery(onField: "type", withRegex: "^(like|share)")
        query.addQueryOnField("event._id", withExactMatchForValue: event.entityID)
        store.group(["type"], reduce: KCSReduceFunction.COUNT(), condition: query, completionBlock: {
            (group:KCSGroup!, error:NSError!) -> Void in
            if (error == nil){
                event.likeManager.numberOfLikes = (group.reducedValueForFields(["type" : "like"]).integerValue)
                if (event.likeManager.numberOfLikes == NSNotFound) { event.likeManager.numberOfLikes = 0 }
                
                
                event.shareManager.numberOfShares = group.reducedValueForFields(["type" : "share"]).integerValue
                if (event.shareManager.numberOfShares  == NSNotFound) { event.shareManager.numberOfShares  = 0 }
                
//                event.additionalDataDownloaded = true

                
                if (yourLikeAndShareLoaded && !Done){
                    Done = true
                    handler(error: nil)
                }
                numbersOfLikesAndSharesLoaded = true
            }else{
                handler(error: error)
            }
        }, progressBlock: nil)

    }
    
    class func GetFollowingData(completionHandler: (downloadedData: [FetchedActivityUnit]!, error: NSError!) -> Void){
        

        let store = KCSLinkedAppdataStore.storeWithOptions([
            KCSStoreKeyCollectionName : "Activity",
            KCSStoreKeyCollectionTemplateClass : ActivityUnit.self
            ])
        
        var temp:[FetchedActivityUnit] = []
//        var userIdsToLoad:[String] = []
        
        // find following ids
        let query:KCSQuery = KCSQuery()
        let query1:KCSQuery = KCSQuery(onField: "fromUser._id", withExactMatchForValue: KCSUser.activeUser().userId)
        let query2:KCSQuery = KCSQuery(onField: "type", withExactMatchForValue: "follow")
        let query3:KCSQuery = KCSQuery(onField: "content", withExactMatchForValue: "accepted")

        query.addQuery(query1)
        query.addQuery(query2)
        query.addQuery(query3)
        
        store.queryWithQuery(query, withCompletionBlock: {
            (objects:[AnyObject]!, error:NSError!) -> Void in
            if (error == nil){
                // build regex
                var userIdRegex:NSString = "^("
                for followee in objects{
                    userIdRegex = userIdRegex.stringByAppendingString((followee as! ActivityUnit).toUser!.userId!)
                    userIdRegex = userIdRegex.stringByAppendingString("|")
                }
                userIdRegex = userIdRegex.substringToIndex(userIdRegex.length-1)
                userIdRegex = userIdRegex.stringByAppendingString(")")
                
                let subquery = KCSQuery(onField: "fromUser._id", usingConditional: KCSQueryConditional.KCSRegex, forValue: userIdRegex)
                let q1 = KCSQuery(onField: "toUser._id", usingConditional: KCSQueryConditional.KCSNotEqual, forValue: KCSUser.activeUser().userId)
                let q2 = KCSQuery(onField: "type", usingConditional: KCSQueryConditional.KCSNotEqual, forValue: "comment")
                let q3 = KCSQuery(onField: "content", usingConditional: KCSQueryConditional.KCSRegex, forValue: "^(?!(no|invite|request|maybe))")
                let q4 = KCSQuery(onField: "addit", usingConditional: KCSQueryConditional.KCSNotEqual, forValue: "s")
                subquery.addQuery(q1)
                subquery.addQuery(q2)
                subquery.addQuery(q3)
                subquery.addQuery(q4)
                subquery.addSortModifier(KCSQuerySortModifier(field: KCSMetadataFieldCreationTime, inDirection: KCSSortDirection.Descending))
                subquery.limitModifer = KCSQueryLimitModifier(limit: 40)
                //var timer = MyTimer()
                store.queryWithQuery(subquery, withCompletionBlock: {
                    (objects:[AnyObject]!, error:NSError!) -> Void in
                    //timer.finish()
                    if (error == nil){
                        print(objects.count)
                        // filter results
                        for object in objects{
                            temp.append(FetchedActivityUnit(fromUnit: object as! ActivityUnit))
                        }
                        completionHandler(downloadedData: temp, error: error)
                    }else{
                        completionHandler(downloadedData: nil, error: error)
                    }
                }, withProgressBlock: nil)
            }else{
                completionHandler(downloadedData: nil, error: error)
            }
        }, withProgressBlock: nil)
    }
    
    class func getUsersByQuery(query:KCSQuery ,completionHandler: (downloadedData: [FetchedActivityUnit]!, error: NSError!) -> Void){
        if !Utility.checkForBeingActive(){
            return
        }
        let store = KCSLinkedAppdataStore.storeWithOptions([
            KCSStoreKeyCollectionName : "Activity",
            KCSStoreKeyCollectionTemplateClass : ActivityUnit.self
            ])
        var temp:[FetchedActivityUnit] = []
        store.queryWithQuery(query,withCompletionBlock: {
                (objects: [AnyObject]!, error: NSError!) -> Void in
                if (error == nil){
                    for object in objects{
                        temp.append(FetchedActivityUnit(fromUnit: object as! ActivityUnit))
                    }
                    completionHandler(downloadedData: temp, error: nil)
                }else{
                    completionHandler(downloadedData: temp, error: error)
                }
            
        },withProgressBlock: nil)
    }
    
    class func getUserIdsOfPeopleYouFollow(handler:(regexString:String!, error:NSError!) -> Void) -> KCSRequest!{
        let store = KCSLinkedAppdataStore.storeWithOptions([
            KCSStoreKeyCollectionName : "Activity",
            KCSStoreKeyCollectionTemplateClass : ActivityUnit.self
            ])
        let query = KCSQuery(onField: "fromUser._id", withExactMatchForValue: KCSUser.activeUser().userId)
        query.addQueryOnField("type", withExactMatchForValue: "follow")
        query.addQueryOnField("content", withExactMatchForValue: "accepted")

        let request = store.queryWithQuery(query, withCompletionBlock: {
            (objects:[AnyObject]!, error:NSError!) -> Void in
            if error == nil {
                var userIdRegex:NSString = "^("
                for followee in objects{
                    userIdRegex = userIdRegex.stringByAppendingString((followee as! ActivityUnit).toUser!.userId!)
                    userIdRegex = userIdRegex.stringByAppendingString("|")
                }
                userIdRegex = userIdRegex.substringToIndex(userIdRegex.length-1)
                userIdRegex = userIdRegex.stringByAppendingString(")")
                handler(regexString: userIdRegex as String, error: nil)
            } else {
                handler(regexString: nil, error: error)
            }
        }, withProgressBlock: nil)
        return request
    }
    
    class func searchUsersByRegexAndUsername(lastObject:FetchedUser!,limit:Int, containsString:String, inout request:KCSRequest,
        handler: (users:[FetchedUser]!, error:NSError!) -> Void) {
        let store = KCSLinkedAppdataStore.storeWithOptions([
            KCSStoreKeyCollectionName : KCSUserCollectionName,
            KCSStoreKeyCollectionTemplateClass : KCSUser.self
            ])
    
        var query = KCSQuery(onField: KCSUserAttributeUsername, withRegex: "^(.*\(containsString.lowercaseString).*)")
        if (lastObject != nil){ // limit 10 + 1 to check if there is anything left
            query = GeneralDownloadManager.loadMoreQuery(lastObject, query: query, limit: limit+1, table: "Activity")
        }else{
            query.limitModifer = KCSQueryLimitModifier(limit: limit+1)
            query.addSortModifier(KCSQuerySortModifier(field: "createdAt", inDirection: KCSSortDirection.Descending))
        }
            
        request = store.queryWithQuery(query, withCompletionBlock: {
            (objects:[AnyObject]!, error:NSError!) -> Void in
            if error == nil {
//                print("users found: \(objects.count)")
                var temp:[FetchedUser] = []
                for object in objects {
                    temp.append(FetchedUser(forUser: object as! KCSUser, username: nil))
                }
                
                handler(users: temp, error: nil)
            } else {
                
                handler(users: nil, error: error)
            }
        }, withProgressBlock: nil)
            

    }
    class func countEventsThatContainString(string:String,inout request:KCSRequest, handler:(number:UInt!,error:NSError!) -> Void){
        let query = KCSQuery(onField: "name", withRegex: "^((.*(\(string)|(\(string.lowercaseString))|(\(string.uppercaseString))).*))")
        request = GeneralDownloadManager.countObjectsWithQuery(query, tableName: "Events") {
            (number:UInt, error:NSError!) -> Void in
            if error == nil {
                handler(number: number, error: nil)
            } else {
                handler(number: nil, error: error)
            }
        }
        
    }
    class func searchEventsByString(containsString:String, inout request:KCSRequest,
        handler: (eventsFound:[FetchedEvent]!,error:NSError!) -> Void){
            
            let store = KCSLinkedAppdataStore.storeWithOptions([
                KCSStoreKeyCollectionName : "Events",
                KCSStoreKeyCollectionTemplateClass : Event.self
                ])
            
//            print(regexString)
            let query = KCSQuery(onField: "name", withRegex: "^(\(containsString))")
            
            
            // Find Events
            request = store.queryWithQuery(query, withCompletionBlock: {
                (objects:[AnyObject]!, error:NSError!) -> Void in
                if error == nil {
                    
                    var eventsFound:[FetchedEvent] = []

                    // Events Found , collect them
                    print("events found: \(objects.count)")
                    for object in objects {
                        eventsFound.append(FetchedEvent(fromEvent: object as! Event, tab: TargetView.Home))
                    }
                    
                    handler(eventsFound: eventsFound,error: nil)
                } else {
                    
                    handler(eventsFound: nil,error: error)
                }
            }, withProgressBlock: nil)
            
            
    }

    
    class func loadPictureForUser(inout user:FetchedUser, completionHandler: (error:NSError!) -> Void) -> KCSRequest!{
        if (user.pictureId != ""){
            if (user.pictureProgress < 0){
                user.pictureProgress = 0
                let request = FileDownloadManager.downloadImage(user.pictureId, completionBlock: {
                    (images:[UIImage]!, error:NSError!) -> Void in
                    if (error == nil){
                        if (images.count > 0){
                            user.picture = images[0]
                            user.pictureProgress = 1
                            completionHandler(error: nil)
                        }else{
                            user.pictureProgress = 1
                            print("no image found")
                            completionHandler(error: nil)
                        }
                    }else{
                        user.pictureProgress = -1
                        print("Error: " + error.description)
                        completionHandler(error: error)
                    }
                    
                    }, progressBlock: {
                        (objects:[AnyObject]!, percentComplete:Double) -> Void in
                        user.pictureProgress = percentComplete
                        completionHandler(error: nil)
                })
                return request
            }else{
                return KCSRequest()
            }
        }else{
            return KCSRequest()
        }
    }
    
    class func countComments(forEvent:Event, handler: (number:Int,error:NSError!) -> Void){
        let store = KCSLinkedAppdataStore.storeWithOptions([
            KCSStoreKeyCollectionName : "Activity",
            KCSStoreKeyCollectionTemplateClass : ActivityUnit.self
        ])
        let query = KCSQuery(onField: "event._id", withExactMatchForValue: forEvent.entityId!)
        query.addQueryOnField("type", withExactMatchForValue: "comment")
        store.countWithQuery(query, completion: {
            (number:UInt, error:NSError!) -> Void in
            if error == nil {
                handler(number: Int(number), error: nil)
            }else{
                handler(number: 0, error: nil)
            }
        })
    }
    
    
    class func postComment(commentString:String,event:FetchedEvent, handler: (object:FetchedActivityUnit!,error:NSError!) -> Void){
        let store = KCSLinkedAppdataStore.storeWithOptions([
            KCSStoreKeyCollectionName : "Activity",
            KCSStoreKeyCollectionTemplateClass : ActivityUnit.self
            ])
        
        let comment:ActivityUnit = ActivityUnit()
        comment.event = event.eventOriginal
        comment.fromUser = KCSUser.activeUser()
        comment.type = "comment"
        comment.content = commentString
        comment.toUser = event.author
        
        store.saveObject(comment, withCompletionBlock: {
            (objects:[AnyObject]!, error:NSError!) -> Void in
            if (error == nil){
                handler(object: FetchedActivityUnit(fromUnit: objects[0] as! ActivityUnit),error: nil)
            }else{
                handler(object: nil,error: error)
            }
        }, withProgressBlock: nil)
    }
    class func deleteComment(comment:FetchedActivityUnit, handler: (error:NSError!) -> Void) {
        GeneralDownloadManager.deleteObjectWithId(comment.entityId, tableName: "Activity", completionBlock: {
            (number:UInt, error:NSError!) -> Void in
            if error == nil {
                handler(error: nil)
            } else {
                handler(error: error)
            }
        }, progressBlock: nil)
    }
    
    class func loadComments(lastObject:FetchedActivityUnit!,event:Event,limit:Int,handler: (data:[FetchedActivityUnit]!,error:NSError!) -> Void){
        var query:KCSQuery = KCSQuery()
        query.addQueryOnField("type", withExactMatchForValue: "comment")
        query.addQueryOnField("event._id", withExactMatchForValue: event.entityId)

        if (lastObject != nil){ // limit 10 + 1 to check if there is anything left
            query = GeneralDownloadManager.loadMoreQuery(lastObject, query: query, limit: limit+1, table: "Activity")
        }else{
            query.limitModifer = KCSQueryLimitModifier(limit: limit+1)
            query.addSortModifier(KCSQuerySortModifier(field: "createdAt", inDirection: KCSSortDirection.Descending))
        }
        let store = KCSLinkedAppdataStore.storeWithOptions([
            KCSStoreKeyCollectionName : "Activity",
            KCSStoreKeyCollectionTemplateClass : ActivityUnit.self
            ])
        store.queryWithQuery(query, withCompletionBlock: {
            (objects:[AnyObject]!, error:NSError!) -> Void in
            if error == nil {
                var temp:[FetchedActivityUnit] = []
                if objects.count > 0 {
                    for object in objects {
                        temp.append(FetchedActivityUnit(fromUnit: object as! ActivityUnit))
                    }
                    for unit in temp { // to shorten createdAt 
                        unit.createdAtText = DateToStringConverter.getCreatedAtString(unit.metadata!.creationTime(), tab: TargetView.Home)
                    }
                    
                    handler(data: temp, error: nil)
                }else{
                    handler(data: [], error: nil)
                }
            }else{
                handler(data: nil, error: error)
            }
        }, withProgressBlock: nil)
    }
}
