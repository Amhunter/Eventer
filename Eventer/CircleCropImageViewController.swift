//
//  CircleCropImageViewController.swift
//  Eventer
//
//  Created by Grisha on 24/08/2015.
//  Copyright (c) 2015 Grisha. All rights reserved.
//

import UIKit

class CircleCropImageViewController: UIViewController, UIScrollViewDelegate {
    var scrollView:UIScrollView = UIScrollView()
    var cropCircleOverlay:UIView = UIView()
    var screenWidth:CGFloat = UIScreen.mainScreen().bounds.width
    var screenHeight:CGFloat = UIScreen.mainScreen().bounds.width
    var image:UIImage!
    var imageView:UIImageView = UIImageView()
    var callback:((Bool,UIImage) -> Void)!

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    init(image withImage:UIImage, callback:(cancelled:Bool, image:UIImage!) -> Void){
        super.init(nibName: nil, bundle: nil)
        self.image = withImage
        self.callback = callback
    }
    
    // necessary to call it
    func initializeView(withImage:UIImage, callback:(cancelled:Bool, image:UIImage!) -> Void){
        self.image = withImage
        self.callback = callback
    }
    override func viewDidLoad() {
        self.view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        let views = [
            "scrollView": scrollView
        ]
        let H_Constraints0 = NSLayoutConstraint.constraintsWithVisualFormat("H:|[scrollView]|", options: [], metrics: nil, views: views)
        let V_Constraints0 = NSLayoutConstraint.constraintsWithVisualFormat("V:|[scrollView]|", options: [], metrics: nil, views: views)
        self.view.addConstraints(H_Constraints0)
        self.view.addConstraints(V_Constraints0)
        
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
        self.scrollView.addSubview(imageView)
        self.imageView = UIImageView(image: self.image)
        self.imageView.frame.size = self.image.size
        self.scrollView.addSubview(self.imageView)
        self.scrollView.contentSize = self.image.size
        self.scrollView.delegate = self
        
        // Add overlay
        self.cropCircleOverlay.frame = self.scrollView.frame
        self.view.addSubview(cropCircleOverlay)
        self.cropCircleOverlay.userInteractionEnabled = false
        //self.cropCircleOverlay.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.8)
        let circleLayer = CAShapeLayer()
        let offsetY = (self.scrollView.frame.height-screenWidth)/2
        let path = UIBezierPath(ovalInRect: CGRectMake(0, offsetY, screenWidth, screenWidth))
        path.usesEvenOddFillRule = true
        circleLayer.fillColor = UIColor.blackColor().colorWithAlphaComponent(0.8).CGColor
        circleLayer.path = path.CGPath
        self.cropCircleOverlay.layer.addSublayer(circleLayer)
        

        


    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
        let scaleWidth = scrollView.frame.size.width/self.scrollView.contentSize.width
        let scaleHeight = scrollView.frame.size.height/self.scrollView.contentSize.height
        let minScale = min(scaleWidth, scaleHeight)
        self.scrollView.maximumZoomScale = 1
        self.scrollView.minimumZoomScale = minScale
        self.scrollView.zoomScale = minScale;

        
        self.centerScrollViewContents()
    }
    func centerScrollViewContents(){ // making image sit in center
        let boundsSize = self.scrollView.bounds.size
        var contentsFrame = self.imageView.frame
        if (contentsFrame.size.width < boundsSize.width) {
            contentsFrame.origin.x = (boundsSize.width - contentsFrame.size.width) / 2
        } else {
            contentsFrame.origin.x = 0
        }
        
        if (contentsFrame.size.height < boundsSize.height) {
            contentsFrame.origin.y = (boundsSize.height - contentsFrame.size.height) / 2
        } else {
            contentsFrame.origin.y = 0
        }
        
        self.imageView.frame = contentsFrame
    }
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return self.imageView
    }
}
