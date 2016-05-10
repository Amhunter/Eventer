//
//  ProfileUsernameCell.swift
//  Eventer
//
//  Created by Grisha on 31/01/2015.
//  Copyright (c) 2015 Grisha. All rights reserved.
//

import UIKit

class EditProfileTableViewCell: UITableViewCell, UITextFieldDelegate, UITextViewDelegate {
    
    var usernameTextfield = UITextField()
    var screenWidth = UIScreen.mainScreen().bounds.width
    var screenHeight = UIScreen.mainScreen().bounds.height
    
    var logoSuperView:UIView = UIView()
    var fullNameTextField:UITextField = UITextField()
    var phoneNumberTextField:UITextField =  UITextField()
    var bioTextView:UITextView = UITextView()
    var bioPlaceholder = UITextView()
    var fullNameCount = UILabel()
    var bioCount = UILabel()
    var fullNameValid:Bool = true
    var phoneNumberValid:Bool = false
    var bioValid:Bool = false
    var CurrentKeyboardHeight:CGFloat = 0
    
    var fullName:String!
    
    var navBarOriginY:CGFloat!
    var selectedView:Int = 2
    
    var pushButton:UIBarButtonItem = UIBarButtonItem()
    var skipButton:UIBarButtonItem = UIBarButtonItem()
    var pushIndicator:UIActivityIndicatorView = UIActivityIndicatorView()
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setSubviews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func setSubviews(){

        
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
        
        self.contentView.addSubview(fullNameIcon)
        //self.contentView.addSubview(phoneNumberIcon)
        self.contentView.addSubview(bioIcon)
        self.contentView.addSubview(fullNameTextField)
        //self.contentView.addSubview(phoneNumberTextField)
        self.contentView.addSubview(bioTextView)
        self.contentView.addSubview(fullNameline)
        //self.contentView.addSubview(phoneNumberline)
        self.contentView.addSubview(bioline)
        self.contentView.addSubview(fullNameCount)
        self.contentView.addSubview(bioCount)
        
        let views = [
            "fullNamepic": fullNameIcon,
            //"phonepic": phoneNumberIcon,
            "biopic": bioIcon,
            "fullNameline": fullNameline,
            //"phoneline": phoneNumberline,
            "bioline": bioline,
            "fullNamefield": fullNameTextField,
            //"phonefield": phoneNumberTextField,
            "biofield": bioTextView,
            "fullNameCount": fullNameCount,
            "bioCount": bioCount
        ]
        let metrics = [
            "lineSpacingY" : 8,
            "picSpacingX": 2.5
        ]
        let LH_Constraint0 = NSLayoutConstraint.constraintsWithVisualFormat("H:|-picSpacingX-[fullNamepic(55)]-picSpacingX-[fullNamefield][fullNameCount(40)]-20@999-|", options: [], metrics: metrics, views: views)
//        let LH_Constraint1 = NSLayoutConstraint.constraintsWithVisualFormat("H:|-picSpacingX-[phonepic(55)]-picSpacingX-[phonefield]-20@999-|", options: [], metrics: metrics, views: views)
        let LH_Constraint2 = NSLayoutConstraint.constraintsWithVisualFormat("H:|-picSpacingX-[biopic(55)]-picSpacingX-[biofield][bioCount(40)]-20@999-|", options: [], metrics: metrics, views: views)
        
        let LH_Constraint3 = NSLayoutConstraint.constraintsWithVisualFormat("H:|-picSpacingX-[fullNamepic(55)]-picSpacingX-[fullNameline]-20@999-|", options: [], metrics: metrics, views: views)
        //let LH_Constraint4 = NSLayoutConstraint.constraintsWithVisualFormat("H:|-picSpacingX-[phonepic(55)]-picSpacingX-[phoneline]-20@999-|", options: [], metrics: metrics, views: views)
        let LH_Constraint5 = NSLayoutConstraint.constraintsWithVisualFormat("H:|-picSpacingX-[biopic(55)]-picSpacingX-[bioline]-20@999-|", options: [], metrics: metrics, views: views)
        
        let LV_Constraint0 = NSLayoutConstraint.constraintsWithVisualFormat("V:|-33.5-[fullNamepic]-38.5-[biopic]->=0@999-|", options: [], metrics: nil, views: views)
        let LV_Constraint1 = NSLayoutConstraint.constraintsWithVisualFormat("V:|-32.5-[fullNamefield(==fullNamepic)]-lineSpacingY-[fullNameline(0.5)]-30-[biofield(>=150@999)]-lineSpacingY-[bioline(0.5)]->=15@999-|", options: [], metrics: metrics, views: views)
        let LV_Constraint2 = NSLayoutConstraint(item: fullNameCount, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: fullNameTextField, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0)
        let LV_Constraint3 = NSLayoutConstraint(item: bioCount, attribute: NSLayoutAttribute.CenterY, relatedBy: NSLayoutRelation.Equal, toItem: bioIcon, attribute: NSLayoutAttribute.CenterY, multiplier: 1, constant: 0)
        
        
        self.contentView.addConstraints(LH_Constraint0)
        //self.contentView.addConstraints(LH_Constraint1)
        self.contentView.addConstraints(LH_Constraint2)
        self.contentView.addConstraints(LH_Constraint3)
        //self.contentView.addConstraints(LH_Constraint4)
        self.contentView.addConstraints(LH_Constraint5)
        
        self.contentView.addConstraints(LV_Constraint0)
        self.contentView.addConstraints(LV_Constraint1)
        self.contentView.addConstraint(LV_Constraint2)
        self.contentView.addConstraint(LV_Constraint3)
        
        
        self.contentView.setNeedsLayout()
        self.contentView.layoutIfNeeded()
        
        phoneNumberTextField.placeholder = "Phone number"
        fullNameTextField.placeholder = "Full name"
        fullNameTextField.textAlignment = NSTextAlignment.Center
        phoneNumberTextField.font = UIFont(name: "Helvetica", size: 17)
        fullNameTextField.font = UIFont(name: "Helvetica", size: 17)
        phoneNumberTextField.tintColor =  ColorFromCode.colorWithHexString("#B8B7B9")
        fullNameTextField.tintColor = ColorFromCode.colorWithHexString("#B8B7B9")
        
        fullNameTextField.addTarget(self, action: #selector(fullNameTextFieldDidChange), forControlEvents: UIControlEvents.EditingChanged)
        phoneNumberTextField.keyboardType = UIKeyboardType.PhonePad
        
        fullNameTextField.delegate = self
        
        
        // Bio textview and placeholder
        bioTextView.font = UIFont(name: "Helvetica", size: 17)
        bioTextView.tintColor =  ColorFromCode.colorWithHexString("#B8B7B9")
        bioTextView.delegate  = self
        bioTextView.textContainer.lineFragmentPadding = 0
        bioTextView.textContainerInset = UIEdgeInsetsZero
        
        // Placeholder
        bioPlaceholder.editable = false
        bioPlaceholder.scrollEnabled = false
        bioPlaceholder.font = bioTextView.font
        bioPlaceholder.text = "Short bio"
        bioPlaceholder.frame.size = bioPlaceholder.sizeThatFits(CGSizeMake(bioTextView.frame.width,100))
        bioPlaceholder.textContainer.lineFragmentPadding = 0
        bioPlaceholder.textContainerInset = UIEdgeInsetsZero
        bioPlaceholder.userInteractionEnabled = false
        bioTextView.addSubview(bioPlaceholder)
        bioPlaceholder.frame.origin = CGPointZero
        bioPlaceholder.textColor = ColorFromCode.colorWithHexString("#BEBEBE")
        bioPlaceholder.hidden = bioTextView.text.characters.count != 0

        // Count Labels
        fullNameCount.textColor = ColorFromCode.randomBlueColorFromNumber(3)
        fullNameCount.font = UIFont(name: "Lato-Semibold", size: 17)
        fullNameCount.text = "100"
        bioCount.textColor = ColorFromCode.randomBlueColorFromNumber(3)
        bioCount.font = UIFont(name: "Lato-Semibold", size: 17)
        bioCount.text = "150"
        

        
    }
    
    func fullNameTextFieldDidChange(){
        fullNameCount.text = "\(100 - (fullNameTextField.text!).characters.count)"
    }
    func textViewDidChange(textView: UITextView) {
        bioPlaceholder.hidden = bioTextView.text.characters.count != 0
        bioCount.text = "\(150 - (bioTextView.text!).characters.count)"
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

}
