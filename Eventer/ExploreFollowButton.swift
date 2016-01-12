//
//  ExploreFollowButton.swift
//  Eventer
//
//  Created by Grisha on 26/07/2015.
//  Copyright (c) 2015 Grisha. All rights reserved.
//

import UIKit

class ExploreFollowButton: UIButton {
    func initialize(isActive:Bool, isLoaded:Bool){
        if (isLoaded){
            self.userInteractionEnabled = true
            self.backgroundColor = UIColor.clearColor()
            if (isActive){
                self.setImage(UIImage(named: "following.png"), forState: UIControlState.Normal)
                self.setImage(UIImage(named: "follow.png"), forState: UIControlState.Highlighted)
            }else{
                self.setImage(UIImage(named: "follow.png"), forState: UIControlState.Normal)
                self.setImage(UIImage(named: "following.png"), forState: UIControlState.Highlighted)
            }
        }else{
            self.userInteractionEnabled = false
            self.backgroundColor = UIColor.grayColor()
        }

    }
}
