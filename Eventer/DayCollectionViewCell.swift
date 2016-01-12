//
//  DayCellCollectionViewCell.swift
//  GCalendar
//
//  Created by Grisha on 05/11/2014.
//  Copyright (c) 2014 Grisha. All rights reserved.
//

import UIKit

class DayCollectionViewCell: UICollectionViewCell {
    var newEventCircle: UIImageView = UIImageView(frame: CGRectMake(32, 10, 13, 13))
    var dayLabel:UILabel = UILabel(frame: CGRectMake(3, 0, 25, 25))
    var day:Int = Int()
    var month:Int = Int()
    var year:Int = Int()
    var NumberOfEvents:UILabel = UILabel(frame: CGRectMake(3, 33, 50, 17))


    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)

    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(newEventCircle)
        self.addSubview(dayLabel)
        self.addSubview(NumberOfEvents)
        
        NumberOfEvents.textColor = UIColor.darkGrayColor()
        NumberOfEvents.font = UIFont(name: "Helvetica", size: 11)
        
        self.backgroundColor = UIColor.groupTableViewBackgroundColor()
        self.layer.cornerRadius = 10
        
        
    }

}
