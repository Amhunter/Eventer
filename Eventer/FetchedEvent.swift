//
//  FetchedEvent.swift
//  Eventer
//
//  Created by Grisha on 13/05/2015.
//  Copyright (c) 2015 Grisha. All rights reserved.
//

import UIKit

class FetchedEvent:NSObject{ //used just for comfortable data storage and display
    
    
    var eventOriginal:Event! // the originator
    var author: KCSUser!
    var entityID:NSString = NSString()
    var profilePictureID:NSString = NSString()
    var profilePicture:UIImage = UIImage()
    var profilePictureProgress:Double = -99 // -99 means didnt start downloading yet.
    
    var mainDataDownloaded:Bool = false // name picture id , author name blah blah
    var additionalDataDownloaded:Bool = false // no of shares likes etc
    var personalDataDownloaded:Bool = false // no of shares likes etc
    var authorDataDownloaded:Bool = false
    var name: NSString = NSString()
    var details: NSString = NSString()
    var shortDescription = NSString() // details but limited to 250 words to decreate scroll amount
    var picture: UIImage = UIImage()
    var pictureId: NSString = NSString()
    var pictureProgress:Double = -99
    var date: NSDate = NSDate()
    var location: NSString = NSString()
    var authorId:NSString = NSString()
    var createdAtText:NSString = NSString()
    var eventDateText:NSAttributedString = NSAttributedString()
    var smallEventDateText:NSAttributedString = NSAttributedString()
    var timeString:NSString = NSString()
    var locationString:NSAttributedString = NSAttributedString()
    // Additional Data
    
    var goManager:GoManager = GoManager()
    var likeManager:LikeManager = LikeManager()
    var shareManager:ShareManager = ShareManager()
    var moreManager:MoreManager = MoreManager()
    var numberOfComments:Int = 0
    
    var sharedID:NSString = NSString()
    var creatorID:NSString = NSString()
    var createdAt:NSDate = NSDate()
    var modifiedAt:NSDate = NSDate()
    var metadata: KCSMetadata? //Kinvey metadata, optional
    init(fromEvent event:Event, tab:forTab){
        super.init()
        self.loadDataFromOriginalDownloadedFile(event, forActivityUnit: false)
        
        //date
        createdAtText = DateToStringConverter.getCreatedAtString(metadata!.creationTime(), tab: tab)
        eventDateText = DateToStringConverter.eventDateToText(date, tab: tab)
        smallEventDateText = DateToStringConverter.eventDateToText(date, tab: forTab.Explore)
        let dateFormatter:NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        self.timeString = dateFormatter.stringFromDate(self.date)
        self.modifiedAt = metadata!.lastModifiedTime()
        self.creatorID = metadata!.creatorId()
        
    }
    
    init(forActivity event:Event){
        super.init()
        self.loadDataFromOriginalDownloadedFile(event, forActivityUnit: true)
        
        let dateFormatter:NSDateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        self.timeString = dateFormatter.stringFromDate(date)
        self.modifiedAt = metadata!.lastModifiedTime()
        self.creatorID = metadata!.creatorId()
        
        createdAtText = DateToStringConverter.getCreatedAtString(createdAt, tab: forTab.Home)
        smallEventDateText = DateToStringConverter.eventDateToText(date, tab: forTab.Explore)
        
        
    }
    func addAuthor(author:KCSUser){
        self.author = author
        if (author.getValueForAttribute("pictureId") != nil){
            self.profilePictureID = author.getValueForAttribute("pictureId") as! NSString!
        }else{
            self.profilePictureID = ""
        }
    }
    func updateEventDataFromEvent(event:FetchedEvent){
        loadDataFromOriginalDownloadedFile(event.eventOriginal, forActivityUnit: false)
        self.pictureId = event.pictureId
        self.pictureProgress = event.pictureProgress
        self.picture = event.picture
    }
    
    func loadDataFromOriginalDownloadedFile(event:Event, forActivityUnit:Bool){
        self.eventOriginal = event
        self.entityID = event.entityId!
        if (event.authorId != nil){
            self.authorId = event.authorId!
        }
        if !forActivityUnit {
            self.addAuthor(event.author!)
        }
        
        self.name = event.name!
        
        if (event.details != nil){
            self.details = event.details!
            self.shortDescription = Utility.cropString(event.details!, maxLetters: 200)
        }
        
        if (event.pictureId != nil ){
            self.pictureId = event.pictureId!
        }else{
            self.pictureId = ""
        }
        
        if (event.date != nil){
            self.date = event.date!
            
        }
        
        if (event.createdAt != nil){
            self.createdAt = event.createdAt!
            
        }
        
        if (event.location != nil){
            self.location = event.location!
            
        }
        
        self.metadata = event.metadata!
    }
    
}
