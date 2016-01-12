//
//  EventDatePickerViewCell.swift
//  Eventer
//
//  Created by Grisha on 14/09/2015.
//  Copyright (c) 2015 Grisha. All rights reserved.
//

import UIKit

class EventDatePickerViewCell: UICollectionViewCell {

    var dayLabel = UILabel()
    var weekDayLabel = UILabel()
    var leftBorder = UIView()
    var rightBorder = UIView()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.dayLabel.translatesAutoresizingMaskIntoConstraints = false
        self.weekDayLabel.translatesAutoresizingMaskIntoConstraints = false
        self.leftBorder.translatesAutoresizingMaskIntoConstraints = false
        self.rightBorder.translatesAutoresizingMaskIntoConstraints = false
        self.contentView.addSubview(dayLabel)
        self.contentView.addSubview(weekDayLabel)
        self.contentView.addSubview(leftBorder)
        self.contentView.addSubview(rightBorder)

        let views = [
            "dayLabel" : dayLabel,
            "weekdayLabel" : weekDayLabel,
            "left": leftBorder,
            "right": rightBorder
        ]
        
        let H_Constraints0 = NSLayoutConstraint.constraintsWithVisualFormat("H:|[left(0.5@999)][dayLabel]-10@999-[right(0.5@999)]|", options: [], metrics: nil, views: views)
        let H_Constraints1 = NSLayoutConstraint.constraintsWithVisualFormat("H:|[left(0.5@999)][weekdayLabel][right(0.5@999)]|", options: [], metrics: nil, views: views)
        let V_Constraints0 = NSLayoutConstraint.constraintsWithVisualFormat("V:|[dayLabel(30@999)][weekdayLabel(>=0@999)]-10@999-|", options: [], metrics: nil, views: views)
        let V_Constraints1 = NSLayoutConstraint.constraintsWithVisualFormat("V:|[left]|", options: [], metrics: nil, views: views)
        let V_Constraints2 = NSLayoutConstraint.constraintsWithVisualFormat("V:|[right]|", options: [], metrics: nil, views: views)

        self.contentView.addConstraints(H_Constraints0)
        self.contentView.addConstraints(H_Constraints1)
        self.contentView.addConstraints(V_Constraints0)
        self.contentView.addConstraints(V_Constraints1)
        self.contentView.addConstraints(V_Constraints2)

        self.backgroundColor = ColorFromCode.colorWithHexString("#02A8F3")
        
        self.dayLabel.textColor = UIColor.whiteColor()
        self.dayLabel.numberOfLines = 1
        self.dayLabel.textAlignment = NSTextAlignment.Right
        self.dayLabel.font = UIFont(name: "Lato-Semibold", size: 16)
        self.dayLabel.backgroundColor = UIColor.clearColor()
        
        self.weekDayLabel.textColor = UIColor.whiteColor()
        self.weekDayLabel.numberOfLines = 0
        self.weekDayLabel.font = UIFont(name: "Lato-Semibold", size: 16)
        self.weekDayLabel.textAlignment = NSTextAlignment.Center
        self.weekDayLabel.backgroundColor = UIColor.clearColor()
        
        self.leftBorder.backgroundColor = UIColor.whiteColor()
        self.rightBorder.backgroundColor = UIColor.whiteColor()

        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    

//    
//    override func prepareForReuse() {
//        super.prepareForReuse()
//        //        self.EventDescription.text = ""
//        //self.eventNameLabel.text = ""
//        self.imageView.backgroundColor = UIColor.groupTableViewBackgroundColor()
//        self.imageView.image = UIImage()
//    }


}
