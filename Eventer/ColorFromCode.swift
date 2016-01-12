//
//  12131.swift
//  Eventer
//
//  Created by Grisha on 18/06/2015.
//  Copyright (c) 2015 Grisha. All rights reserved.
//

import UIKit

class ColorFromCode {
    
    init(){
        
    }
    class func imageWithColor(color: UIColor) -> UIImage {
        
        let rect:CGRect = CGRectMake(0, 0, 1, 1)
        UIGraphicsBeginImageContext(rect.size)
        let context:CGContextRef = UIGraphicsGetCurrentContext()!
        CGContextSetFillColorWithColor(context, color.CGColor)
        CGContextFillEllipseInRect(context, rect)
        let image:UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
        
    }
    
    class func imageWithCode(hex: String) -> UIImage {
        
        let color:UIColor = self.colorWithHexString(hex)
        let rect:CGRect = CGRectMake(0, 0, 1, 1)
        UIGraphicsBeginImageContext(rect.size)
        let context:CGContextRef = UIGraphicsGetCurrentContext()!
        CGContextSetFillColorWithColor(context, color.CGColor)
        CGContextFillEllipseInRect(context, rect)
        let image:UIImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image
        
    }
    
    class func standardBlueColor() -> UIColor{
        return self.colorWithHexString("#02A8F3")
    }
    class func sexyPurpleColor() -> UIColor {
        return self.colorWithHexString("#FF4500")
    }
    class func orangeFollowColor() -> UIColor{
        return self.colorWithHexString("#FF4500")
    }
    class func redFollowColor() -> UIColor{
        return self.colorWithHexString("#FF2300")
    }
    class func randomBlueColorFromNumber(number:Int) -> UIColor{
//        var code:[String] = ["#03A9F5","#4FC2F8","#039BE6","#0288D1","#28B6F6","#05A8F7"]
        switch number%6{
        case 0:
            return self.colorWithHexString("#03A9F5")
        case 1:
            return self.colorWithHexString("#4FC2F8")
        case 2:
            return self.colorWithHexString("#039BE6")
        case 3:
            return self.colorWithHexString("#0288D1")
        case 4:
            return self.colorWithHexString("#28B6F6")
        case 5:
            return self.colorWithHexString("#05A8F7")
        default:
            return self.standardBlueColor()
        }
        
        
    }
    

    class func tabBackgroundColor() -> UIColor{
        return self.colorWithHexString("#EBF0F2")
    }
    
    class func tabForegroundColor() -> UIColor{
        return self.colorWithHexString("#747474")
    }
    class func tabForegroundActiveColor() -> UIColor{
        return self.colorWithHexString("#0087D9")
    }
     class func colorWithHexString (hex:String) -> UIColor {
        var cString:String = hex.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).uppercaseString
        
        if (cString.hasPrefix("#")) {
            
            cString = (cString as NSString).substringFromIndex(1)
        }
        
        if (cString.characters.count != 6) {
            return UIColor.grayColor()
        }
        
        let rString = (cString as NSString).substringToIndex(2)
        let gString = ((cString as NSString).substringFromIndex(2) as NSString).substringToIndex(2)
        let bString = ((cString as NSString).substringFromIndex(4) as NSString).substringToIndex(2)
        
        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
        NSScanner(string: rString).scanHexInt(&r)
        NSScanner(string: gString).scanHexInt(&g)
        NSScanner(string: bString).scanHexInt(&b)

        return UIColor(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(1))
    }
}
