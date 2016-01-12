//
//  EventDatePickerCalendarCell.swift
//  Eventer
//
//  Created by Grisha on 19/09/2015.
//  Copyright (c) 2015 Grisha. All rights reserved.
//

import UIKit

class EventDatePickerCalendarCell: UICollectionViewCell {
    var dayLabel = UILabel()

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.dayLabel.translatesAutoresizingMaskIntoConstraints = false

        self.contentView.addSubview(dayLabel)
        
        let views = [
            "dayLabel" : dayLabel,
        ]
        
        let H_Constraints0 = NSLayoutConstraint.constraintsWithVisualFormat("H:|[dayLabel]-10@999-|", options: [], metrics: nil, views: views)
        let V_Constraints0 = NSLayoutConstraint.constraintsWithVisualFormat("V:|[dayLabel(30@999)]->=0@999-|", options: [], metrics: nil, views: views)
        
        self.contentView.addConstraints(H_Constraints0)
        self.contentView.addConstraints(V_Constraints0)

        
        self.backgroundColor = ColorFromCode.colorWithHexString("#02A8F3")
        
        self.dayLabel.textColor = UIColor.whiteColor()
        self.dayLabel.numberOfLines = 1
        self.dayLabel.textAlignment = NSTextAlignment.Right
        self.dayLabel.font = UIFont(name: "Lato-Semibold", size: 16)
        self.dayLabel.backgroundColor = UIColor.clearColor()
        
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    

}
