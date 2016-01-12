//
//  MiniCommentTableViewCell.swift
//  Eventer
//
//  Created by Grisha on 24/02/2015.
//  Copyright (c) 2015 Grisha. All rights reserved.
//

import UIKit

class MiniCommentTableViewCell: UITableViewCell {

    var commentLabel = TTTAttributedLabel(frame: CGRectZero)
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setSubviews()
    }
    
    func setSubviews(){
        commentLabel.translatesAutoresizingMaskIntoConstraints = false
        commentLabel.numberOfLines = 0
        self.contentView.addSubview(commentLabel)
        
        let views = [
            "commentLabel": commentLabel
        ]

        let H_Constraints0 = NSLayoutConstraint.constraintsWithVisualFormat("H:|-10-[commentLabel]-10@999-|", options: [], metrics: nil, views: views)
        let V_Constraints0 = NSLayoutConstraint.constraintsWithVisualFormat("V:|-5-[commentLabel(>=0@999)]-5-|", options: [], metrics: nil, views: views)
        self.contentView.addConstraints(H_Constraints0)
        self.contentView.addConstraints(V_Constraints0)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
  
    }


}
