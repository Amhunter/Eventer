//
//  ExploreCollectionCustomLayout.swift
//  Eventer
//
//  Created by Grisha on 23/06/2015.
//  Copyright (c) 2015 Grisha. All rights reserved.
//

import UIKit

class ExploreCollectionCustomLayout: UICollectionViewFlowLayout {
    var collectionCellWidth = (UIScreen.mainScreen().bounds.width-2)/3
    var collectionCellHeight = (UIScreen.mainScreen().bounds.width-2)/2
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init() {
        super.init()
        self.itemSize = CGSizeMake(collectionCellWidth, collectionCellHeight)
        self.scrollDirection = UICollectionViewScrollDirection.Vertical
    }
}
