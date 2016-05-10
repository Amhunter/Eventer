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
            self.setImage(ImagesCenter.eventLikeImage(true), forState: UIControlState.Normal)
            self.setImage(ImagesCenter.eventLikeImage(false), forState: UIControlState.Highlighted)
        }else{
            self.setImage(ImagesCenter.eventLikeImage(false), forState: UIControlState.Normal)
            self.setImage(ImagesCenter.eventLikeImage(true), forState: UIControlState.Highlighted)
        }
    }
}
