//
//  ProfileNoPictureTableViewCell.swift
//  Eventer
//
//  Created by Grisha on 18/07/2015.
//  Copyright (c) 2015 Grisha. All rights reserved.
//

import UIKit

class ProfileNoPictureTableViewCell: UITableViewCell {

    var ProfileView: UIView = UIView()
    var AuthorName: UILabel = UILabel()
    var ProfilePicture: UIImageView = UIImageView()
    
    var EventName: UILabel = UILabel()
    var EventDate: UILabel = UILabel()
    var EventDescription: TTTAttributedLabel = TTTAttributedLabel(frame: CGRectZero)
    var timeLocationLabel: TTTAttributedLabel = TTTAttributedLabel(frame: CGRectZero)
    var createdAtLabel:UILabel = UILabel()
    var EventView: UIView = UIView()
    
    
    var numberOfGoing:Int!
    var numberOfLikes:Int!
    var numberOfComments:Int!
    var numberOfShares:Int!
    
    var goingbtn:UIButton = UIButton()
    var likesbtn:UIButton = UIButton()
    var commentsbtn:UIButton = UIButton()
    var sharesbtn:UIButton = UIButton()
    
    var goingimg:UIImageView = UIImageView(image: UIImage(named: "small-going.png"))
    var likesimg:UIImageView = UIImageView(image: UIImage(named: "small-like.png"))
    var commentsimg:UIImageView = UIImageView(image: UIImage(named: "small-comment.png"))
    var sharesimg:UIImageView = UIImageView(image: UIImage(named: "small-share.png"))
    
