//
//  ProgressObserver.swift
//  Eventer
//
//  Created by Grisha on 04/09/2015.
//  Copyright (c) 2015 Grisha. All rights reserved.
//

import UIKit



class ProgressObserver: NSObject {
    private var kvoContext: UInt = 1
    private let observationEvent:FetchedEvent
    var eventPictureHandler:(progress:CGFloat) -> Void
    var profilePictureHandler:(progress:CGFloat) -> Void

    
    init(observationEvent:FetchedEvent, profilePictureHandler:(progress:CGFloat) -> Void, eventPictureHandler:(progress:CGFloat) -> Void) {
        self.observationEvent = observationEvent
        self.eventPictureHandler = eventPictureHandler
        self.profilePictureHandler = profilePictureHandler
        super.init()
        self.observationEvent.addObserver(self, forKeyPath: "profilePictureProgress", options: NSKeyValueObservingOptions.New, context: &kvoContext)
    }
    
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        if context == &kvoContext {
            print("Change at keyPath = \(keyPath) for \(object)")
        }
    }
    
    func removeObservers(){
        self.observationEvent.removeObserver(self, forKeyPath: "profilePictureProgress")
    }
}
