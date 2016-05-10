//
//  ImagesCenter.swift
//  Eventer
//
//  Created by Grisha on 17/02/2016.
//  Copyright © 2016 Grisha. All rights reserved.
//

import UIKit

class ImagesCenter {
    
    class func homeLikeImage() -> UIImage {
        var image = UIImage(named: "medium-like.png")

        image = image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        
        return image!
    }
    class func eventLikeImage(active:Bool) -> UIImage {
        var image:UIImage!
        if active {
            image = UIImage(named: "like-active.png")
        } else {
            image = UIImage(named: "like.png")
        }
        
        return image
    }
    class func homeGoImage() -> UIImage {
        var image = UIImage(named: "medium-going.png")

        image = image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
    
        return image!
    }
    class func eventGoImage(active:Bool) -> UIImage {
        var image:UIImage!
        if active {
            image = UIImage(named: "going-active.png")
        } else {
            image = UIImage(named: "going.png")
        }
        
        return image
    }
    class func homeShareImage() -> UIImage {
        var image = UIImage(named: "medium-share.png")
        
        image = image!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        
        return image!
    }
    class func eventShareImage(active:Bool) -> UIImage {
        var image:UIImage!
        if active {
            image = UIImage(named: "share-active.png")
        } else {
            image = UIImage(named: "share.png")
        }
        
        return image
    }
    class func homeCommentImage(active:Bool) -> UIImage {
        var image:UIImage!
        
        if active {
            image = UIImage(named: "medium-comment.png")
        } else {
            image = UIImage(named: "medium-comment.png")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        }
        return image!
    }
    
    
    class func homeMoreImage(active:Bool) -> UIImage {
        var image:UIImage!
        if active {
            image = UIImage(named: "more-active.png")
        } else {
            image = UIImage(named: "more.png")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        }
        
        return image
    }
    
}
