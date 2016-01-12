//
//  CommentTableViewCell.swift
//  Eventer
//
//  Created by Grisha on 09/09/2015.
//  Copyright (c) 2015 Grisha. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {
    var usernameLabel = TTTAttributedLabel(frame: CGRectZero)
    var pictureImageView = UIImageView()
    var commentLabel = TTTAttributedLabel(frame: CGRectZero)
    var createdAtLabel = UILabel()
    var textFont = UIFont(name: "Lato-Regular", size: 13)
    var usernameFont = UIFont(name: "Lato-Medium", size: 13)
    var border:UIView = UIView()

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.frame.size.width = UIScreen.mainScreen().bounds.width
        self.contentView.addSubview(usernameLabel)
        self.contentView.addSubview(pictureImageView)
        self.contentView.addSubview(commentLabel)
        self.contentView.addSubview(createdAtLabel)
        self.contentView.addSubview(border)

        usernameLabel.translatesAutoresizingMaskIntoConstraints = false
        pictureImageView.translatesAutoresizingMaskIntoConstraints = false
        commentLabel.translatesAutoresizingMaskIntoConstraints = false
        createdAtLabel.translatesAutoresizingMaskIntoConstraints = false
        border.translatesAutoresizingMaskIntoConstraints = false
        let views = [
            "usernameLabel" : usernameLabel,
            "pictureImageView": pictureImageView,
            "commentLabel": commentLabel,
            "createdAtLabel": createdAtLabel,
            "border": border
        ]
        
        let H_Constraints0 = NSLayoutConstraint.constraintsWithVisualFormat("H:|-10@999-[pictureImageView(32.5@999)]-10@999-[usernameLabel]-5@999-[createdAtLabel(>=0@999)]-10@999-|", options: [], metrics: nil, views: views)
        let H_Constraints1 = NSLayoutConstraint.constraintsWithVisualFormat("H:|-52.5@999-[commentLabel(>=0@700)]-10@999-|", options: [], metrics: nil, views: views)
        let H_Constraints2 = NSLayoutConstraint.constraintsWithVisualFormat("H:|[border]|", options: [], metrics: nil, views: views)

        let V_Constraints0 = NSLayoutConstraint.constraintsWithVisualFormat("V:|-5@999-[usernameLabel(>=0@999)]-5-[commentLabel(>=0@999)]-10@999-[border(0.5@999)]|", options: [], metrics: nil, views: views)
        let V_Constraints1 = NSLayoutConstraint.constraintsWithVisualFormat("V:|-5@999-[createdAtLabel(==usernameLabel@999)]-5-[commentLabel(>=0@999)]-10@999-[border(0.5@999)]|", options: [], metrics: nil, views: views)
        let V_Constraints2 = NSLayoutConstraint.constraintsWithVisualFormat("V:|-10@999-[pictureImageView(32.5@999)]->=10@999-[border(0.5@999)]|", options: [], metrics: nil, views: views)


        self.contentView.addConstraints(H_Constraints0)
        self.contentView.addConstraints(H_Constraints1)
        self.contentView.addConstraints(H_Constraints2)
        self.contentView.addConstraints(V_Constraints0)
        self.contentView.addConstraints(V_Constraints1)
        self.contentView.addConstraints(V_Constraints2)
        
        border.backgroundColor = ColorFromCode.colorWithHexString("#DAE4E7")

        createdAtLabel.numberOfLines = 1
        createdAtLabel.font = UIFont(name: "Lato-Medium", size: 13)
        createdAtLabel.textColor = UIColor.lightGrayColor()
        createdAtLabel.textAlignment = NSTextAlignment.Right
        
        var attrs = [NSForegroundColorAttributeName: UIColor.blackColor()]

        usernameLabel.textColor = ColorFromCode.colorWithHexString("#0087D9")
        usernameLabel.activeLinkAttributes = attrs
        usernameLabel.font = UIFont(name: "Lato-Medium", size: 13)
        usernameLabel.verticalAlignment = TTTAttributedLabelVerticalAlignment.Top
        usernameLabel.numberOfLines = 2
        commentLabel.numberOfLines = 0
        //commentLabel.font = UIFont(name: "Lato-Regular", size: 13)
        //commentLabel.textColor = ColorFromCode.colorWithHexString("#9A9A9A")
        commentLabel.activeLinkAttributes = [NSForegroundColorAttributeName: UIColor.blackColor()]
        pictureImageView.backgroundColor = UIColor.groupTableViewBackgroundColor()
        pictureImageView.layer.masksToBounds = true //without it its not gonna work
        pictureImageView.userInteractionEnabled = true
        pictureImageView.layer.cornerRadius = 32.5/2
        
        attrs = [NSForegroundColorAttributeName: ColorFromCode.orangeFollowColor()]
        commentLabel.activeLinkAttributes = attrs
        self.setNeedsLayout()
        self.layoutIfNeeded()


    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    func UpdateProfilePicture(id:String, progress:Double, image:UIImage!, row:Int){
        dispatch_async(dispatch_get_main_queue(), {
            () -> Void in
            if (row == self.tag){
                if (id == ""){//no picture
                }else{
                    if (progress < 1){ //picture is loading
                    }else{ //picture is loaded
                        self.pictureImageView.image = image
                    }
                }
            }
        })
    }
    
    override func prepareForReuse() {

        //self.usernameLabel.links = nil
        self.commentLabel.setText(nil)
        self.createdAtLabel.text = ""
        self.pictureImageView.image = nil
    }

}
