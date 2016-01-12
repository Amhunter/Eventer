//
//  SignupStep3ViewController.swift
//  Eventer
//
//  Created by Grisha on 25/08/2015.
//  Copyright (c) 2015 Grisha. All rights reserved.
//

import UIKit

class SignupStep3ViewController: UIViewController,UITextFieldDelegate, UITextViewDelegate {

    var screenWidth = UIScreen.mainScreen().bounds.width
    var screenHeight = UIScreen.mainScreen().bounds.height
    var mainView:UIView = UIView()
    
    var backgroundImageView:UIImageView = UIImageView()
    var backgroundLabel:UILabel = UILabel()
    var logoSuperView:UIView = UIView()
    var textfieldSuperview = UIView()
    var fullNameTextField:UITextField = UITextField()
    var phoneNumberTextField:UITextField =  UITextField()
    var bioTextView:UITextView = UITextView()
    var bioPlaceholder:UILabel = UILabel()
    var fullNameCount = UILabel()
    var bioCount = UILabel()
    
    
    var fullName:String!

    var fullNameValid:Bool = true
    var phoneNumberValid:Bool = false
    var bioValid:Bool = false
    
    var navBarOriginY:CGFloat!
    var selectedView:Int = 2
    
    var CurrentKeyboardHeight:CGFloat = 0
    
    var pushButton:UIBarButtonItem = UIBarButtonItem()
    var skipButton:UIBarButtonItem = UIBarButtonItem()
    var pushIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    func back(){
        self.navigationController!.popViewControllerAnimated(true)
    }
    
