//
//  ProfileCameraViewController.swift
//  Eventer
//
//  Created by Grisha on 26/08/2015.
//  Copyright (c) 2015 Grisha. All rights reserved.
//

import UIKit
import AVFoundation

class ProfileCameraViewController: UIViewController {
    var handler:(UIImage! -> Void)!
    var captureDevice : AVCaptureDevice?
    
    var captureSession: AVCaptureSession?
    var stillImageOutput: AVCaptureStillImageOutput?
    var previewLayer: AVCaptureVideoPreviewLayer?
    var imageView:UIImageView = UIImageView()
    var capturedImageView:UIImageView = UIImageView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.width))
    var previewView:UIView = UIView(frame: CGRectMake(0, 0, UIScreen.mainScreen().bounds.width, UIScreen.mainScreen().bounds.width))
    
    var screenWidth = UIScreen.mainScreen().bounds.width
    var screenHeight = UIScreen.mainScreen().bounds.height
    var navBar:UIView = UIView()
    var toolBar:UIView = UIView()
    var bottomView:UIView = UIView()

    var takePhotoButton:UIButton = UIButton()
    var retakePhotoButton:UIButton = UIButton()
    var donePhotoButton:UIButton = UIButton()
    var flipCameraButton:UIButton = UIButton()
    var focusIcon:UIImageView = UIImageView()
    
    var frontCameraActive:Bool = false
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: NSBundle?) {
        super.init(nibName: nil, bundle: nil)
    }
    init(handler: (image:UIImage!) -> Void){
        super.init(nibName: nil, bundle: nil)
        self.handler = handler
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setSubviews()
        setupCamera()
        setCameraControls()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        //UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: UIStatusBarAnimation.Slide)
    }
    func setSubviews(){
        
//        self.view.addSubview(navBar)
        self.view.addSubview(previewView)
        self.view.addSubview(toolBar)
        self.view.addSubview(bottomView)
        
//        navBar.setTranslatesAutoresizingMaskIntoConstraints(false)
        previewView.translatesAutoresizingMaskIntoConstraints = false
        toolBar.translatesAutoresizingMaskIntoConstraints = false
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        
        let views = [
            "navBar": navBar,
            "preview": previewView,
            "toolBar": toolBar,
            "bottomView": bottomView
        ]
        let metrics = [
            "screenWidth": screenWidth
        ]
        let constraints = NSLayoutConstraint.constraintsWithVisualFormat("V:|[preview(screenWidth)][toolBar(50)][bottomView(>=0@999)]|", options: [NSLayoutFormatOptions.AlignAllCenterX, NSLayoutFormatOptions.AlignAllLeft, NSLayoutFormatOptions.AlignAllRight], metrics: metrics, views: views)
        var squareConstraint = NSLayoutConstraint(item: previewView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: previewView, attribute: NSLayoutAttribute.Height, multiplier: 1, constant: 0)
        self.view.addConstraints(constraints)
        self.view.addConstraint(squareConstraint)
        
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
        
        // Take your profile picture
        
        let titleLabel:UILabel = UILabel()
        titleLabel.numberOfLines = 1
        titleLabel.text = "Your Profile Picture"
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.textAlignment = NSTextAlignment.Center
        titleLabel.font = UIFont(name: "Lato-Semibold", size: 18)
        self.navigationItem.titleView = titleLabel
        titleLabel.sizeToFit()
        
        let cancelButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Stop, target: self, action: "cancel")
        self.navigationItem.leftBarButtonItem = cancelButton
        self.navigationController!.navigationBar.tintColor = UIColor.whiteColor()
        
        self.view.addSubview(imageView)
        self.imageView.frame = self.previewView.frame
        
        // Transparent View
        
        let transparentView = UIView()
        transparentView.userInteractionEnabled = false
        self.view.addSubview(transparentView)
        transparentView.frame = previewView.frame
        let spacing:CGFloat = 20
        // ()
        let circleLayer = CAShapeLayer()
        let path2 = UIBezierPath(ovalInRect: CGRectMake(spacing, spacing, screenWidth-(2*spacing), screenWidth-(2*spacing)))
        path2.usesEvenOddFillRule = true
        circleLayer.path = path2.CGPath
        circleLayer.fillColor = UIColor.clearColor().CGColor
        // []
        let path = UIBezierPath(roundedRect: CGRectMake(0, 0, screenWidth, screenWidth), cornerRadius: 0)
        path.usesEvenOddFillRule = true
        path.appendPath(path2)
        // [()]
        let fillLayer = CAShapeLayer()
        fillLayer.path = path.CGPath
        fillLayer.fillRule = kCAFillRuleEvenOdd
        fillLayer.fillColor = UIColor.blackColor().CGColor
        fillLayer.opacity = 0.65
        transparentView.layer.addSublayer(fillLayer)

        
        

        self.navBar.backgroundColor = ColorFromCode.standardBlueColor()
        self.toolBar.backgroundColor = ColorFromCode.tabForegroundColor()

        
        
        // Customize Bottom View
        
        self.bottomView.backgroundColor = UIColor.whiteColor()
        self.takePhotoButton.translatesAutoresizingMaskIntoConstraints = false
        self.retakePhotoButton.translatesAutoresizingMaskIntoConstraints = false
        self.donePhotoButton.translatesAutoresizingMaskIntoConstraints = false

        self.bottomView.addSubview(self.takePhotoButton)
        self.bottomView.addSubview(self.retakePhotoButton)
        self.bottomView.addSubview(self.donePhotoButton)
        
        let toolbarSubviews = [
            "takePhoto": self.takePhotoButton,
            "retakePhoto": self.retakePhotoButton,
            "doneButton": self.donePhotoButton
        ]
        let toolbarMetrics = [
            "btnWidth" : 95
        ]
        let H_Constraint0 = NSLayoutConstraint(item: takePhotoButton, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: bottomView, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
        let H_Constraints0 = NSLayoutConstraint.constraintsWithVisualFormat("H:|[retakePhoto][takePhoto(btnWidth)][doneButton]|", options: NSLayoutFormatOptions.AlignAllCenterY, metrics: toolbarMetrics, views: toolbarSubviews)
        let V_Constraints0 = NSLayoutConstraint.constraintsWithVisualFormat("V:|[retakePhoto]|", options: [], metrics: nil, views: toolbarSubviews)
        let V_Constraints1 = NSLayoutConstraint.constraintsWithVisualFormat("V:|[doneButton]|", options: [], metrics: nil, views: toolbarSubviews)
        squareConstraint = NSLayoutConstraint(item: takePhotoButton, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: takePhotoButton, attribute: NSLayoutAttribute.Height, multiplier: 1, constant: 0)
        bottomView.addConstraint(H_Constraint0)
        bottomView.addConstraints(H_Constraints0)
        bottomView.addConstraints(V_Constraints0)
        bottomView.addConstraints(V_Constraints1)
        bottomView.addConstraint(squareConstraint)

        self.takePhotoButton.layer.cornerRadius = 47.5
        self.takePhotoButton.backgroundColor = ColorFromCode.standardBlueColor()
        self.takePhotoButton.layer.borderWidth = 10
        self.takePhotoButton.layer.borderColor = ColorFromCode.tabBackgroundColor().CGColor
        retakePhotoButton.titleLabel!.font = UIFont(name: "Lato-Semibold", size: 18)
        retakePhotoButton.titleLabel!.textAlignment = NSTextAlignment.Center
        retakePhotoButton.setTitle("Retake", forState: UIControlState.Normal)
        retakePhotoButton.addTarget(self, action: "retakePhoto:", forControlEvents: UIControlEvents.TouchUpInside)
        retakePhotoButton.setTitleColor(ColorFromCode.standardBlueColor(), forState: UIControlState.Normal)
        retakePhotoButton.setTitleColor(ColorFromCode.randomBlueColorFromNumber(3), forState: UIControlState.Highlighted)
        donePhotoButton.titleLabel!.font = UIFont(name: "Lato-Semibold", size: 18)
        donePhotoButton.titleLabel!.textAlignment = NSTextAlignment.Center
        donePhotoButton.setTitle("Done", forState: UIControlState.Normal)
        donePhotoButton.addTarget(self, action: "done:", forControlEvents: UIControlEvents.TouchUpInside)
        donePhotoButton.setTitleColor(ColorFromCode.standardBlueColor(), forState: UIControlState.Normal)
        donePhotoButton.setTitleColor(ColorFromCode.randomBlueColorFromNumber(3), forState: UIControlState.Highlighted)
        retakePhotoButton.hidden = true
        donePhotoButton.hidden = true
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func cancel(){
        handler(nil)
    }
    
    func setCameraControls(){
        flipCameraButton.translatesAutoresizingMaskIntoConstraints = false
        
        let controlViews = [
            "flipBtn": flipCameraButton,
            
        ]
        toolBar.addSubview(flipCameraButton)
        
        let H_Constraints0 = NSLayoutConstraint.constraintsWithVisualFormat("H:|[flipBtn]->=0@999-|", options: NSLayoutFormatOptions.AlignAllCenterX, metrics: nil, views: controlViews)
        let V_Constraints0 = NSLayoutConstraint.constraintsWithVisualFormat("V:|->=0@999-[flipBtn]->=0@999-|", options: NSLayoutFormatOptions.AlignAllCenterY, metrics: nil, views: controlViews)
        let H_Constraint0 = NSLayoutConstraint(item: flipCameraButton, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: toolBar, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
        let V_Constraint0 = NSLayoutConstraint(item: flipCameraButton, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: toolBar, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0)

        self.toolBar.addConstraints(H_Constraints0)
        self.toolBar.addConstraints(V_Constraints0)
        self.toolBar.addConstraint(H_Constraint0)
        self.toolBar.addConstraint(V_Constraint0)

        flipCameraButton.setImage(UIImage(named: "flip.png"), forState: UIControlState.Normal)
        flipCameraButton.addTarget(self, action: "flipCamera", forControlEvents: UIControlEvents.TouchUpInside)
        
        takePhotoButton.addTarget(self, action: "takePhoto:", forControlEvents: UIControlEvents.TouchUpInside)
        takePhotoButton.addTarget(self, action: "Unhighlight:", forControlEvents: UIControlEvents.TouchDragOutside)
        takePhotoButton.addTarget(self, action: "Highlight:", forControlEvents: UIControlEvents.TouchDragInside)
        takePhotoButton.addTarget(self, action: "Highlight:", forControlEvents: UIControlEvents.TouchDown)
        
        let image:UIImage = UIImage(named: "focus.png")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        focusIcon.tintColor = UIColor.whiteColor()
        focusIcon.backgroundColor = UIColor.clearColor()
        focusIcon.image = image
        focusIcon.frame.size = image.size
        self.previewView.addSubview(focusIcon)
        focusIcon.alpha = 0
        focusIcon.userInteractionEnabled = false
    }
    func Highlight(sender:UIButton){
        sender.backgroundColor = ColorFromCode.randomBlueColorFromNumber(3)
    }
    // unhighlight button
    func Unhighlight(sender:UIButton){
        sender.backgroundColor = ColorFromCode.standardBlueColor()
    }
    
    
    func flipCamera(){
        flipCameraButton.enabled = false
        //Change camera source
        if (captureSession != nil) {
            //Indicate that some changes will be made to the session
            captureSession?.beginConfiguration()
            
            //Remove existing input
            let currentCameraInput = captureSession?.inputs[0] as! AVCaptureInput
            captureSession?.removeInput(currentCameraInput)
            
            //Get new input
            var newCamera:AVCaptureDevice!
            if (currentCameraInput as! AVCaptureDeviceInput).device.position == AVCaptureDevicePosition.Back {
                newCamera = CameraManager.cameraWithPosition(AVCaptureDevicePosition.Front)
            }else{
                newCamera = CameraManager.cameraWithPosition(AVCaptureDevicePosition.Back)
                do {
                    try newCamera.lockForConfiguration()
                } catch _ {
                }
                newCamera.focusMode = AVCaptureFocusMode.AutoFocus
                newCamera.unlockForConfiguration()
            }
            captureDevice = newCamera
            
            //Add input to session
            var error:NSError?
            var newVideoInput:AVCaptureDeviceInput
            do {
                newVideoInput = try AVCaptureDeviceInput(device: newCamera)
                captureSession?.addInput(newVideoInput)
            } catch let error1 as NSError {
                error = error1
                print("Error creating capture device input:" + error!.localizedDescription)
            }

            
            //Commit all the configuration changes at once
            captureSession!.commitConfiguration()
        }
        flipCameraButton.enabled = true
    }
    
    func setupCamera(){
        
        let devices = AVCaptureDevice.devices()
        
        // Loop through all the capture devices on this phone
        for device in devices {
            // Make sure this particular device supports video
            if (device.hasMediaType(AVMediaTypeVideo)) {
                // Finally check the position and confirm we've got the front camera
                if(device.position == AVCaptureDevicePosition.Front) {
                    captureDevice = device as? AVCaptureDevice
                    frontCameraActive = true
                }
            }
        }
        configureDevice()
        
        captureSession = AVCaptureSession()
        captureSession!.sessionPreset = AVCaptureSessionPresetPhoto //determine quality
        
        var error: NSError?
        var input: AVCaptureDeviceInput!
        do {
            input = try AVCaptureDeviceInput(device: captureDevice)
        } catch let error1 as NSError {
            error = error1
            input = nil
        } // find input
        
        if error == nil && captureSession!.canAddInput(input) { //link input - session
            captureSession!.addInput(input)
        }
        
        stillImageOutput = AVCaptureStillImageOutput() // create output
        stillImageOutput?.outputSettings = [AVVideoCodecKey: AVVideoCodecJPEG] //configure

        captureSession!.addOutput(stillImageOutput) //output - session
        
        previewView.frame = CGRectMake(0, 0, screenWidth, screenWidth)
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession) //output to previewlayer
        
        previewLayer?.frame.size = previewView.frame.size

        previewLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        previewView.layer.addSublayer(previewLayer!)
        captureSession?.startRunning()
        
        previewView.userInteractionEnabled = true
        let taprec = UITapGestureRecognizer(target: self,action: "focusTo:")
        previewView.addGestureRecognizer(taprec)
        
        self.focusToPoint(self.previewView.center, device: captureDevice!)
        
    }
    
    func configureDevice() {
        if let device = captureDevice {
            do {
                try device.lockForConfiguration()
            } catch _ {
            }
            if device.isFocusModeSupported(AVCaptureFocusMode.AutoFocus) {
                device.focusMode = AVCaptureFocusMode.AutoFocus
            }
            device.unlockForConfiguration()
        }
    }
    func retakePhoto(sender:UIButton){
        sender.hidden = true
        self.takePhotoButton.hidden = false
        self.imageView.image = nil
        self.previewView.hidden = false
        donePhotoButton.hidden = true
        self.flipCameraButton.enabled = true
        previewLayer!.connection.enabled = true
    }
    func takePhoto(sender:UIButton){
        sender.hidden = true
        self.flipCameraButton.enabled = false
        if (captureDevice == nil){
            let Alt = UIAlertController(title: "Ooops :(", message: "You don't have your camera device enabled", preferredStyle: UIAlertControllerStyle.Alert)
            Alt.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {
                (AlertAction:UIAlertAction) -> Void in
                //code
            }))
            self.presentViewController(Alt, animated: true, completion: nil)
        }else{
            previewLayer?.connection.enabled = false
            
            if let videoConnection = stillImageOutput!.connectionWithMediaType(AVMediaTypeVideo) { // if video connection is there
                
                stillImageOutput?.captureStillImageAsynchronouslyFromConnection(videoConnection, completionHandler: {(sampleBuffer, error:NSError!) in //take picture
                    //dispatch_async(dispatch_get_main_queue(), { () -> Void in
                    if (error == nil){
                        
                        let jpegData:NSData = AVCaptureStillImageOutput.jpegStillImageNSDataRepresentation(sampleBuffer)
                        var takenImage:UIImage = UIImage(data: jpegData)!
                        let outputRect:CGRect = self.previewLayer!.metadataOutputRectOfInterestForRect(self.previewLayer!.bounds)
                        let takenCGIMage:CGImageRef = takenImage.CGImage!
                        let width:CGFloat = CGFloat(CGImageGetWidth(takenCGIMage))
                        let height:CGFloat = CGFloat(CGImageGetHeight(takenCGIMage))
                        let cropRect:CGRect = CGRectMake(outputRect.origin.x*width, outputRect.origin.y*height, outputRect.size.width*width, outputRect.size.height*height)
                        let cropCGImage:CGImageRef = CGImageCreateWithImageInRect(takenCGIMage, cropRect)!
                        takenImage = UIImage(CGImage: cropCGImage, scale: 1, orientation: UIImageOrientation.Right)
                        var image = takenImage
                        
                        let currentCameraInput = self.captureSession?.inputs[0] as! AVCaptureInput
                        if (currentCameraInput as! AVCaptureDeviceInput).device.position == AVCaptureDevicePosition.Front {
                            image = UIImage(CGImage: image.CGImage!, scale: image.scale, orientation: UIImageOrientation.LeftMirrored)
                        }
                        
                        self.takePhotoButton.hidden = true
                        self.retakePhotoButton.hidden = false
                        self.donePhotoButton.hidden = false

                        self.imageView.image = image
                        self.previewView.hidden = true
                        
                    }else if ((error) != nil){
                        //println(error.description)
                        self.captureSession?.stopRunning()
                        self.captureSession?.startRunning()
                        sender.hidden = false
                        self.retakePhotoButton.hidden = true
                        self.donePhotoButton.hidden = true
                        //couldnt save
                    }
                    self.previewLayer?.connection.enabled = true
                    
                })
            }
        }
    }
    func focusTo(sender:UITapGestureRecognizer) {
        if (captureDevice == nil){
            let Alt = UIAlertController(title: "Sorry, You can't use this app :(", message: "You don't have your camera device enabled", preferredStyle: UIAlertControllerStyle.Alert)
            Alt.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: {
                (AlertAction:UIAlertAction) -> Void in
                //code
            }))
            self.presentViewController(Alt, animated: true, completion: nil)
        }else{
            let touchPoint:CGPoint = sender.locationInView(self.previewView)
            let device:AVCaptureDevice = captureDevice!
            focusToPoint(touchPoint,device: device)


        }
    }
    func focusToPoint(touchPoint:CGPoint,device:AVCaptureDevice){
        let convertedPoint:CGPoint = self.previewLayer!.captureDevicePointOfInterestForPoint(touchPoint)

        do {
            try device.lockForConfiguration()
            // adjust focus
            if(device.focusPointOfInterestSupported && device.isFocusModeSupported(AVCaptureFocusMode.AutoFocus)){
                device.focusPointOfInterest = convertedPoint
                device.focusMode = AVCaptureFocusMode.AutoFocus
                
                
            }
            // adjust brightness
            if (device.exposurePointOfInterestSupported && device.isExposureModeSupported(AVCaptureExposureMode.AutoExpose)){
                device.exposurePointOfInterest = convertedPoint
                device.exposureMode = AVCaptureExposureMode.AutoExpose
                
            }
            
            // adjust white balance
            if device.isWhiteBalanceModeSupported(AVCaptureWhiteBalanceMode.AutoWhiteBalance){
                device.whiteBalanceMode = AVCaptureWhiteBalanceMode.AutoWhiteBalance
            }
            
            if device.lowLightBoostSupported{
                device.automaticallyEnablesLowLightBoostWhenAvailable = true
            }
            device.subjectAreaChangeMonitoringEnabled = true
            
        } catch let error as NSError {
            print(error)
        }
        

        device.unlockForConfiguration()

        self.focusIcon.alpha = 1
        self.focusIcon.center = CGPointMake(touchPoint.x, touchPoint.y)
        UIView.animateWithDuration(1, delay: 0.7, options: [], animations: {
            self.focusIcon.alpha = 0
            }, completion: nil)

    }
    
    func done(sender:UIButton){
        let spacing:CGFloat = 20
        let cropRect = CGRectMake(spacing, spacing, screenWidth-(2*spacing), screenWidth-(2*spacing))
        let croppedImage = CameraManager.crop(self.imageView, toFrame: cropRect)
        
        
        let currentCameraInput = captureSession?.inputs[0] as! AVCaptureInput
        if (currentCameraInput as! AVCaptureDeviceInput).device.position == AVCaptureDevicePosition.Front {
            let rotatedImage = UIImage(CGImage: croppedImage.CGImage! ,
                scale: 1.0 ,
                orientation: UIImageOrientation.LeftMirrored)
            handler(rotatedImage)
        }else{
            let rotatedImage = UIImage(CGImage: croppedImage.CGImage! ,
                scale: 1.0 ,
                orientation: UIImageOrientation.Right)
            handler(rotatedImage)
        }
        

        
    }

}
