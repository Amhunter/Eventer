//
//  SearchDisplayScrollView.swift
//  Eventer
//  Replacement for UISearchDisplayController
//
//  Created by Grisha on 22/06/2015.
//  Copyright (c) 2015 Grisha. All rights reserved.
//

import UIKit

class SearchDisplayView: UIView, UIScrollViewDelegate {
    var ScreenWidth = UIScreen.mainScreen().bounds.width
    var ScreenHeight = UIScreen.mainScreen().bounds.height
    
    var scrollView:UIScrollView = UIScrollView()
    var hashtagsTableView:UITableView = UITableView()
    var usersTableView:UITableView = UITableView()
    
    var segmentView:UIView = UIView()
    var segmentChanging:Bool = false
    var segmentIndicator:UIView = UIView()
    var segmentLabel1:UIButton = UIButton()
    var segmentLabel2:UIButton = UIButton()
    var selectedSegment:Int = Int()
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.addSubview(scrollView)
        self.addSubview(segmentView)
        
        self.scrollView.translatesAutoresizingMaskIntoConstraints = false
        self.segmentView.translatesAutoresizingMaskIntoConstraints = false
        
        
        let subviews = [
            "segment": segmentView,
            "scrollview": scrollView,
        ]
        let H_Constraint0 = NSLayoutConstraint.constraintsWithVisualFormat("H:|[segment]|", options: [], metrics: nil, views: subviews)
        let H_Constraint1 = NSLayoutConstraint.constraintsWithVisualFormat("H:|[scrollview]|", options: [], metrics: nil, views: subviews)
        let V_Constraint0 = NSLayoutConstraint.constraintsWithVisualFormat("V:|[segment(44.5@999)][scrollview]|", options: [], metrics: nil, views: subviews)
        
        self.addConstraints(H_Constraint0)
        self.addConstraints(H_Constraint1)
        self.addConstraints(V_Constraint0)
        
        // Scroll View Autolayout
        self.scrollView.addSubview(hashtagsTableView)
        self.scrollView.addSubview(usersTableView)
        
        self.setNeedsLayout()
        self.layoutIfNeeded()
        
        hashtagsTableView.frame = CGRectMake(0, 0, ScreenWidth, self.scrollView.frame.height)
        usersTableView.frame = CGRectMake(ScreenWidth, 0, ScreenWidth, self.scrollView.frame.height)
        hashtagsTableView.separatorStyle = UITableViewCellSeparatorStyle.None
        usersTableView.separatorStyle = UITableViewCellSeparatorStyle.None

        self.scrollView.contentSize = CGSizeMake(ScreenWidth*2, self.scrollView.frame.height)
        
        // Set Scroll View and subviews
        self.scrollView.scrollEnabled = true
        self.scrollView.pagingEnabled = true
        self.scrollView.delegate = self
        
        
        // Segment View Autolayout
        self.segmentLabel1.setTitle("EVENTS", forState: UIControlState.Normal)
        self.segmentLabel2.setTitle("USERS", forState: UIControlState.Normal)
        self.segmentLabel1.adjustsImageWhenDisabled = false
        self.segmentLabel2.adjustsImageWhenDisabled = false
        self.segmentLabel1.titleLabel?.font = UIFont(name: "Lato-Bold", size: 15)
        self.segmentLabel2.titleLabel?.font = UIFont(name: "Lato-Bold", size: 15)
        self.segmentLabel1.tag = 1
        self.segmentLabel2.tag = 2
        self.segmentLabel1.setTitleColor(ColorFromCode.tabForegroundColor(), forState: UIControlState.Normal)
        self.segmentLabel2.setTitleColor(ColorFromCode.tabForegroundColor(), forState: UIControlState.Normal)
        self.segmentLabel1.setTitleColor(ColorFromCode.colorWithHexString("#0087D9"), forState: UIControlState.Highlighted)
        self.segmentLabel2.setTitleColor(ColorFromCode.colorWithHexString("#0087D9"), forState: UIControlState.Highlighted)
        
        self.segmentLabel1.titleLabel?.textAlignment = NSTextAlignment.Center
        self.segmentLabel2.titleLabel?.textAlignment = NSTextAlignment.Center
        self.segmentLabel1.addTarget(self, action: "switchSegment:", forControlEvents: UIControlEvents.TouchUpInside)
        self.segmentLabel2.addTarget(self, action: "switchSegment:", forControlEvents: UIControlEvents.TouchUpInside)

        
        self.segmentIndicator.backgroundColor = ColorFromCode.colorWithHexString("#02A8F3")
        
        
        self.segmentView.addSubview(segmentLabel1)
        self.segmentView.addSubview(segmentLabel2)
        self.segmentView.addSubview(segmentIndicator)
        
        let border:CGFloat = 41.5
        self.segmentLabel1.frame = CGRectMake(0,0,ScreenWidth/2,border)
        self.segmentLabel2.frame = CGRectMake(ScreenWidth/2,0,ScreenWidth/2,border)
        self.segmentIndicator.frame = CGRectMake(0,border,ScreenWidth/2,3)
        self.segmentView.layer.addSublayer(Utility.gradientLayer(segmentView.frame, height: 2, alpha: 0.3))
        self.selectSegment(1)


    }
    

    
    func scrollViewDidScroll(scrollView: UIScrollView) { // make ScrollView only horizontal scrolling
        if (scrollView == self.scrollView){
            self.segmentIndicator.frame.origin.x = scrollView.contentOffset.x/2
            if (scrollView.contentOffset.x < ScreenWidth/2){ // page 1
                selectSegment(1)
            }else{ // page 2
                selectSegment(2)
            }
        }
    }
    func selectSegment(index:Int){
        self.selectedSegment = index

        if (index == 1){
            self.segmentLabel1.highlighted = true
            self.segmentLabel2.highlighted = false
            
            self.segmentLabel1.enabled = false
            self.segmentLabel2.enabled = true
            
        }else if (index == 2){
            
            self.segmentLabel1.highlighted = false
            self.segmentLabel2.highlighted = true
            
            self.segmentLabel1.enabled = true
            self.segmentLabel2.enabled = false
            
        }
    }
    func switchSegment(sender:UIButton){
        if (sender.tag == 1){ //Segment Changing boolean is just to remove flickering when we press segment
            segmentChanging = true
            self.segmentLabel1.enabled = false
            scrollView.setContentOffset(CGPointMake(0,scrollView.contentOffset.y), animated: true)
            self.segmentLabel1.enabled = true
            segmentChanging = false
        }else if (sender.tag == 2){
            segmentChanging = true
            self.segmentLabel2.enabled = false
            scrollView.setContentOffset(CGPointMake(ScreenWidth, scrollView.contentOffset.y), animated: true)
            self.segmentLabel2.enabled = true
            segmentChanging = false
        }
    }
}
