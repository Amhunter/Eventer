//
//  CommuniteTableViewCell.swift
//  Eventer
//
//  Created by Grisha on 23/06/2015.
//  Copyright (c) 2015 Grisha. All rights reserved.
//

import UIKit

class ExploreTableViewCell: UITableViewCell {

    var row:Int = Int()
    var profileView: EHighlightView = EHighlightView()
    var usernameLabel: UILabel = UILabel()
    var profilePicture: UIImageView = UIImageView()
    var followButton:ExploreFollowButton = ExploreFollowButton()
    
    var eventPictures:[EImageView] = [
        EImageView(),
        EImageView(),
        EImageView()
    ]
    
    var eventNameLabels:[ELabel] = [
        ELabel(),
        ELabel(),
        ELabel()
    ]
    
    var transparentViews:[UIView] = [
        UIView(),
        UIView(),
        UIView()
    ]


    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        Set_Subviews()
        Make_Autolayout()

        
    }
    func Set_Subviews(){
        
        // Profile View
        profileView.backgroundColor = UIColor.whiteColor()
        profilePicture.layer.cornerRadius = 20
        profilePicture.layer.masksToBounds = true
        profilePicture.layer.shouldRasterize = true
        profileView.userInteractionEnabled = true

        self.usernameLabel.font = UIFont(name: "Lato-Medium", size: 14.5)

        self.profilePicture.backgroundColor = UIColor.groupTableViewBackgroundColor()
        for label in eventNameLabels{
            label.font =  UIFont(name: "Helvetica", size: 13)
            label.textColor = UIColor.whiteColor()
            label.numberOfLines = 0
            label.alignment = ETextAlignment.bottom
        }
        for (index,imageView) in self.eventPictures.enumerate(){
            imageView.tag = index
        }
        //followButton.textColor = UIColor.lightGrayColor()
        //createdAtLabel.font = UIFont(name: "Helvetica", size: 14)
        //createdAtLabel.textAlignment = NSTextAlignment.Right
    }
    
    
    func Make_Autolayout(){
        self.contentView.frame.size.width = UIScreen.mainScreen().bounds.width
        self.profileView.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(profileView)
        
        for eventPicture in eventPictures{
            self.contentView.addSubview(eventPicture)
            eventPicture.translatesAutoresizingMaskIntoConstraints = false
            eventPicture.backgroundColor = UIColor.groupTableViewBackgroundColor()
            //ColorFromCode.colorWithHexString("#02A8F3")
        }


        let views = [
            "profileView": profileView,
            "evPicture0": eventPictures[0],
            "evPicture1": eventPictures[1],
            "evPicture2": eventPictures[2],
        ]
        let metrics = [
            "profileHeight": 50,
            "picSide": (self.contentView.frame.width-2)/3
        ]
        let H_Constraint0 = NSLayoutConstraint.constraintsWithVisualFormat("H:|[profileView]|", options: [], metrics: nil, views: views)
        let H_Constraint1 = NSLayoutConstraint.constraintsWithVisualFormat("H:|[evPicture0(picSide)]-1@999-[evPicture1(picSide)]-1@999-[evPicture2(picSide)]|", options: [NSLayoutFormatOptions.AlignAllTop, NSLayoutFormatOptions.AlignAllCenterY, NSLayoutFormatOptions.AlignAllBottom], metrics: metrics, views: views)
        
        let V_Constraint0 = NSLayoutConstraint.constraintsWithVisualFormat("V:|[profileView(==profileHeight@999)][evPicture0(picSide)]|", options: [], metrics: metrics, views: views)


//        for eventPicture in eventPictures{
//            //self.contentView.addConstraint(NSLayoutConstraint(item: eventPicture, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: eventPicture, attribute: NSLayoutAttribute.Width, multiplier: 1, constant: 0))
//        }

        
        self.contentView.addConstraints(H_Constraint0)
        self.contentView.addConstraints(H_Constraint1)
        self.contentView.addConstraints(V_Constraint0)

        
        
        
        
        // Set Subviews on ImageView
        
        for (index,label) in eventNameLabels.enumerate(){
            label.translatesAutoresizingMaskIntoConstraints = false
            transparentViews[index].translatesAutoresizingMaskIntoConstraints = false
            
            self.eventPictures[index].addSubview(self.eventNameLabels[index])
            self.eventPictures[index].addSubview(self.transparentViews[index])

            

            self.eventPictures[index].addSubview(label)

            transparentViews[index].backgroundColor = UIColor.clearColor()
            transparentViews[index].hidden = true

            let imageSubviews = [
                "label": label,
                "transp": transparentViews[index]
            ]
            let H_Constraint0 = NSLayoutConstraint.constraintsWithVisualFormat("H:|-8-[label]-8-|", options: [], metrics: nil, views: imageSubviews)
            let H_Constraint1 = NSLayoutConstraint.constraintsWithVisualFormat("H:|[transp]|", options: [], metrics: nil, views: imageSubviews)

            let V_Constraint0 = NSLayoutConstraint.constraintsWithVisualFormat("V:|->=0@999-[label(30)]-6-|", options: [], metrics: nil, views: imageSubviews)
            let V_Constraint1 = NSLayoutConstraint.constraintsWithVisualFormat("V:|-[transp(60)]|", options: [], metrics: nil, views: imageSubviews)

            self.eventPictures[index].addConstraints(H_Constraint0)
            self.eventPictures[index].addConstraints(H_Constraint1)
            self.eventPictures[index].addConstraints(V_Constraint0)
            self.eventPictures[index].addConstraints(V_Constraint1)
            
            self.eventPictures[index].bringSubviewToFront(label)
            self.eventPictures[index].setNeedsLayout()
            self.eventPictures[index].layoutIfNeeded()
            transparentViews[index].layer.addSublayer(Utility.gradientLayer(
                transparentViews[index].frame, height: 60, alpha: 0.9))

        }

        
        
        
        // Setting Profile View
        self.profileView.addSubview(profilePicture)
        self.profileView.addSubview(usernameLabel)
        self.profileView.addSubview(followButton)
        
        self.profilePicture.translatesAutoresizingMaskIntoConstraints = false
        self.usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        self.followButton.translatesAutoresizingMaskIntoConstraints = false
        
        let profileViews = [
            "profilePicture": profilePicture,
            "profileName" : usernameLabel,
            "followButton" : followButton
        ]
        let metrics2 = [
            "offset" : 10
        ]
        
        let SH_Constraint0 = NSLayoutConstraint.constraintsWithVisualFormat("H:|-15-[profilePicture(40)]-10-[profileName]-10-[followButton(40)]-15-|", options: [], metrics: nil, views: profileViews)
        let SV_Constraint0 = NSLayoutConstraint.constraintsWithVisualFormat("V:|-offset-[profilePicture(40)]-offset-|", options: [], metrics: metrics2, views: profileViews)
        let SV_Constraint1 = NSLayoutConstraint.constraintsWithVisualFormat("V:|[profileName]|", options: [], metrics: nil, views: profileViews)
        let SV_Constraint2 = NSLayoutConstraint.constraintsWithVisualFormat("V:|-offset-[followButton(40)]-offset-|", options: [], metrics: metrics2, views: profileViews)
        
        self.profileView.addConstraints(SH_Constraint0)
        self.profileView.addConstraints(SV_Constraint0)
        self.profileView.addConstraints(SV_Constraint1)
        self.profileView.addConstraints(SV_Constraint2)
        
        //self.contentView.addConstraint(NSLayoutConstraint(item: EventPicture, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self.contentView, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0))
        
        
    }
    
    // Download Events Picture passed by reference

    func showEventNames(forEvents:[FetchedEvent], cellRow:Int){
        if (cellRow == self.tag){
            for (index,event) in forEvents.enumerate(){
                eventNameLabels[index].text = event.name as String
            }
        }
    }
    
    func UpdateEventPictures(forEvents:[FetchedEvent], cellRow:Int){
        if (cellRow == self.tag){
            for (index,event) in forEvents.enumerate(){
                UpdateEventPicture(event, atIndex: index, cellRow: cellRow)
            }
        }
    }
    
    func UpdateEventPicture(forEvent:FetchedEvent, atIndex:Int, cellRow:Int){
        
        if (cellRow == self.tag){
            eventPictures[atIndex].userInteractionEnabled = true
            if (forEvent.pictureId == ""){//no picture
                self.eventPictures[atIndex].backgroundColor = ColorFromCode.randomBlueColorFromNumber(cellRow+atIndex)
                self.transparentViews[atIndex].hidden = true
            }else{

                if (forEvent.pictureProgress < 1){ //picture is loading
                    self.eventPictures[atIndex].backgroundColor = UIColor.darkGrayColor()
                    self.transparentViews[atIndex].hidden = true
                }else{ //picture is loaded
                    self.eventPictures[atIndex].image = forEvent.picture
                    self.transparentViews[atIndex].hidden = false
                }
            }
        }
    }
    
    
    
    func UpdateProfilePicture(forUser:KCSUserWith3Events){
        if (forUser.profilePictureID == ""){//no picture
        }else{
            if (forUser.profilePictureProgress < 1){ //picture is loading
                
            }else{ //picture is loaded
                self.profilePicture.image = forUser.profilePicture
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
//        self.EventDescription.text = ""
//        self.EventName.text = ""
        for (index,imageView) in self.eventPictures.enumerate(){
            imageView.image = UIImage()
            imageView.backgroundColor = UIColor.groupTableViewBackgroundColor()
            transparentViews[index].hidden = true
            eventNameLabels[index].text = ""
            eventPictures[index].userInteractionEnabled = false
        }
        self.profilePicture.image = UIImage()
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
    }
}
