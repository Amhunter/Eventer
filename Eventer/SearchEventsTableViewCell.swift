//
//  SearchEventsTableViewCell.swift
//  Eventer
//
//  Created by Grisha on 13/10/2015.
//  Copyright © 2015 Grisha. All rights reserved.
//

import UIKit

class SearchEventsTableViewCell: UITableViewCell {
    
    var resultsLabel = UILabel()
    var viewResultsButton = UIButton()
    
    //var followLabel:UILabel = UILabel(frame: CGRectMake(50, 5, 220, 30))
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.contentView.frame.size.width = UIScreen.mainScreen().bounds.width
        
        self.contentView.addSubview(resultsLabel)
        self.contentView.addSubview(viewResultsButton)
        
        resultsLabel.translatesAutoresizingMaskIntoConstraints = false
        viewResultsButton.translatesAutoresizingMaskIntoConstraints = false
        
        resultsLabel.numberOfLines = 0
        resultsLabel.font = UIFont(name: "Lato-Semibold", size: 19)
        resultsLabel.textColor = ColorFromCode.tabForegroundColor()
        resultsLabel.textAlignment = NSTextAlignment.Center
        
        viewResultsButton.layer.masksToBounds = true //without it its not gonna work
        viewResultsButton.layer.cornerRadius = 12.5
        viewResultsButton.setTitle("View Results", forState: UIControlState.Normal)
        viewResultsButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        viewResultsButton.backgroundColor = UIColor.blackColor()
        viewResultsButton.titleLabel!.font = UIFont(name: "Lato-Medium", size: 17)
        
        let border:UIView = UIView()
        border.translatesAutoresizingMaskIntoConstraints = false
        border.backgroundColor = ColorFromCode.colorWithHexString("#DAE4E7")
        self.contentView.addSubview(border)
        
        let views = [
            "resultsLabel": resultsLabel,
            "viewResultsButton": viewResultsButton,
            "brdr": border
        ]

        let H_Constraint0 = NSLayoutConstraint.constraintsWithVisualFormat("H:|-20-[resultsLabel]-20@999-|", options: [], metrics: nil, views: views)
        let H_Constraint1 = NSLayoutConstraint.constraintsWithVisualFormat("H:|-100-[viewResultsButton]-100@999-|", options: [], metrics: nil, views: views)
        let H_Constraint2 = NSLayoutConstraint.constraintsWithVisualFormat("H:|[brdr]|", options: [], metrics: nil, views: views)

        
        let V_Constraint0 = NSLayoutConstraint.constraintsWithVisualFormat("V:|-14-[resultsLabel(60)]-10-[viewResultsButton]->=14@999-[brdr(0.5)]|", options: [], metrics: nil, views: views)

        
        self.contentView.addConstraints(H_Constraint0)
        self.contentView.addConstraints(H_Constraint1)
        self.contentView.addConstraints(H_Constraint2)

        self.contentView.addConstraints(V_Constraint0)
        
        self.contentView.setNeedsLayout()
        self.contentView.layoutIfNeeded()
        
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
