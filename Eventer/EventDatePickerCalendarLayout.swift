//
//  EventDatePickerCalendarLayout.swift
//  Eventer
//
//  Created by Grisha on 19/09/2015.
//  Copyright (c) 2015 Grisha. All rights reserved.
//

import UIKit

class EventDatePickerCalendarLayout: UICollectionViewFlowLayout {
    
    var screenWidth = UIScreen.mainScreen().bounds.width
    var screenHeight = UIScreen.mainScreen().bounds.height
    
    var collectionViewHeight:CGFloat = 0
    
    var cellSize: CGSize = CGSize()
    
    var xOffset:CGFloat = 0
    var yOffset:CGFloat = 0
    var pageWidth:CGFloat = UIScreen.mainScreen().bounds.width
    var xSpacing:CGFloat = 0
    var ySpacing:CGFloat = 0
    
    override init() {
        super.init()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
    }
    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
        return true;
    }
    
    override func prepareLayout() { // we don't need it right now,since we dont have any additional calculations
        self.collectionViewHeight = self.collectionView!.frame.height
        self.xOffset = CGFloat(Int(screenWidth-6)%7)/2
        self.yOffset = 0
        let cellWidth = CGFloat(Int(screenWidth-6)/7)
        self.cellSize = CGSizeMake(cellWidth,cellWidth) // this is will be cell size
        self.xSpacing = 1
        self.ySpacing = 1
        
    }
    
    override func collectionViewContentSize() -> CGSize { //name speaks for itself
        return CGSizeMake(screenWidth*3,collectionViewHeight) //425
    }
    
    //this func is used for setting sizes and positions for all existing cells
    override  func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var AllCells:[UICollectionViewLayoutAttributes] = [] // creating array to represent all cells we are going
        // to add
        for var s = 0; s<self.collectionView?.numberOfSections(); s++ {

            for var i = 0; i<self.collectionView?.numberOfItemsInSection(s); i++ {
                // this bit calculates all properties of cells
                let row:Int = ((i) / 7); // first cell is a month, thats where i-1 comes from
                let col:Int = ((i) % 7);
                let CellWidth:CGFloat = cellSize.width  // 2 15 3 15 3
                let CellHeight:CGFloat = cellSize.height
                let xOffset:CGFloat = self.xOffset
                let yOffset = self.yOffset
                let xSpacing:CGFloat = self.xSpacing
                let ySpacing:CGFloat = self.ySpacing
                
                var xPosition:CGFloat = CGFloat(xOffset+(CGFloat(col)*((self.cellSize.width)+xSpacing)))
                let yPosition:CGFloat = CGFloat(yOffset+(CGFloat(row)*((self.cellSize.height)+ySpacing)))
                xPosition = xPosition + CGFloat(CGFloat(s)*self.pageWidth)
                
                //set these properties
                let CellRect = CGRectMake(xPosition, yPosition, CellWidth, CellHeight);
                
                //create local cell in order to add it in the AllCells Array
                let indexPath:NSIndexPath = NSIndexPath(forItem: i , inSection: s)
                let att:UICollectionViewLayoutAttributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
                att.frame = CellRect
                AllCells.append(att)
                
            }
            
        }
        return AllCells
    }

}
