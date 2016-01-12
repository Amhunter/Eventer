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
            self.setImage(UIImage(named: "share-active.png"), forState: UIControlState.Normal)
            self.setImage(UIImage(named: "share.png"), forState: UIControlState.Highlighted)
        }else{
            self.setImage(UIImage(named: "share.png"), forState: UIControlState.Normal)
            self.setImage(UIImage(named: "share-active.png"), forState: UIControlState.Highlighted)
        }
    }
    
}
