//
//  EventCellTableViewCell.swift
//  GCalendar
//
//  Created by Grisha on 30/10/2014.
//  Copyright (c) 2014 Grisha. All rights reserved.
//


import UIKit

class HomeEventTableViewCell: UITableViewCell {
    let screenWidth = UIScreen.mainScreen().bounds.width
    
    var downloadingProfilePicture:Bool = false

    var eventNameLabel: UILabel = UILabel()
    var eventDateLabel: UILabel = UILabel()
    var pictureImageView: UIImageView = UIImageView()
    var progressView: EProgressView = EProgressView()
    var transparentView: UIView = UIView()
    var createdAtLabel:UILabel = UILabel()
    var eventDescriptionLabel: TTTAttributedLabel = TTTAttributedLabel(frame: CGRectZero)
    var timeLocationLabel:TTTAttributedLabel = TTTAttributedLabel(frame: CGRectZero)
    var numberOfGoing:Int!
    var numberOfLikes:Int!
    var numberOfComments:Int!
    var numberOfShares:Int!
    

    var goingimg:UIImageView = UIImageView(image: UIImage(named: "small-going.png"))
    var likesimg:UIImageView = UIImageView(image: UIImage(named: "small-like.png"))
    var commentsimg:UIImageView = UIImageView(image: UIImage(named: "small-comment.png"))
    var sharesimg:UIImageView = UIImageView(image: UIImage(named: "small-share.png"))
    

    var likeButton = ETableViewCellButton(withButtonImage: ImagesCenter.homeLikeImage(), backgroundColor: ColorFromCode.colorWithHexString("#008DD4"))
    var goButton = ETableViewCellButton(withButtonImage: ImagesCenter.homeGoImage(), backgroundColor: ColorFromCode.colorWithHexString("#0079BF"))
    var shareButton = ETableViewCellButton(withButtonImage: ImagesCenter.homeShareImage(), backgroundColor: ColorFromCode.colorWithHexString("#009DE6"))
    var moreButton:HomeMoreButton = HomeMoreButton()
    var commentButton = HomeCommentButton()
    


    
    var goingbtn:UIButton = UIButton()
    var likesbtn:UIButton = UIButton()
    var commentsbtn:UIButton = UIButton()
    var sharesbtn:UIButton = UIButton()

