//
//  MyTimer.swift
//  Eventer
//
//  Created by Grisha on 05/08/2015.
//  Copyright (c) 2015 Grisha. All rights reserved.
//

import UIKit

class MyTimer: NSTimer {
    var startDate:NSDate!
    var total:CGFloat = 0
    var iterations:CGFloat = 0
    func start(){
        startDate = NSDate()
    }
    
    func finish(){
        let finishDate = NSDate()
        let executionTime = finishDate.timeIntervalSinceDate(startDate)
        iterations++
        self.total += CGFloat(executionTime)
        let average = total/iterations
        print("\(executionTime) seconds passed, average \(average)");
    }
}