//
//  SignupStep2ViewController.swift
//  Eventer
//
//  Created by Grisha on 22/08/2015.
//  Copyright (c) 2015 Grisha. All rights reserved.
//

import UIKit

class SignupStep2ViewController: UIViewController, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate {
    var screenWidth = UIScreen.mainScreen().bounds.width
    var screenHeight = UIScreen.mainScreen().bounds.height
    var mainView:UIView = UIView()
    
    var backgroundImageView:UIImageView = UIImageView()
    var logoSuperView:UIView = UIView()
    var textfieldSuperview = UIView()
    var emailTextField:UITextField = UITextField()
    var usernameTextField:UITextField =  UITextField()
    var passwordTextField:UITextField = UITextField()
    var emailIndicator = UIActivityIndicatorView()
    var usernameIndicator = UIActivityIndicatorView()
    var passwordIndicator = UIActivityIndicatorView()
    var emailConfirmIcon = UIButton()
    var usernameConfirmIcon = UIButton()
    var passwordConfirmIcon = UIButton()
    
    
    var email:String!
    var pickedImageView:UIImageView = UIImageView()
    var pickImageButton:UIButton = UIButton()
    var pickedImage:UIImage!
    
    var emailValid:Bool = true
    var usernameValid:Bool = false
    var passwordValid:Bool = false
    
    var navBarOriginY:CGFloat!
    var selectedView:Int = 2
    
    var CurrentKeyboardHeight:CGFloat = 0
    
    var pushButton:UIBarButtonItem = UIBarButtonItem()
    var pushIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    func back(){
        self.navigationController!.popViewControllerAnimated(true)
    }

