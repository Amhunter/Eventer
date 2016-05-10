//
//  HomeShareButton.swift
//  Eventer
//
//  Created by Grisha on 20/06/2015.
//  Copyright (c) 2015 Grisha. All rights reserved.
//

import UIKit

class HomeShareButton: UIButton {
    
    
    func initialize(isActive:Bool){
        if (isActive){
            self.setImage(ImagesCenter.eventShareImage(true), forState: UIControlState.Normal)
            self.setImage(ImagesCenter.eventShareImage(false), forState: UIControlState.Highlighted)
        }else{
            self.setImage(ImagesCenter.eventShareImage(false), forState: UIControlState.Normal)
            self.setImage(ImagesCenter.eventShareImage(true), forState: UIControlState.Highlighted)

        }
        
    }
    

}
