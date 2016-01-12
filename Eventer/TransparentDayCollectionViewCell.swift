//
//  TransparentDayCollectionViewCell.swift
//  Eventer
//
//  Created by Grisha on 20/12/2014.
//  Copyright (c) 2014 Grisha. All rights reserved.
//

import UIKit

class TransparentDayCollectionViewCell: UICollectionViewCell {
    required init?(coder aDecoder: NSCoder) {
        
        super.init(coder: aDecoder)
        
        
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.hidden = true
    }
    
}
