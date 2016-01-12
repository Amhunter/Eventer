//
//  MoreManager.swift
//  Eventer
//
//  Created by Grisha on 23/07/2015.
//  Copyright (c) 2015 Grisha. All rights reserved.
//

import UIKit
extension UIView {
    var parentViewController: UIViewController? {
        var parentResponder: UIResponder? = self
        while parentResponder != nil {
            parentResponder = parentResponder!.nextResponder()
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
        }
        return nil
    }
}

class MoreManager:NSObject,UIActionSheetDelegate {
    var handler:((String,NSError!) -> Void)! = nil
    var event:FetchedEvent! = nil
    var view:UIView!
    
    class func sharedManager() -> MoreManager {
        let moreManager = MoreManager()
        return moreManager
    }
    
    func showInView(view:UIView,event:FetchedEvent, row:Int, handler:(result:String, error:NSError!) -> Void){
        self.handler = handler
        self.event = event
        self.view = view
        var actionSheet:UIActionSheet = UIActionSheet(title: (event.name as String), delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil)
        
        if (event.authorId == GeneralDownloadManager.myUserId()){
            //actionSheet.addButtonWithTitle("Edit")
            actionSheet = UIActionSheet(title: (event.name as String), delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: "Delete")
            actionSheet.addButtonWithTitle("Edit")
        }else{
            actionSheet.addButtonWithTitle("Report")
        }
        actionSheet.tag = row
        actionSheet.showInView(self.view)
        
        
    }
    
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        print(buttonIndex)
        if (actionSheet.buttonTitleAtIndex(buttonIndex) == "Delete"){ // delete
            deleteEvent(actionSheet.tag,event: event, handler: self.handler)
        } else if actionSheet.buttonTitleAtIndex(buttonIndex) == "Edit" {
            editEvent(actionSheet.tag, event: event, handler: self.handler)
        }
    }
    
    func editEvent(atIndex:Int,event:FetchedEvent, handler: (result:String, error:NSError!) -> Void){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let currentVC = view.parentViewController!
        let editVC = storyboard.instantiateViewControllerWithIdentifier("EditEventView") as! EditEventViewController
        let editNC = UINavigationController(rootViewController: editVC)
        
        editVC.initializeEditController(event) {
            (updated:Bool, event:FetchedEvent!) -> Void in
            if updated {
                handler(result: "Updated", error: nil)
            } else {
                handler(result: "Cancelled", error: nil)
            }
            currentVC.dismissViewControllerAnimated(true, completion: nil)
        }
        currentVC.presentViewController(editNC, animated: true, completion: nil)
        
    }
    func deleteEvent(atIndex:Int,event:FetchedEvent, handler: (result:String, error:NSError!) -> Void) {
        let query = KCSQuery(onField: "event._id", withExactMatchForValue: event.entityID)
        // Delete all activity
        
        GeneralDownloadManager.deleteObjectWithId(query, tableName: "Activity", completionBlock: {
            (number:UInt!, error:NSError!) -> Void in
            if error == nil {
                print("deleted activity: \(number)")
                if (event.pictureId != "") {
                    print("deleting image")
                    // if activity deleted , let's delete image too
                    FileDownloadManager.deleteImage(event.pictureId as String, completionBlock: {
                        (error:NSError!) -> Void in
                        if error == nil {
                            print("image deleted")
                            // image deleted, now let's delete event itself
                            GeneralDownloadManager.deleteObjectWithId(event.entityID, tableName: "Events", completionBlock: {
                                (number:UInt!, error:NSError!) -> Void in
                                if error == nil{
                                    print("deleted event")
                                    handler(result: "Deleted", error: nil)
                                }
                                }, progressBlock: nil)
                        }
                    })
                } else {
                    GeneralDownloadManager.deleteObjectWithId(event.entityID, tableName: "Events", completionBlock: {
                        (number:UInt!, error:NSError!) -> Void in
                        if error == nil{
                            
                            handler(result: "Deleted", error: nil)
                        }
                        }, progressBlock: nil)
                }
            }
            }, progressBlock: nil)
        
    }
    
}
