//
//  GeneralUploadManager.swift
//  Eventer
//
//  Created by Grisha on 03/02/2016.
//  Copyright © 2016 Grisha. All rights reserved.
//

import UIKit

class GeneralUploadManager {
    
    class func uploadObject(objectOrObjects:AnyObject, tableName:String,
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
            store.saveObject(objectOrObjects, withCompletionBlock: {
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
    



}
