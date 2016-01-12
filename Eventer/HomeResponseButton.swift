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
            self.setImage(UIImage(named: "going-active.png"), forState: UIControlState.Normal)
            self.setImage(UIImage(named: "going.png"), forState: UIControlState.Highlighted)
        }else{
            self.setImage(UIImage(named: "going.png"), forState: UIControlState.Normal)
            self.setImage(UIImage(named: "going-active.png"), forState: UIControlState.Highlighted)

        }

    }
    


}
