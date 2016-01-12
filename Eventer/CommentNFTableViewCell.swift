//
//  CommentNFTableViewCell.swift
//  Eventer
//
//  Created by Grisha on 03/03/2015.
//  Copyright (c) 2015 Grisha. All rights reserved.
//

import UIKit

class CommentNFTableViewCell: UITableViewCell,TTTAttributedLabelDelegate {
    var ScreenWidth = UIScreen.mainScreen().bounds.width
    var didSetupConstraints = false

    
    var profilePicture:EImageView = EImageView()
    var commentLabel:TTTAttributedLabel = TTTAttributedLabel(frame: CGRectZero)

    var eventPicture:EImageView = EImageView()
    var dateLabel:UILabel = UILabel()
    var username:NSString!
    var textFont = UIFont(name: "Lato-Regular", size: 14)

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.frame.size.width = UIScreen.mainScreen().bounds.width

        self.contentView.addSubview(profilePicture)
        self.contentView.addSubview(commentLabel)
        self.contentView.addSubview(dateLabel)
        self.contentView.addSubview(eventPicture)
        
        profilePicture.translatesAutoresizingMaskIntoConstraints = false
        commentLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        eventPicture.translatesAutoresizingMaskIntoConstraints = false
        
        commentLabel.numberOfLines = 0
        commentLabel.lineBreakMode = NSLineBreakMode.ByWordWrapping
        commentLabel.preferredMaxLayoutWidth = 220
        
        dateLabel.numberOfLines = 2
        dateLabel.backgroundColor = ColorFromCode.standardBlueColor()
        dateLabel.textColor = UIColor.whiteColor()
        dateLabel.font = UIFont(name: "Helvetica", size: 14)
        dateLabel.layer.masksToBounds = true
        dateLabel.layer.cornerRadius = 3
        dateLabel.textAlignment = NSTextAlignment.Center
        
        eventPicture.layer.masksToBounds = true //without it its not gonna work
        eventPicture.layer.cornerRadius = 3
        
        profilePicture.layer.masksToBounds = true //without it its not gonna work
        profilePicture.layer.cornerRadius = 20
        profilePicture.userInteractionEnabled = true
        eventPicture.userInteractionEnabled = true
        dateLabel.userInteractionEnabled = true
        
        let attrs = [NSForegroundColorAttributeName: UIColor.blackColor()]
        self.commentLabel.activeLinkAttributes = attrs
        make_Layout()
        
    }
    
    func make_Layout(){
        
        let border:UIView = UIView()
        border.translatesAutoresizingMaskIntoConstraints = false
        border.backgroundColor = ColorFromCode.colorWithHexString("#DAE4E7")
        self.contentView.addSubview(border)
        let views = [
            "profilePicture": profilePicture,
            "commentLabel": commentLabel,
            "dateLabel": dateLabel,
            "eventPicture": eventPicture,
            "brdr": border
        ]

        let H_Constraint0 = NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[profilePicture(40)]-10-[commentLabel]-10-[eventPicture(49)]-8-|", options: [], metrics: nil, views: views)
        let H_Constraint1 = NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[profilePicture(40)]-10-[commentLabel]-10-[dateLabel(49)]-8-|", options: [], metrics: nil, views: views)
        let H_Constraint2 = NSLayoutConstraint.constraintsWithVisualFormat("H:|[brdr]|", options: [], metrics: nil, views: views)
        
        
        let V_Constraint0 = NSLayoutConstraint.constraintsWithVisualFormat("V:|-14-[profilePicture(40)]->=14@999-[brdr(0.5)]|", options: [], metrics: nil, views: views)
        let V_Constraint1 = NSLayoutConstraint.constraintsWithVisualFormat("V:|-5-[commentLabel(>=0)]-5@999-[brdr(0.5)]|", options: [], metrics: nil, views: views)
        let V_Constraint2 = NSLayoutConstraint.constraintsWithVisualFormat("V:|-10-[dateLabel(49)]->=10@999-[brdr(0.5)]|", options: [], metrics: nil, views: views)
        let V_Constraint3 = NSLayoutConstraint.constraintsWithVisualFormat("V:|-10-[eventPicture(49)]->=10@999-[brdr(0.5)]|", options: [], metrics: nil, views: views)

        
        
        
        // height == width for picture
        
        
        self.contentView.addConstraints(H_Constraint0)
        self.contentView.addConstraints(H_Constraint1)
        self.contentView.addConstraints(H_Constraint2)
        
        self.contentView.addConstraints(V_Constraint0)
        self.contentView.addConstraints(V_Constraint1)
        self.contentView.addConstraints(V_Constraint2)
        self.contentView.addConstraints(V_Constraint3)
        self.contentView.setNeedsLayout()
        self.contentView.layoutIfNeeded()
        self.commentLabel.preferredMaxLayoutWidth = self.commentLabel.frame.size.width;
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
            self.commentLabel.addLinkToURL(url, withRange: linkRange)
            text.addAttribute(NSForegroundColorAttributeName, value: withColor, range: linkRange)
        }
        self.commentLabel.attributedText = text

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
            self.commentLabel.addLinkToURL(url, withRange: linkRange)
            text.addAttribute(NSForegroundColorAttributeName, value: withColor, range: linkRange)
        }
        self.commentLabel.attributedText = text
        
    }
    
    func UpdatePictures(unit:FetchedActivityUnit,row:Int){
        
        if (row == self.tag){
            if (unit.fromUserProfilePictureID == ""){//no picture
                self.profilePicture.image = UIImage(named: "defaultPicture.png")!
            }else{
                if (unit.fromUserPictureProgress < 1){ //picture is loading
                    self.profilePicture.backgroundColor = UIColor.groupTableViewBackgroundColor()
                    
                }else{ //picture is loaded
                    self.profilePicture.image = unit.fromUserProfilePicture
                }
            }
            if (unit.event.pictureId == ""){//no picture
                self.eventPicture.hidden = true
            }else{
                self.dateLabel.hidden = true
                if (unit.event.pictureProgress < 1){ //picture is loading
                    self.eventPicture.backgroundColor = UIColor.groupTableViewBackgroundColor()
                    
                }else{ //picture is loaded
                    self.eventPicture.image = unit.event.picture
                }
            }
        }
    }
    override func prepareForReuse() {
        self.profilePicture.backgroundColor = UIColor.groupTableViewBackgroundColor()
        self.profilePicture.image = UIImage()
        self.eventPicture.image = UIImage()
        self.eventPicture.hidden = false
        self.dateLabel.hidden = false
    }


    //    - (void)layoutSubviews
//    {
//    [super layoutSubviews];
//    [self.contentView layoutIfNeeded];
//    self.myLabel.preferredMaxLayoutWidth = self.myLabel.frame.size.width;
//    }
}
