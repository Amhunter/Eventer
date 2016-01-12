//
//  ActivityResponseButton.swift
//  Eventer
//
//  Created by Grisha on 11/06/2015.
//  Copyright (c) 2015 Grisha. All rights reserved.
//

import UIKit

class ResponseButton: UIButton {

    var content:NSString = "" // yes no maybe
    
    func setActive(active:Bool){
        if content == "yes" {
            if active {
                self.setImage(UIImage(named: "event-accept-active"), forState: UIControlState.Normal)
                self.setImage(UIImage(named: "event-accept"), forState: UIControlState.Highlighted)
            } else {
                self.setImage(UIImage(named: "event-accept"), forState: UIControlState.Normal)
                self.setImage(UIImage(named: "event-accept-active"), forState: UIControlState.Highlighted)
            }
        }else if content == "maybe" {
            if active {
                self.setImage(UIImage(named: "event-maybe-going-active"), forState: UIControlState.Normal)
                self.setImage(UIImage(named: "event-maybe-going"), forState: UIControlState.Highlighted)
            } else {
                self.setImage(UIImage(named: "event-maybe-going"), forState: UIControlState.Normal)
                self.setImage(UIImage(named: "event-maybe-going-active"), forState: UIControlState.Highlighted)
            }
        }else if content == "no" {
            if active {
                self.setImage(UIImage(named: "event-not-going-active"), forState: UIControlState.Normal)
                self.setImage(UIImage(named: "event-not-going"), forState: UIControlState.Highlighted)
            } else {
                self.setImage(UIImage(named: "event-not-going"), forState: UIControlState.Normal)
                self.setImage(UIImage(named: "event-not-going-active"), forState: UIControlState.Highlighted)
            }
        }
    }

}
