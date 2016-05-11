//
//  SignupViewController.swift
//  Eventer
//
//  Created by Grisha on 04/05/2015.
//  Copyright (c) 2015 Grisha. All rights reserved.
//

import UIKit

class SignupViewController: UIViewController {
    var screenWidth = UIScreen.mainScreen().bounds.width
    var screenHeight = UIScreen.mainScreen().bounds.height
    var mainView:UIView = UIView()

    var backgroundImageView:UIImageView = UIImageView()
    var logoImageView:UIImageView = UIImageView()
    var logoSuperView:UIView = UIView()
    
    var emailTextField:UITextField = UITextField()
    var usernameTextField:UITextField =  UITextField()
    var passwordTextField:UITextField = UITextField()
    var loginOrForgotButton:UIButton = UIButton()
    var loginButton:UIButton = UIButton()
    
    var loginSegmentView:UIView = UIView()
    var signupSegmentView:UIView = UIView()
    var loginOrSignupSuperview:UIView = UIView()
    var loginView:UIView = UIView()
    var signupView:UIView = UIView()
    
    // Sign up
    var signupButton:UIButton = UIButton()
    var signupIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    var signupLabel:UILabel = UILabel()
    var signupIcon:UIButton = UIButton()
    var signupContinueButton:UIButton = UIButton()
    
    var selectedView:Int = 2
    
    var CurrentKeyboardHeight:CGFloat = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(mainView)
        self.mainView.frame = self.view.frame
        
        self.loginOrSignupSuperview.translatesAutoresizingMaskIntoConstraints = false
        self.backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        self.logoSuperView.translatesAutoresizingMaskIntoConstraints = false
        self.signupButton.translatesAutoresizingMaskIntoConstraints = false
        self.loginButton.translatesAutoresizingMaskIntoConstraints = false
        self.signupSegmentView.translatesAutoresizingMaskIntoConstraints = false
        self.loginSegmentView.translatesAutoresizingMaskIntoConstraints = false
        
        // self view
        self.mainView.addSubview(backgroundImageView)
        self.mainView.addSubview(loginOrSignupSuperview)
        let views = [
            "bgView": backgroundImageView,
            "backView": loginOrSignupSuperview
        ]
        let H_Constraint0 = NSLayoutConstraint.constraintsWithVisualFormat("H:|[bgView]|", options: [], metrics: nil, views: views)
        let H_Constraint1 = NSLayoutConstraint.constraintsWithVisualFormat("H:|[backView]|", options: [], metrics: nil, views: views)
        let V_Constraint0 = NSLayoutConstraint.constraintsWithVisualFormat("V:|[bgView(250)][backView]|", options: [], metrics: nil, views: views)
        
        self.mainView.addConstraints(H_Constraint0)
        self.mainView.addConstraints(H_Constraint1)
        self.mainView.addConstraints(V_Constraint0)
        
        // background Image View
        self.backgroundImageView.addSubview(logoSuperView)
        self.backgroundImageView.addSubview(loginButton)
        self.backgroundImageView.addSubview(signupButton)
        self.backgroundImageView.addSubview(loginSegmentView)
        self.backgroundImageView.addSubview(signupSegmentView)

        let subviews = [
            "logo": logoSuperView,
            "signupbtn": signupButton,
            "loginbtn": loginButton,
            "signupseg": signupSegmentView,
            "loginseg": loginSegmentView
        ]
        

