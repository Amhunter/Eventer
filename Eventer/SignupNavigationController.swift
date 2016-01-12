//
//  SignupNavigationController.swift
//  Eventer
//
//  Created by Grisha on 19/08/2015.
//  Copyright (c) 2015 Grisha. All rights reserved.
//

import UIKit

class SignupNavigationController: UINavigationController {
    override func viewWillAppear(animated: Bool) {
        UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: UIStatusBarAnimation.None)
    }
}
