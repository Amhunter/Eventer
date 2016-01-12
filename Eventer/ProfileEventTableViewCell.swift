//
//  ProfileEventTableViewCell.swift
//  Eventer
//
//  Created by Grisha on 18/07/2015.
//  Copyright (c) 2015 Grisha. All rights reserved.
//

import UIKit

class ProfileEventTableViewCell: UITableViewCell {
    var downloadingProfilePicture:Bool = false
    
    var row:Int = Int()
    var ProfileView: UIView = UIView()
    var AuthorName: UILabel = UILabel()
    var ProfilePicture: UIImageView = UIImageView()
    var EventName: UILabel = UILabel()
    var EventDate: UILabel = UILabel()
    var EventPicture: UIImageView = UIImageView()
    var ProgressView: EProgressView = EProgressView()
    var TransparentView: UIView = UIView()
    var createdAtLabel:UILabel = UILabel()
    var EventDescription: TTTAttributedLabel = TTTAttributedLabel(frame: CGRectZero)
    var timeLocationLabel:TTTAttributedLabel = TTTAttributedLabel(frame: CGRectZero)
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
        //        println(height)
        //        println(width)
        self.contentView.frame.size.width = UIScreen.mainScreen().bounds.width
        
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
        
        timeLocationLabel.textAlignment = NSTextAlignment.Center
        timeLocationLabel.numberOfLines = 3
        
        let attrs = [NSForegroundColorAttributeName: UIColor.blackColor()]
        timeLocationLabel.activeLinkAttributes = attrs
        EventDescription.activeLinkAttributes = attrs
        
        // Image View
        EventName.alpha = 1
        EventName.backgroundColor = UIColor.clearColor()
        EventName.textColor = UIColor.whiteColor()
        EventName.textAlignment = NSTextAlignment.Center
        EventName.font = UIFont(name: "Lato-Semibold", size: 21)
        EventName.numberOfLines = 0
        EventDate.backgroundColor = ColorFromCode.colorWithHexString("#02A8F3")
        EventDate.textColor = UIColor.whiteColor()
        EventDate.numberOfLines = 0
        EventDate.textAlignment = NSTextAlignment.Center
        EventDescription.numberOfLines = 0
        // Progress View
        ProgressView.backgroundColor = ColorFromCode.colorWithHexString("#02A8F3")
        TransparentView.backgroundColor = UIColor.clearColor()
        
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
        //self.contentMode = UIViewContentMode.Redraw
        //self.contentView.contentMode = UIViewContentMode.Redraw
        
        
        self.EventName.translatesAutoresizingMaskIntoConstraints = false
        self.EventDate.translatesAutoresizingMaskIntoConstraints = false
        self.EventDescription.translatesAutoresizingMaskIntoConstraints = false
        self.EventPicture.translatesAutoresizingMaskIntoConstraints = false
        self.timeLocationLabel.translatesAutoresizingMaskIntoConstraints = false
        self.GoButton.translatesAutoresizingMaskIntoConstraints = false
        self.LikeButton.translatesAutoresizingMaskIntoConstraints = false
        self.ShareButton.translatesAutoresizingMaskIntoConstraints = false
        self.MoreButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.goingbtn.translatesAutoresizingMaskIntoConstraints = false
        self.likesbtn.translatesAutoresizingMaskIntoConstraints = false
        self.commentsbtn.translatesAutoresizingMaskIntoConstraints = false
        self.sharesbtn.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(ProfileView)
        self.contentView.addSubview(EventPicture)
        self.contentView.addSubview(EventDescription)
        self.contentView.addSubview(timeLocationLabel)
        
        self.contentView.addSubview(GoButton)
        self.contentView.addSubview(LikeButton)
        self.contentView.addSubview(ShareButton)
        self.contentView.addSubview(MoreButton)
        
        
        self.contentView.addSubview(goingbtn)
        self.contentView.addSubview(likesbtn)
        self.contentView.addSubview(commentsbtn)
        self.contentView.addSubview(sharesbtn)
        let greySeparator = UIView()
        greySeparator.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(greySeparator)
        greySeparator.backgroundColor = UIColor.lightGrayColor()
        let views = [
            "evPicture": EventPicture,
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
        let H_Constraint2 = NSLayoutConstraint.constraintsWithVisualFormat("H:|-0-[evPicture]-0-|", options: [], metrics: nil, views: views)
        let H_Constraint3 = NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[noOfGoing]-20-[noOfLikes]-20-[noOfComments]-20-[noOfShares]->=5@999-|", options: [NSLayoutFormatOptions.AlignAllBaseline, NSLayoutFormatOptions.AlignAllCenterY], metrics: nil, views: views)
        let H_Constraint4 = NSLayoutConstraint.constraintsWithVisualFormat("H:|[goButton(==likeButton)][likeButton(==shareButton)][shareButton(==moreButton)][moreButton(==goButton)]|", options: [NSLayoutFormatOptions.AlignAllBaseline, NSLayoutFormatOptions.AlignAllCenterY], metrics: nil, views: views)
        let H_Constraint5 = NSLayoutConstraint.constraintsWithVisualFormat("H:|[profileView]|", options: [], metrics: nil, views: views)

        let V_Constraint0 = NSLayoutConstraint.constraintsWithVisualFormat("V:|[profileView(profileHeight)][evPicture]-15@999-[timeloc(<=100@999)]-5-[evDescription(<=550@999)]-10-[noOfGoing]-5-[likeButton(60)]|", options: [], metrics: metrics, views: views)

        
        
        // height == width for picture
        self.contentView.addConstraint(NSLayoutConstraint(item: EventPicture, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: EventPicture, attribute: NSLayoutAttribute.Width, multiplier: 1, constant: 0))
        self.contentView.addConstraints(H_Constraint0)
        self.contentView.addConstraints(H_Constraint1)
        self.contentView.addConstraints(H_Constraint2)
        self.contentView.addConstraints(H_Constraint3)
        self.contentView.addConstraints(H_Constraint4)
        self.contentView.addConstraints(H_Constraint5)
        self.contentView.addConstraints(V_Constraint0)
        
        // Set ImageView and ProgressView
        
        self.contentView.setNeedsLayout()
        self.contentView.layoutIfNeeded()
        self.EventPicture.addSubview(TransparentView)
        self.TransparentView.frame.origin = CGPointMake(0, EventPicture.frame.height-160)
        self.TransparentView.frame.size = CGSizeMake(EventPicture.frame.width, 160)
        self.TransparentView.layer.insertSublayer(Utility.gradientLayer(self.TransparentView.frame, height: self.TransparentView.frame.height, alpha: 0.75), atIndex: 0)
        
        self.contentView.addSubview(ProgressView)
        self.ProgressView.frame = self.EventPicture.frame
        self.ProgressView.initProgressView()
        //        println(EventPicture.frame)
        //        println(ProgressView.frame)
        self.showImage(false)
        
        
        
        
        
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
        
        //self.contentView.addConstraint(NSLayoutConstraint(item: EventPicture, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self.contentView, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0))

        
    }
    
