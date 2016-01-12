//
//  LoadingIndicatorView.swift
//  Eventer
//
//  Created by Grisha on 06/10/2015.
//  Copyright © 2015 Grisha. All rights reserved.
//

import UIKit

class LoadingIndicatorView: UIView {

    var indicator:UIActivityIndicatorView = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.Gray)
    var button:UIButton = UIButton()
    var isAnimating:Bool = false
    var didAnimateBefore = false
    var usedMoreThan1Time = false
    var disableAfterFirstTime = true
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(indicator)
        self.addSubview(button)
        indicator.frame = frame
        indicator.hidesWhenStopped = true
        button.setTitle("Try again", forState: UIControlState.Normal)
        button.setTitleColor(ColorFromCode.colorWithHexString("#0087D9"), forState: UIControlState.Normal)
        button.setTitleColor(UIColor.blackColor(), forState: UIControlState.Highlighted)
        button.backgroundColor = ColorFromCode.colorWithHexString("#EBF0F2")
        button.titleLabel!.font = UIFont(name: "Lato-Regular", size: 16)
        button.layer.cornerRadius = 7
        button.frame.size = CGSizeMake(200, 40)
        button.center = CGPointMake(frame.midX,frame.midY)
        button.hidden = true
    }
    func startAnimating(){
        button.hidden = true
        self.hidden = false
        isAnimating = true
        indicator.startAnimating()
    }
    
    func stopAnimating(success:Bool){
        if disableAfterFirstTime{
            if usedMoreThan1Time {
                return
            }
        }

        self.hidden = success
        self.button.hidden = success
        isAnimating = false
        indicator.stopAnimating()
        usedMoreThan1Time = success
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
