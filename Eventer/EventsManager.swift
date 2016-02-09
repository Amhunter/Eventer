//
//  EventsManager.swift
//  Eventer
//
//  Created by Grisha on 17/07/2015.
//  Copyright (c) 2015 Grisha. All rights reserved.
//

import UIKit
enum EventsTarget {
    case HomeTabEventsTableView
    case ExploreTabEventsCollectionView
    case ExploreTabEventsTableView
    case MyProfileEventsTableView
    case LoadEventsByID
}
protocol EventsManagerDelegate{
    func eventDeleted(atIndex:Int)
}
class EventsManager:NSObject, UIActionSheetDelegate {
    var events:[FetchedEvent] = []
    var delegate:EventsManagerDelegate! = nil


    
    func loadProfilePictureForEvent(inout event:FetchedEvent, completionHandler: (error:NSError!) -> Void){
        if (event.profilePictureID != ""){
            if (event.profilePictureProgress < 0){
                event.profilePictureProgress = 0
                FileDownloadManager.downloadImage(event.profilePictureID, completionBlock: {
                    (images:[UIImage]!, error:NSError!) -> Void in
                    if (error == nil){
                        if (images.count > 0){
                            event.profilePicture = images[0]
                            event.profilePictureProgress = 1
                            completionHandler(error: nil)
                        }else{
                            event.profilePictureProgress = 1
                            print("no image found")
                            completionHandler(error: nil)
                        }
                    }else{
                        event.profilePictureProgress = -1
                        print("Error: " + error.description)
                        completionHandler(error: error)
                    }
                    
                    }, progressBlock: {
                        (objects:[AnyObject]!, percentComplete:Double) -> Void in
                        event.profilePictureProgress = percentComplete
                        completionHandler(error: nil)
                })
            }
        }
    }
    func loadProfilePictureForUser(inout user:KCSUserWith3Events, completionHandler: (error:NSError!) -> Void){
        if (user.profilePictureID != ""){
            if (user.profilePictureProgress < 0){
                user.profilePictureProgress = 0
                FileDownloadManager.downloadImage(user.profilePictureID, completionBlock: {
                    (images:[UIImage]!, error:NSError!) -> Void in
                    if (error == nil){
                        if (images.count > 0){
                            user.profilePicture = images[0]
                            user.profilePictureProgress = 1
                            completionHandler(error: nil)
                        }else{
                            user.profilePictureProgress = 1
                            print("no image found")
                            completionHandler(error: nil)
                        }
                    }else{
                        user.profilePictureProgress = -1
                        print("Error: " + error.description)
                        completionHandler(error: error)
                    }
                    
                    }, progressBlock: {
                        (objects:[AnyObject]!, percentComplete:Double) -> Void in
                        user.profilePictureProgress = percentComplete
                        completionHandler(error: nil)
                })
            }
        }
    }
    func updateEventData(inout event:FetchedEvent, completionHandler:(error:NSError!) -> Void){
        GeneralDownloadManager.loadObjectWithId(event.eventOriginal.entityId, tableName: "Events", completionBlock: {
            (objects:[AnyObject]!, error:NSError!) -> Void in
            var temp:FetchedEvent!
            if error == nil {
                if objects != nil {
                    temp = FetchedEvent(fromEvent: objects[0] as! Event, tab: forTab.Home)
                    event.eventOriginal = temp.eventOriginal
                    event.name = temp.name
                    event.details = temp.details
                    event.location = temp.location
                    event.locationString = temp.locationString
                    event.date = temp.date
                    event.eventDateText = temp.eventDateText
                    event.author = temp.author
                    if event.pictureId != temp.pictureId {
                        event.pictureId = temp.pictureId
                        event.pictureProgress = -99
                    }
                    if event.profilePictureID != temp.profilePictureID {
                        event.profilePictureID = temp.profilePictureID
                        event.profilePictureProgress = -99
                    }
                }
                completionHandler(error: nil)
            }else{
                completionHandler(error: error)
            }
        }, progressBlock: nil)
    }
    func loadPictureForEvent(inout event:FetchedEvent, completionHandler: (error:NSError!) -> Void){
        if (event.pictureId != ""){
            if (event.pictureProgress < 0){
                event.pictureProgress = 0
                FileDownloadManager.downloadImage(event.pictureId, completionBlock: {
                    (images:[UIImage]!, error:NSError!) -> Void in
                    if (error == nil){
                        if (images.count > 0){
                            event.picture = images[0]
                            event.pictureProgress = 1
                            completionHandler(error: nil)
                        }else{
                            event.pictureProgress = 1
                            print("no image found")
                            completionHandler(error: nil)
                        }
                    }else{
                        event.pictureProgress = -1
                        print("Error: " + error.description)
                        completionHandler(error: error)
                    }
                    
                    }, progressBlock: {
                        (objects:[AnyObject]!, percentComplete:Double) -> Void in
                        event.pictureProgress = percentComplete
                        completionHandler(error: nil)
                })
            }
        }
    }
    
    
    class func loadEventsForHomeTableView(lastObject:FetchedEvent!,
        completionHandler: (downloadedEventsArray: [FetchedEvent], error: NSError!) -> Void){

        var EventsData:[FetchedEvent] = []
        var query:KCSQuery = KCSQuery()

        
        if (lastObject != nil){ // limit 10 + 1 to check if there is anything left
            query = GeneralDownloadManager.loadMoreQuery(lastObject, query: query, limit: 11, table: "Events")
        }else{
            query.limitModifer = KCSQueryLimitModifier(limit: 11)
            query.addSortModifier(KCSQuerySortModifier(field: "createdAt", inDirection: KCSSortDirection.Descending))
        }
        GeneralDownloadManager.loadEventsWithQuery(query,tab:forTab.Home, completionBlock: {
            (events:[FetchedEvent]!, error:NSError!) -> Void in
            if (error == nil){
                //println("events found: \(events.count)")
                for (index,event) in events.enumerate(){
                    EventsData.insert(event, atIndex: index)
                }
                EventsManager.loadAdditionalData(&EventsData, tab: forTab.Home, completionHandler: {
                    (error:NSError!) -> Void in
                    if (error == nil){
                        completionHandler(downloadedEventsArray: EventsData, error: nil)
                    }else{
                        completionHandler(downloadedEventsArray: EventsData, error: error)
                        
                    }
                })
            }else{
                completionHandler(downloadedEventsArray: EventsData, error: error)
            }
        }, progressBlock: nil)
    }
    

    
    func loadEventsForProfileView(lastObject:FetchedEvent!,forUserId:String,completionHandler: (downloadedEventsArray: [FetchedEvent], error: NSError!) -> Void){
        
//        let store = KCSLinkedAppdataStore.storeWithOptions([
//            KCSStoreKeyCollectionName : "Events",
//            KCSStoreKeyCollectionTemplateClass : Event.self
//            ])
        var EventsData:[FetchedEvent] = []
//        var event:Event!
        var query:KCSQuery = KCSQuery(onField: KCSMetadataFieldCreator, withExactMatchForValue: forUserId)
        
        if (lastObject != nil){ // limit 10 + 1 to check if there is anything left
            query = GeneralDownloadManager.loadMoreQuery(lastObject, query: query, limit: 19, table: "Events")
        }else{
            query.limitModifer = KCSQueryLimitModifier(limit: 19)
            query.addSortModifier(KCSQuerySortModifier(field: "createdAt", inDirection: KCSSortDirection.Descending))
        }
        GeneralDownloadManager.loadEventsWithQuery(query,tab:forTab.Home, completionBlock: {
            (events:[FetchedEvent]!, error:NSError!) -> Void in
            if (error == nil){
                //println("events found: \(events.count)")
                for (index,event) in events.enumerate(){
                    EventsData.insert(event, atIndex: index)
                }
                EventsManager.loadAdditionalData(&EventsData, tab: forTab.Profile, completionHandler: {
                    (error:NSError!) -> Void in
                    if (error == nil){
                        completionHandler(downloadedEventsArray: EventsData, error: nil)
                    }else{
                        completionHandler(downloadedEventsArray: EventsData, error: error)
                        
                    }
                })
            }else{
                completionHandler(downloadedEventsArray: EventsData, error: error)
            }
        }, progressBlock: nil)
    }
    
    
    class func loadAdditionalData(inout forEvents:[FetchedEvent], tab:forTab, completionHandler: (error: NSError!) -> Void){
        
