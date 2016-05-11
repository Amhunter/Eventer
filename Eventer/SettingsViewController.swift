//
//  SettingsViewController.swift
//  Eventer
//
//  Created by Grisha on 23/10/2015.
//  Copyright © 2015 Grisha. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    let logoutButton = UIButton()
    func back(){
        self.navigationController!.popViewControllerAnimated(true)
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        setSubviews()
    }
    func setSubviews(){
        let backButton = UIBarButtonItem(image: UIImage(named: "back.png"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(back))
        backButton.tintColor = UIColor.whiteColor()
        if (self.navigationController!.viewControllers.count > 1){
            self.navigationItem.leftBarButtonItem = backButton
        }
        
        let titleLabel:UILabel = UILabel()
        titleLabel.numberOfLines = 1
        titleLabel.text = "SETTINGS"
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.textAlignment = NSTextAlignment.Center
        titleLabel.font = UIFont(name: "Lato-Semibold", size: 18)
        self.navigationItem.titleView = titleLabel
        titleLabel.sizeToFit()
        
        
        
        // Autolayout First
        self.view.addSubview(logoutButton)
        logoutButton.translatesAutoresizingMaskIntoConstraints = false
        let views = [
            "logoutBtn": logoutButton
        ]
        let H_Constraints0 = NSLayoutConstraint.constraintsWithVisualFormat("H:|-20-[logoutBtn]-20@999-|", options: [], metrics: nil, views: views)
        let V_Constraints0 = NSLayoutConstraint.constraintsWithVisualFormat("V:|-20-[logoutBtn(45@999)]->=20@999-|", options: [], metrics: nil, views: views)
        
        self.view.addConstraints(H_Constraints0)
        self.view.addConstraints(V_Constraints0)
        
        // Now Customize Subviews
        self.logoutButton.setTitle("Log Out", forState: UIControlState.Normal)
        self.logoutButton.backgroundColor = ColorFromCode.redFollowColor()
        self.logoutButton.setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        self.logoutButton.titleLabel!.font = UIFont(name: "Lato-Semibold", size: 17)
        self.logoutButton.addTarget(self, action: #selector(logout), forControlEvents: UIControlEvents.TouchUpInside)

    }
    
    func logout() {
        KCSUser.activeUser().logout()
        
        let appDelegateTemp:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        let rootController:UIViewController = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier("Signup View") as! SignupViewController
        let navigation:UINavigationController = UINavigationController(rootViewController: rootController)
        appDelegateTemp.window?.rootViewController = navigation as UIViewController
        
    }


}
