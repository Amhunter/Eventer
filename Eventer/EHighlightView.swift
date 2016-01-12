//
//  EHighlightView.swift
//  Eventer
//
//  Created by Grisha on 26/07/2015.
//  Copyright (c) 2015 Grisha. All rights reserved.
//

import UIKit

class EHighlightView: UIView {
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.alpha = 0.65
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.alpha = 1
    }
    override func touchesCancelled(touches: Set<UITouch>?, withEvent event: UIEvent?) {
        self.alpha = 1

    }
}
