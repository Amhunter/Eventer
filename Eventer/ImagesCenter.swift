//
//  ImagesCenter.swift
//  Eventer
//
//  Created by Grisha on 17/02/2016.
//  Copyright © 2016 Grisha. All rights reserved.
//

import UIKit

class ImagesCenter {
    
    class func homeLikeImage(active:Bool) -> UIImage {
        var image:UIImage!
        if active {
            image = UIImage(named: "like-active.png")
        } else {
            image = UIImage(named: "like-active.png")
        }
        image = image.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)

        
        return image
    }
    class func homeGoImage(active:Bool) -> UIImage {
        var image:UIImage!
        if active {
            image = UIImage(named: "going-active.png")
        } else {
            image = UIImage(named: "going-active.png")
        }
        image = image.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        
        
        return image
    }
    
    class func homeShareImage(active:Bool) -> UIImage {
        var image:UIImage!
        if active {
            image = UIImage(named: "share-active.png")
        } else {
            image = UIImage(named: "share-active.png")
        }
        image = image.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        
        
        return image
    }
}
