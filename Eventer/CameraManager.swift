//
//  CameraManager.swift
//  Eventer
//
//  Created by Grisha on 26/08/2015.
//  Copyright (c) 2015 Grisha. All rights reserved.
//

import UIKit
import AVFoundation
class CameraManager {
    
    /*
     * Find a camera with the specified AVCaptureDevicePosition, returning nil if one is not found
     *
     */
    class func cameraWithPosition(position:AVCaptureDevicePosition) -> AVCaptureDevice!{
        let devices = AVCaptureDevice.devicesWithMediaType(AVMediaTypeVideo)
        for device in devices as! [AVCaptureDevice] {
            if device.position == position {
                return device
            }
        }
        return nil
    }
    class func crop(imageView:UIImageView, toFrame:CGRect) -> UIImage {
        // Find the scalefactors  UIImageView's widht and height / UIImage width and height
        let widthScale = imageView.bounds.size.width / imageView.image!.size.width
        let heightScale = imageView.bounds.size.height / imageView.image!.size.height
        var frame = toFrame
        // Calculate the right crop rectangle
        frame.origin.x = frame.origin.x * (1 / widthScale)
        frame.origin.y = frame.origin.y * (1 / heightScale)
        frame.size.width = frame.size.width * (1 / widthScale)
        frame.size.height = frame.size.height * (1 / heightScale)
        
        // Create a new UIImage
        let imageRef = CGImageCreateWithImageInRect(imageView.image!.CGImage, frame)
        let croppedImage = UIImage(CGImage: imageRef!)
        return croppedImage
    }
}
