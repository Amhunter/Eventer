//
//  HomeMoreButton.swift
//  Eventer
//
//  Created by Grisha on 14/07/2015.
//  Copyright (c) 2015 Grisha. All rights reserved.
//

import UIKit

class HomeMoreButton: UIButton {

    func initialize(){
            self.setImage(UIImage(named: "more.png"), forState: UIControlState.Normal)
            self.setImage(UIImage(named: "more-active.png"), forState: UIControlState.Highlighted)
    }
}
