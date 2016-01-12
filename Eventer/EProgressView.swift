//
//  EProgressView.swift
//  Eventer
//
//  Created by Grisha on 06/08/2015.
//  Copyright (c) 2015 Grisha. All rights reserved.
//

import UIKit

class EProgressView: UIView {
    var progressCircle:UIButton = UIButton()
    func initProgressView(){
        self.addSubview(progressCircle)
        let side:CGFloat = 75
        progressCircle.frame.origin.x = (self.frame.width/2)-(side/2)
        progressCircle.frame.origin.y = (self.frame.height/2)-(side/2)


        progressCircle.layer.masksToBounds = true
        progressCircle.frame.size = CGSizeMake(side, side)
        progressCircle.layer.cornerRadius = side/2
        progressCircle.alpha = 1
        progressCircle.backgroundColor = UIColor.whiteColor()
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