//
//  ETableView.swift
//  Eventer
//
//  Created by Grisha on 01/08/2015.
//  Copyright (c) 2015 Grisha. All rights reserved.
//

import UIKit

class ETableView: UITableView {
    var barMoving:Bool = false
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
//    func handlePan(sender:UIPanGestureRecognizer){
//        if (self.scrollableView != nil) {
//            [self.navigationController.navigationBar bringSubviewToFront:self.overlay];
//        }
//        
//        CGPoint translation = [gesture translationInView:[self.scrollableView superview]];
//        float delta = self.lastContentOffset - translation.y;
//        self.lastContentOffset = translation.y;
//        
//        if ([self checkRubberbanding:delta]) {
//            [self scrollWithDelta:delta];
//        }
//        
//        if ([gesture state] == UIGestureRecognizerStateEnded || [gesture state] == UIGestureRecognizerStateCancelled) {
//            // Reset the nav bar if the scroll is partial
//            [self checkForPartialScroll];
//            [self checkForHeaderPartialScroll];
//            self.lastContentOffset = 0;
//        }
//    }
}