    override func viewDidLoad() {
        Set_Subviews()
    }
    func Set_Subviews(){
        let backButton = UIBarButtonItem(image: UIImage(named: "back.png"), style: UIBarButtonItemStyle.Plain, target: self, action: #selector(SignupStep2ViewController.back))
        backButton.tintColor = UIColor.whiteColor()
        
        pushButton = UIBarButtonItem(image: UIImage(named: "forward.png"), style: UIBarButtonItemStyle.Plain, target: self, action: Selector("createAccount"))
        pushButton.tintColor = UIColor.whiteColor()
        
        if (self.navigationController!.viewControllers.count > 1){
            self.navigationItem.leftBarButtonItem = backButton
        }
        self.navigationItem.rightBarButtonItem = pushButton
        pushButton.enabled = false
        
        

        navBarOriginY = self.navigationController!.navigationBar.frame.origin.y
        
        self.navigationController!.navigationBarHidden = false
        self.navigationController!.navigationBar.backgroundColor = UIColor.clearColor()
        self.navigationController!.navigationBar.setBackgroundImage(UIImage(), forBarMetrics: UIBarMetrics.Default)
        self.navigationController!.navigationBar.shadowImage = UIImage()
        self.navigationController!.navigationBar.translucent = true
        self.navigationController!.view.backgroundColor = UIColor.clearColor()
        
        self.view.addSubview(mainView)
        self.mainView.frame = self.view.frame
        
        self.backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        self.logoSuperView.translatesAutoresizingMaskIntoConstraints = false
        self.textfieldSuperview.translatesAutoresizingMaskIntoConstraints = false
        // self view
        self.mainView.addSubview(backgroundImageView)
        self.mainView.addSubview(textfieldSuperview)
        let views = [
            "bgView": backgroundImageView,
            "backView": textfieldSuperview
        ]
        let H_Constraint0 = NSLayoutConstraint.constraintsWithVisualFormat("H:|[bgView]|", options: [], metrics: nil, views: views)
        let H_Constraint1 = NSLayoutConstraint.constraintsWithVisualFormat("H:|[backView]|", options: [], metrics: nil, views: views)
        let V_Constraint0 = NSLayoutConstraint.constraintsWithVisualFormat("V:|[bgView(250)][backView]|", options: [], metrics: nil, views: views)
        
        self.mainView.addConstraints(H_Constraint0)
        self.mainView.addConstraints(H_Constraint1)
        self.mainView.addConstraints(V_Constraint0)
        

        
        initMainView()
        
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
        
        
        // pick Image
        
        self.backgroundImageView.addSubview(pickImageButton)
        self.pickImageButton.frame.size = CGSizeMake(80, 80)
        self.pickImageButton.backgroundColor = UIColor.whiteColor()
        self.pickImageButton.layer.cornerRadius = self.pickImageButton.frame.width/2
        self.pickImageButton.center = backgroundImageView.center
        self.pickImageButton.setImage(UIImage(named: "signup-addphoto.png"), forState: UIControlState.Normal)
        self.pickImageButton.setTitleColor(ColorFromCode.colorWithHexString("#00AAFC"), forState: UIControlState.Normal)
        self.pickImageButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Highlighted)
        let font = UIFont(name: "Lato-Semibold", size: 14)!
        self.pickImageButton.titleLabel!.font = font
        self.pickImageButton.setTitle("PHOTO", forState: UIControlState.Normal)
        
        
        let view:UIView = UIView()
        self.backgroundImageView.addSubview(view)
        view.backgroundColor = UIColor.clearColor()
        view.frame.size = CGSizeMake(84, 84)
        view.center = pickImageButton.center
        view.layer.borderWidth = 4
        view.layer.borderColor = UIColor.whiteColor().CGColor
        view.userInteractionEnabled = false
        view.layer.cornerRadius = view.frame.width/2

        
        let buttonSize = pickImageButton.frame.size
        let buttonTitle = pickImageButton.titleLabel!.text
        let titleSize = (buttonTitle! as NSString).sizeWithAttributes([NSFontAttributeName: font])
        let buttonImage = pickImageButton.imageView!.image
        let buttonImageSize = buttonImage!.size
        let offsetBetweenImageAndText:CGFloat = 2 // vertical space between image and text
        pickImageButton.contentHorizontalAlignment = UIControlContentHorizontalAlignment.Left
        pickImageButton.contentVerticalAlignment = UIControlContentVerticalAlignment.Top
        pickImageButton.imageEdgeInsets = UIEdgeInsetsMake((buttonSize.height - (titleSize.height + buttonImageSize.height)) / 2 - offsetBetweenImageAndText, (buttonSize.width - buttonImageSize.width) / 2, 0, 0)
        pickImageButton.titleEdgeInsets = UIEdgeInsetsMake((buttonSize.height - (titleSize.height + buttonImageSize.height)) / 2 + buttonImageSize.height + offsetBetweenImageAndText, titleSize.width + pickImageButton.imageEdgeInsets.left > buttonSize.width ? -buttonImage!.size.width  +  (buttonSize.width - titleSize.width) / 2 : (buttonSize.width - titleSize.width)/2 - buttonImage!.size.width, 0, 0)
        pickImageButton.addTarget(self, action: #selector(self.presentActionSheet), forControlEvents: UIControlEvents.TouchUpInside)
        
        
        self.backgroundImageView.image = UIImage(named: "signup-background.png")
        

        
//        var passiveButtonColor = ColorFromCode.colorWithHexString("#B8B7B9")
//        var activeButtonColor = UIColor.whiteColor()
//        var buttonFont = UIFont(name: "Lato-Bold", size: 17)

        usernameTextField.placeholder = "Username"
        passwordTextField.placeholder = "Password"
        emailTextField.placeholder = "E-mail"
        usernameTextField.font = UIFont(name: "Helvetica", size: 17)
        passwordTextField.font = UIFont(name: "Helvetica", size: 17)
        emailTextField.font = UIFont(name: "Helvetica", size: 17)
        usernameTextField.tintColor =  ColorFromCode.colorWithHexString("#B8B7B9")
        passwordTextField.tintColor =  ColorFromCode.colorWithHexString("#B8B7B9")
        emailTextField.tintColor = ColorFromCode.colorWithHexString("#B8B7B9")
        
        
        if (email != nil){
            emailTextField.text = email
            self.emailConfirmIcon.setImage(UIImage(named: "accept"), forState: UIControlState.Normal)
            self.emailConfirmIcon.frame.size = UIImage(named: "accept")!.size
            self.emailValid = true
        }
        
        emailTextField.addTarget(self, action: #selector(self.emailTextFieldDidChange), forControlEvents: UIControlEvents.EditingChanged)
        usernameTextField.addTarget(self, action: #selector(self.usernameTextFieldDidChange), forControlEvents: UIControlEvents.EditingChanged)
        passwordTextField.addTarget(self, action: #selector(self.passwordTextFieldDidChange), forControlEvents: UIControlEvents.EditingChanged)
        passwordTextField.secureTextEntry = true
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.endEditing)))
        

        backgroundImageView.userInteractionEnabled = true
        

        emailIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        emailIndicator.hidesWhenStopped = true
        usernameIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        usernameIndicator.hidesWhenStopped = true
        passwordIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        passwordIndicator.hidesWhenStopped = true
        
        
        
        pushButton.action = #selector(self.signup)
        pushIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.White
        pushIndicator.hidesWhenStopped = true
        pushIndicator.frame = CGRectMake(0,0,25,25)
        pushIndicator.autoresizingMask = [UIViewAutoresizing.FlexibleLeftMargin, UIViewAutoresizing.FlexibleRightMargin, UIViewAutoresizing.FlexibleTopMargin, UIViewAutoresizing.FlexibleBottomMargin]
        pushIndicator.sizeToFit()
        

        // Recognizer
        let rec = UISwipeGestureRecognizer(target: self, action: "endEditing")
        rec.direction = UISwipeGestureRecognizerDirection.Down
        self.view.addGestureRecognizer(rec)
        
    }
    func signup(){
        let indicator = UIBarButtonItem(customView: pushIndicator)
        
        self.navigationItem.rightBarButtonItem = indicator
        pushIndicator.startAnimating()
        SignupManager.SignupWithParameters(emailTextField.text!, username: usernameTextField.text!, password: passwordTextField.text!, picture: ( pickedImage == nil ? nil : pickedImage)) {
            (error:NSError!, pictureUploadError:NSError!) -> Void in
            self.pushIndicator.stopAnimating()
            self.navigationItem.rightBarButtonItem = self.pushButton
            if (error == nil){
                let VC = SignupStep3ViewController()
                self.navigationController?.pushViewController(VC, animated: true)
                if pictureUploadError != nil {
                    let alertController = UIAlertController(title: "Image upload error", message: pictureUploadError.description, preferredStyle: UIAlertControllerStyle.Alert)
                    let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil)
                    alertController.addAction(okAction)
                    self.presentViewController(alertController, animated: true, completion: nil)
                }
            }else{
                print(error.description)
            }
        }
    }
    

    
    func checkAllTextFields(){
        if emailValid && usernameValid && passwordValid {
            self.pushButton.enabled = true
        }else{
            self.pushButton.enabled = false
        }
    }
    func usernameTextFieldDidChange(){
        if (usernameTextField.text as NSString!).length > 0 {
            let text = usernameTextField.text!.stringByReplacingOccurrencesOfString(" ", withString: "_")
            usernameTextField.text = text
            if (usernameTextField.text as NSString!).length < 2 {
                self.usernameConfirmIcon.setImage(UIImage(named: "decline"), forState: UIControlState.Normal)
                self.usernameConfirmIcon.frame.size = UIImage(named: "decline")!.size
                self.usernameValid = false
                self.usernameIndicator.stopAnimating()
                self.checkAllTextFields()
                return
            }
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.usernameIndicator.startAnimating()
                self.usernameConfirmIcon.setImage(nil, forState: UIControlState.Normal)
                self.usernameValid = false
                self.checkAllTextFields()
            })
            