        let substore = KCSAppdataStore.storeWithOptions([
            KCSStoreKeyCollectionName : "Activity",
            KCSStoreKeyCollectionTemplateClass : ActivityUnit.self
            ])
        
        var eventids:[NSString] = []
        for (index,event) in forEvents.enumerate(){
            eventids.insert(event.eventOriginal!.entityId!, atIndex: index)
        }
        var string:NSString = "^("

        // regex way
        
        for name in eventids{
            string = string.stringByAppendingString(name as String)
            string = string.stringByAppendingString("|")
        }
        string = string.substringToIndex(string.length-1)
        string = string.stringByAppendingString(")")
        
        let subquery:KCSQuery = KCSQuery(onField: "event._id", withRegex: string as String)
        
        var Data0Loaded:Bool = false
        var Data1Loaded:Bool = false
        var Data2Loaded:Bool = false

        var Done:Bool = false
        // Parallel query 0, get number of likes comments and shares
        let query0:KCSQuery = KCSQuery(onField: "type", withExactMatchForValue: "response")
        query0.addQueryOnField("content", withExactMatchForValue: "yes")
        query0.addQuery(subquery)
        substore.group(["event._id"], reduce: KCSReduceFunction.COUNT(), condition: query0, completionBlock: {
            (group:KCSGroup!, error:NSError!) -> Void in
            if (error == nil){
                let temp:[FetchedEvent] = forEvents
                
                for (index,event) in temp.enumerate(){
                    
                    forEvents[index].goManager.numberOfGoing = group.reducedValueForFields(["event._id" : event.eventOriginal!.entityId!]).integerValue
                    if (forEvents[index].goManager.numberOfGoing == NSNotFound) { forEvents[index].goManager.numberOfGoing = 0 }
                    
                    
                    forEvents[index].additionalDataDownloaded = true
                    
                }
                
                
                if (Data2Loaded && Data1Loaded && !Done){
                    Done = true
                    completionHandler(error: nil)
                    
                }
                Data0Loaded = true
            }else{
                completionHandler(error: error)
            }
        }, progressBlock: nil)
        
