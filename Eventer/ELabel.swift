//
//  ELabel.swift
//  Eventer
//
//  Created by Grisha on 26/07/2015.
//  Copyright (c) 2015 Grisha. All rights reserved.
//

import UIKit

enum ETextAlignment {
    case top
    case bottom
}

class ELabel: UILabel {
    var alignment = ETextAlignment.bottom
    override func drawTextInRect(rect: CGRect) {
        var newRect = rect
        if (alignment == ETextAlignment.top){
            newRect.size.height = self.sizeThatFits(rect.size).height
        }else if (alignment == ETextAlignment.bottom){
            let height = self.sizeThatFits(rect.size).height
            newRect.origin.y += newRect.size.height - height
            newRect.size.height = height
        }
        super.drawTextInRect(rect)
    }
//    func insertAndAlignText(withText:NSString){
//        self.setNeedsLayout()
//        self.layoutIfNeeded()
//        var height = withText.sizeWithAttributes([NSFontAttributeName: self.font]).height
//        if (alignment == ETextAlignment.top){
//            self.frame.size.height = height
//        }else if (alignment == ETextAlignment.bottom){
//            self.frame.origin.y += self.frame.size.height - height
//            self.frame.size.height = height
//        }
//
//    }


}
