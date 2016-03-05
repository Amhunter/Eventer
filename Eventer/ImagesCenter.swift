//
//  ImagesCenter.swift
//  Eventer
//
//  Created by Grisha on 17/02/2016.
//  Copyright © 2016 Grisha. All rights reserved.
//

import UIKit

class ImagesCenter {
    
    class func HomeLikeImage(active:Bool) -> UIImage {
        var image:UIImage!
        if active {
            image = UIImage(named: "like-active.png")
        } else {
            image = UIImage(named: "like.png")

        }
        image = image.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)

        
        return image
    }
}
