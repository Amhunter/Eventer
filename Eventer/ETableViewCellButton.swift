//
//  ETableViewCellButton.swift
//  Eventer
//
//  Created by Grisha on 05/03/2016.
//  Copyright © 2016 Grisha. All rights reserved.
//

import UIKit
extension UIButton {
    func setBackgroundColor(color: UIColor, forState: UIControlState) {
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        CGContextSetFillColorWithColor(UIGraphicsGetCurrentContext(), color.CGColor)
        CGContextFillRect(UIGraphicsGetCurrentContext(), CGRect(x: 0, y: 0, width: 1, height: 1))
        let colorImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        self.setBackgroundImage(colorImage, forState: forState)
    }
}

class ETableViewCellButton: UIView {
    var containerCenterSubview = UIView()
    var buttonImageView = UIImageView()
    var label = UILabel()
    var active = false
    var standardColor = UIColor()
    
    var highlightColor:UIColor!
    var unhighlightColor:UIColor!
    
    init(withButtonImage:UIImage, backgroundColor:UIColor) {
        super.init(frame: CGRectZero)
        self.buttonImageView.tintColor = UIColor.whiteColor()
        self.buttonImageView.image = withButtonImage
        self.backgroundColor = backgroundColor
        self.standardColor = backgroundColor
        label.font = UIFont(name: "Lato-Bold", size: 15)
        label.textColor = UIColor.whiteColor()
        label.textAlignment = NSTextAlignment.Center
        
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
        let sV_Constraints0 = NSLayoutConstraint.constraintsWithVisualFormat("V:|[imageView]-2@999-[label]|", options: [NSLayoutFormatOptions.AlignAllCenterX], metrics: nil, views: s)
        
        self.containerCenterSubview.addConstraints(sH_Constraints0)
        self.containerCenterSubview.addConstraints(sV_Constraints0)
        self.exclusiveTouch = true
        self.setNeedsLayout()
        self.layoutIfNeeded()
//        self.backgroundRectForBounds(self.frame)
        let rec1 = LXTouchGestureRecognizer(),rec2 = LXTouchGestureRecognizer(),rec3 = LXTouchGestureRecognizer(),rec4 = LXTouchGestureRecognizer(),rec5 = LXTouchGestureRecognizer()
        
        rec1.addTarget(self, action: "unhighlight", forControlEvents: UIControlEvents.TouchCancel)
        rec2.addTarget(self, action: "unhighlight", forControlEvents: UIControlEvents.TouchDragOutside)
        rec3.addTarget(self, action: "highlight", forControlEvents: UIControlEvents.TouchDragInside)
        rec4.addTarget(self, action: "highlight", forControlEvents: UIControlEvents.TouchDown)
        rec5.addTarget(self, action: "trigger", forControlEvents: UIControlEvents.TouchUpInside)
        
        self.addGestureRecognizer(rec1)
        self.addGestureRecognizer(rec2)
        self.addGestureRecognizer(rec3)
        self.addGestureRecognizer(rec4)
        self.addGestureRecognizer(rec5)

    }
    func setState(active:Bool) {
        self.active = active
        self.highlightColor = active ? standardColor : ColorFromCode.orangeDateColor()
        self.unhighlightColor = active ? ColorFromCode.orangeDateColor() : standardColor
        self.backgroundColor = unhighlightColor
    }
    
//    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
//        super.touchesBegan(touches, withEvent: event)
//        print("touched")
//    }
//    
//    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
//        super.touchesEnded(touches, withEvent: event)
//        print("touch ended")
//    }
//    
//    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
//        super.touchesCancelled(touches, withEvent: event)
//        print("touch cancelled")
//    }
//    
    
    func trigger() {
        self.setState(!self.active)
        print("trigger")
    }
    func highlight() {
        self.backgroundColor = self.highlightColor
    }
    
    func unhighlight() {
        self.backgroundColor = self.unhighlightColor
    }
    
    func setLabelNumber(number:Int!) {
        if number != nil {
            self.label.text = "\(number)"
        }
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
