//
//  ProfileGridViewLayout.swift
//  Eventer
//
//  Created by Grisha on 08/08/2015.
//  Copyright (c) 2015 Grisha. All rights reserved.
//

import UIKit

class ProfileGridViewLayout: UICollectionViewFlowLayout {
    var screenWidth = UIScreen.mainScreen().bounds.width
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
//    override init() {
//        super.init()
//    }
//
//    override func shouldInvalidateLayoutForBoundsChange(newBounds: CGRect) -> Bool {
//        return true
//    }
////    override func prepareLayout() {
////        layoutAttributesForSupplementaryViewOfKind(<#elementKind: String#>, atIndexPath: <#NSIndexPath#>)
////    }
//    
//    override func collectionViewContentSize() -> CGSize {
//        
//        // Ask the data source how many items there are (assume a single section)
//        var dataSource:UICollectionViewDataSource = self.collectionView!.dataSource!
//        var numberOfItems = dataSource.collectionView(self.collectionView!, numberOfItemsInSection: 0)
//        
//        // Determine number of rows
//        var ySpacing = 1
//        var numberOfColumns:Int = (numberOfItems / 4)+1 // 3 items in a row
//        var totalHeight = CGFloat(numberOfColumns)*collectionCellHeight - CGFloat(1*(numberOfColumns-1))
//
//        return CGSizeMake(screenWidth, totalHeight)
//    }
////    override func layoutAttributesForSupplementaryViewOfKind(elementKind: String, atIndexPath indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes! {
////        
////    }
//    override  func layoutAttributesForElementsInRect(rect: CGRect) -> [AnyObject]? {
//        // creating array to represent all cells we are going to add
//        var AllCells:NSMutableArray = NSMutableArray()
//
//        for var i = 0; i<self.collectionView?.numberOfItemsInSection(0); i++ {
//            // this bit calculates all properties of cells
//            var row:Int = ((i) / 3); // first cell is a month, thats where i-1 comes from
//            var col:Int = ((i) % 3);
//            var xOffset:Int = 0
//            var yOffset:Int = 0
//            var xSpacing:Int = 1
//            var ySpacing:Int = 0
//            
//            var xPosition:CGFloat = CGFloat(xOffset+(col*(Int(collectionCellWidth)+xSpacing)));
//            var yPosition:CGFloat = CGFloat(yOffset+(row*(Int(collectionCellHeight)+ySpacing)));
//            
//            //set these properties
//            var CellRect = CGRectMake(xPosition, yPosition, collectionCellWidth, collectionCellHeight);
//            
//            //create local cell in order to add it in the AllCells Array
//            var indexPath:NSIndexPath = NSIndexPath(forItem: i , inSection: 0)
//            var att:UICollectionViewLayoutAttributes = UICollectionViewLayoutAttributes(forCellWithIndexPath: indexPath)
//            att.frame = CellRect
//            AllCells.addObject(att)
//            
//        }
//            
//        return AllCells as [AnyObject];
//    }

}