    override func viewDidLoad() {
        Set_Subviews()
    }
    func Set_Subviews(){
        
        pushButton = UIBarButtonItem(image: UIImage(named: "forward.png"), style: UIBarButtonItemStyle.Plain, target: self, action: "save:")
        pushButton.tintColor = UIColor.whiteColor()
        
        skipButton = UIBarButtonItem(title: " Skip", style: UIBarButtonItemStyle.Plain, target: self , action: "skip")
        skipButton.setTitleTextAttributes([NSFontAttributeName: UIFont(name: "Lato-Semibold", size: 18)!, NSForegroundColorAttributeName: UIColor.whiteColor()], forState: UIControlState.Normal)
        self.navigationItem.hidesBackButton = true
        self.navigationItem.rightBarButtonItem = pushButton
        self.navigationItem.leftBarButtonItem = skipButton
        
        
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
        
        // Background Label
        self.backgroundImageView.image = UIImage(named: "signup-background.png")
        backgroundImageView.addSubview(backgroundLabel)
        backgroundLabel.frame = backgroundImageView.frame
        backgroundLabel.textColor = UIColor.whiteColor()
        backgroundLabel.font = UIFont(name: "Lato-Semibold", size: 17)
        backgroundLabel.textAlignment = NSTextAlignment.Center
        backgroundLabel.text = "Congratulations, you have created your account in Eventer!"
        backgroundLabel.numberOfLines = 0
        backgroundLabel.backgroundColor = UIColor.blackColor().colorWithAlphaComponent(0.65)
        
//        var passiveButtonColor = ColorFromCode.colorWithHexString("#B8B7B9")
//        var activeButtonColor = UIColor.whiteColor()
//        var buttonFont = UIFont(name: "Lato-Bold", size: 17)
        
        phoneNumberTextField.placeholder = "Phone number"
        fullNameTextField.placeholder = "Full name"
        phoneNumberTextField.font = UIFont(name: "Helvetica", size: 17)
        fullNameTextField.font = UIFont(name: "Helvetica", size: 17)
        phoneNumberTextField.tintColor =  ColorFromCode.colorWithHexString("#B8B7B9")
        fullNameTextField.tintColor = ColorFromCode.colorWithHexString("#B8B7B9")
        
        fullNameTextField.addTarget(self, action: "fullNameTextFieldDidChange", forControlEvents: UIControlEvents.EditingChanged)
        phoneNumberTextField.keyboardType = UIKeyboardType.PhonePad
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: "endEditing"))
        
        backgroundImageView.userInteractionEnabled = true
        
        fullNameTextField.delegate = self
        
        // Push Indicator
        pushIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.White
        pushIndicator.hidesWhenStopped = true
        pushIndicator.frame = CGRectMake(0,0,25,25)
        pushIndicator.autoresizingMask = [UIViewAutoresizing.FlexibleLeftMargin, UIViewAutoresizing.FlexibleRightMargin, UIViewAutoresizing.FlexibleTopMargin, UIViewAutoresizing.FlexibleBottomMargin]
        pushIndicator.sizeToFit()
        
        
        // Bio textview and placeholder
        bioTextView.font = UIFont(name: "Helvetica", size: 17)
        bioTextView.tintColor =  ColorFromCode.colorWithHexString("#B8B7B9")
        bioTextView.delegate  = self
        bioTextView.textContainer.lineFragmentPadding = 0
        bioTextView.textContainerInset = UIEdgeInsetsZero
        

        bioPlaceholder = UILabel()
        bioPlaceholder.text = "Bio"
        bioPlaceholder.font = bioTextView.font
        bioPlaceholder.sizeToFit()
        bioPlaceholder.userInteractionEnabled = false
        bioTextView.addSubview(bioPlaceholder)
        bioPlaceholder.frame.origin = CGPointMake(0, 0)
        bioPlaceholder.textColor = ColorFromCode.colorWithHexString("#BEBEBE")
        bioPlaceholder.hidden = bioTextView.text.characters.count != 0
        
        
        // Count Labels
        fullNameCount.textColor = ColorFromCode.randomBlueColorFromNumber(3)
        fullNameCount.font = UIFont(name: "Lato-Semibold", size: 17)
        fullNameCount.text = "100"
        bioCount.textColor = ColorFromCode.randomBlueColorFromNumber(3)
        bioCount.font = UIFont(name: "Lato-Semibold", size: 17)
        bioCount.text = "150"
        
        // Recognizer
        let rec = UISwipeGestureRecognizer(target: self, action: "endEditing")
        rec.direction = UISwipeGestureRecognizerDirection.Down
        self.view.addGestureRecognizer(rec)
    }
    func fullNameTextFieldDidChange(){
        fullNameCount.text = "\(100 - (fullNameTextField.text!).characters.count)"
    }
    func textViewDidChange(textView: UITextView) {
        bioPlaceholder.hidden = bioTextView.text.characters.count != 0
        bioCount.text = "\(150 - (bioTextView.text!).characters.count)"
    }
    func initMainView(){
        self.textfieldSuperview.backgroundColor = UIColor.whiteColor()
        let fullNameIcon = UIButton() // phoneNumber pic
        fullNameIcon.translatesAutoresizingMaskIntoConstraints = false
        fullNameIcon.setImage(UIImage(named: "signup-fullname.png")!, forState: UIControlState.Normal)
        fullNameIcon.userInteractionEnabled = false
        let phoneNumberIcon = UIButton() // phoneNumber pic
        phoneNumberIcon.translatesAutoresizingMaskIntoConstraints = false
        phoneNumberIcon.setImage(UIImage(named: "signup-phone.png")!, forState: UIControlState.Normal)
        phoneNumberIcon.userInteractionEnabled = false
        let bioIcon = UIButton() // bio pic
        bioIcon.translatesAutoresizingMaskIntoConstraints = false
        bioIcon.setImage(UIImage(named: "signup-bio.png")!, forState: UIControlState.Normal)
        bioIcon.userInteractionEnabled = false
        let fullNameline = UIView()
        fullNameline.translatesAutoresizingMaskIntoConstraints = false
        fullNameline.backgroundColor = ColorFromCode.colorWithHexString("#C8C6CC")
        let phoneNumberline = UIView()
        phoneNumberline.translatesAutoresizingMaskIntoConstraints = false
        phoneNumberline.backgroundColor = ColorFromCode.colorWithHexString("#C8C6CC")
        let bioline = UIView()
        bioline.translatesAutoresizingMaskIntoConstraints = false
        bioline.backgroundColor = ColorFromCode.colorWithHexString("#C8C6CC")
        
        fullNameTextField.translatesAutoresizingMaskIntoConstraints = false
        phoneNumberTextField.translatesAutoresizingMaskIntoConstraints = false
        bioTextView.translatesAutoresizingMaskIntoConstraints = false
        bioCount.translatesAutoresizingMaskIntoConstraints = false
        fullNameCount.translatesAutoresizingMaskIntoConstraints = false
        
        self.textfieldSuperview.addSubview(fullNameIcon)
        self.textfieldSuperview.addSubview(phoneNumberIcon)
        self.textfieldSuperview.addSubview(bioIcon)
        self.textfieldSuperview.addSubview(fullNameTextField)
        self.textfieldSuperview.addSubview(phoneNumberTextField)
        self.textfieldSuperview.addSubview(bioTextView)
        self.textfieldSuperview.addSubview(fullNameline)
        self.textfieldSuperview.addSubview(phoneNumberline)
        self.textfieldSuperview.addSubview(bioline)
        self.textfieldSuperview.addSubview(fullNameCount)
        self.textfieldSuperview.addSubview(bioCount)
        
        let views = [
            "fullNamepic": fullNameIcon,
            "phonepic": phoneNumberIcon,
            "biopic": bioIcon,
            "fullNameline": fullNameline,
            "phoneline": phoneNumberline,
            "bioline": bioline,
            "fullNamefield": fullNameTextField,
            "phonefield": phoneNumberTextField,
            "biofield": bioTextView,
            "fullNameCount": fullNameCount,
            "bioCount": bioCount
        ]
        let metrics = [
            "lineSpacingY" : 8,
            "picSpacingX": 2.5
        ]
        let LH_Constraint0 = NSLayoutConstraint.constraintsWithVisualFormat("H:|-picSpacingX-[fullNamepic(55)]-picSpacingX-[fullNamefield][fullNameCount(40)]-20@999-|", options: [], metrics: metrics, views: views)
        let LH_Constraint1 = NSLayoutConstraint.constraintsWithVisualFormat("H:|-picSpacingX-[phonepic(55)]-picSpacingX-[phonefield]-20@999-|", options: [], metrics: metrics, views: views)
        let LH_Constraint2 = NSLayoutConstraint.constraintsWithVisualFormat("H:|-picSpacingX-[biopic(55)]-picSpacingX-[biofield][bioCount(40)]-20@999-|", options: [], metrics: metrics, views: views)
        
        let LH_Constraint3 = NSLayoutConstraint.constraintsWithVisualFormat("H:|-picSpacingX-[fullNamepic(55)]-picSpacingX-[fullNameline]-20@999-|", options: [], metrics: metrics, views: views)
        let LH_Constraint4 = NSLayoutConstraint.constraintsWithVisualFormat("H:|-picSpacingX-[phonepic(55)]-picSpacingX-[phoneline]-20@999-|", options: [], metrics: metrics, views: views)
        let LH_Constraint5 = NSLayoutConstraint.constraintsWithVisualFormat("H:|-picSpacingX-[biopic(55)]-picSpacingX-[bioline]-20@999-|", options: [], metrics: metrics, views: views)
        
        let LV_Constraint0 = NSLayoutConstraint.constraintsWithVisualFormat("V:|-33.5-[fullNamepic]-38.5-[phonepic]-38.5-[biopic]->=0@999-|", options: [], metrics: nil, views: views)
        let LV_Constraint1 = NSLayoutConstraint.constraintsWithVisualFormat("V:|-32.5-[fullNamefield(==fullNamepic)]-lineSpacingY-[fullNameline(0.5)]-34-[phonefield(==phonepic@999)]-lineSpacingY-[phoneline(0.5)]-30-[biofield(>=50@999)]-lineSpacingY-[bioline(0.5)]->=15@999-|", options: [], metrics: metrics, views: views)
        let LV_Constraint2 = NSLayoutConstraint(item: fullNameCount, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: fullNameTextField, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0)
        let LV_Constraint3 = NSLayoutConstraint(item: bioCount, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: bioIcon, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0)
        
        
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
        
        
        self.textfieldSuperview.setNeedsLayout()
        self.textfieldSuperview.layoutIfNeeded()
        

        
        
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if textField == fullNameTextField {
            // prevent undo bug
            if (range.length + range.location > textField.text!.characters.count )
            {
                return false;
            }
            
            let newLength = textField.text!.characters.count + string.characters.count - range.length
            return newLength <= 100
        }
        return true
    }
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        // prevent undo bug
        if (range.length + range.location > textView.text.characters.count )
        {
            return false;
        }
        
        let newLength = textView.text.characters.count + text.characters.count - range.length
        return newLength <= 150
    }
    
    func endEditing(){
        self.view.endEditing(true)
    }
    func skip(){
        let appDelegateTemp:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        appDelegateTemp.window?.rootViewController = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()).instantiateInitialViewController()
    }
    
    func save(sender:UIBarButtonItem){
        let indicator = UIBarButtonItem(customView: pushIndicator)

        if phoneNumberTextField.text!.characters.count > 0 {
            if SignupManager.isValidPhoneNumber(phoneNumberTextField.text!) {
                pushIndicator.startAnimating()
                self.navigationItem.rightBarButtonItem = indicator
                KCSUser.activeUser().setValue(phoneNumberTextField.text, forAttribute: "phoneNumber")
                KCSUser.activeUser().setValue(fullNameTextField.text, forAttribute: KCSUserAttributeGivenname)
                KCSUser.activeUser().setValue(bioTextView.text, forAttribute: "bio")
                KCSUser.activeUser().saveWithCompletionBlock({
                    (objects:[AnyObject]!, error:NSError!) -> Void in
                    self.pushIndicator.stopAnimating()
                    self.navigationItem.rightBarButtonItem = self.pushButton
                    if error == nil {
                        let appDelegateTemp:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                        appDelegateTemp.window?.rootViewController = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()).instantiateInitialViewController()
                    }else{
                        self.backgroundLabel.text = "Ooops!\nSomething bad happened!"
                    }
                })
            }else{
                backgroundLabel.text = "Please enter a valid phone number"
                backgroundLabel.textColor = UIColor.redColor()
            }
        }else{
            pushIndicator.startAnimating()
            self.navigationItem.rightBarButtonItem = indicator
            KCSUser.activeUser().setValue(phoneNumberTextField.text, forAttribute: "phoneNumber")
            KCSUser.activeUser().setValue(fullNameTextField.text, forAttribute: KCSUserAttributeGivenname)
            KCSUser.activeUser().setValue(bioTextView.text, forAttribute: "bio")
            KCSUser.activeUser().saveWithCompletionBlock({
                (objects:[AnyObject]!, error:NSError!) -> Void in
                self.pushIndicator.stopAnimating()
                self.navigationItem.rightBarButtonItem = self.pushButton
                if error == nil {
                    let appDelegateTemp:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                    appDelegateTemp.window?.rootViewController = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()).instantiateInitialViewController()
                }else{
                    self.backgroundLabel.text = "Ooops!\nSomething bad happened!"
                }
            })
        }

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
