    //
//  WeekDayCellCollectionViewCell.swift
//  GCalendar
//
//  Created by Grisha on 13/11/2014.
//  Copyright (c) 2014 Grisha. All rights reserved.
//

import UIKit

class WeekDayCollectionViewCell: UICollectionViewCell {
    var Day:UILabel = UILabel(frame: CGRectMake(0,0,50,50))
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)

        
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.lightGrayColor()
        Day.textColor = UIColor.blackColor()
        Day.textAlignment = NSTextAlignment.Center
        Day.font = UIFont(name: "Helvetica", size: 16)
        self.addSubview(Day)
        self.layer.cornerRadius = 10
    }
    
}
