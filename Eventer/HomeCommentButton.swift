//
//  HomeCommentButton.swift
//  Eventer
//
//  Created by Grisha on 14/03/2016.
//  Copyright © 2016 Grisha. All rights reserved.
//

import UIKit

class HomeCommentButton: UIView {
    
//    func initialize(){
//        self.tintColor = ColorFromCode.colorWithHexString("#0069B2")
//        self.setImage(ImagesCenter.homeCommentImage(false), forState: UIControlState.Normal)
//        self.setImage(ImagesCenter.homeCommentImage(true), forState: UIControlState.Highlighted)
//    }
    
    
    
    var containerCenterSubview = UIButton()
    var buttonImageView = UIButton()
    var label = UILabel()
    var standardColor = UIColor()
    
    var highlightColor:UIColor!
    var unhighlightColor:UIColor!
    var handler:(() -> Void)!
    
    init() {
        super.init(frame: CGRectZero)
        self.standardColor = ColorFromCode.colorWithHexString("#0069B2")
        self.highlightColor = ColorFromCode.orangeDateColor()
        self.unhighlightColor = standardColor
        self.buttonImageView.tintColor = standardColor
        self.buttonImageView.setImage(ImagesCenter.homeCommentImage(false), forState: UIControlState.Normal)
//        self.buttonImageView.image =
        label.font = UIFont(name: "Lato-Bold", size: 15)
        label.textColor = standardColor
        label.textAlignment = NSTextAlignment.Center
        buttonImageView.userInteractionEnabled = false
        label.userInteractionEnabled = false
        self.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(containerCenterSubview)
        containerCenterSubview.translatesAutoresizingMaskIntoConstraints = false
        self.addConstraint(NSLayoutConstraint(item: containerCenterSubview, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0))
        self.addConstraint(NSLayoutConstraint(item: containerCenterSubview, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0))
        
        self.containerCenterSubview.addSubview(buttonImageView)
        self.containerCenterSubview.addSubview(label)
        
        self.label.translatesAutoresizingMaskIntoConstraints = false
        self.buttonImageView.translatesAutoresizingMaskIntoConstraints = false
        let s = [
            "imageView" : buttonImageView,
            "label" : label
        ]
        
        let sH_Constraints0 = NSLayoutConstraint.constraintsWithVisualFormat("H:|[label]|", options: [], metrics: nil, views: s)
        let sV_Constraints0 = NSLayoutConstraint.constraintsWithVisualFormat("V:|[imageView]-1@999-[label]|", options: [NSLayoutFormatOptions.AlignAllCenterX], metrics: nil, views: s)
        
        self.containerCenterSubview.addConstraints(sH_Constraints0)
        self.containerCenterSubview.addConstraints(sV_Constraints0)

        self.setNeedsLayout()
        self.layoutIfNeeded()
        
        containerCenterSubview.addTarget(self, action: #selector(unhighlight), forControlEvents: UIControlEvents.TouchCancel)
        containerCenterSubview.addTarget(self, action: #selector(unhighlight), forControlEvents: UIControlEvents.TouchDragOutside)
        containerCenterSubview.addTarget(self, action: #selector(highlight), forControlEvents: UIControlEvents.TouchDragInside)
        containerCenterSubview.addTarget(self, action: #selector(highlight), forControlEvents: UIControlEvents.TouchDown)
        containerCenterSubview.addTarget(self, action: #selector(trigger), forControlEvents: UIControlEvents.TouchUpInside)
        
    }
    func handleTap(completionBlock:() -> Void) {
        self.handler = completionBlock
    }
    
    func trigger() {
        //        print("trigger")
        unhighlight()
        if self.handler != nil {
            self.handler()
        }
    }
    func highlight() {
        self.label.textColor = self.highlightColor
        self.buttonImageView.setImage(ImagesCenter.homeCommentImage(true), forState: UIControlState.Normal)
    }
    
    func unhighlight() {
        self.label.textColor = self.unhighlightColor
        self.buttonImageView.setImage(ImagesCenter.homeCommentImage(false), forState: UIControlState.Normal)

    }
    
    func setLabelNumber(number:Int!) {
        if number != nil {
            if number > 0 {
                self.label.text = "\(number)"
            } else {
                self.label.text = ""
            }
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