        // Parallel query 1, get number of likes comments and shares
        
        let query1:KCSQuery = KCSQuery(onField: "type", withRegex: "^(like|comment|share|response)")
        query1.addQueryOnField("content", usingConditional: KCSQueryConditional.KCSOr, forValue: "yes")
        query1.addQuery(subquery)
        
        substore.group(["event._id","type"], reduce: KCSReduceFunction.COUNT(), condition: query1, completionBlock: {
            (group:KCSGroup!, error:NSError!) -> Void in
            if (error == nil){
                let temp:[FetchedEvent] = forEvents
                
                for (index,event) in temp.enumerate(){
                    
                    forEvents[index].likeManager.numberOfLikes = (group.reducedValueForFields(["event._id" : event.eventOriginal!.entityId! ,"type" : "like"]).integerValue)
                    if (forEvents[index].likeManager.numberOfLikes == NSNotFound) { forEvents[index].likeManager.numberOfLikes = 0 }

                    
                    forEvents[index].shareManager.numberOfShares = group.reducedValueForFields(["event._id" : event.eventOriginal!.entityId!, "type" : "share"]).integerValue
                    if (forEvents[index].shareManager.numberOfShares  == NSNotFound) { forEvents[index].shareManager.numberOfShares  = 0 }
                    
                    forEvents[index].numberOfComments = group.reducedValueForFields(["event._id" : event.eventOriginal!.entityId!, "type" : "comment"]).integerValue
                    if (forEvents[index].numberOfComments == NSNotFound) { forEvents[index].numberOfComments = 0 }
                    
                    
                    forEvents[index].additionalDataDownloaded = true
                    
                }
                
                
                if (Data2Loaded && Data0Loaded && !Done){
                    Done = true
                    completionHandler(error: nil)

                }
                Data1Loaded = true
            }else{
                completionHandler(error: error)
            }
        }, progressBlock: nil)
        
        // Parallel Query 2, get your response, like and share
        
        let query2:KCSQuery = KCSQuery()  // activeUser
        query2.addQueryOnField("fromUser._id", withExactMatchForValue: KCSUser.activeUser().userId)
        query2.addQueryOnField("type", usingConditional: KCSQueryConditional.KCSRegex, forValue: "^(like|share|response)")
        query2.addQuery(subquery) // evs & (activeUser & (like | (response & yes)))
        
