//
//  SearchUsersTableViewCell.swift
//  Eventer
//
//  Created by Grisha on 13/10/2015.
//  Copyright © 2015 Grisha. All rights reserved.
//

import UIKit

class SearchUsersTableViewCell: UITableViewCell {

    var profileImageView:EImageView = EImageView()
    var label:TTTAttributedLabel = TTTAttributedLabel(frame: CGRectZero)
    
    var usernameFont = UIFont(name: "Lato-Regular", size: 14)
    var fullnameFont = UIFont(name: "Lato-Semibold", size: 14)
    
    //var followLabel:UILabel = UILabel(frame: CGRectMake(50, 5, 220, 30))
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.frame.size.width = UIScreen.mainScreen().bounds.width
        
        self.contentView.addSubview(profileImageView)
        self.contentView.addSubview(label)
        
        profileImageView.translatesAutoresizingMaskIntoConstraints = false
        label.translatesAutoresizingMaskIntoConstraints = false
        
        label.numberOfLines = 0
        label.font = UIFont(name: "Lato-Medium", size: 14)
        label.textColor = ColorFromCode.colorWithHexString("#9A9A9A")
        label.activeLinkAttributes = [NSForegroundColorAttributeName: UIColor.blackColor()]
        

        
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
            "brdr": border
        ]
        //        var metrics = [
        //        ]
        
        let H_Constraint0 = NSLayoutConstraint.constraintsWithVisualFormat("H:|-11-[imageView(40)]-10-[label(>=0)]-30@999-|", options: [], metrics: nil, views: views)
        let H_Constraint1 = NSLayoutConstraint.constraintsWithVisualFormat("H:|[brdr]|", options: [], metrics: nil, views: views)
        
        
        let V_Constraint0 = NSLayoutConstraint.constraintsWithVisualFormat("V:|-14-[imageView(40)]->=14@999-[brdr(0.5)]|", options: [], metrics: nil, views: views)
        let V_Constraint1 = NSLayoutConstraint.constraintsWithVisualFormat("V:|-5@999-[label(>=0@700)]-5@999-[brdr(0.5@999)]|", options: [], metrics: nil, views: views)
        
        self.contentView.addConstraints(H_Constraint0)
        self.contentView.addConstraints(H_Constraint1)
        
        self.contentView.addConstraints(V_Constraint0)
        self.contentView.addConstraints(V_Constraint1)
        
        self.contentView.setNeedsLayout()
        self.contentView.layoutIfNeeded()
        //        self.followLabel.preferredMaxLayoutWidth = self.followLabel.frame.size.width;
        //        self.followLabel.preferredMaxLayoutWidth = self.followLabel.frame.size.width;
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
        
    }
    func UpdatePictures(user:FetchedUser,row:Int){
        
        if (row == self.tag){
            if (user.pictureId == ""){//no picture
                self.profileImageView.image = UIImage(named: "defaultPicture.png")!
            }else{
                if (user.pictureProgress < 1){ //picture is loading
                    self.profileImageView.backgroundColor = UIColor.groupTableViewBackgroundColor()
                    
                }else{ //picture is loaded
                    self.profileImageView.image = user.picture
                }
            }
        }
    }
    override func prepareForReuse() {
        self.profileImageView.backgroundColor = UIColor.groupTableViewBackgroundColor()
        self.profileImageView.image = UIImage()
        
    }

    




}
