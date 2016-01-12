//
//  1231dsa.swift
//  Eventer
//
//  Created by Grisha on 15/06/2015.
//  Copyright (c) 2015 Grisha. All rights reserved.
//

import UIKit

class Utility {
    class func classNameAsString(obj: Any) -> String {
        //prints more readable results for dictionaries, arrays, Int, etc
        return _stdlib_getDemangledTypeName(obj).componentsSeparatedByString(".").last!
        
        
    }

    
    
    /*
    * Generate random number in specified range
    *
    */
    class func randomNumber(lowestValue:Int , highestValue:Int) -> Int{
        let u = highestValue - lowestValue
        let r = Int(arc4random())
        
        return (r % u) + lowestValue
    }
    
    class func statusBarHeight() -> CGFloat {
        let statusBarSize = UIApplication.sharedApplication().statusBarFrame.size
        return Swift.min(statusBarSize.width, statusBarSize.height)
        
       
    }
    
    class func numberOfWordsInString(str:NSString) -> Int {
        let words = str.componentsSeparatedByCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        var wordDictionary = Dictionary<String, Int>()
        for word in words {
            if let count = wordDictionary[word] {
                wordDictionary[word] = count + 1
            } else {
                wordDictionary[word] = 1
            }
        }
        return wordDictionary.count
    }
    
