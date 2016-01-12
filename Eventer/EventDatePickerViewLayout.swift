//
//  EventDatePickerViewLayout.swift
//  Eventer
//
//  Created by Grisha on 14/09/2015.
//  Copyright (c) 2015 Grisha. All rights reserved.
//

import UIKit

class EventDatePickerViewLayout: UICollectionViewFlowLayout {
    var collectionCellWidth = UIScreen.mainScreen().bounds.width/4
    var collectionCellHeight:CGFloat = 70
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init() {
        super.init()
        self.itemSize = CGSizeMake(collectionCellWidth, collectionCellHeight)
        //self.estimatedItemSize = CGSizeMake(collectionCellWidth, collectionCellHeight)
        self.scrollDirection = UICollectionViewScrollDirection.Horizontal
    }

}
