//
//  ExploreCollectionViewCell.swift
//  Eventer
//
//  Created by Grisha on 22/06/2015.
//  Copyright (c) 2015 Grisha. All rights reserved.
//

import UIKit

class ExploreCollectionViewCell: UICollectionViewCell {
    var row:Int = Int()
    var imageView:UIImageView = UIImageView()
    var eventNameLabel:UILabel = UILabel()
    var eventDateLabel:UILabel = UILabel()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(imageView)
        self.addSubview(eventNameLabel)
        
        self.eventNameLabel.numberOfLines = 0
        self.eventNameLabel.font = UIFont(name: "Helvetica", size: 13)
        self.imageView.backgroundColor = UIColor.groupTableViewBackgroundColor()
        self.imageView.frame = CGRectMake(0, 0, self.frame.width, self.frame.width)
        self.eventNameLabel.frame = CGRectMake(7, self.frame.width+5, self.frame.width-7, (self.frame.width/2)-5)
        self.imageView.addSubview(eventDateLabel)
        
        self.eventDateLabel.numberOfLines = 2
        self.eventDateLabel.textAlignment = NSTextAlignment.Center
        self.eventDateLabel.textColor = UIColor.whiteColor()
        self.eventDateLabel.font = UIFont(name: "Helvetica", size: 13)
        self.eventDateLabel.backgroundColor = ColorFromCode.colorWithHexString("#02A8F3")
        let dateWidth:CGFloat = 39
        self.eventDateLabel.frame = CGRectMake(0, self.imageView.frame.height-dateWidth, dateWidth, dateWidth)

    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // Download Event Picture passed by reference
//    
//    func DownloadEventPicture(inout withDataFromEvent:FetchedEvent, row:Int){
//        if (withDataFromEvent.pictureProgress == -99){
//            withDataFromEvent.pictureProgress = 0
//            KCSFileStore.downloadFile(withDataFromEvent.pictureID, options: [KCSFileOnlyIfNewer : true], completionBlock: {
//                (objects:[AnyObject]!, error:NSError!) -> Void in
//                if (error == nil){
//                    if (objects.count > 0){
//                        let file = objects[0] as! KCSFile
//                        let fileURL = file.localURL
//                        withDataFromEvent.picture = UIImage(contentsOfFile: fileURL.path!)!
//                        withDataFromEvent.pictureProgress = 100
//                    }else{
//                        withDataFromEvent.pictureProgress = -1
//                        println("Error: object not found")
//                    }
//                    
//                }else{
//                    println("Error: " + error.description)
//                }
//                // Reload Picture
//                self.UpdateEventPicture(withDataFromEvent, row: row)
//                
//                }, progressBlock: { (objects:[AnyObject]!, percentComplete:Double) -> Void in
//                    withDataFromEvent.pictureProgress = percentComplete
//                    self.UpdateEventPicture(withDataFromEvent, row: row)
//                    
//            })
//        }
//    }
    func UpdateEventPicture(withDataFromEvent:FetchedEvent, row:Int){
        if (row == self.tag){
            if (withDataFromEvent.pictureId == ""){//no picture
                self.imageView.backgroundColor = ColorFromCode.randomBlueColorFromNumber(row)
                self.eventDateLabel.backgroundColor = ColorFromCode.randomBlueColorFromNumber(row)
                
            }else{
                self.eventDateLabel.backgroundColor = ColorFromCode.randomBlueColorFromNumber(row)
                if (withDataFromEvent.pictureProgress < 1){ //picture is loading

                }else{ //picture is loaded
                    self.imageView.image = withDataFromEvent.picture
                }
            }

        }
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        //        self.EventDescription.text = ""
        //self.eventNameLabel.text = ""
        self.imageView.backgroundColor = UIColor.groupTableViewBackgroundColor()
        self.imageView.image = UIImage()
    }
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.alpha = 0.65
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.alpha = 1
    }
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        self.alpha = 1
        
    }

}
