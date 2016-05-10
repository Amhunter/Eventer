//
//  HomeResponseButton.swift
//  Eventer
//
//  Created by Grisha on 20/06/2015.
//  Copyright (c) 2015 Grisha. All rights reserved.
//

import UIKit
class HomeResponseButton: UIButton {    

    func initialize(isActive:Bool){
        if (isActive){
            self.setImage(ImagesCenter.eventGoImage(true), forState: UIControlState.Normal)
            self.setImage(ImagesCenter.eventGoImage(false), forState: UIControlState.Highlighted)
            
        }else{
            self.setImage(ImagesCenter.eventGoImage(false), forState: UIControlState.Normal)
            self.setImage(ImagesCenter.eventGoImage(true), forState: UIControlState.Highlighted)
        }

    }
    


}
