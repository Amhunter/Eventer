//
//  EventDatePickerCalendarWeekdayCell.swift
//  Eventer
//
//  Created by Grisha on 19/09/2015.
//  Copyright (c) 2015 Grisha. All rights reserved.
//

import UIKit

class EventDatePickerCalendarWeekdayCell: UICollectionViewCell {
    var weekDayLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.weekDayLabel.translatesAutoresizingMaskIntoConstraints = false
        
        self.contentView.addSubview(weekDayLabel)
        
        let views = [
            "weekDayLabel" : weekDayLabel,
        ]
        
        let H_Constraints0 = NSLayoutConstraint.constraintsWithVisualFormat("H:|[weekDayLabel]|", options: [], metrics: nil, views: views)
        let V_Constraints0 = NSLayoutConstraint.constraintsWithVisualFormat("V:|[weekDayLabel]|", options: [], metrics: nil, views: views)
        
        self.contentView.addConstraints(H_Constraints0)
        self.contentView.addConstraints(V_Constraints0)
        
        
        self.backgroundColor = ColorFromCode.colorWithHexString("#02A8F3")
        
        self.weekDayLabel.textColor = UIColor.whiteColor()
        self.weekDayLabel.numberOfLines = 1
        self.weekDayLabel.textAlignment = NSTextAlignment.Center
        self.weekDayLabel.font = UIFont(name: "Lato-Semibold", size: 16)
        self.weekDayLabel.backgroundColor = UIColor.clearColor()
        
        
    }
    
    func setWeekDay(weekDay:Int) {
        var val = weekDay + 2
        if weekDay == 6 {
            val = 1
        }
        self.weekDayLabel.text = DateToStringConverter.weekDayInText(val, shorten: true)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
}
