//
//  eventHeaderView.swift
//  Eventer
//
//  Created by Grisha on 23/07/2015.
//  Copyright (c) 2015 Grisha. All rights reserved.
//

import UIKit

class eventHeaderView: UITableViewHeaderFooterView {
    var profilePictureImageView:UIImageView = UIImageView()
    var profileUsernameLabel:UILabel = UILabel()
    var createdAtLabel:UILabel = UILabel()
    var graySeparator:UIView = UIView()
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
    }

    init(event withEvent:FetchedEvent){
        self.init()
        self.profileUsernameLabel.text = withEvent.author!.username
        self.profileUsernameLabel.font = UIFont(name: "Lato-Medium", size: 15)
        self.createdAtLabel.text = withEvent.createdAtText as String
        self.profilePictureImageView.backgroundColor = UIColor.lightGrayColor()
        // Profile View
        self.contentView.backgroundColor = UIColor.whiteColor()
        profilePictureImageView.layer.cornerRadius = 17.5
        profilePictureImageView.layer.masksToBounds = true
        profilePictureImageView.layer.rasterizationScale = UIScreen.mainScreen().scale

        createdAtLabel.textColor = UIColor.lightGrayColor()
        createdAtLabel.font = UIFont(name: "Lato-Regular", size: 14)
        createdAtLabel.textAlignment = NSTextAlignment.Right
        graySeparator.backgroundColor = UIColor.groupTableViewBackgroundColor()
        
        // Setting Profile View
        self.contentView.addSubview(profilePictureImageView)
        self.contentView.addSubview(profileUsernameLabel)
        self.contentView.addSubview(createdAtLabel)
        self.contentView.addSubview(graySeparator)
        self.profilePictureImageView.translatesAutoresizingMaskIntoConstraints = false
        self.profileUsernameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.createdAtLabel.translatesAutoresizingMaskIntoConstraints = false
        self.graySeparator.translatesAutoresizingMaskIntoConstraints = false

        let views = [
            "profilePicture": profilePictureImageView,
            "profileName" : profileUsernameLabel,
            "createdAt" : createdAtLabel,
            "graySep": graySeparator
        ]
        
        let SH_Constraints0 = NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[profilePicture(35)]-10-[profileName]-10-[createdAt]-15@999-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views)
        let SV_Constraints0 = NSLayoutConstraint.constraintsWithVisualFormat("V:|-10-[profilePicture(35@999)]->=10@700-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views)
        let SV_Constraints1 = NSLayoutConstraint.constraintsWithVisualFormat("V:|-10-[profileName(35@999)]->=10@700-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views)
        let SV_Constraints2 = NSLayoutConstraint.constraintsWithVisualFormat("V:|-10-[createdAt(35@999)]->=10@700-|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views)
        let SV_Constraints3 = NSLayoutConstraint.constraintsWithVisualFormat("V:|->=0@999-[graySep(1)]|", options: NSLayoutFormatOptions(rawValue: 0), metrics: nil, views: views)

        self.contentView.addConstraints(SH_Constraints0)
        self.contentView.addConstraints(SV_Constraints0)
        self.contentView.addConstraints(SV_Constraints1)
        self.contentView.addConstraints(SV_Constraints2)
        self.contentView.addConstraints(SV_Constraints3)

        self.setNeedsLayout()
        self.layoutIfNeeded()
        updateProfilePicture(withEvent.profilePictureID as String, progress: withEvent.profilePictureProgress, image: withEvent.profilePicture)
        
    }
//    func DownloadProfilePicture(inout withDataFromEvent:FetchedEvent, row:Int){
//        if (withDataFromEvent.profilePictureProgress == -99){
//            withDataFromEvent.profilePictureProgress = 0
//            KCSFileStore.downloadFile(withDataFromEvent.profilePictureID, options: [KCSFileOnlyIfNewer : true], completionBlock: {
//                (objects:[AnyObject]!, error:NSError!) -> Void in
//                if (error == nil){
//                    if (objects.count > 0){
//                        let file = objects[0] as! KCSFile
//                        let fileURL = file.localURL
//                        withDataFromEvent.profilePicture = UIImage(contentsOfFile: fileURL.path!)!
//                        withDataFromEvent.profilePictureProgress = 1
//                    }else{
//                        withDataFromEvent.profilePictureProgress = -1
//                        println("Error: object not found")
//                    }
//                    
//                }else{
//                    println("Error: " + error.description)
//                }
//                // Reload Picture
//                
//                self.UpdateProfilePicture(withDataFromEvent, row: row)
//                
//                }, progressBlock: { (objects:[AnyObject]!, percentComplete:Double) -> Void in
//                    withDataFromEvent.profilePictureProgress = percentComplete
//                    self.UpdateProfilePicture(withDataFromEvent, row: row)
//                    
//            })
//        }
    func updateProfilePicture(id:String,progress:Double,image:UIImage){
        
        if (id == ""){//no picture
            //self.ProfilePicture.image = UIImage(named: "defaultPicture.png")!
        }else{
            if (progress < 1){ //picture is loading
                //self.ProfilePicture.image = UIImage(named: "defaultPicture.png")!
                
            }else{ //picture is loaded
                self.profilePictureImageView.image = image
            }
        }
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
 

}