        let SH_Constraint0 = NSLayoutConstraint.constraintsWithVisualFormat("H:|[logo]|", options: [], metrics: nil, views: subviews)
        let SH_Constraint1 = NSLayoutConstraint.constraintsWithVisualFormat("H:|[signupseg(==loginseg)][loginseg]|", options: [], metrics: nil, views: subviews)
        let SH_Constraint2 = NSLayoutConstraint.constraintsWithVisualFormat("H:|[signupbtn(==loginbtn)][loginbtn]|", options: [], metrics: nil, views: subviews)
        let SV_Constraint0 = NSLayoutConstraint.constraintsWithVisualFormat("V:|-10-[logo][signupbtn(51@999)][signupseg(3)]|", options: [], metrics: nil, views: subviews)
        let SV_Constraint1 = NSLayoutConstraint.constraintsWithVisualFormat("V:|-10-[logo][loginbtn(51@999)][loginseg(3)]|", options: [], metrics: nil, views: subviews)

        
        self.backgroundImageView.addConstraints(SH_Constraint0)
        self.backgroundImageView.addConstraints(SH_Constraint1)
        self.backgroundImageView.addConstraints(SH_Constraint2)
        self.backgroundImageView.addConstraints(SV_Constraint0)
        self.backgroundImageView.addConstraints(SV_Constraint1)
        
        // Signup or Login Superview
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
        self.loginView.frame.size = self.loginOrSignupSuperview.frame.size
        self.signupView.frame.size = self.loginOrSignupSuperview.frame.size
        self.initializeLoginView()
        self.initializeSignupView()
        
        // Now Customize things

        self.backgroundImageView.image = UIImage(named: "login-background-pic.png")
        self.logoImageView.image = UIImage(named: "logo.png")
        self.logoImageView.frame.size = UIImage(named: "logo.png")!.size
        self.logoSuperView.addSubview(logoImageView)
        self.logoImageView.center = logoSuperView.center
        
        let passiveButtonColor = ColorFromCode.colorWithHexString("#B8B7B9")
        let activeButtonColor = UIColor.whiteColor()
        let buttonFont = UIFont(name: "Lato-Bold", size: 17)
        self.signupButton.titleLabel!.font = buttonFont
        self.signupButton.setTitle("SIGN UP", forState: UIControlState.Normal)
        self.signupButton.setTitleColor(passiveButtonColor, forState: UIControlState.Normal)
        self.signupButton.setTitleColor(activeButtonColor, forState: UIControlState.Selected)
        
        self.loginButton.titleLabel!.font = buttonFont
        self.loginButton.setTitle("LOG IN", forState: UIControlState.Normal)
        self.loginButton.setTitleColor(passiveButtonColor, forState: UIControlState.Normal)
        self.loginButton.setTitleColor(activeButtonColor, forState: UIControlState.Selected)
        switchViews(1, animated: false)
        
        usernameTextField.placeholder = "Username"
        passwordTextField.placeholder = "Password"
        emailTextField.placeholder = "E-mail"
        usernameTextField.font = UIFont(name: "Helvetica", size: 17)
        passwordTextField.font = UIFont(name: "Helvetica", size: 17)
        emailTextField.font = UIFont(name: "Helvetica", size: 17)
        usernameTextField.tintColor =  ColorFromCode.colorWithHexString("#B8B7B9")
        passwordTextField.tintColor =  ColorFromCode.colorWithHexString("#B8B7B9")
        emailTextField.tintColor = ColorFromCode.colorWithHexString("#B8B7B9")
        passwordTextField.secureTextEntry = true
        
