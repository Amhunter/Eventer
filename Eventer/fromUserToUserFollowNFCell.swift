//
//  fromUserToUserFollowNFCell.swift
//  Eventer
//
//  Created by Grisha on 05/08/2015.
//  Copyright (c) 2015 Grisha. All rights reserved.
//

import UIKit

class fromUserToUserFollowNFCell: UITableViewCell {
    
    
    var fromUserImageView:EImageView = EImageView()
    var toUserImageView:EImageView = EImageView()
    var followLabel:TTTAttributedLabel = TTTAttributedLabel(frame: CGRectZero)
    
    var username:NSString!
    var textFont = UIFont(name: "Lato-Regular", size: 14)
    
    //var followLabel:UILabel = UILabel(frame: CGRectMake(50, 5, 220, 30))
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.frame.size.width = UIScreen.mainScreen().bounds.width
        
        self.contentView.addSubview(fromUserImageView)
        self.contentView.addSubview(followLabel)
        self.contentView.addSubview(toUserImageView)
        
        fromUserImageView.translatesAutoresizingMaskIntoConstraints = false
        followLabel.translatesAutoresizingMaskIntoConstraints = false
        toUserImageView.translatesAutoresizingMaskIntoConstraints = false
        
        followLabel.numberOfLines = 0
        followLabel.font = UIFont(name: "Helvetica", size: 14)
        
        fromUserImageView.userInteractionEnabled = true
        fromUserImageView.layer.masksToBounds = true //without it its not gonna work
        fromUserImageView.layer.cornerRadius = 20
        fromUserImageView.layer.shouldRasterize = true
        
        toUserImageView.userInteractionEnabled = true
        toUserImageView.layer.masksToBounds = true //without it its not gonna work
        toUserImageView.layer.cornerRadius = 20
        toUserImageView.layer.shouldRasterize = true

        
        let border:UIView = UIView()
        border.translatesAutoresizingMaskIntoConstraints = false
        border.backgroundColor = ColorFromCode.colorWithHexString("#DAE4E7")
        self.contentView.addSubview(border)
        
        let views = [
            "fromUserImageView": fromUserImageView,
            "followLabel": followLabel,
            "toUserImageView": toUserImageView,
            "brdr": border
        ]
//        var metrics = [
//        ]
        
        let H_Constraint0 = NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[fromUserImageView(40)]-10-[followLabel(>=0)]-13.5-[toUserImageView(40)]-13.5@999-|", options: [], metrics: nil, views: views)
        let H_Constraint1 = NSLayoutConstraint.constraintsWithVisualFormat("H:|[brdr]|", options: [], metrics: nil, views: views)
        
        
        let V_Constraint0 = NSLayoutConstraint.constraintsWithVisualFormat("V:|-14-[fromUserImageView(40)]->=14@999-[brdr(0.5)]|", options: [], metrics: nil, views: views)
        let V_Constraint1 = NSLayoutConstraint.constraintsWithVisualFormat("V:|-5-[followLabel(>=0)]-5@999-[brdr(0.5)]|", options: [], metrics: nil, views: views)
        let V_Constraint2 = NSLayoutConstraint.constraintsWithVisualFormat("V:|-14-[toUserImageView(40)]->=14@999-[brdr(0.5)]|", options: [], metrics: nil, views: views)
        
        self.contentView.addConstraints(H_Constraint0)
        self.contentView.addConstraints(H_Constraint1)
        
        self.contentView.addConstraints(V_Constraint0)
        self.contentView.addConstraints(V_Constraint1)
        self.contentView.addConstraints(V_Constraint2)
        
        let attrs = [NSForegroundColorAttributeName: UIColor.blackColor()]
        self.followLabel.activeLinkAttributes = attrs
        
        self.contentView.setNeedsLayout()
        self.contentView.layoutIfNeeded()
        self.followLabel.preferredMaxLayoutWidth = self.followLabel.frame.size.width;
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
        
    }
    
    
    func highlightMentionsInString(text:NSMutableAttributedString, withColor:UIColor){
        let mentionExpression:NSRegularExpression = try! NSRegularExpression(pattern: "(?:^|\\s)(@\\w+)" , options: [])
        
        let matches = mentionExpression.matchesInString(text.string, options: NSMatchingOptions(), range: NSRange(location: 0,length: text.length))
        for match:NSTextCheckingResult in matches {
            let matchRange:NSRange = match.rangeAtIndex(1)
            let mentionString:NSString = (text.string as NSString).substringWithRange(matchRange)
            let linkRange:NSRange = (text.string as NSString).rangeOfString(mentionString as String)
            let username:NSString = mentionString.substringFromIndex(1)
            let url:NSURL = NSURL(scheme: "mention", host: username as String, path: "/")!
            self.followLabel.addLinkToURL(url, withRange: linkRange)
            text.addAttribute(NSForegroundColorAttributeName, value: withColor, range: linkRange)
        }
        self.followLabel.attributedText = text
        
    }
    
    func highlightHashtagsInString(text:NSMutableAttributedString, withColor:UIColor){
        let mentionExpression:NSRegularExpression = try! NSRegularExpression(pattern: "(?:^|\\s)(#\\w+)" , options: [])
        
        let matches = mentionExpression.matchesInString(text.string, options: NSMatchingOptions(), range: NSRange(location: 0,length: text.length))
        for match:NSTextCheckingResult in matches {
            let matchRange:NSRange = match.rangeAtIndex(1)
            let mentionString:NSString = (text.string as NSString).substringWithRange(matchRange)
            let linkRange:NSRange = (text.string as NSString).rangeOfString(mentionString as String)
            let tag:NSString = mentionString.substringFromIndex(1)
            let url:NSURL = NSURL(scheme: "hashtag", host: tag as String, path: "/")!
            self.followLabel.addLinkToURL(url, withRange: linkRange)
            text.addAttribute(NSForegroundColorAttributeName, value: withColor, range: linkRange)
        }
        self.followLabel.attributedText = text
        
    }
    
    func UpdatePictures(unit:FetchedActivityUnit,row:Int){
        
        if (row == self.tag){
            if (unit.fromUserProfilePictureID == ""){//no picture
                self.fromUserImageView.image = UIImage(named: "defaultPicture.png")!
            }else{
                if (unit.fromUserPictureProgress < 1){ //picture is loading
                    self.fromUserImageView.backgroundColor = UIColor.groupTableViewBackgroundColor()
                    
                }else{ //picture is loaded
                    self.fromUserImageView.image = unit.fromUserProfilePicture
                }
            }
            if (unit.toUserProfilePictureID == ""){//no picture
                self.toUserImageView.image = UIImage(named: "defaultPicture.png")!
            }else{
                if (unit.toUserPictureProgress < 1){ //picture is loading
                    self.toUserImageView.backgroundColor = UIColor.groupTableViewBackgroundColor()
                    
                }else{ //picture is loaded
                    self.toUserImageView.image = unit.toUserProfilePicture
                }
            }
        }
    }
    override func prepareForReuse() {
        self.fromUserImageView.backgroundColor = UIColor.groupTableViewBackgroundColor()
        self.fromUserImageView.image = UIImage()
        self.toUserImageView.backgroundColor = UIColor.groupTableViewBackgroundColor()
        self.toUserImageView.image = UIImage()
    }
    

}
