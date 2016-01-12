//
//  HomeNavigationController.swift
//  Eventer
//
//  Created by Grisha on 21/12/2014.
//  Copyright (c) 2014 Grisha. All rights reserved.
//

import UIKit

class HomeNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        //self.tabBarItem.selectedImage = UIImage(named: "tab-home-active.png")

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //overriding methods to stop flickering when push views
//    override func popViewControllerAnimated(animated: Bool) -> UIViewController? {
//        self.navigationBar.hidden = true
//        var VC:UIViewController = super.popViewControllerAnimated(animated)!
//        self.navigationBar.hidden = false
//        return VC
//    }
//    
//    override func pushViewController(viewController: UIViewController, animated: Bool) {
//        self.navigationBarHidden = true
//        super.pushViewController(viewController, animated: animated)
//        self.navigationBarHidden = false
//    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
