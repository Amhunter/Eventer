//
//  HashtagTableViewCell.swift
//  Eventer
//
//  Created by Grisha on 20/04/2015.
//  Copyright (c) 2015 Grisha. All rights reserved.
//

import UIKit

class HashtagTableViewCell: UITableViewCell {
    var hashtagNameLabel:UILabel = UILabel(frame: CGRectMake(5, 5, 200, 40))
    var countLabel:UILabel = UILabel(frame: CGRectMake(210, 5, 100, 40))
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        //self.frame = CGRectMake(0, 0, 320, 60)
        hashtagNameLabel.numberOfLines = 0
        hashtagNameLabel.font = UIFont(name: "Helvetica", size: 16)
        hashtagNameLabel.textColor = UIColor.blackColor()
        
        countLabel.numberOfLines = 0
        countLabel.font = UIFont(name: "Helvetica", size: 16)
        countLabel.textColor = UIColor.lightGrayColor()
        

        self.addSubview(hashtagNameLabel)
        self.addSubview(countLabel)

        
        
        
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        fatalError("init(coder:) has not been implemented")
        
    }

}
