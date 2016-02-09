//
//  UsersManager.swift
//  Eventer
//
//  Created by Grisha on 24/01/2016.
//  Copyright © 2016 Grisha. All rights reserved.
//

import UIKit

class UsersManager: NSObject {

    class func loadMyProfileData(loadPicture:Bool, completionHandler:(user:FetchedUser!,error:NSError!) -> Void){
        
        KCSUser.activeUser().refreshFromServer {
            (objects:[AnyObject]!, error:NSError!) -> Void in
            if (error == nil){
                let fetchedUser = FetchedUser(forUser: KCSUser.activeUser(), username: nil)
                
                if !loadPicture {
                    
                    completionHandler(user: fetchedUser, error: nil)
                    
                } else {
                    if fetchedUser.pictureId != "" {
                        FileDownloadManager.downloadImage(fetchedUser.pictureId, completionBlock: {
                            (images:[UIImage]!, error:NSError!) -> Void in
                            if error == nil {
                                if images.count > 0 {
                                    fetchedUser.pictureProgress = 1
                                    fetchedUser.picture = images[0]
                                    completionHandler(user: fetchedUser, error: nil)
                                }
                            } else {
                                completionHandler(user: fetchedUser, error: error)
                            }
                        }, progressBlock: nil)

                    } else {
                        completionHandler(user: fetchedUser, error: nil)
                    }
                }
                
            }else{
                completionHandler(user: nil, error: error)
            }
        }
    }
    class func uploadMyProfileData(dictionary:NSDictionary, pictureToUpload:UIImage!,completionHandler:(error:NSError!) -> Void){
        let user = KCSUser.activeUser()
        user.givenName = dictionary["fullname"] as! String
        user.setValue(dictionary["bio"], forAttribute: "bio")
        
        // first try to update picture
        if pictureToUpload != nil {
            // upload picture
            let options:NSMutableDictionary = NSMutableDictionary()
            
            if user.getValueForAttribute("pictureId") != nil {
                if (user.getValueForAttribute("pictureId") as! String) != "" {
                    options[KCSFileId] = user.getValueForAttribute("pictureId")!
                }
            }
            FileDownloadManager.uploadImage(pictureToUpload, options: options, completionBlock: {
                (error:NSError!, fileId:String!) -> Void in
                if error == nil {
                    
                    user.setValue(fileId, forAttribute: "pictureId")
                    // Picture Uploaded, now update profile and link picture id
                    user.saveWithCompletionBlock { (objects:[AnyObject]!, error:NSError!) -> Void in
                        if error == nil {
                            completionHandler(error: nil)
                        } else {
                            completionHandler(error: error)
                        }
                    }

                } else {
                    completionHandler(error: error)
                    print("Couldn't upload picture\n \(error.description)")
                }
            })
        } else {
            
            // delete if needed
            if dictionary["idOfPictureToRemove"] != nil {
                FileDownloadManager.deleteImage(dictionary["idOfPictureToRemove"] as! String, completionBlock: {
                    (error:NSError!) -> Void in
                    if error == nil {
                        
                        user.removeValueForAttribute("pictureId")
                        // Picture Deleted, now update profile and link picture id
                        user.saveWithCompletionBlock { (objects:[AnyObject]!, error:NSError!) -> Void in
                            if error == nil {
                                completionHandler(error: nil)
                            } else {
                                completionHandler(error: error)
                            }
                        }
                        
                    } else {
                        completionHandler(error: error)
                        print("Couldn't delete picture\n \(error.description)")
                    }
                })
            } else {
                user.saveWithCompletionBlock { (objects:[AnyObject]!, error:NSError!) -> Void in
                    if error == nil {
                        completionHandler(error: nil)
                    } else {
                        completionHandler(error: error)
                    }
                }
            }
        }

        
        
    }

}