        passwordTextField.addTarget(self, action: #selector(passwordTextFieldDidChange), forControlEvents: UIControlEvents.EditingChanged)
        loginOrForgotButton.addTarget(self, action: #selector(LoginOrForgot(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(endEditing)))
        
        loginButton.addTarget(self, action: #selector(buttonPressed(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        signupButton.addTarget(self, action: #selector(buttonPressed(_:)), forControlEvents: UIControlEvents.TouchUpInside)
        backgroundImageView.userInteractionEnabled = true
        signupButton.tag = 1
        loginButton.tag = 2
        
        // sign up
        signupIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyle.Gray
        signupIndicator.hidesWhenStopped = true
        signupIndicator.transform = CGAffineTransformMakeScale(1.25, 1.25)
        emailTextField.addTarget(self, action: #selector(emailTextFieldDidChange), forControlEvents: UIControlEvents.EditingChanged)
        emailTextField.keyboardType = UIKeyboardType.EmailAddress
        signupLabel.font = UIFont(name: "Lato-Semibold", size: 17)
        signupLabel.textAlignment = NSTextAlignment.Center
        signupIcon.userInteractionEnabled = false
        signupLabel.numberOfLines = 0
        
        let image = UIImage(named: "forward.png")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
        self.signupContinueButton.hidden = true
        self.signupContinueButton.setImage(image, forState: UIControlState.Normal)
        self.signupContinueButton.tintColor = ColorFromCode.colorWithHexString("#00CA7D")
        self.signupContinueButton.addTarget(self, action: #selector(ContinueSignUp), forControlEvents: UIControlEvents.TouchUpInside)
        // Do any additional setup after loading the view.
        switchForgetLoginButton(0)
        
        // Recognizer
        let rec = UISwipeGestureRecognizer(target: self, action: #selector(endEditing))
        rec.direction = UISwipeGestureRecognizerDirection.Down
        self.view.addGestureRecognizer(rec)

    }
    func endEditing(){
        self.view.endEditing(true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func ContinueSignUp(){
        if SignupManager.isValidEmail(self.emailTextField.text!) {
            let VC = self.storyboard!.instantiateViewControllerWithIdentifier("Signup2") as! SignupStep2ViewController
            VC.email = self.emailTextField.text
            self.navigationController!.pushViewController(VC, animated: true)
        }else{
            self.signupLabel.text = "Please enter a valid e-mail adress"
            self.signupLabel.textColor = ColorFromCode.colorWithHexString("#FF6067")
            self.signupIcon.setImage(UIImage(named: "decline"), forState: UIControlState.Normal)
            self.signupIcon.frame.size = UIImage(named: "decline")!.size
            self.signupContinueButton.hidden = true
        }
    }
    func passwordTextFieldDidChange(){
        switchForgetLoginButton((passwordTextField.text as NSString!).length)
    }
    
    func emailTextFieldDidChange(){
        if (emailTextField.text as NSString!).length > 0 {
            
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.signupIndicator.startAnimating()
                self.signupLabel.text = ""
                self.signupIcon.setImage(nil, forState: UIControlState.Normal)
                self.signupContinueButton.hidden = true
            })

            SignupManager.checkEmailForAvailability(emailTextField.text!, completion: {
                (busy:Bool, email:String) -> Void in
                if (email == self.emailTextField.text!){
                    dispatch_async(dispatch_get_main_queue(), { () -> Void in
                        self.signupIndicator.stopAnimating()
                        if !busy {
                            self.signupLabel.text = "You can use this e-mail"
                            self.signupLabel.textColor = ColorFromCode.colorWithHexString("#00CA7D")
                            self.signupIcon.setImage(UIImage(named: "accept"), forState: UIControlState.Normal)
                            self.signupIcon.frame.size = UIImage(named: "accept")!.size
                            self.signupContinueButton.hidden = false
                        }else{
                            self.signupLabel.text = "Unfortunately this e-mail is already used\nTry a different One"
                            self.signupLabel.textColor = ColorFromCode.colorWithHexString("#FF6067")
                            self.signupIcon.setImage(UIImage(named: "decline"), forState: UIControlState.Normal)
                            self.signupIcon.frame.size = UIImage(named: "decline")!.size
                            self.signupContinueButton.hidden = true

                        }
                    })
                }
            })
        }else{
            dispatch_async(dispatch_get_main_queue(), { () -> Void in
                self.signupIndicator.stopAnimating()
                self.signupLabel.text = ""
                self.signupIcon.setImage(nil, forState: UIControlState.Normal)
                self.signupContinueButton.hidden = true
            })
        }
    }
    func LoginOrForgot(sender:UIButton){
        let userlength = (usernameTextField.text as NSString!).length
        let passlength = (passwordTextField.text as NSString!).length
        if userlength > 0 {
            if passlength > 0 {
                Login()
            }else{ // forgot
                
            }
            
        }
        
    }
    func switchForgetLoginButton(length:Int){
        if length > 0 {
            let image = UIImage(named: "forward.png")!.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
            self.loginOrForgotButton.setImage(image, forState: UIControlState.Normal)
            self.loginOrForgotButton.tintColor = ColorFromCode.colorWithHexString("#00AAFC")
            self.loginOrForgotButton.setTitle(nil, forState: UIControlState.Normal)
        }else{
            self.loginOrForgotButton.titleLabel!.font = UIFont(name: "Lato-Regular", size: 14)
            self.loginOrForgotButton.setTitleColor(ColorFromCode.colorWithHexString("#00AAFC"), forState: UIControlState.Normal)
            self.loginOrForgotButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Highlighted)
            self.loginOrForgotButton.setTitle("Forgot?", forState: UIControlState.Normal)
            self.loginOrForgotButton.setImage(nil, forState: UIControlState.Normal)
        }
    }
    
    func initializeLoginView(){
        // Login
        let loginicon1 = UIButton() // username pic
        loginicon1.translatesAutoresizingMaskIntoConstraints = false
        loginicon1.setImage(UIImage(named: "login-username.png")!, forState: UIControlState.Normal)
        loginicon1.userInteractionEnabled = false
        let loginicon2 = UIButton() // password pic
        loginicon2.translatesAutoresizingMaskIntoConstraints = false
        loginicon2.setImage(UIImage(named: "login-pass.png")!, forState: UIControlState.Normal)
        loginicon2.userInteractionEnabled = false
        let loginline1 = UIView()
        loginline1.translatesAutoresizingMaskIntoConstraints = false
        loginline1.backgroundColor = ColorFromCode.colorWithHexString("#C8C6CC")
        let loginline2 = UIView()
        loginline2.translatesAutoresizingMaskIntoConstraints = false
        loginline2.backgroundColor = ColorFromCode.colorWithHexString("#C8C6CC")
        
        usernameTextField.translatesAutoresizingMaskIntoConstraints = false
        passwordTextField.translatesAutoresizingMaskIntoConstraints = false
        loginOrForgotButton.translatesAutoresizingMaskIntoConstraints = false
        
        self.loginView.addSubview(loginicon1)
        self.loginView.addSubview(loginicon2)
        self.loginView.addSubview(usernameTextField)
        self.loginView.addSubview(passwordTextField)
        self.loginView.addSubview(loginline1)
        self.loginView.addSubview(loginline2)
        self.loginView.addSubview(loginOrForgotButton)
        let loginviews = [
            "userpic": loginicon1,
            "passpic": loginicon2,
            "userline": loginline1,
            "passline": loginline2,
            "userfield": usernameTextField,
            "passfield": passwordTextField,
            "logforbtn": loginOrForgotButton
        ]
        let metrics = [
            "lineSpacingY" : 8,
            "picSpacingX": 2.5
        ]
        let LH_Constraint0 = NSLayoutConstraint.constraintsWithVisualFormat("H:|-picSpacingX-[userpic(55)]-picSpacingX-[userfield]-20@999-|", options: [], metrics: metrics, views: loginviews)
        let LH_Constraint1 = NSLayoutConstraint.constraintsWithVisualFormat("H:|-picSpacingX-[passpic(55)]-picSpacingX-[passfield][logforbtn(50)]-20@999-|", options: [], metrics: metrics, views: loginviews)
        let LH_Constraint2 = NSLayoutConstraint.constraintsWithVisualFormat("H:|-picSpacingX-[userpic(55)]-picSpacingX-[userline]-20@999-|", options: [], metrics: metrics, views: loginviews)
        let LH_Constraint3 = NSLayoutConstraint.constraintsWithVisualFormat("H:|-picSpacingX-[passpic(55)]-picSpacingX-[passline]-20@999-|", options: [], metrics: metrics, views: loginviews)
        
        let LV_Constraint0 = NSLayoutConstraint.constraintsWithVisualFormat("V:|-33.5-[userpic]-38.5-[passpic]->=0@999-|", options: [], metrics: nil, views: loginviews)
        let LV_Constraint1 = NSLayoutConstraint.constraintsWithVisualFormat("V:|-32.5-[userfield(==userpic)]-lineSpacingY-[userline(0.5)]-34-[passfield(==passpic@999)]-lineSpacingY-[passline(0.5)]->=0@999-|", options: [], metrics: metrics, views: loginviews)
        let LV_Constraint2 = NSLayoutConstraint(item: loginOrForgotButton, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: passwordTextField, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0)
        
        self.loginView.addConstraints(LH_Constraint0)
        self.loginView.addConstraints(LH_Constraint1)
        self.loginView.addConstraints(LH_Constraint2)
        self.loginView.addConstraints(LH_Constraint3)
        self.loginView.addConstraints(LV_Constraint0)
        self.loginView.addConstraints(LV_Constraint1)
        self.loginView.addConstraint(LV_Constraint2)

    }
    
    func initializeSignupView(){
        // Login
        let emailicon = UIButton() // username pic
        emailicon.translatesAutoresizingMaskIntoConstraints = false
        emailicon.setImage(UIImage(named: "signup-email.png")!, forState: UIControlState.Normal)
        emailicon.userInteractionEnabled = false

        let emailline = UIView()
        emailline.translatesAutoresizingMaskIntoConstraints = false
        emailline.backgroundColor = ColorFromCode.colorWithHexString("#C8C6CC")
        
        emailTextField.translatesAutoresizingMaskIntoConstraints = false
        signupIndicator.translatesAutoresizingMaskIntoConstraints = false
        signupLabel.translatesAutoresizingMaskIntoConstraints = false
        signupIcon.translatesAutoresizingMaskIntoConstraints = false
        signupContinueButton.translatesAutoresizingMaskIntoConstraints = false
        self.signupView.addSubview(emailicon)
        self.signupView.addSubview(emailTextField)
        self.signupView.addSubview(emailline)
        self.signupView.addSubview(signupIndicator)
        self.signupView.addSubview(signupLabel)
        self.signupView.addSubview(signupIcon)
        self.signupView.addSubview(signupContinueButton)

        let loginviews = [
            "emailpic": emailicon,
            "emailline": emailline,
            "emailfield": emailTextField,
            "ind": signupIndicator,
            "label": signupLabel,
            "icon" : signupIcon,
            "con": signupContinueButton
        ]
        let metrics = [
            "lineSpacingY" : 8,
            "picSpacingX": 2.5
        ]
        let LH_Constraint0 = NSLayoutConstraint.constraintsWithVisualFormat("H:|-picSpacingX-[emailpic(55)]-picSpacingX-[emailfield][con(50)]-20@999-|", options: [], metrics: metrics, views: loginviews)
        let LH_Constraint1 = NSLayoutConstraint.constraintsWithVisualFormat("H:|-picSpacingX-[emailpic(55)]-picSpacingX-[emailline]-20@999-|", options: [], metrics: metrics, views: loginviews)
        let LH_Constraint2 = NSLayoutConstraint.constraintsWithVisualFormat("H:|-20@999-[label]-15-[icon]->=20@999-|", options: [], metrics: metrics, views: loginviews)

        let LV_Constraint0 = NSLayoutConstraint.constraintsWithVisualFormat("V:|-33.5-[emailpic]->=0@999-|", options: [], metrics: nil, views: loginviews)
        let LV_Constraint1 = NSLayoutConstraint.constraintsWithVisualFormat("V:|-32.5-[emailfield(==emailpic)]-lineSpacingY-[emailline(0.5)]-25-[ind]->=0@999-|", options: [], metrics: metrics, views: loginviews)
        let LV_Constraint2 = NSLayoutConstraint(item: signupIndicator, attribute: NSLayoutAttribute.CenterX, relatedBy: NSLayoutRelation.Equal, toItem: signupIndicator.superview!, attribute: NSLayoutAttribute.CenterX, multiplier: 1, constant: 0)
        let LV_Constraint3 = NSLayoutConstraint(item: signupLabel, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: signupIndicator, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0)
        let LV_Constraint4 = NSLayoutConstraint(item: signupIcon, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: signupIndicator, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0)
        let LV_Constraint5 = NSLayoutConstraint(item: signupContinueButton, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: emailTextField, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0)


        self.signupView.addConstraints(LH_Constraint0)
        self.signupView.addConstraints(LH_Constraint1)
        self.signupView.addConstraints(LH_Constraint2)
        
        self.signupView.addConstraints(LV_Constraint0)
        self.signupView.addConstraints(LV_Constraint1)
        self.signupView.addConstraint(LV_Constraint2)
        self.signupView.addConstraint(LV_Constraint3)
        self.signupView.addConstraint(LV_Constraint4)
        self.signupView.addConstraint(LV_Constraint5)

        
    }

    func buttonPressed(sender:UIButton){
        if (sender.tag != selectedView){
            switchViews(sender.tag, animated: false)
        }
    }

    func switchViews(tag:Int, animated:Bool){
        self.view.endEditing(true)
        let passiveSegmentColor = UIColor.clearColor()
        let activeSegmentColor = ColorFromCode.colorWithHexString("#FFE473")
        if (tag == 1){
            selectedView = 1
            self.loginView.removeFromSuperview()
            self.loginOrSignupSuperview.addSubview(signupView)
            self.signupSegmentView.backgroundColor = activeSegmentColor
            self.loginSegmentView.backgroundColor = passiveSegmentColor
            self.loginButton.selected = false
            self.signupButton.selected = true
        }else if (tag == 2){
            selectedView = 2
            self.signupView.removeFromSuperview()
            self.loginOrSignupSuperview.addSubview(loginView)
            self.loginSegmentView.backgroundColor = activeSegmentColor
            self.signupSegmentView.backgroundColor = passiveSegmentColor
            self.loginButton.selected = true
            self.signupButton.selected = false
        }
    }

    func Signup(){

    }
    func Login(){
        self.view.endEditing(true)
        self.loginOrForgotButton.enabled = false
        KCSUser.loginWithUsername(
            usernameTextField.text!.lowercaseString,
            password: passwordTextField.text,
            withCompletionBlock: { (user: KCSUser!, error: NSError!, result: KCSUserActionResult) -> Void in
                if error == nil {
                    //the log-in was successful and the user is now the active user and credentials saved
                    //hide log-in view and show main app content
                    
                    KCSUser.activeUser().refreshFromServer({
                        (objects:[AnyObject]!, error:NSError!) -> Void in
                        if (error == nil){
                            let appDelegateTemp:AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
                            appDelegateTemp.window?.rootViewController = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()).instantiateInitialViewController() as UIViewController!

                        }else{
                            print("\(error.description)")
                        }
                    })

                } else {
                    self.loginOrForgotButton.enabled = true
                    //there was an error with the update save
                    let message = error.localizedDescription
                    let alert = UIAlertView(
                        title: NSLocalizedString("Login ailed", comment: "Login account failed"),
                        message: message,
                        delegate: nil,
                        cancelButtonTitle: NSLocalizedString("OK", comment: "OK")
                    )
                    alert.show()
                }
            }
        )
    }
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.sharedApplication().setStatusBarHidden(true, withAnimation: UIStatusBarAnimation.None)
        self.navigationController?.navigationBarHidden = true
        self.Add_Keyboard_Observers()
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        endEditing()
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().removeObserver(self, name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func Add_Keyboard_Observers(){
        //initial view frame
        //make trigger when keyboard displayed/changed
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIKeyboardWillShowNotification, object: nil)
        
        //when keyboard is hidden
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIKeyboardWillHideNotification, object: nil)
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
            self.mainView.frame.origin.y = 0
            }, completion: nil)
        
    }
}
