//
//  InvitePeopleTableViewCell.swift
//  Eventer
//
//  Created by Grisha on 09/04/2015.
//  Copyright (c) 2015 Grisha. All rights reserved.
//

import UIKit

class InvitePeopleTableViewCell: UITableViewCell {

    var profileImageView:EImageView = EImageView()
    var label:TTTAttributedLabel = TTTAttributedLabel(frame: CGRectZero)
    
    var selectedView = UIImageView()
    var usernameFont = UIFont(name: "Lato-Regular", size: 14)
    var fullnameFont = UIFont(name: "Lato-Semibold", size: 14)
    
    //var followLabel:UILabel = UILabel(frame: CGRectMake(50, 5, 220, 30))
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.frame.size.width = UIScreen.mainScreen().bounds.width
        
        self.contentView.addSubview(profileImageView)
        self.contentView.addSubview(label)
        self.contentView.addSubview(selectedView)
        
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        selectedView.translatesAutoresizingMaskIntoConstraints = false
        
        label.numberOfLines = 0
        label.font = UIFont(name: "Lato-Medium", size: 14)
        label.textColor = ColorFromCode.colorWithHexString("#9A9A9A")
        label.activeLinkAttributes = [NSForegroundColorAttributeName: UIColor.blackColor()]
        
        
        selectedView.layer.masksToBounds = true //without it its not gonna work
        selectedView.layer.cornerRadius = 12.5
        selectedView.image = UIImage(named: "accept")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        
        profileImageView.layer.masksToBounds = true //without it its not gonna work
        profileImageView.userInteractionEnabled = true
        profileImageView.layer.cornerRadius = 20
        
        let border:UIView = UIView()
        border.translatesAutoresizingMaskIntoConstraints = false
        border.backgroundColor = ColorFromCode.colorWithHexString("#DAE4E7")
        self.contentView.addSubview(border)
        
        let views = [
            "imageView": profileImageView,
            "label": label,
            "selectedView": selectedView,
            "brdr": border
        ]
        //        var metrics = [
        //        ]
        
        let H_Constraint0 = NSLayoutConstraint.constraintsWithVisualFormat("H:|-11-[imageView(40)]-10-[label(>=0)]-10-[selectedView(25)]-30@999-|", options: [], metrics: nil, views: views)
        let H_Constraint1 = NSLayoutConstraint.constraintsWithVisualFormat("H:|[brdr]|", options: [], metrics: nil, views: views)
        
        
        let V_Constraint0 = NSLayoutConstraint.constraintsWithVisualFormat("V:|-14-[imageView(40)]->=14@999-[brdr(0.5)]|", options: [], metrics: nil, views: views)
        let V_Constraint1 = NSLayoutConstraint.constraintsWithVisualFormat("V:|-5@999-[label(>=0@700)]-5@999-[brdr(0.5@999)]|", options: [], metrics: nil, views: views)
        let V_Constraint2 = NSLayoutConstraint.constraintsWithVisualFormat("V:|-20-[selectedView(25)]->=20@999-[brdr(0.5)]|", options: [], metrics: nil, views: views)
        
        self.contentView.addConstraints(H_Constraint0)
        self.contentView.addConstraints(H_Constraint1)
        
        self.contentView.addConstraints(V_Constraint0)
        self.contentView.addConstraints(V_Constraint1)
        self.contentView.addConstraints(V_Constraint2)
        
        self.contentView.setNeedsLayout()
        self.contentView.layoutIfNeeded()
        //        self.followLabel.preferredMaxLayoutWidth = self.followLabel.frame.size.width;
        //        self.followLabel.preferredMaxLayoutWidth = self.followLabel.frame.size.width;
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
        
    }
    
    func UpdatePictures(unit:InviteUserUnit,row:Int){
        
        if (row == self.tag){
            if (unit.pictureId == ""){//no picture
                self.profileImageView.image = UIImage(named: "defaultPicture.png")!
            }else{
                if (unit.pictureProgress < 1){ //picture is loading
                    self.profileImageView.backgroundColor = UIColor.groupTableViewBackgroundColor()
                    
                }else{ //picture is loaded
                    self.profileImageView.image = unit.picture
                }
            }
        }
    }
    
    func displaySelected(selected:Bool,animated:Bool){
//        print(selected)
        if selected {
            selectedView.tintColor = ColorFromCode.standardBlueColor()
        } else {
            selectedView.tintColor = UIColor.whiteColor()

        }
    }
    override func prepareForReuse() {
        self.profileImageView.backgroundColor = UIColor.groupTableViewBackgroundColor()
        self.profileImageView.image = UIImage()
        self.selectedView.tintColor = UIColor.whiteColor()

    }

}
