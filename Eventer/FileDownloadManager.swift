//
//  FileDownloadManager.swift
//  Eventer
//
//  Created by Grisha on 03/08/2015.
//  Copyright (c) 2015 Grisha. All rights reserved.
//

import UIKit
enum FileDownloadOption{
    case fromUserPicture
    case toUserPicture
    case eventPicture
    //case eventCreatorPicture
}
class FileDownloadManager {
    
    class func downloadImage(idOrIds:AnyObject!,
        completionBlock: (images:[UIImage]!, error:NSError!) -> Void,
        progressBlock: ((objects:[AnyObject]!, percentComplete:Double) -> Void)!) -> KCSRequest{
            
            let request = KCSFileStore.downloadFile(idOrIds, options: [KCSFileOnlyIfNewer : true], completionBlock: {
                (objects:[AnyObject]!, error:NSError!) -> Void in
                if (error == nil){
                    var images:[UIImage] = []
                    if (objects.count > 0){
                        for (index,_) in objects.enumerate(){
                            let file = objects[0] as! KCSFile
                            let fileURL = file.localURL
                            //println(file.localURL)
                            images.insert(UIImage(), atIndex: index)
                            if (UIImage(contentsOfFile: fileURL.path!) != nil){
                                images.insert(UIImage(contentsOfFile: fileURL.path!)!, atIndex: index)
                            }
                        }
                    }
                    completionBlock(images: images, error: nil)
                }else{
                    completionBlock(images: nil, error: error)
                }
                },progressBlock: {
                    (objects:[AnyObject]!, percentComplete:Double) -> Void in
                    if progressBlock != nil {
                        progressBlock(objects: objects, percentComplete: percentComplete)
                    }
            })
            return request
    }
    class func uploadImage(image:UIImage, options:NSMutableDictionary!, completionBlock: (error: NSError!,fileId:String!) -> Void){
        let data = UIImageJPEGRepresentation(image, 1)
        
        //making photo findable by all users
        let metadata:KCSMetadata = KCSMetadata()
        metadata.setGloballyReadable(true)
        
        var opts = NSMutableDictionary()
        
        if options != nil {
            opts = options
        }
        
        opts[KCSFilePublic] = true
        opts[KCSFileACL] = metadata
        
        KCSFileStore.uploadData(data, options: opts as [NSObject : AnyObject], completionBlock: {
            (file:KCSFile!, error:NSError!) -> Void in
            if (error == nil){
                let id = file.fileId
                completionBlock(error: nil, fileId: id)
            }else{
                completionBlock(error: error, fileId: nil)
            }
        }, progressBlock: nil)
    }
    
    class func modifyImage(image:UIImage,existingFileId:NSString, completionBlock: (error: NSError!,fileId:String!) -> Void){
        let data = UIImageJPEGRepresentation(image, 1)
        
        //making photo findable by all users
        let metadata:KCSMetadata = KCSMetadata()
        metadata.setGloballyReadable(true)
        
        var options = [
            KCSFilePublic : true,
            KCSFileACL : metadata
        ]
        if existingFileId != "" {
            options[KCSFileId] = existingFileId
        }
        
        KCSFileStore.uploadData(data, options:options, completionBlock: {
            (file:KCSFile!, error:NSError!) -> Void in
            if (error == nil){
                let id = file.fileId
                completionBlock(error: nil, fileId: id)
            }else{
                completionBlock(error: error, fileId: nil)
            }
            }, progressBlock: nil)
    }
    
    class func deleteImage(fileId:String, completionBlock: (error: NSError!) -> Void){
        
        KCSFileStore.deleteFile(fileId) { (number:UInt, error:NSError!) -> Void in
            if error == nil {
                completionBlock(error: nil)
            } else {
                completionBlock(error: error)
            }
        }
    }
    
    
}
