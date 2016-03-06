//
//  CommentTextView.swift
//  Eventer
//
//  Created by Grisha on 13/04/2015.
//  Copyright (c) 2015 Grisha. All rights reserved.
//

import UIKit

class CommentTextView: UITextView {
    var isEmpty:Bool
    var newNumberOfLines:CGFloat = CGFloat()
    var previousNumberOfLines:CGFloat = CGFloat()
    required init?(coder aDecoder: NSCoder) {
        self.isEmpty = true
        super.init(coder: aDecoder)
        self.layer.cornerRadius = 3
        self.backgroundColor = UIColor.whiteColor()
        self.editable = true
        self.selectable = true
        self.font = UIFont(name: "Helvetica", size: 15)
        self.userInteractionEnabled = true
        self.textContainerInset = UIEdgeInsetsMake(5, 5, 5, 5)
        putPlaceHolder()
        //sds
    }
    

    //used for posting comments
    override init(frame: CGRect, textContainer: NSTextContainer?) {
        self.isEmpty = true
        super.init(frame: frame, textContainer: textContainer)
        self.layer.cornerRadius = 3
        self.backgroundColor = UIColor.whiteColor()
        self.editable = true
        self.selectable = true
        self.font = UIFont(name: "Helvetica", size: 15)
        self.userInteractionEnabled = true
        self.textContainerInset = UIEdgeInsetsMake(5, 5, 5, 5)
        putPlaceHolder()
    }

//    override func paste(sender: AnyObject?) {
//        super.paste(sender)
//        println("Paste")
//        if (self.contentSize.height/self.font.lineHeight < 6){
//            self.newNumberOfLines  = self.contentSize.height / self.font.lineHeight
//        }else{
//            self.newNumberOfLines = 5
//        }
//    }
    func putPlaceHolder(){
        self.isEmpty = true
        self.text = "Comment text here..."
        self.textColor = UIColor.lightGrayColor()
    }
}