            SignupManager.checkUsernameForAvailability(usernameTextField.text!, completion: {
                (busy:Bool, username:String) -> Void in
                if (username == self.usernameTextField.text!){
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.usernameIndicator.stopAnimating()
                        if !busy {
                            self.usernameConfirmIcon.setImage(UIImage(named: "accept"), forState: UIControlState.Normal)
                            self.usernameConfirmIcon.frame.size = UIImage(named: "accept")!.size
                            self.usernameValid = true
                            self.checkAllTextFields()
                        }else{
                            self.usernameConfirmIcon.setImage(UIImage(named: "decline"), forState: UIControlState.Normal)
                            self.usernameConfirmIcon.frame.size = UIImage(named: "decline")!.size
                            self.usernameValid = false
                            self.checkAllTextFields()
                            
                        }
                    })
                }
            })
        }else{
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.usernameIndicator.stopAnimating()
                self.usernameConfirmIcon.setImage(nil, forState: UIControlState.Normal)
                self.usernameValid = false
                self.checkAllTextFields()
            })
        }
    }
    
    func passwordTextFieldDidChange(){
        if (self.passwordTextField.text as NSString!).length > 3 {
            self.passwordConfirmIcon.setImage(UIImage(named: "accept"), forState: UIControlState.Normal)
            self.passwordConfirmIcon.frame.size = UIImage(named: "accept")!.size
            self.passwordValid = true
            self.checkAllTextFields()
        }else{
            self.passwordConfirmIcon.setImage(UIImage(named: "decline"), forState: UIControlState.Normal)
            self.passwordConfirmIcon.frame.size = UIImage(named: "decline")!.size
            self.passwordValid = false
            self.checkAllTextFields()
        }
    }
    func emailTextFieldDidChange(){
        if (emailTextField.text as NSString!).length > 0 {
            
            if !SignupManager.isValidEmail(emailTextField.text!) {
                self.emailConfirmIcon.setImage(UIImage(named: "decline"), forState: UIControlState.Normal)
                self.emailConfirmIcon.frame.size = UIImage(named: "decline")!.size
                self.emailValid = false
                self.checkAllTextFields()
                return
            }
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.emailIndicator.startAnimating()
                self.emailConfirmIcon.setImage(nil, forState: UIControlState.Normal)
                self.emailValid = false
                self.checkAllTextFields()
            })
            
            SignupManager.checkEmailForAvailability(emailTextField.text!, completion: {
                (busy:Bool, email:String) -> Void in
                if (email == self.emailTextField.text!){
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.emailIndicator.stopAnimating()
                        if !busy {
                            self.emailConfirmIcon.setImage(UIImage(named: "accept"), forState: UIControlState.Normal)
                            self.emailConfirmIcon.frame.size = UIImage(named: "accept")!.size
                            self.emailValid = true
                            self.checkAllTextFields()
                        }else{
                            self.emailConfirmIcon.setImage(UIImage(named: "decline"), forState: UIControlState.Normal)
                            self.emailConfirmIcon.frame.size = UIImage(named: "decline")!.size
                            self.emailValid = false
                            self.checkAllTextFields()
                            
                        }
                    })
                }
            })
        }else{
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.emailIndicator.stopAnimating()
                self.emailConfirmIcon.setImage(nil, forState: UIControlState.Normal)
                self.emailValid = false
                self.checkAllTextFields()
            })
        }
        
    }

    
    
    
    
    func initMainView(){
        let emailIcon = UIButton() // username pic
        emailIcon.translatesAutoresizingMaskIntoConstraints = false
        emailIcon.setImage(UIImage(named: "signup-email.png")!, forState: UIControlState.Normal)
        emailIcon.userInteractionEnabled = false
        let usernameIcon = UIButton() // username pic
        usernameIcon.translatesAutoresizingMaskIntoConstraints = false
        usernameIcon.setImage(UIImage(named: "login-username.png")!, forState: UIControlState.Normal)
        usernameIcon.userInteractionEnabled = false
        let passwordIcon = UIButton() // password pic
        passwordIcon.translatesAutoresizingMaskIntoConstraints = false
        passwordIcon.setImage(UIImage(named: "login-pass.png")!, forState: UIControlState.Normal)
        passwordIcon.userInteractionEnabled = false
        let emailline = UIView()
        emailline.translatesAutoresizingMaskIntoConstraints = false
        emailline.backgroundColor = ColorFromCode.colorWithHexString("#C8C6CC")
        let usernameline = UIView()
        usernameline.translatesAutoresizingMaskIntoConstraints = false
        usernameline.backgroundColor = ColorFromCode.colorWithHexString("#C8C6CC")
        let passwordline = UIView()
        passwordline.translatesAutoresizingMaskIntoConstraints = false
        passwordline.backgroundColor = ColorFromCode.colorWithHexString("#C8C6CC")
        
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        usernameTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        emailIndicator.translatesAutoresizingMaskIntoConstraints = false
        usernameIndicator.translatesAutoresizingMaskIntoConstraints = false
        passwordIndicator.translatesAutoresizingMaskIntoConstraints = false


        self.textfieldSuperview.addSubview(emailIcon)
        self.textfieldSuperview.addSubview(usernameIcon)
        self.textfieldSuperview.addSubview(passwordIcon)
        self.textfieldSuperview.addSubview(emailTextField)
        self.textfieldSuperview.addSubview(usernameTextField)
        self.textfieldSuperview.addSubview(passwordTextField)
        self.textfieldSuperview.addSubview(emailline)
        self.textfieldSuperview.addSubview(usernameline)
        self.textfieldSuperview.addSubview(passwordline)
        self.textfieldSuperview.addSubview(emailIndicator)
        self.textfieldSuperview.addSubview(usernameIndicator)
        self.textfieldSuperview.addSubview(passwordIndicator)
        self.textfieldSuperview.addSubview(emailConfirmIcon)
        self.textfieldSuperview.addSubview(usernameConfirmIcon)
        self.textfieldSuperview.addSubview(passwordConfirmIcon)

        let views = [
            "emailpic": emailIcon,
            "userpic": usernameIcon,
            "passpic": passwordIcon,
            "emailline": emailline,
            "userline": usernameline,
            "passline": passwordline,
            "emailfield": emailTextField,
            "userfield": usernameTextField,
            "passfield": passwordTextField,
            "emailind": emailIndicator,
            "userind": usernameIndicator,
            "passind": passwordIndicator
        ]
        let metrics = [
            "lineSpacingY" : 8,
            "picSpacingX": 2.5
        ]
        let LH_Constraint0 = NSLayoutConstraint.constraintsWithVisualFormat("H:|-picSpacingX-[emailpic(55)]-picSpacingX-[emailfield][emailind(40)]-20@999-|", options: [], metrics: metrics, views: views)
        let LH_Constraint1 = NSLayoutConstraint.constraintsWithVisualFormat("H:|-picSpacingX-[userpic(55)]-picSpacingX-[userfield][userind(40)]-20@999-|", options: [], metrics: metrics, views: views)
        let LH_Constraint2 = NSLayoutConstraint.constraintsWithVisualFormat("H:|-picSpacingX-[passpic(55)]-picSpacingX-[passfield][passind(40)]-20@999-|", options: [], metrics: metrics, views: views)

        let LH_Constraint3 = NSLayoutConstraint.constraintsWithVisualFormat("H:|-picSpacingX-[emailpic(55)]-picSpacingX-[emailline]-20@999-|", options: [], metrics: metrics, views: views)
        let LH_Constraint4 = NSLayoutConstraint.constraintsWithVisualFormat("H:|-picSpacingX-[userpic(55)]-picSpacingX-[userline]-20@999-|", options: [], metrics: metrics, views: views)
        let LH_Constraint5 = NSLayoutConstraint.constraintsWithVisualFormat("H:|-picSpacingX-[passpic(55)]-picSpacingX-[passline]-20@999-|", options: [], metrics: metrics, views: views)
        
        let LV_Constraint0 = NSLayoutConstraint.constraintsWithVisualFormat("V:|-33.5-[emailpic]-38.5-[userpic]-38.5-[passpic]->=0@999-|", options: [], metrics: nil, views: views)
        let LV_Constraint1 = NSLayoutConstraint.constraintsWithVisualFormat("V:|-32.5-[emailfield(==emailpic)]-lineSpacingY-[emailline(0.5)]-34-[userfield(==userpic@999)]-lineSpacingY-[userline(0.5)]-34-[passfield(==passpic@999)]-lineSpacingY-[passline(0.5)]->=0@999-|", options: [], metrics: metrics, views: views)
        let LV_Constraint2 = NSLayoutConstraint(item: emailIndicator, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: emailTextField, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0)
        let LV_Constraint3 = NSLayoutConstraint(item: usernameIndicator, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: usernameTextField, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0)
        let LV_Constraint4 = NSLayoutConstraint(item: passwordIndicator, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: passwordTextField, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0)

        
        self.textfieldSuperview.addConstraints(LH_Constraint0)
        self.textfieldSuperview.addConstraints(LH_Constraint1)
        self.textfieldSuperview.addConstraints(LH_Constraint2)
        self.textfieldSuperview.addConstraints(LH_Constraint3)
        self.textfieldSuperview.addConstraints(LH_Constraint4)
        self.textfieldSuperview.addConstraints(LH_Constraint5)
        
        self.textfieldSuperview.addConstraints(LV_Constraint0)
        self.textfieldSuperview.addConstraints(LV_Constraint1)
        self.textfieldSuperview.addConstraint(LV_Constraint2)
        self.textfieldSuperview.addConstraint(LV_Constraint3)
        self.textfieldSuperview.addConstraint(LV_Constraint4)
        
        
        self.textfieldSuperview.setNeedsLayout()
        self.textfieldSuperview.layoutIfNeeded()
        
        self.emailConfirmIcon.frame.origin = self.emailIndicator.frame.origin
        self.usernameConfirmIcon.frame.origin = self.usernameIndicator.frame.origin
        self.passwordConfirmIcon.frame.origin = self.passwordIndicator.frame.origin

    }
    func presentActionSheet(){
        let actionSheet = UIActionSheet(title: "Add a photo", delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: "Select from Photos", otherButtonTitles: "Take a Picture", "Remove Selected Picture")
        actionSheet.destructiveButtonIndex = 3

        
        actionSheet.showInView(self.view)
    }

    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex == 0 { // Select from Photos
            let imagePicker = UIImagePickerController()
            imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            imagePicker.delegate = self
            imagePicker.navigationBar.tintColor = UIColor.whiteColor()
            imagePicker.allowsEditing = true
            self.presentViewController(imagePicker, animated: true, completion: {
                self.viewWillAppear(false)
            })
            
        } else if buttonIndex == 2 { // Take a Picture

            let imagePicker = ProfileCameraViewController(handler: {
                (image:UIImage!) -> Void in
                if image != nil {
                    self.setAddPhotoButton(image)
                }
                self.dismissViewControllerAnimated(true, completion:{
                    UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: UIStatusBarAnimation.Slide)
                })
            })
            let navController = UINavigationController(rootViewController: imagePicker)
            self.presentViewController(navController, animated: true, completion: {
                self.viewWillAppear(false)
            })
            
        } else if buttonIndex == 3 {
            pickedImageView.removeFromSuperview()
            pickedImage = nil
        }
    }
    func navigationController(navigationController: UINavigationController, willShowViewController viewController: UIViewController, animated: Bool) {

        
        let titleLabel:UILabel = UILabel()
        titleLabel.numberOfLines = 1
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.textAlignment = NSTextAlignment.Center
        titleLabel.font = UIFont(name: "Lato-Semibold", size: 18)
        if navigationController.viewControllers.count == 1 {
            if viewController.view.tag != 1 {
                titleLabel.text = "Photos"
                titleLabel.sizeToFit()
                viewController.navigationItem.titleView = titleLabel
                viewController.view.tag = 1
            }
        }
        
        if navigationController.viewControllers.count == 2 {
            if viewController.view.tag != 1 {
                titleLabel.text = viewController.navigationItem.title!
                titleLabel.sizeToFit()
                viewController.navigationItem.titleView = titleLabel

                viewController.view.tag = 1
            }
        }
        
        if navigationController.viewControllers.count == 3 {
            if viewController.view.tag != 1 {
                let cropOverlay = viewController.view.subviews[1].subviews[0] 
                cropOverlay.hidden = true
                
                var position:CGFloat = 80
                if (screenHeight == 568){
                    position = 124
                }
                // ()
                let circleLayer = CAShapeLayer()
                let path2 = UIBezierPath(ovalInRect: CGRectMake(0, position, screenWidth, screenWidth))
                path2.usesEvenOddFillRule = true
                circleLayer.path = path2.CGPath
                circleLayer.fillColor = UIColor.clearColor().CGColor
                
                // []
                let path = UIBezierPath(roundedRect: CGRectMake(0, 0, screenWidth, screenHeight-72), cornerRadius: 0)
                path.usesEvenOddFillRule = true
                path.appendPath(path2)
                
                let fillLayer = CAShapeLayer()
                fillLayer.path = path.CGPath
                fillLayer.fillRule = kCAFillRuleEvenOdd
                fillLayer.fillColor = UIColor.blackColor().CGColor
                fillLayer.opacity = 0.8
                viewController.view.layer.addSublayer(fillLayer)
                let scrollView = viewController.view.subviews[0].subviews[0] as! UIScrollView
//                let imageView = viewController.view.subviews[0].subviews[0].subviews[0].subviews[0] as! UIImageView
                scrollView.bounces = false

                //scrollView.zoomScale = imageView.image!.size.height / scrollView.frame.size.height
                viewController.view.tag = 1
            }
        }

        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: false)

    }
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
//        self.viewWillAppear(true)
        self.dismissViewControllerAnimated(true, completion:{
            UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: UIStatusBarAnimation.Slide)
        })
        

    }
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
//        var position:CGFloat = 80
//        if (screenHeight == 568){
//            position = 124
//        }
//        let rect = CGRectMake(0, position, screenWidth, screenWidth)
//        let imageRef = CGImageCreateWithImageInRect(image.CGImage, rect)
//        var croppedImage = UIImage(CGImage: imageRef!)
        setAddPhotoButton(image)
        self.dismissViewControllerAnimated(true, completion:{
            UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: UIStatusBarAnimation.Slide)
        })
    }
    func setAddPhotoButton(photo:UIImage!){
        pickedImage = photo
        pickedImageView.frame.size = self.pickImageButton.frame.size
        //println(self.pickImageButton.frame.size)
        pickedImageView.image = photo
        pickedImageView.layer.cornerRadius = self.pickImageButton.frame.size.width/2
        pickedImageView.layer.masksToBounds = true
        
        self.pickImageButton.addSubview(pickedImageView)
    }

    func endEditing(){
        self.view.endEditing(true)
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController!.navigationBarHidden = false
        UIApplication.sharedApplication().setStatusBarHidden(false, withAnimation: UIStatusBarAnimation.None)
        self.Add_Keyboard_Observers()
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.view.endEditing(true)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func Add_Keyboard_Observers(){
        //initial view frame
        //make trigger when keyboard displayed/changed
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        
        //when keyboard is hidden
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    
    func keyboardWillShow(notification: NSNotification) {
        let info:NSDictionary = notification.userInfo!
        let keyboardSize = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        let keyboardHeight:CGFloat = keyboardSize.height
        let movement:CGFloat = keyboardHeight
        //var movement:CGFloat = self.logoSuperView.frame.size.height/2
        self.CurrentKeyboardHeight = movement
        
        let animationDuration = (info[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        
        UIView.animateWithDuration(animationDuration, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {

            self.navigationController!.navigationBar.frame.origin.y = self.navBarOriginY-movement
            self.mainView.frame.origin.y = self.view.frame.origin.y-movement
            }
            , completion: nil)
        
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        let info:NSDictionary = notification.userInfo!
//        let keyboardSize = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
//        let keyboardHeight:CGFloat = keyboardSize.height
        
//        var movement:CGFloat = keyboardHeight
        
        self.CurrentKeyboardHeight = 0
        let animationDuration = (info[UIKeyboardAnimationDurationUserInfoKey] as! NSNumber).doubleValue
        
        UIView.animateWithDuration(animationDuration, delay: 0, options: UIViewAnimationOptions.CurveEaseInOut, animations: {
            self.navigationController!.navigationBar.frame.origin.y = Utility.statusBarHeight()
            self.mainView.frame.origin.y = 0
            }, completion: nil)
        
    }
}
