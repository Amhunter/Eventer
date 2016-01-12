//
//  HomeLikeButton.swift
//  Eventer
//
//  Created by Grisha on 20/06/2015.
//  Copyright (c) 2015 Grisha. All rights reserved.
//

import UIKit
class HomeLikeButton: UIButton {

    func initialize(isActive:Bool){
        if (isActive){
            self.setImage(UIImage(named: "like-active.png"), forState: UIControlState.Normal)
            self.setImage(UIImage(named: "like.png"), forState: UIControlState.Highlighted)
        }else{
            self.setImage(UIImage(named: "like.png"), forState: UIControlState.Normal)
            self.setImage(UIImage(named: "like-active.png"), forState: UIControlState.Highlighted)
        }
    }
}