    class func checkForBeingActive() -> Bool{
        if (KCSUser.activeUser() == nil){
            let appDelegateTemp:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            
            let rootController:UIViewController = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()).instantiateViewControllerWithIdentifier("Signup View") as! SignupViewController
            let navigation:UINavigationController = UINavigationController(rootViewController: rootController)
            appDelegateTemp.window?.rootViewController = navigation as UIViewController
            return false
        }else{
            return true
        }
        
    }

    class func gradientLayer(forImageviewFrame:CGRect, height:CGFloat, alpha:CGFloat) -> CAGradientLayer {
        let gradient:CAGradientLayer = CAGradientLayer()
        gradient.frame = CGRectMake(0, forImageviewFrame.height-height, forImageviewFrame.width, height)
        gradient.colors = NSArray(array:
            [
                UIColor(red: 0, green: 0, blue: 0, alpha: 0).CGColor,
                UIColor(red: 0, green: 0, blue: 0, alpha: alpha).CGColor
            ]) as [AnyObject]

        return gradient
        //[self.view.layer insertSublayer:gradient atIndex:0];
    }
    class func dropShadow(forView:UIView, offset:CGFloat, opacity:CGFloat){
        // add the drop shadow
        forView.layer.shadowColor = UIColor.blackColor().CGColor
        forView.layer.shadowOffset = CGSizeMake(0, offset)
        forView.layer.shadowOpacity = Float(opacity)    
        forView.layer.masksToBounds = false
        forView.layer.shouldRasterize = true
    }
    
    
    /*
     * Extracting image out of bar button item
     *
     */
    class func getImageFromUIBarButtonItem(systemItem:UIBarButtonSystemItem) -> UIImage!{
        
        // Creating a temporary item: UIBarButtonSystemItemTrash - change based on your needs
        let item:UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: systemItem, target: self, action: "")
        let itemView = item.customView!
        
        for view in itemView.subviews {
            if view.isKindOfClass(UIImageView) {
                return (view as! UIImageView).image
            }
        }
        return nil
    }
    
    
    /*
     * Highlight Mentions
     *
     */
    class func highlightMentionsInString(text:NSMutableAttributedString, withColor:UIColor, inLabel:TTTAttributedLabel){
        let mentionExpression:NSRegularExpression = try! NSRegularExpression(pattern: "(?:^|\\s)(@\\w+)" , options: [])
        
        let matches = mentionExpression.matchesInString(text.string, options: NSMatchingOptions(), range: NSRange(location: 0,length: text.length))
        for match:NSTextCheckingResult in matches {
            let matchRange:NSRange = match.rangeAtIndex(1)
            let mentionString:NSString = (text.string as NSString).substringWithRange(matchRange)
            let linkRange:NSRange = (text.string as NSString).rangeOfString(mentionString as String)
            let username:NSString = mentionString.substringFromIndex(1)
            let url:NSURL = NSURL(scheme: "mention", host: username as String, path: "/")!
            inLabel.addLinkToURL(url, withRange: linkRange)
            text.addAttribute(NSForegroundColorAttributeName, value: withColor, range: linkRange)
        }
        inLabel.attributedText = text
        
    }
    
    /*
     * Highlight Hashtags
     *
     */
    class func highlightHashtagsInString(text:NSMutableAttributedString, withColor:UIColor, inLabel:TTTAttributedLabel){
        let mentionExpression:NSRegularExpression = try! NSRegularExpression(pattern: "(?:^|\\s)(#\\w+)" , options: [])
        
        let matches = mentionExpression.matchesInString(text.string, options: NSMatchingOptions(), range: NSRange(location: 0,length: text.length))
        for match:NSTextCheckingResult in matches {
            let matchRange:NSRange = match.rangeAtIndex(1)
            let mentionString:NSString = (text.string as NSString).substringWithRange(matchRange)
            let linkRange:NSRange = (text.string as NSString).rangeOfString(mentionString as String)
            let tag:NSString = mentionString.substringFromIndex(1)
            let url:NSURL = NSURL(scheme: "hashtag", host: tag as String, path: "/")!
            inLabel.addLinkToURL(url, withRange: linkRange)
            text.addAttribute(NSForegroundColorAttributeName, value: withColor, range: linkRange)
        }
        inLabel.attributedText = text
        
    }

    /*
    * Scale Image
    *
    */
    class func scaleImage(image:UIImage,scale:CGFloat) -> UIImage{
        return UIImage(CGImage: image.CGImage!, scale: scale, orientation: image.imageOrientation)
    }
    
    class func cropString(text:NSString, maxLetters:Int) -> String {
        var string = text
        if string.length > maxLetters {
            string = string.substringToIndex(maxLetters)
            string = (string as String) + "..."
        }
        return string as String
    }

    /*
    * Generate constraints to make 2 views have equal frame
    *
    */
    class func equalFrameViaAutolayoutConstraints(view:UIView,equalToView:UIView) -> [AnyObject]{
        let centerXConstraint = NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: equalToView, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
        let centerYConstraint = NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: equalToView, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0)
        let equalWidthConstraint = NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: equalToView, attribute: NSLayoutAttribute.Width, multiplier: 1, constant: 0)
        let equalHeightConstraint = NSLayoutConstraint(item: view, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: equalToView, attribute: NSLayoutAttribute.Height, multiplier: 1, constant: 0)
        return [centerXConstraint , centerYConstraint, equalWidthConstraint, equalHeightConstraint]
    }
    
    /*
    * Checking versions
    *
    */
    class func SYSTEM_VERSION_EQUAL_TO(version: NSString) -> Bool {
        return UIDevice.currentDevice().systemVersion.compare(version as String,
            options: NSStringCompareOptions.NumericSearch) == NSComparisonResult.OrderedSame
    }
    
    class func SYSTEM_VERSION_GREATER_THAN(version: NSString) -> Bool {
        return UIDevice.currentDevice().systemVersion.compare(version as String,
            options: NSStringCompareOptions.NumericSearch) == NSComparisonResult.OrderedDescending
    }
    
    class func SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(version: NSString) -> Bool {
        return UIDevice.currentDevice().systemVersion.compare(version as String,
            options: NSStringCompareOptions.NumericSearch) != NSComparisonResult.OrderedAscending
    }
    
    class func SYSTEM_VERSION_LESS_THAN(version: NSString) -> Bool {
        return UIDevice.currentDevice().systemVersion.compare(version as String,
            options: NSStringCompareOptions.NumericSearch) == NSComparisonResult.OrderedAscending
    }
    
    class func SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(version: NSString) -> Bool {
        return UIDevice.currentDevice().systemVersion.compare(version as String,
            options: NSStringCompareOptions.NumericSearch) != NSComparisonResult.OrderedDescending
    }
}