        substore.group(["event._id","content"], reduce: KCSReduceFunction.COUNT(), condition: query2, completionBlock: {
            (group:KCSGroup!, error:NSError!) -> Void in
            if (error == nil){
                let temp:[FetchedEvent] = forEvents
                
                for (index,event) in temp.enumerate(){
                    // get if liked by you
                    var number = group.reducedValueForFields(["event._id": event.eventOriginal!.entityId!, "content" : "l"]).integerValue
                    var liked:Bool = false
                    if (number != NSNotFound){ liked = true }
                    forEvents[index].likeManager.initialize(forEvents[index], isLiked: liked, row: index, tab: tab)
                    
                    // get if you are going
                    number = group.reducedValueForFields(["event._id": event.eventOriginal!.entityId!, "content" : "yes"]).integerValue
                    var going:Bool = false
                    if (number != NSNotFound){ going = true }
                    forEvents[index].goManager.initialize(forEvents[index], isGoing: going, row: index, tab: tab)
                    
                    number = group.reducedValueForFields(["event._id": event.eventOriginal!.entityId!, "content" : "s"]).integerValue
                    var shared:Bool = false
                    if (number != NSNotFound){ shared = true }
                    forEvents[index].shareManager.initialize(forEvents[index], isShared: shared, row: index, tab: tab)
                    
                    
                    forEvents[index].personalDataDownloaded = true
                    
                    
                }
                if (Data1Loaded && Data0Loaded && !Done){
                    Done = true
                    completionHandler(error: nil)
                }
                Data2Loaded = true
                
            }else{
                completionHandler(error: error)

            }
        }, progressBlock: nil)

    }
    

