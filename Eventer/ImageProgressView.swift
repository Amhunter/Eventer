//
//  ImageProgressView.swift
//  Eventer
//
//  Created by Grisha on 07/09/2015.
//  Copyright (c) 2015 Grisha. All rights reserved.
//

import UIKit

class ImageProgressView: UIImageView {

    var progressCircle:UIButton = UIButton()

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    init() {
        super.init(frame: CGRectZero)
        let side:CGFloat = 75
        self.backgroundColor = ColorFromCode.standardBlueColor()

        progressCircle.layer.masksToBounds = true
        progressCircle.frame.size = CGSizeMake(side, side)
        progressCircle.layer.cornerRadius = side/2
        progressCircle.alpha = 1
        progressCircle.backgroundColor = UIColor.whiteColor()
    }
    func updateView(image:UIImage!, showProgress:Bool){
        if image == nil {
            self.image = nil
            if showProgress {
                self.addSubview(progressCircle)
                let side:CGFloat = 75
                progressCircle.frame.origin.x = (self.frame.width/2)-(side/2)
                progressCircle.frame.origin.y = (self.frame.height/2)-(side/2)
            }else{
                self.progressCircle.removeFromSuperview()
            }
        } else {
            self.progressCircle.removeFromSuperview()
            self.image = image
        }
    }
    
    func updateProgress(progress:Double){
        if (progress < 0){
            progressCircle.alpha = 1
            progressCircle.backgroundColor = UIColor.clearColor()
            progressCircle.setImage(UIImage(named: "refresh-big.png"), forState: UIControlState.Normal)
            progressCircle.enabled = true
        }else{
            if (progressCircle.backgroundColor != UIColor.whiteColor()){
                progressCircle.backgroundColor = UIColor.whiteColor()
            }
            progressCircle.enabled = false
            progressCircle.alpha = 1-CGFloat(progress)
            progressCircle.setImage(UIImage(), forState: UIControlState.Normal)
        }
    }

}