    var didSetupConstraints = false
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        Set_Subviews()
        Make_Autolayout()
    }
    override func layoutSubviews() {

    }
    func Set_Subviews(){
//        var height = self.frame.height
//        var width = self.frame.width
//        println(height)
//        println(width)
        self.contentView.frame.size.width = UIScreen.mainScreen().bounds.width

        timeLocationLabel.textAlignment = NSTextAlignment.Center
        timeLocationLabel.numberOfLines = 3
        
        let attrs = [NSForegroundColorAttributeName: UIColor.blackColor()]
        timeLocationLabel.activeLinkAttributes = attrs
        
        eventDescriptionLabel.activeLinkAttributes = attrs
        // Image View
        eventNameLabel.alpha = 1
        eventNameLabel.backgroundColor = UIColor.clearColor()
        eventNameLabel.textColor = UIColor.whiteColor()
//        eventNameLabel.textAlignment = NSTextAlignment.Center
        eventNameLabel.font = UIFont(name: "Lato-Bold", size: 19)
        eventNameLabel.numberOfLines = 0
        eventDateLabel.backgroundColor = ColorFromCode.colorWithHexString("#02A8F3")
        eventDateLabel.textColor = UIColor.whiteColor()
        eventDateLabel.numberOfLines = 0
        eventDateLabel.textAlignment = NSTextAlignment.Center
        eventDescriptionLabel.numberOfLines = 0
        // Progress View
        progressView.backgroundColor = ColorFromCode.colorWithHexString("#02A8F3")
        
        transparentView.backgroundColor = UIColor.clearColor()
        

    }

    
    func Make_Autolayout(){
        //self.contentMode = UIViewContentMode.Redraw
        //self.contentView.contentMode = UIViewContentMode.Redraw

        self.eventNameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.eventDateLabel.translatesAutoresizingMaskIntoConstraints = false
        self.eventDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        self.pictureImageView.translatesAutoresizingMaskIntoConstraints = false
        self.timeLocationLabel.translatesAutoresizingMaskIntoConstraints = false
        self.goButton.translatesAutoresizingMaskIntoConstraints = false
        self.likeButton.translatesAutoresizingMaskIntoConstraints = false
        self.commentButton.translatesAutoresizingMaskIntoConstraints = false
        self.shareButton.translatesAutoresizingMaskIntoConstraints = false
        self.moreButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.goingbtn.translatesAutoresizingMaskIntoConstraints = false
        self.likesbtn.translatesAutoresizingMaskIntoConstraints = false
        self.commentsbtn.translatesAutoresizingMaskIntoConstraints = false
        self.sharesbtn.translatesAutoresizingMaskIntoConstraints = false

        self.contentView.addSubview(pictureImageView)
        self.contentView.addSubview(eventDateLabel)
        self.contentView.addSubview(eventDescriptionLabel)
        self.contentView.addSubview(timeLocationLabel)
        
//        self.contentView.addSubview(GoButton)
//        self.contentView.addSubview(likeButton)
//        self.contentView.addSubview(ShareButton)
////        self.contentView.addSubview(moreButton)
//        self.contentView.addSubview(commentButton)
        self.contentView.addSubview(goButton)
        self.contentView.addSubview(likeButton)
        self.contentView.addSubview(shareButton)
        self.contentView.addSubview(moreButton)
        self.contentView.addSubview(commentButton)

//        self.contentView.addSubview(sharesbtn)

//        self.contentView.addSubview(goingbtn)
//        self.contentView.addSubview(likesbtn)
//        self.contentView.addSubview(commentsbtn)
//        self.contentView.addSubview(sharesbtn)

        
        let views = [
            "evPicture": pictureImageView,
            "evDate": eventDateLabel,
            "evDescription": eventDescriptionLabel,
            "goButton": goButton,
            "likeButton": likeButton,
            "shareButton": shareButton,
            "commentButton" : commentButton,
            "moreButton" : moreButton,
            "timeloc" : timeLocationLabel,
        ]
        let metrics = [
            "sq" : screenWidth/5, // little square for date
            "bsq": (screenWidth/5)*4, // big square for pic
            "rec": (screenWidth/5)*3
        ]
        let H_Constraint0 = NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[evDescription]-10-|", options: [], metrics: nil, views: views)
        let H_Constraint1 = NSLayoutConstraint.constraintsWithVisualFormat("H:|[evPicture][evDate(sq@999)]|", options: [], metrics: metrics, views: views)
        let H_Constraint2 = NSLayoutConstraint.constraintsWithVisualFormat("H:|[evPicture][likeButton(sq@999)]|", options: [], metrics: metrics, views: views)
        let H_Constraint3 = NSLayoutConstraint.constraintsWithVisualFormat("H:|[evPicture][goButton(sq@999)]|", options: [], metrics: metrics, views: views)
        let H_Constraint4 = NSLayoutConstraint.constraintsWithVisualFormat("H:|[evPicture][shareButton(sq@999)]|", options: [], metrics: metrics, views: views)
        let H_Constraint5 = NSLayoutConstraint.constraintsWithVisualFormat("H:|[moreButton(sq@999)][timeloc][commentButton(sq@999)]|", options: [.AlignAllTop, .AlignAllBottom, .AlignAllCenterY], metrics: metrics, views: views)


        let V_Constraint0 = NSLayoutConstraint.constraintsWithVisualFormat("V:|[evPicture(bsq@999)][moreButton(sq@999)]-5-[evDescription(>=0@999)]->=0@999-|", options: [], metrics: metrics, views: views)
        let V_Constraint1 = NSLayoutConstraint.constraintsWithVisualFormat("V:|[evDate(sq@999)][shareButton(sq@999)][likeButton(sq@999)][goButton(sq@999)][commentButton(sq@999)]-5-[evDescription(>=0@999)]->=0@999-|", options: [], metrics: metrics, views: views)

        // height == width for picture
        self.contentView.addConstraint(NSLayoutConstraint(item: pictureImageView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: pictureImageView, attribute: NSLayoutAttribute.Width, multiplier: 1, constant: 0))
        self.contentView.addConstraints(H_Constraint0)
        self.contentView.addConstraints(H_Constraint1)
        self.contentView.addConstraints(H_Constraint2)
        self.contentView.addConstraints(H_Constraint3)
        self.contentView.addConstraints(H_Constraint4)
        self.contentView.addConstraints(H_Constraint5)
        self.contentView.addConstraints(V_Constraint0)
        self.contentView.addConstraints(V_Constraint1)

        // Set ImageView and progressView

        self.contentView.setNeedsLayout()
        self.contentView.layoutIfNeeded()
        self.pictureImageView.addSubview(transparentView)
        self.transparentView.frame.origin = CGPointMake(0, pictureImageView.frame.height-160)
        self.transparentView.frame.size = CGSizeMake(pictureImageView.frame.width, 160)
        self.transparentView.layer.insertSublayer(Utility.gradientLayer(self.transparentView.frame, height: self.transparentView.frame.height, alpha: 0.75), atIndex: 0)

        self.contentView.addSubview(progressView)
        self.progressView.frame = self.pictureImageView.frame
        self.progressView.initProgressView()
//        println(pictureImageView.frame)
//        println(progressView.frame)
        self.showImage(false)
        
        
        
        
        
//        likeContainer.setBackgroundColor(ColorFromCode.orangeDateColor(), forState: UIControlState.Highlighted)
//        likeContainer.setBackgroundColor(ColorFromCode.likeBlueColor(), forState: UIControlState.Normal)
        // Set number of going/likes/comments/shares
//        
//        self.numberOfGoingLabel.translatesAutoresizingMaskIntoConstraints = false
//        self.numberOfLikesLabel.translatesAutoresizingMaskIntoConstraints = false
//        self.numberOfCommentsLabel.translatesAutoresizingMaskIntoConstraints = false
//        self.numberOfSharesLabel.translatesAutoresizingMaskIntoConstraints = false
//        self.goingimg.translatesAutoresizingMaskIntoConstraints = false
//        self.likesimg.translatesAutoresizingMaskIntoConstraints = false
//        self.commentsimg.translatesAutoresizingMaskIntoConstraints = false
//        self.sharesimg.translatesAutoresizingMaskIntoConstraints = false
//        let s = [
//            "gimg" : goingimg,
//            "limg" : likesimg,
//            "cimg" : commentsimg,
//            "simg" : sharesimg,
//            "glbl" : numberOfGoingLabel,
//            "llbl" : numberOfLikesLabel,
//            "clbl" : numberOfCommentsLabel,
//            "slbl" : numberOfSharesLabel
//        ]
//        let m = [
//            "s": 5,
//            "sz": 12
//        ]
//        self.goingbtn.addSubview(goingimg)
//        self.goingbtn.addSubview(numberOfGoingLabel)
//        self.goingbtn.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[gimg(sz@999)]-s-[glbl]|", options: [NSLayoutFormatOptions.AlignAllCenterY, NSLayoutFormatOptions.AlignAllTop, NSLayoutFormatOptions.AlignAllBottom], metrics: m, views: s))
//        self.goingbtn.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[glbl]|", options: [], metrics: m, views: s))
//        self.goingbtn.addConstraint(NSLayoutConstraint(item: goingimg, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: goingimg, attribute: NSLayoutAttribute.Width, multiplier: 1, constant: 0))
//        
//        self.likesbtn.addSubview(likesimg)
//        self.likesbtn.addSubview(numberOfLikesLabel)
//        self.likesbtn.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[limg(sz@999)]-s-[llbl]|", options:  [NSLayoutFormatOptions.AlignAllCenterY, NSLayoutFormatOptions.AlignAllTop, NSLayoutFormatOptions.AlignAllBottom], metrics: m, views: s))
//        self.likesbtn.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[llbl]|", options: [], metrics: m, views: s))
//        self.likesbtn.addConstraint(NSLayoutConstraint(item: likesimg, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: likesimg, attribute: NSLayoutAttribute.Width, multiplier: 1, constant: 0))
//        
//
//        self.commentsbtn.addSubview(commentsimg)
//        self.commentsbtn.addSubview(numberOfCommentsLabel)
//        self.commentsbtn.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[cimg(sz@999)]-s-[clbl]|", options: [NSLayoutFormatOptions.AlignAllCenterY, NSLayoutFormatOptions.AlignAllTop, NSLayoutFormatOptions.AlignAllBottom], metrics: m, views: s))
//        self.commentsbtn.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[clbl]|", options: [], metrics: m, views: s))
//        self.commentsbtn.addConstraint(NSLayoutConstraint(item: commentsimg, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: commentsimg, attribute: NSLayoutAttribute.Width, multiplier: 1, constant: 0))
//        
//        self.sharesbtn.addSubview(sharesimg)
//        self.sharesbtn.addSubview(numberOfSharesLabel)
//        self.sharesbtn.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("H:|[simg(sz@999)][slbl]|", options: [NSLayoutFormatOptions.AlignAllCenterY, NSLayoutFormatOptions.AlignAllTop, NSLayoutFormatOptions.AlignAllBottom], metrics: m, views: s))
//        self.sharesbtn.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[slbl]|", options: [], metrics: m, views: s))
//        self.sharesbtn.addConstraint(NSLayoutConstraint(item: sharesimg, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: sharesimg, attribute: NSLayoutAttribute.Width, multiplier: 1, constant: 0))
//        


        //self.contentView.addConstraint(NSLayoutConstraint(item: pictureImageView, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self.contentView, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0))
        
        
    }
    
    func showImage(show:Bool){
        let ImageSubviews = [
            "evName": eventNameLabel,
        ]


        if (show){
            self.progressView.hidden = true
            self.pictureImageView.hidden = false
            self.pictureImageView.addSubview(eventNameLabel)
            
            let IH_Constraint1 = NSLayoutConstraint.constraintsWithVisualFormat("H:|-20-[evName(>=0@999)]-20-|", options: [], metrics: nil, views: ImageSubviews)
            

            let IV_Constraint1 = NSLayoutConstraint.constraintsWithVisualFormat("V:|->=0@999-[evName(90)]|", options: [], metrics: nil, views: ImageSubviews)

            self.pictureImageView.addConstraints(IH_Constraint1)
            self.pictureImageView.addConstraints(IV_Constraint1)
            self.pictureImageView.bringSubviewToFront(eventNameLabel)
        }else{
            self.progressView.hidden = false
            self.pictureImageView.hidden = true
            self.progressView.addSubview(eventNameLabel)

            let IH_Constraint1 = NSLayoutConstraint.constraintsWithVisualFormat("H:|-20-[evName]-20-|", options: [], metrics: nil, views: ImageSubviews)
            
            let IV_Constraint2 = NSLayoutConstraint.constraintsWithVisualFormat("V:|->=0@999-[evName(90)]|", options: [], metrics: nil, views: ImageSubviews)
            
            self.progressView.addConstraints(IH_Constraint1)
            self.progressView.addConstraints(IV_Constraint2)
            self.progressView.bringSubviewToFront(eventNameLabel)

        }

    }
    
    

    func UpdateEventPicture(withDataFromEvent:FetchedEvent, row:Int){
        dispatch_async(dispatch_get_main_queue(), {
            () -> Void in
            if (row == self.tag){
                if (withDataFromEvent.pictureId == ""){//no picture
                    self.progressView.progressCircle.hidden = true
                    self.progressView.backgroundColor = UIColor.lightGrayColor()
                    self.showImage(false)
                }else{
                    if (withDataFromEvent.pictureProgress < 1){ //picture is loading
                        self.progressView.updateProgress(withDataFromEvent.pictureProgress)
                        self.showImage(false)
                    }else{ //picture is loaded
                        self.pictureImageView.image = withDataFromEvent.picture
                        self.showImage(true)

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
            self.eventDescriptionLabel.addLinkToURL(url, withRange: linkRange)
            text.addAttribute(NSForegroundColorAttributeName, value: withColor, range: linkRange)
        }
        self.eventDescriptionLabel.attributedText = text
        
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
            self.eventDescriptionLabel.addLinkToURL(url, withRange: linkRange)
            text.addAttribute(NSForegroundColorAttributeName, value: withColor, range: linkRange)
        }
        self.eventDescriptionLabel.attributedText = text
        
    }

    
    
    func Set_Numbers(going:Int, likes:Int, comments:Int, shares:Int){

        self.numberOfGoing = going
        self.numberOfLikes = likes
        self.numberOfComments = comments
        self.numberOfShares = shares
        
        self.goButton.setLabelNumber(going)
        self.likeButton.setLabelNumber(likes)
        self.shareButton.setLabelNumber(shares)
        self.commentButton.setLabelNumber(comments)

        
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.eventDescriptionLabel.text = ""
        self.timeLocationLabel.text = ""
        self.eventNameLabel.text = ""
        self.pictureImageView.image = UIImage()

    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
}
