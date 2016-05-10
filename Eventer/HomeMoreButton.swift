//
//  HomeMoreButton.swift
//  Eventer
//
//  Created by Grisha on 14/07/2015.
//  Copyright (c) 2015 Grisha. All rights reserved.
//

import UIKit

class HomeMoreButton: UIButton {

    func initialize(){
        self.tintColor = UIColor.blackColor()
        self.setImage(ImagesCenter.homeMoreImage(false), forState: UIControlState.Normal)
        self.setImage(ImagesCenter.homeMoreImage(true), forState: UIControlState.Highlighted)
    }
    init() {
        super.init(frame: CGRectZero)
        self.tintColor = UIColor.blackColor()
        self.setImage(ImagesCenter.homeMoreImage(false), forState: UIControlState.Normal)
        self.setImage(ImagesCenter.homeMoreImage(true), forState: UIControlState.Highlighted)
    }
    
//    var containerCenterSubview = UIView()
//    var buttonImageView = UIButton()
//    var label = UILabel()
//    var active = false
//    var standardColor = UIColor()
//    
//    var highlightColor:UIColor = ColorFromCode.orangeDateColor()
//    var unhighlightColor:UIColor = UIColor.blackColor()
//
//    var handler:(() -> Void)!
//    
//    init() {
//        super.init(frame: CGRectZero)
//        let backgroundColor = UIColor.whiteColor()
//        
//        self.buttonImageView.tintColor = UIColor.blackColor()
//        self.buttonImageView.setImage(ImagesCenter.homeMoreImage(false), forState: UIControlState.Normal)
//        self.buttonImageView.setImage(ImagesCenter.homeMoreImage(true), forState: UIControlState.Highlighted)
//
//        self.backgroundColor = backgroundColor
//        self.standardColor = backgroundColor
//        label.font = UIFont(name: "Lato-Bold", size: 15)
//        label.textColor = UIColor.whiteColor()
//        label.textAlignment = NSTextAlignment.Center
//        
//        self.translatesAutoresizingMaskIntoConstraints = false
//        self.addSubview(containerCenterSubview)
//        containerCenterSubview.translatesAutoresizingMaskIntoConstraints = false
//        self.addConstraint(NSLayoutConstraint(item: containerCenterSubview, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0))
//        self.addConstraint(NSLayoutConstraint(item: containerCenterSubview, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: self, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0))
//        
//        self.containerCenterSubview.addSubview(buttonImageView)
//        self.containerCenterSubview.addSubview(label)
//        
//        self.label.translatesAutoresizingMaskIntoConstraints = false
//        self.buttonImageView.translatesAutoresizingMaskIntoConstraints = false
//        let s = [
//            "imageView" : buttonImageView,
//            "label" : label
//        ]
//        
//        let sH_Constraints0 = NSLayoutConstraint.constraintsWithVisualFormat("H:|[label]|", options: [], metrics: nil, views: s)
//        let sV_Constraints0 = NSLayoutConstraint.constraintsWithVisualFormat("V:|[imageView]-2@999-[label]|", options: [NSLayoutFormatOptions.AlignAllCenterX], metrics: nil, views: s)
//        
//        self.containerCenterSubview.addConstraints(sH_Constraints0)
//        self.containerCenterSubview.addConstraints(sV_Constraints0)
////        self.exclusiveTouch = true
//        self.setNeedsLayout()
//        self.layoutIfNeeded()
//        //        self.backgroundRectForBounds(self.frame)
//        //        let rec1 = LXTouchGestureRecognizer(),rec2 = LXTouchGestureRecognizer(),rec3 = LXTouchGestureRecognizer(),rec4 = LXTouchGestureRecognizer(),rec5 = LXTouchGestureRecognizer()
//        
//        buttonImageView.addTarget(self, action: "unhighlight", forControlEvents: UIControlEvents.TouchCancel)
//        buttonImageView.addTarget(self, action: "unhighlight", forControlEvents: UIControlEvents.TouchDragOutside)
//        buttonImageView.addTarget(self, action: "highlight", forControlEvents: UIControlEvents.TouchDragInside)
//        buttonImageView.addTarget(self, action: "highlight", forControlEvents: UIControlEvents.TouchDown)
//        buttonImageView.addTarget(self, action: "trigger", forControlEvents: UIControlEvents.TouchUpInside)
//        self.userInteractionEnabled = true
//        self.containerCenterSubview.userInteractionEnabled = true
//        self.setLabelNumber(0)
//        
//    }
////    func setState(active:Bool) {
////        self.active = active
////        self.highlightColor = active ? standardColor : ColorFromCode.orangeDateColor()
////        self.unhighlightColor = active ? ColorFromCode.orangeDateColor() : standardColor
////        self.backgroundColor = unhighlightColor
////    }
//    
//    func handleTap(completionBlock:() -> Void) {
//        self.handler = completionBlock
//    }
//    
//    func trigger() {
//        //        print("trigger")
////        self.setState(!self.active)
//        if self.handler != nil {
//            self.handler()
//        }
//    }
//    func highlight() {
//        print("nigga")
////        self.backgroundColor = self.highlightColor
//    }
//    
//    func unhighlight() {
//        print("nigga")
//
////        self.backgroundColor = self.unhighlightColor
//    }
//    
//    func setLabelNumber(number:Int!) {
//        if number != nil {
//            if number > 0 {
//                self.label.text = "\(number)"
//            } else {
//                self.label.text = ""
//            }
//        }
//    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

}