    func More(index:Int,button:HomeMoreButton){
        var actionSheet:UIActionSheet = UIActionSheet(title: (events[index].name as String), delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil)
        
        if (events[index].authorId == KCSUser.activeUser().userId){
            //actionSheet.addButtonWithTitle("Edit")
            actionSheet = UIActionSheet(title: (events[index].name as String), delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: "Delete")
            
        }else{
            actionSheet.addButtonWithTitle("Report")
        }
        actionSheet.tag = index
        actionSheet.showInView(button.superview!.superview!.superview!.superview!) // button-content-cell-table-view
        
    }
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        if (actionSheet.buttonTitleAtIndex(buttonIndex) == "Delete"){ // delete
            Delete(actionSheet.tag)
        }
    }

    
    func Delete(atIndex:Int){
        let store = KCSLinkedAppdataStore.storeWithOptions([
            KCSStoreKeyCollectionName : "Events",
            KCSStoreKeyCollectionTemplateClass : Event.self
            ])
        
        store.removeObject(events[atIndex].eventOriginal!.entityId, withCompletionBlock: { (number:UInt, error:NSError!) -> Void in
            if (error == nil){
                print("deleted event at index \(atIndex)")
                self.events.removeAtIndex(atIndex)
                self.delegate.eventDeleted(atIndex)
            }else{
                print("Error: " + error.description)
            }
        }, withProgressBlock: nil)
    }
    
    func loadEventsForExploreCollectionView(lastObject:FetchedEvent!, completionHandler: (downloadedEventsArray: [FetchedEvent], error: NSError!) -> Void){
        
        var EventsData:[FetchedEvent] = []
        var query:KCSQuery = KCSQuery()
        
        
        if (lastObject != nil){ // limit 20 + 1 to check if there is anything left
            // modify query 
            query = GeneralDownloadManager.loadMoreQuery(lastObject, query: query, limit: 19, table: "Events")
        }else{
            query.limitModifer = KCSQueryLimitModifier(limit: 19)
            query.addSortModifier(KCSQuerySortModifier(field: "createdAt", inDirection: KCSSortDirection.Descending))
        }
        GeneralDownloadManager.loadEventsWithQuery(query, tab:forTab.Explore, completionBlock: {
            (events:[FetchedEvent]!, error:NSError!) -> Void in
            if (error == nil){
                //println("events found: \(events.count)")
                for (index,event) in events.enumerate(){
                    EventsData.insert(event, atIndex: index)
                }
                EventsManager.loadAdditionalData(&EventsData, tab: forTab.Home, completionHandler: {
                    (error:NSError!) -> Void in
                    if (error == nil){
                        completionHandler(downloadedEventsArray: EventsData, error: nil)
                    }else{
                        completionHandler(downloadedEventsArray: EventsData, error: error)
                        
                    }
                })
            }else{
                completionHandler(downloadedEventsArray: EventsData, error: error)
            }
        }, progressBlock: nil)
    }

    
    
    func loadEventsForExploreTableView(completionHandler: (downloadedUsersArray:[KCSUserWith3Events]!, error: NSError!) -> Void){
        
        let store = KCSLinkedAppdataStore.storeWithOptions([
            KCSStoreKeyCollectionName : KCSUserCollectionName,
            KCSStoreKeyCollectionTemplateClass : KCSUser.self
            ])
        
        let eventstore = KCSLinkedAppdataStore.storeWithOptions([
            KCSStoreKeyCollectionName : "Events",
            KCSStoreKeyCollectionTemplateClass : Event.self
            ])
        let activitystore = KCSLinkedAppdataStore.storeWithOptions([
            KCSStoreKeyCollectionName : "Activity",
            KCSStoreKeyCollectionTemplateClass : ActivityUnit.self
            ])
        
        let query = KCSQuery(onField: "access", withExactMatchForValue: "public")
        query.addSortModifier(KCSQuerySortModifier(field: KCSMetadataFieldCreationTime, inDirection: KCSSortDirection.Descending))
        
        //var userIdsToLoad:[String]
        
        
        store.group(["_id"], reduce: KCSReduceFunction.COUNT(), condition: query, completionBlock: {
            (group:KCSGroup!, error:NSError!) -> Void in
            if (error == nil){
                var usersIdsToLoad:[String] = []
                let array:[NSDictionary] = group.fieldsAndValues() as! [NSDictionary]
                //println(array.count)
                var ids:[String] = []
                for obj in array{
                    ids.append(obj["_id"] as! String)
                }
                var temp:[KCSUserWith3Events] = []
                var eventsLoaded:[[FetchedEvent]] = []
                var followArray:[String:Bool] = [String:Bool]()
                var Done = false
                var usersLoaded = false
                var numberOfEventsLoaded = 0
                var followsLoaded = false

                if (ids.count <= 100){
                    usersIdsToLoad = ids
                    
                    // load users
                    store.loadObjectWithID(ids, withCompletionBlock: {
                        (objects:[AnyObject]!, error:NSError!) -> Void in
                        if (error == nil){
                            for object in objects{
                                temp.append(KCSUserWith3Events(forUser: object as! KCSUser))
                            }
                            if ((numberOfEventsLoaded == usersIdsToLoad.count) && followsLoaded && !Done){
                                Done = true
                                //merge data
                                for (idx, threeEvents) in eventsLoaded.enumerate(){
                                    temp[idx].events = threeEvents
                                }
                                for (index,user) in temp.enumerate(){
                                    user.followManager.initialize(user.user! ,isFollowing: followArray[user.user!.userId]!, row: index, tab:forTab.Home)
                                }
                                completionHandler(downloadedUsersArray: temp, error: nil)
                            }
                            usersLoaded = true
                            
                        }else{
                            completionHandler(downloadedUsersArray: nil, error: error)
                        }
                    }, withProgressBlock: nil)
                    
                    // load events
                    
                    for (index,id) in usersIdsToLoad.enumerate(){
                        eventsLoaded.append([])
                        var subquery:KCSQuery = KCSQuery(onField: "author._id", withRegex: "^(\(id))")
                        subquery.limitModifer = KCSQueryLimitModifier(limit: 3)
                        subquery.addSortModifier(KCSQuerySortModifier(field: KCSMetadataFieldCreationTime, inDirection: KCSSortDirection.Descending))
                        eventstore.queryWithQuery(subquery, withCompletionBlock: {
                            (objects:[AnyObject]!, error:NSError!) -> Void in
                            if (error == nil){
                                
                                var tempev:[FetchedEvent] = []
                                for object in objects{
                                    tempev.append(FetchedEvent(fromEvent: object as! Event, tab: forTab.Explore))
                                }
                                eventsLoaded[index] = tempev
                                numberOfEventsLoaded++
                                if (numberOfEventsLoaded == usersIdsToLoad.count){
                                    if (usersLoaded && followsLoaded && !Done){
                                        Done = true
                                        for (idx, threeEvents) in eventsLoaded.enumerate(){
                                            temp[idx].events = threeEvents
                                        }
                                        for (index,user) in temp.enumerate(){
                                            user.followManager.initialize(user.user! ,isFollowing: followArray[user.user!.userId]!, row: index, tab:forTab.Home)
                                        }
                                        completionHandler(downloadedUsersArray: temp, error: nil)
                                        
                                    }
                                }

                            }else{
                                completionHandler(downloadedUsersArray: nil, error: error)
                            }
                            
                        }, withProgressBlock: nil)
                        
                        // load follows
                        
                        
                        var string:NSString = "^("
                        for id in usersIdsToLoad{
                            string = string.stringByAppendingString(id as String)
                            string = string.stringByAppendingString("|")
                        }
                        string = string.substringToIndex(string.length-1)
                        string = string.stringByAppendingString(")")
                        subquery = KCSQuery(onField: "toUser._id", withRegex: string as String)
                        subquery.addQueryOnField("fromUser._id", withExactMatchForValue: KCSUser.activeUser().userId)
                        subquery.addQueryOnField("type", withExactMatchForValue: "follow")
                        activitystore.group("toUser._id", reduce: KCSReduceFunction.COUNT(), condition: subquery, completionBlock: {
                            (group:KCSGroup!, error:NSError!) -> Void in
                            if (error == nil){
                                for id in usersIdsToLoad{
                                    var following:Bool = false
                                    let number = group.reducedValueForFields(["toUser._id": id]).integerValue
                                    if (number != NSNotFound){ following = true }
                                    followArray[id] = following
                                }
                                if ((numberOfEventsLoaded == usersIdsToLoad.count) && usersLoaded && !Done){
                                    Done = true
                                    
                                    for (idx, threeEvents) in eventsLoaded.enumerate(){
                                        temp[idx].events = threeEvents
                                    }
                                    for (index,user) in temp.enumerate(){
                                        user.followManager.initialize(user.user! ,isFollowing: followArray[user.user!.userId]!, row: index, tab:forTab.Home)
                                    }
                                    completionHandler(downloadedUsersArray: temp, error: nil)

                                }
                                followsLoaded = true
                            }else{
                                completionHandler(downloadedUsersArray: nil, error: error)
   
                            }
                        }, progressBlock: nil)
                    }
                }
                
            }else{
                print("Error:" + error.description)
                completionHandler(downloadedUsersArray: [], error: error)

                //self.usersTableViewRefreshControl.endRefreshing()
            }
        }, progressBlock: nil)
        
    }
    class func createEvent(name:String, date:NSDate,description:String?,image:UIImage?, isPublic:Bool, invitedPeople:[KCSUser],handler:
        (progress:Double,error:NSError!) -> Void){
        // progress 101 = done, 0 - 100 = still doing, -1 error
            let eventStore = KCSLinkedAppdataStore.storeWithOptions([
                KCSStoreKeyCollectionName : "Events",
                KCSStoreKeyCollectionTemplateClass : Event.self
                ])
            
            let event:Event = Event()
            event.author = KCSUser.activeUser()
            event.authorId = KCSUser.activeUser().userId
            event.name = name
            event.date = date
            if description != nil {
                event.details = description
            }
            (isPublic == true) ? (event.access = "public") : (event.access = "private")
            
            if image == nil {
                eventStore.saveObject(event, withCompletionBlock: {
                    (objects:[AnyObject]!, error:NSError!) -> Void in
                    if error == nil {
                        handler(progress: 101, error: nil)
                    } else {
                        handler(progress: -1, error: error)
                    }
                    })
                    { (objects:[AnyObject]!, percentComplete:Double) -> Void in
                        handler(progress: percentComplete, error: nil)
                }
            } else {
                FileDownloadManager.uploadImage(image!,options:nil, completionBlock: {
                    (error:NSError!, fileId:String!) -> Void in
                    if error == nil {
                        event.pictureId = fileId
                        eventStore.saveObject(event, withCompletionBlock: {
                            (objects:[AnyObject]!, error:NSError!) -> Void in
                            if error == nil {
                                handler(progress: 101, error: nil)
                            } else {
                                handler(progress: -1, error: error)
                            }
                            })
                            { (objects:[AnyObject]!, percentComplete:Double) -> Void in
                                handler(progress: percentComplete, error: nil)
                        }
                    } else {
                        handler(progress: -1, error: error)
                    }
                })
            }
    }
    
    class func modifyEventData(event:FetchedEvent, imageChanged: Bool, removeImage:Bool, completionBlock:(updatedEvent:Event!, error:NSError!) -> Void) {
        let eventToUpload:Event = event.eventOriginal
        eventToUpload.name = event.name
        eventToUpload.date = event.date
        if event.details != "" {
            eventToUpload.details = event.details
        }
        
        
        // first try to update picture
        if imageChanged {
            if !removeImage {
                // upload picture
                let options:NSMutableDictionary = NSMutableDictionary()
                
                // specify id of the picture, to replace if there is one already
                if event.pictureId != "" {
                    options[KCSFileId] = event.pictureId
                }
                
                FileDownloadManager.uploadImage(event.picture, options: options, completionBlock: {
                    (error:NSError!, fileId:String!) -> Void in
                    if error == nil {
                        eventToUpload.pictureId = fileId
                        // Picture Uploaded, now update event and link picture id
                        
                        GeneralUploadManager.uploadObject(eventToUpload, tableName: "Events", completionBlock: {
                            (objects:[AnyObject]!, error:NSError!) -> Void in
                            if error == nil {
                                completionBlock(updatedEvent: eventToUpload,error: nil)
                            } else {
                                completionBlock(updatedEvent: nil,error: error)
                            }
                            }, progressBlock: nil)
                        
                        
                    } else {
                        completionBlock(updatedEvent: nil,error: error)
                        print("Couldn't upload picture\n \(error.description)")
                    }
                })
                
            } else {
                
                // delete if needed
                if eventToUpload.pictureId != nil {
                    FileDownloadManager.deleteImage(eventToUpload.pictureId! as String, completionBlock: {
                        (error:NSError!) -> Void in
                        if error == nil {
                            eventToUpload.pictureId = nil
                            
                            // Picture Deleted, now update event and link picture id
                            GeneralUploadManager.uploadObject(eventToUpload, tableName: "Events", completionBlock: {
                                (objects:[AnyObject]!, error:NSError!) -> Void in
                                if error == nil {
                                    completionBlock(updatedEvent: eventToUpload,error: nil)
                                } else {
                                    completionBlock(updatedEvent: nil,error: error)
                                }
                                }, progressBlock: nil)
                            
                        } else {
                            completionBlock(updatedEvent: nil,error: error)
                            print("Couldn't delete picture\n \(error.description)")
                        }
                    })
                }
            }
        } else {
            GeneralUploadManager.uploadObject(eventToUpload, tableName: "Events", completionBlock: {
                (objects:[AnyObject]!, error:NSError!) -> Void in
                if error == nil {
                    completionBlock(updatedEvent: eventToUpload,error: nil)
                } else {
                    completionBlock(updatedEvent: nil,error: error)
                }
            }, progressBlock: nil)
        }
    }

    
    /* loadEventsForTarget
    *  Loads event for specified target, 
    *  Target can be hashtag,day ,
    *  addit can have hashtagValue, date if target is day
    */
    
    class func loadEventsForTarget(lastObject:FetchedEvent!,Target:String,Addit:String,
        completionHandler: (downloadedEventsArray: [FetchedEvent], error: NSError!) -> Void){
            
            var EventsData:[FetchedEvent] = []
            var query:KCSQuery = KCSQuery()
            
            switch Target {
            case "Search":
                    query = KCSQuery(onField: "name", withRegex: "^((.*(\(Addit)|(\(Addit.lowercaseString))|(\(Addit.uppercaseString))).*))")
            default:
                break
            }
            
            
            if (lastObject != nil){ // limit 10 + 1 to check if there is anything left
                
                query = GeneralDownloadManager.loadMoreQuery(lastObject!, query: query, limit: 19, table: "Events")
            }else{
                query.limitModifer = KCSQueryLimitModifier(limit: 19)
                query.addSortModifier(KCSQuerySortModifier(field: "createdAt", inDirection: KCSSortDirection.Descending))
            }
            GeneralDownloadManager.loadEventsWithQuery(query,tab:forTab.Home, completionBlock: {
                (events:[FetchedEvent]!, error:NSError!) -> Void in
                if (error == nil){
                    //println("events found: \(events.count)")
                    for (index,event) in events.enumerate(){
                        EventsData.insert(event, atIndex: index)
                    }
                    EventsManager.loadAdditionalData(&EventsData, tab: forTab.Profile, completionHandler: {
                        (error:NSError!) -> Void in
                        if (error == nil){
                            completionHandler(downloadedEventsArray: EventsData, error: nil)
                        }else{
                            completionHandler(downloadedEventsArray: EventsData, error: error)
                            
                        }
                    })
                }else{
                    completionHandler(downloadedEventsArray: EventsData, error: error)
                }
            }, progressBlock: nil)
    }

}
