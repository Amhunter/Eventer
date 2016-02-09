//
//  GeneralDownloadManager.swift
//  Eventer
//
//  Created by Grisha on 04/08/2015.
//  Copyright (c) 2015 Grisha. All rights reserved.
//

import UIKit

class GeneralDownloadManager {
    class func myUserId() -> String {
        return KCSUser.activeUser().userId
    }
    
    class func loadObjectWithId(idOrIds:AnyObject!, tableName:String,
        completionBlock: (objects:[AnyObject]!, error:NSError!) -> Void,
        progressBlock: ((objects:[AnyObject]!, percentComplete:Double) -> Void)!){
        var store:KCSLinkedAppdataStore
        print(tableName)
        switch tableName{
        case "Events":
            store = KCSLinkedAppdataStore.storeWithOptions([
                KCSStoreKeyCollectionName : "Events",
                KCSStoreKeyCollectionTemplateClass : Event.self
                ])
        case "Users":
            store = KCSLinkedAppdataStore.storeWithOptions([
                KCSStoreKeyCollectionName : KCSUserCollectionName,
                KCSStoreKeyCollectionTemplateClass : KCSUser.self
                ])
        case "Activity":
            store = KCSLinkedAppdataStore.storeWithOptions([
                KCSStoreKeyCollectionName : "Activity",
                KCSStoreKeyCollectionTemplateClass : ActivityUnit.self
                ])
        default:
            store = KCSLinkedAppdataStore()
        }
            
        store.loadObjectWithID(idOrIds, withCompletionBlock: {
            (objects:[AnyObject]!, error:NSError!) -> Void in
            if error == nil {
                if (objects == nil){
                    completionBlock(objects: nil, error: nil)
                }else{
//                    var objs:[AnyObject] = []
//                    switch tableName{
//                    case "Events":
//                        objs = objects as! [Event]
//                    case "Users":
//                        objs = objects as! [KCSUser]
//                    case "Activity":
//                        objs = objects as! [ActivityUnit]
//                    default:
//                        objs = objects
//                    }
                    completionBlock(objects: objects, error: nil)
                }
            }else{
                completionBlock(objects: nil, error: error)
            }
        }, withProgressBlock: nil)
    }
    
    class func deleteObjectWithId(idOrIds:AnyObject!, tableName:String,
        completionBlock: (number:UInt, error:NSError!) -> Void,
        progressBlock: ((objects:[AnyObject]!, percentComplete:Double) -> Void)!){
        var store:KCSLinkedAppdataStore = KCSLinkedAppdataStore()
        
        switch tableName{
        case "Events":
            store = KCSLinkedAppdataStore.storeWithOptions([
                KCSStoreKeyCollectionName : "Events",
                KCSStoreKeyCollectionTemplateClass : Event.self
                ])
        case "Users":
            store = KCSLinkedAppdataStore.storeWithOptions([
                KCSStoreKeyCollectionName : KCSUserCollectionName,
                KCSStoreKeyCollectionTemplateClass : KCSUser.self
                ])
        case "Activity":
            store = KCSLinkedAppdataStore.storeWithOptions([
                KCSStoreKeyCollectionName : "Activity",
                KCSStoreKeyCollectionTemplateClass : ActivityUnit.self
                ])
        default:
            store = KCSLinkedAppdataStore()
        }
        
        store.removeObject(idOrIds, withCompletionBlock: {
            (number:UInt, error:NSError!) -> Void in
            if (error == nil){
                completionBlock(number: number, error: nil)
            }else{
                completionBlock(number: number, error: error)
            }
        } ,withProgressBlock:{
            (objects:[AnyObject]!, percentComplete:Double) -> Void in
            if (objects == nil){
                //progressBlock(objects: nil, percentComplete: percentComplete)
            }else{
                //progressBlock(objects: nil, percentComplete: percentComplete)
            }
        })
    }
    
    /* loadMoreQuery
     * Modify existing query to set limit
     */
    class func loadMoreQuery(lastObject:AnyObject,query:KCSQuery,limit:Int,table:String) -> KCSQuery{
        query.limitModifer = KCSQueryLimitModifier(limit: limit)
        if (table == "Events"){
            let lastEvent = lastObject as! FetchedEvent
            query.addSortModifier(KCSQuerySortModifier(field: "createdAt", inDirection: KCSSortDirection.Descending))
            let subquery = KCSQuery(onField: "createdAt", usingConditional: KCSQueryConditional.KCSLessThan, forValue: lastEvent.createdAt)
            query.addQuery(subquery)
            print(lastEvent.createdAtText)
            return query
        }else if (table == "Activity"){
            let lastunit = lastObject as! FetchedActivityUnit
            query.addSortModifier(KCSQuerySortModifier(field: "createdAt", inDirection: KCSSortDirection.Descending))
            let subquery = KCSQuery(onField: "createdAt", usingConditional: KCSQueryConditional.KCSLessThan, forValue: lastunit.createdAt)
            query.addQuery(subquery)
            print(lastunit.createdAtText)
            return query
        }
        return query
    }
    
    class func loadEventsWithQuery(query:KCSQuery,tab:forTab,
        completionBlock: (events:[FetchedEvent]!, error:NSError!) -> Void,
        progressBlock: ((objects:[AnyObject]!, percentComplete:Double) -> Void)!){
        let store = KCSLinkedAppdataStore.storeWithOptions([
            KCSStoreKeyCollectionName : "Events",
            KCSStoreKeyCollectionTemplateClass : Event.self
            ])
        store.queryWithQuery(query, withCompletionBlock: {
        (objects:[AnyObject]!, error:NSError!) -> Void in
            if (error == nil){
                var temp:[FetchedEvent] = []
                for object in objects {
                    temp.append(FetchedEvent(fromEvent: object as! Event, tab: tab))
                }
                completionBlock(events: temp, error: nil)
            }else{
                completionBlock(events: nil, error: error)
            }
        }, withProgressBlock: {
        (objects:[AnyObject]!, percentComplete:Double) -> Void in
//            if (objects != nil){
//                progressBlock(objects: objects, percentComplete: percentComplete)
//            }else{
//                progressBlock(objects: nil, percentComplete: percentComplete)
//            }
        })
    }
    
    class func countObjectsWithQuery(query:KCSQuery, tableName:String, handler: (number:UInt, error:NSError!) -> Void) -> KCSRequest{
        var store:KCSLinkedAppdataStore
        switch tableName{
        case "Events":
            store = KCSLinkedAppdataStore.storeWithOptions([
                KCSStoreKeyCollectionName : "Events",
                KCSStoreKeyCollectionTemplateClass : Event.self
                ])
        case "Users":
            store = KCSLinkedAppdataStore.storeWithOptions([
                KCSStoreKeyCollectionName : KCSUserCollectionName,
                KCSStoreKeyCollectionTemplateClass : KCSUser.self
                ])
        case "Activity":
            store = KCSLinkedAppdataStore.storeWithOptions([
                KCSStoreKeyCollectionName : "Activity",
                KCSStoreKeyCollectionTemplateClass : ActivityUnit.self
                ])
        default:
            store = KCSLinkedAppdataStore()
        }
        
        return store.countWithQuery(query, completion: {
            (number:UInt, error:NSError!) -> Void in
            if error == nil {
                handler(number: number, error: nil)
            } else {
                handler(number: number, error: error)
            }
        })
    }
}