    func showImage(show:Bool){
        let ImageSubviews = [
            "evDate": EventDate,
            "evName": EventName,
        ]
        
        
        if (show){
            self.ProgressView.hidden = true
            self.EventPicture.hidden = false
            self.EventPicture.addSubview(EventName)
            self.EventPicture.addSubview(EventDate)
            
            let IH_Constraint1 = NSLayoutConstraint.constraintsWithVisualFormat("H:|[evDate(60)]->=0@999-|", options: [], metrics: nil, views: ImageSubviews)
            let IH_Constraint2 = NSLayoutConstraint.constraintsWithVisualFormat("H:|-20-[evName(>=0@999)]-20-|", options: [], metrics: nil, views: ImageSubviews)
            
            
            let IV_Constraint1 = NSLayoutConstraint.constraintsWithVisualFormat("V:|[evDate(60)]->=0@999-[evName(90)]|", options: [], metrics: nil, views: ImageSubviews)
            
            self.EventPicture.addConstraints(IH_Constraint1)
            self.EventPicture.addConstraints(IH_Constraint2)
            self.EventPicture.addConstraints(IV_Constraint1)
            self.EventPicture.bringSubviewToFront(EventName)
        }else{
            self.ProgressView.hidden = false
            self.EventPicture.hidden = true
            self.ProgressView.addSubview(EventName)
            self.ProgressView.addSubview(EventDate)
            
            let IH_Constraint1 = NSLayoutConstraint.constraintsWithVisualFormat("H:|[evDate(60)]->=0@999-|", options: [], metrics: nil, views: ImageSubviews)
            let IH_Constraint2 = NSLayoutConstraint.constraintsWithVisualFormat("H:|-20-[evName]-20-|", options: [], metrics: nil, views: ImageSubviews)
            
            let IV_Constraint2 = NSLayoutConstraint.constraintsWithVisualFormat("V:|[evDate(60)]->=0@999-[evName(90)]|", options: [], metrics: nil, views: ImageSubviews)
            
            self.ProgressView.addConstraints(IH_Constraint1)
            self.ProgressView.addConstraints(IH_Constraint2)
            self.ProgressView.addConstraints(IV_Constraint2)
            self.ProgressView.bringSubviewToFront(EventName)
            
        }
        
    }
    
    
    
    func UpdateEventPicture(withDataFromEvent:FetchedEvent, row:Int){
        dispatch_async(dispatch_get_main_queue(), {
            () -> Void in
            if (row == self.tag){
                if (withDataFromEvent.pictureId == ""){//no picture
                    self.showImage(false)
                }else{
                    if (withDataFromEvent.pictureProgress < 1){ //picture is loading
                        self.ProgressView.updateProgress(withDataFromEvent.pictureProgress)
                        self.showImage(false)
                    }else{ //picture is loaded
                        self.EventPicture.image = withDataFromEvent.picture
                        self.showImage(true)
                        
                    }
                }
            }
        })
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

    
    
    
    
    
    
    //    func UpdateProfilePicture(withDataFromEvent:FetchedEvent, row:Int){
    //        dispatch_async(dispatch_get_main_queue(), {
    //            () -> Void in
    //            if (row == self.row){
    //                if (withDataFromEvent.profilePictureID == ""){//no picture
    //
    //                    //self.ProfilePicture.image = UIImage(named: "defaultPicture.png")!
    //                }else{
    //                    if (withDataFromEvent.profilePictureProgress < 1){ //picture is loading
    //                        //self.ProfilePicture.image = UIImage(named: "defaultPicture.png")!
    //
    //                    }else{ //picture is loaded
    //                        self.ProfilePicture.image = withDataFromEvent.profilePicture
    //                    }
    //                }
    //            }
    //        })
    //    }
    
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.EventDescription.text = ""
        self.timeLocationLabel.text = ""
        self.EventName.text = ""
        self.ProfilePicture.image = UIImage()
        self.EventPicture.image = UIImage()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }

}