    var numberOfGoingLabel:UILabel = UILabel()
    var numberOfLikesLabel:UILabel = UILabel()
    var numberOfCommentsLabel:UILabel = UILabel()
    var numberOfSharesLabel:UILabel = UILabel()
    
    
    var GoButton:HomeResponseButton = HomeResponseButton()
    var LikeButton:HomeLikeButton = HomeLikeButton()
    var ShareButton:HomeShareButton = HomeShareButton()
    var MoreButton:HomeMoreButton = HomeMoreButton()
    
    
    var didSetupConstraints = false
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        Set_Subviews()
        Make_Autolayout()
        
        
    }
    func Set_Subviews(){
//        var height = self.frame.height
//        var width = self.frame.width
        
        numberOfGoingLabel.font = UIFont(name: "Lato-Regular", size: 12)
        numberOfLikesLabel.font = UIFont(name: "Lato-Regular", size: 12)
        numberOfCommentsLabel.font = UIFont(name: "Lato-Regular", size: 12)
        numberOfSharesLabel.font = UIFont(name: "Lato-Regular", size: 12)
        
        numberOfGoingLabel.textColor = UIColor.lightGrayColor()
        numberOfLikesLabel.textColor = UIColor.lightGrayColor()
        numberOfCommentsLabel.textColor = UIColor.lightGrayColor()
        numberOfSharesLabel.textColor = UIColor.lightGrayColor()
        
        numberOfGoingLabel.textAlignment = NSTextAlignment.Center
        numberOfLikesLabel.textAlignment = NSTextAlignment.Center
        numberOfCommentsLabel.textAlignment = NSTextAlignment.Center
        numberOfSharesLabel.textAlignment = NSTextAlignment.Center
        
        
        
        // Event View
        EventView.backgroundColor = ColorFromCode.colorWithHexString("#02A8F3")
        EventName.backgroundColor = UIColor.clearColor()
        EventName.textColor = UIColor.whiteColor()
        EventName.font = UIFont(name: "Lato-Semibold", size: 21)
        EventName.textAlignment = NSTextAlignment.Center
        EventName.numberOfLines = 0
        EventDate.textColor = UIColor.whiteColor()
        EventDate.numberOfLines = 0
        EventDate.textAlignment = NSTextAlignment.Center
        
        
        // Under Square View
        EventDescription.numberOfLines = 0
        EventDescription.textColor = UIColor.blackColor()
        EventDescription.font = UIFont(name: "Helvetica", size: 13)
        
        timeLocationLabel.textAlignment = NSTextAlignment.Center
        timeLocationLabel.numberOfLines = 3
        
        let attrs = [NSForegroundColorAttributeName: UIColor.blackColor()]
        timeLocationLabel.activeLinkAttributes = attrs
        EventDescription.activeLinkAttributes = attrs
        
        ProfileView.backgroundColor = UIColor.whiteColor()
        ProfilePicture.layer.cornerRadius = 17.5
        ProfilePicture.layer.masksToBounds = true
        AuthorName.font = UIFont(name: "Lato-Medium", size: 15)
        createdAtLabel.textColor = UIColor.lightGrayColor()
        createdAtLabel.font = UIFont(name: "Lato-Regular", size: 14)
        createdAtLabel.textAlignment = NSTextAlignment.Right

    }
    
    
    func Make_Autolayout(){
        self.ProfileView.translatesAutoresizingMaskIntoConstraints = false
        self.AuthorName.translatesAutoresizingMaskIntoConstraints = false
        self.ProfilePicture.translatesAutoresizingMaskIntoConstraints = false
        
        self.EventName.translatesAutoresizingMaskIntoConstraints = false
        self.EventDate.translatesAutoresizingMaskIntoConstraints = false
        self.EventDescription.translatesAutoresizingMaskIntoConstraints = false
        self.EventView.translatesAutoresizingMaskIntoConstraints = false
        self.timeLocationLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.GoButton.translatesAutoresizingMaskIntoConstraints = false
        self.LikeButton.translatesAutoresizingMaskIntoConstraints = false
        self.ShareButton.translatesAutoresizingMaskIntoConstraints = false
        self.MoreButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.goingbtn.translatesAutoresizingMaskIntoConstraints = false
        self.likesbtn.translatesAutoresizingMaskIntoConstraints = false
        self.commentsbtn.translatesAutoresizingMaskIntoConstraints = false
        self.sharesbtn.translatesAutoresizingMaskIntoConstraints = false
        
        self.contentView.addSubview(EventView)
        self.contentView.addSubview(EventDescription)
        self.contentView.addSubview(timeLocationLabel)
        self.contentView.addSubview(ProfileView)

        self.contentView.addSubview(GoButton)
        self.contentView.addSubview(LikeButton)
        self.contentView.addSubview(ShareButton)
        self.contentView.addSubview(MoreButton)
        
        
        self.contentView.addSubview(goingbtn)
        self.contentView.addSubview(likesbtn)
        self.contentView.addSubview(commentsbtn)
        self.contentView.addSubview(sharesbtn)
        
        
        let views = [
            "evView": EventView,
            "evDescription": EventDescription,
            "noOfGoing": goingbtn,
            "noOfLikes": likesbtn,
            "noOfComments": commentsbtn,
            "noOfShares": sharesbtn,
            "goButton": GoButton,
            "likeButton": LikeButton,
            "shareButton": ShareButton,
            "moreButton" : MoreButton,
            "timeloc" : timeLocationLabel,
            "profileView": ProfileView
        ]
        let profileHeight = 55
        let metrics = [
            "profileHeight" : profileHeight
        ]
        let H_Constraint0 = NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[timeloc]-10-|", options: [], metrics: nil, views: views)
        let H_Constraint1 = NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[evDescription]-10-|", options: [], metrics: nil, views: views)
        let H_Constraint2 = NSLayoutConstraint.constraintsWithVisualFormat("H:|[evView]|", options: [], metrics: nil, views: views)
        let H_Constraint3 = NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[noOfGoing]-20-[noOfLikes]-20-[noOfComments]-20-[noOfShares]->=5@999-|", options: [NSLayoutFormatOptions.AlignAllBaseline, NSLayoutFormatOptions.AlignAllCenterY], metrics: nil, views: views)
        let H_Constraint4 = NSLayoutConstraint.constraintsWithVisualFormat("H:|[goButton(==likeButton)][likeButton(==shareButton)][shareButton(==moreButton)][moreButton(==goButton)]|", options: [NSLayoutFormatOptions.AlignAllBaseline, NSLayoutFormatOptions.AlignAllCenterY], metrics: nil, views: views)
        let H_Constraint5 = NSLayoutConstraint.constraintsWithVisualFormat("H:|[profileView]|", options: [], metrics: nil, views: views)

        let V_Constraint0 = NSLayoutConstraint.constraintsWithVisualFormat("V:|[profileView(profileHeight)][evView]-15@999-[timeloc(<=100@999)]-5-[evDescription(<=550@999)]-10-[noOfGoing]-5-[likeButton(60)]|", options: [], metrics: metrics, views: views)
        
        // Set Square View
        
        self.contentView.addConstraint(NSLayoutConstraint(item: EventView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: EventView, attribute: NSLayoutAttribute.Width, multiplier: 1, constant: 0))
        self.contentView.addConstraints(H_Constraint0)
        self.contentView.addConstraints(H_Constraint1)
        self.contentView.addConstraints(H_Constraint2)
        self.contentView.addConstraints(H_Constraint3)
        self.contentView.addConstraints(H_Constraint4)
        self.contentView.addConstraints(H_Constraint5)
        self.contentView.addConstraints(V_Constraint0)
        
        self.EventView.addSubview(EventName)
        self.EventView.addSubview(EventDate)
        let ImageSubviews = [
            "evDate": EventDate,
            "evName": EventName,
        ]
        //var IH_Constraint1 = NSLayoutConstraint.constraintsWithVisualFormat("H:|--[evDate]-10-|", options: nil, metrics: nil, views: ImageSubviews)
        let IH_Constraint1 = NSLayoutConstraint.constraintsWithVisualFormat("H:|[evDate(60)]->=0@999-|", options: [], metrics: nil, views: ImageSubviews)
        let IH_Constraint2 = NSLayoutConstraint.constraintsWithVisualFormat("H:|-20-[evName]-20-|", options: [], metrics: nil, views: ImageSubviews)
        let IV_Constraint2 = NSLayoutConstraint.constraintsWithVisualFormat("V:|[evDate(60)]-[evName]-60-|", options: [], metrics: nil, views: ImageSubviews)
        
        self.EventView.addConstraints(IH_Constraint1)
        self.EventView.addConstraints(IH_Constraint2)
        self.EventView.addConstraints(IV_Constraint2)
        
        
        
        // Set number of going/likes/comments/shares
        
        self.numberOfGoingLabel.translatesAutoresizingMaskIntoConstraints = false
        self.numberOfLikesLabel.translatesAutoresizingMaskIntoConstraints = false
        self.numberOfCommentsLabel.translatesAutoresizingMaskIntoConstraints = false
        self.numberOfSharesLabel.translatesAutoresizingMaskIntoConstraints = false
        self.goingimg.translatesAutoresizingMaskIntoConstraints = false
        self.likesimg.translatesAutoresizingMaskIntoConstraints = false
        self.commentsimg.translatesAutoresizingMaskIntoConstraints = false
        self.sharesimg.translatesAutoresizingMaskIntoConstraints = false
        let s = [
            "gimg" : goingimg,
            "limg" : likesimg,
            "cimg" : commentsimg,
            "simg" : sharesimg,
            "glbl" : numberOfGoingLabel,
            "llbl" : numberOfLikesLabel,
            "clbl" : numberOfCommentsLabel,
            "slbl" : numberOfSharesLabel
        ]
        let m = [
            "s": 5,
            "sz": 12
        ]
        self.goingbtn.addSubview(goingimg)
        self.goingbtn.addSubview(numberOfGoingLabel)
        self.goingbtn.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[gimg(sz@999)]-s-[glbl]|", options: [NSLayoutFormatOptions.AlignAllCenterY, NSLayoutFormatOptions.AlignAllTop, NSLayoutFormatOptions.AlignAllBottom], metrics: m, views: s))
        self.goingbtn.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[glbl]|", options: [], metrics: m, views: s))
        self.goingbtn.addConstraint(NSLayoutConstraint(item: goingimg, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: goingimg, attribute: NSLayoutAttribute.Width, multiplier: 1, constant: 0))
        
        self.likesbtn.addSubview(likesimg)
        self.likesbtn.addSubview(numberOfLikesLabel)
        self.likesbtn.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[limg(sz@999)]-s-[llbl]|", options:  [NSLayoutFormatOptions.AlignAllCenterY, NSLayoutFormatOptions.AlignAllTop, NSLayoutFormatOptions.AlignAllBottom], metrics: m, views: s))
        self.likesbtn.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[llbl]|", options: [], metrics: m, views: s))
        self.likesbtn.addConstraint(NSLayoutConstraint(item: likesimg, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: likesimg, attribute: NSLayoutAttribute.Width, multiplier: 1, constant: 0))
        
        
        self.commentsbtn.addSubview(commentsimg)
        self.commentsbtn.addSubview(numberOfCommentsLabel)
        self.commentsbtn.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[cimg(sz@999)]-s-[clbl]|", options: [NSLayoutFormatOptions.AlignAllCenterY, NSLayoutFormatOptions.AlignAllTop, NSLayoutFormatOptions.AlignAllBottom], metrics: m, views: s))
        self.commentsbtn.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[clbl]|", options: [], metrics: m, views: s))
        self.commentsbtn.addConstraint(NSLayoutConstraint(item: commentsimg, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: commentsimg, attribute: NSLayoutAttribute.Width, multiplier: 1, constant: 0))
        
        self.sharesbtn.addSubview(sharesimg)
        self.sharesbtn.addSubview(numberOfSharesLabel)
        self.sharesbtn.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[simg(sz@999)][slbl]|", options: [NSLayoutFormatOptions.AlignAllCenterY, NSLayoutFormatOptions.AlignAllTop, NSLayoutFormatOptions.AlignAllBottom], metrics: m, views: s))
        self.sharesbtn.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[slbl]|", options: [], metrics: m, views: s))
        self.sharesbtn.addConstraint(NSLayoutConstraint(item: sharesimg, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: sharesimg, attribute: NSLayoutAttribute.Width, multiplier: 1, constant: 0))
        
        
        // Setting Profile View
        self.ProfileView.addSubview(ProfilePicture)
        self.ProfileView.addSubview(AuthorName)
        self.ProfileView.addSubview(createdAtLabel)
        
        self.ProfilePicture.translatesAutoresizingMaskIntoConstraints = false
        self.AuthorName.translatesAutoresizingMaskIntoConstraints = false
        self.createdAtLabel.translatesAutoresizingMaskIntoConstraints = false
        
        let profileViews = [
            "profilePicture": ProfilePicture,
            "profileName" : AuthorName,
            "createdAt" : createdAtLabel
        ]
        
        let SH_Constraint0 = NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[profilePicture(35@999)]-10-[profileName]-10-[createdAt]-15-|", options: [], metrics: nil, views: profileViews)
        let SV_Constraint0 = NSLayoutConstraint.constraintsWithVisualFormat("V:|-10-[profilePicture(35@999)]-10-|", options: [], metrics: nil, views: profileViews)
        let SV_Constraint1 = NSLayoutConstraint.constraintsWithVisualFormat("V:|-10-[profileName(35@999)]-10-|", options: [], metrics: nil, views: profileViews)
        let SV_Constraint2 = NSLayoutConstraint.constraintsWithVisualFormat("V:|-10-[createdAt(35@999)]-10-|", options: [], metrics: nil, views: profileViews)
        
        self.ProfileView.addConstraints(SH_Constraint0)
        self.ProfileView.addConstraints(SV_Constraint0)
        self.ProfileView.addConstraints(SV_Constraint1)
        self.ProfileView.addConstraints(SV_Constraint2)
        
        
        
    }
    
    func UpdateProfilePicture(id:String, progress:Double, image:UIImage!, row:Int){
        dispatch_async(dispatch_get_main_queue(), {
            () -> Void in
            if (row == self.tag){
                if (id == ""){//no picture
                }else{
                    if (progress < 1){ //picture is loading
                    }else{ //picture is loaded
                        self.ProfilePicture.image = image
                    }
                }
            }
        })
    }
    func Set_Numbers(going:Int, likes:Int, comments:Int, shares:Int){
        
        self.numberOfGoing = going
        self.numberOfLikes = likes
        self.numberOfComments = comments
        self.numberOfShares = shares
        
        self.numberOfGoingLabel.text = "\(going)"
        self.numberOfLikesLabel.text = "\(likes)"
        self.numberOfCommentsLabel.text = "\(comments)"
        self.numberOfSharesLabel.text = "\(shares)"
        
        
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
            self.EventDescription.addLinkToURL(url, withRange: linkRange)
            text.addAttribute(NSForegroundColorAttributeName, value: withColor, range: linkRange)
        }
        self.EventDescription.attributedText = text
        
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
            self.EventDescription.addLinkToURL(url, withRange: linkRange)
            text.addAttribute(NSForegroundColorAttributeName, value: withColor, range: linkRange)
        }
        self.EventDescription.attributedText = text
        
    }
    override func prepareForReuse() {
        super.prepareForReuse()
        self.ProfilePicture.image = UIImage()
        self.EventDescription.text = ""
        self.EventName.text = ""
        self.timeLocationLabel.text = ""
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }

}
