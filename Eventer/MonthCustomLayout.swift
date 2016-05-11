//
//  MonthCustomLayout.swift
//  GCalendar
//
//  Created by Grisha on 13/11/2014.
//  Copyright (c) 2014 Grisha. All rights reserved.
//

import UIKit

class MonthCustomLayout: UICollectionViewLayout {
    
//    var SkippedDays0:Int = Int()    //skipped days are used for making a different offset for different
//    var SkippedDays1:Int = Int()    //months, because their first weekdays are different
//    var SkippedDays2:Int = Int()    //number in the end represents section
//    inefficient
    var CellCenter:CGPoint = CGPoint()
    var CellSize: CGSize = CGSize()
    var CVBounds:CGRect? = CGRect()
    var PageWidth:CGFloat = CGFloat()
    var xOffset:Int = Int()
    var yOffset:Int = Int()
    var xSpacing:Int = Int()
    var ySpacing:Int = Int()
    var NumberOfSections:Int? = Int()
    var CurrentPage:CGFloat = CGFloat()
    
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
        self.CellSize = CGSizeMake(55,55) // this is will be cell size
        self.CellCenter = CGPointMake(CellSize.height/2, CellSize.width/2); // this will be center coords
        self.xOffset = 5
        self.yOffset = 5
        self.xSpacing = 5
        self.ySpacing = 5
        self.PageWidth = ((self.collectionViewContentSize().width)/3)
        self.CVBounds = self.collectionView?.bounds
        self.NumberOfSections = self.collectionView?.numberOfSections()
        self.CurrentPage = 1

    }
    
    override func collectionViewContentSize() -> CGSize { //name speaks for itself
        
        return CGSizeMake(425*CGFloat(self.NumberOfSections!)+10,350) //425
    }
    
    // THIS func is used when we insert / delete cells and we need to know how to position them
   /*
    override func layoutAttributesForItemAtIndexPath(indexPath: NSIndexPath) -> UICollectionViewLayoutAttributes! {
        //let's determine the horizontal and vertical offset for each item
        var attributes:UICollectionViewLayoutAttributes = layoutAttributesForItemAtIndexPath(indexPath)
        var row:Int = (indexPath.item / 7);
        var col:Int = (indexPath.item % 7);
        var xOffset:Int = self.xOffset
        var yOffset:Int = self.yOffset
        var xSpacing:Int = self.xSpacing
        var ySpacing:Int = self.ySpacing
        var xPosition:CGFloat = CGFloat(xOffset+(col*(Int(self.CellSize.width)+xSpacing)));
        var yPosition:CGFloat = CGFloat(yOffset+(row*(Int(self.CellSize.height)+ySpacing)));
        var CellWidth:CGFloat = CellSize.width;
        var CellHeight:CGFloat = CellSize.height;
        //set these properties
        var CellRect = CGRectMake(xPosition, yPosition, CellWidth, CellHeight);
        attributes.frame = CellRect;
        
        return attributes;
    }
    
    */
    
    
    
    //this func is used for setting sizes and positions for all existing cells
    override  func layoutAttributesForElementsInRect(rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var AllCells:[UICollectionViewLayoutAttributes] = [] // creating array to represent all cells we are going
                                                       // to add
        for s in 0 ..< self.collectionView!.numberOfSections() {
// Commented because i found refreshing layout inefficient in comparison to just adding empty transparent cells
//            var SkippedDays:Int
//            if (s == 0){
//                SkippedDays = SkippedDays0
//            }else if (s == 1){
//                SkippedDays = SkippedDays1
//            }else if (s == 2){
//                SkippedDays = SkippedDays2
//            }else{
//                SkippedDays = 0 //not supposed to happen
//            }
            for i in 0 ..< self.collectionView!.numberOfItemsInSection(s) {
                // this bit calculates all properties of cells
                let row:Int = ((i) / 7); // first cell is a month, thats where i-1 comes from
                let col:Int = ((i) % 7);
                let CellWidth:CGFloat = CellSize.width;
                let CellHeight:CGFloat = CellSize.height;
                let xOffset:Int = self.xOffset
                let yOffset:Int = self.yOffset
                let xSpacing:Int = self.xSpacing
                let ySpacing:Int = self.ySpacing

                var xPosition:CGFloat = CGFloat(xOffset+(col*(Int(self.CellSize.width)+xSpacing)));
                let yPosition:CGFloat = CGFloat(yOffset+(row*(Int(self.CellSize.height)+ySpacing)));
                xPosition = xPosition + CGFloat(CGFloat(s)*self.PageWidth)

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

    
    //now for pages
    override func targetContentOffsetForProposedContentOffset(proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {

        let RawPageValue:CGFloat = (CGFloat(proposedContentOffset.x)/self.PageWidth)
        //this part tries to find ProposedPage, i.e. page at which our proposedContentOffset is , or page where we scrolled
        var ProposedPage:CGFloat = CGFloat()
        if (floor(RawPageValue) == 1){
            if  ((RawPageValue-floor(RawPageValue)) > ((PageWidth/4)/PageWidth)){
                ProposedPage = floor(RawPageValue) + 1
            }else{
                ProposedPage = floor(RawPageValue)
            }
        }else{
            ProposedPage = floor(RawPageValue)
        }
        //println("\((PageWidth/4)/PageWidth)") just to ensure that 0.25 is that border for transition
        //---------------------------------------------------------//
        var targetContentOffset:CGPoint = CGPoint()
        

        if (ProposedPage == 0){
            if (RawPageValue > 0.75){
                targetContentOffset = CGPoint(x: CurrentPage * self.PageWidth, y: proposedContentOffset.y);
            }else{
                targetContentOffset = CGPoint(x:(((CurrentPage-1)*self.PageWidth)+(self.PageWidth/4)), y: proposedContentOffset.y);
            }
        }
        else if (ProposedPage == 1){
            targetContentOffset = proposedContentOffset
        }
        else if (ProposedPage == 2){
            if (RawPageValue > 1.5){
                if (RawPageValue > 2){
                    if (RawPageValue > 2.25){
                        targetContentOffset = CGPoint(x:(((CurrentPage+1)*self.PageWidth)+(self.PageWidth/4)), y: proposedContentOffset.y);
                    }else{ // 2 - 2.25
                        targetContentOffset = CGPoint(x: (CurrentPage+1) * self.PageWidth, y: proposedContentOffset.y);
                    }
                }else{
                    targetContentOffset = CGPoint(x: (CurrentPage+1) * self.PageWidth, y: proposedContentOffset.y);
                }
            }else{
                targetContentOffset = CGPoint(x:((CurrentPage*self.PageWidth)+(self.PageWidth/4)), y: proposedContentOffset.y);
            }
        }
        //println("\(CurrentMonth.StillDecellerates)")
        //println("\(RawPageValue)")
        //println("\(ProposedPage)")

        return targetContentOffset
    }
    
    
    
}
