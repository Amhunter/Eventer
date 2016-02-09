//
//  Signup Manager.swift
//  Eventer
//
//  Created by Grisha on 21/08/2015.
//  Copyright (c) 2015 Grisha. All rights reserved.
//

import UIKit

class SignupManager {
    
    class func checkEmailForAvailability(email:String,completion: (busy:Bool,email:String) -> Void){
        KCSUser.userWithUsername("t", password: "t", fieldsAndValues: ["_id":"-check-", KCSUserAttributeEmail: email.lowercaseString]) {
            (user:KCSUser!, error:NSError!, result:KCSUserActionResult) -> Void in
            if error != nil {
                if error.userInfo["body"] != nil {
                    if error.userInfo["body"]!.valueForKey("error") != nil {
                        if error.userInfo["body"]!.valueForKey("error") as! String == "free" {
                            completion(busy: false, email: email)
                        } else if error.userInfo["body"]!.valueForKey("error") as! String == "busy" {
                            completion(busy: true, email: email)
                        } else {
                            print(error.description)
                        }
                    }
                }else{
                    print(error.description)
                }
            }
        }
    }
    class func checkUsernameForAvailability(username:String,completion: (busy:Bool,username:String) -> Void){
        KCSUser.checkUsername(username.lowercaseString, withCompletionBlock: {
            (string:String!, isTaken:Bool, error:NSError!) -> Void in
            if error == nil {
                print(string)
                if isTaken {
                    completion(busy: true, username: username)
                }else{
                    completion(busy: false, username: username)
                }
            }

        })
        
    }
    class func isValidEmail(emailString:String) -> Bool {
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,10}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        
        let result = emailTest.evaluateWithObject(emailString)
        return result
    }
    
    class func isValidPhoneNumber(phoneNumber:String) -> Bool{
        
        do {
            let matchDetector = try NSDataDetector(types: NSTextCheckingType.PhoneNumber.rawValue)
            let matchNumber = matchDetector.numberOfMatchesInString(phoneNumber, options: NSMatchingOptions(rawValue: 0), range: NSMakeRange(0, (phoneNumber as NSString).length))
            if matchNumber > 0 {
                return true
            }else{
                return false
            }
        } catch _ {
            return false
        }

    }
    class func SignupWithParameters(email:String,username:String,password:String,picture:UIImage!,handler: (error:NSError!,pictureUploadError:NSError!) -> Void){
        KCSUser.userWithUsername(username.lowercaseString, password: password, fieldsAndValues: ["access":"public", KCSUserAttributeEmail:email.lowercaseString]) { (user:KCSUser!, error:NSError!, result:KCSUserActionResult) -> Void in
            
            if (error == nil){
                if picture != nil {
                    FileDownloadManager.uploadImage(picture,options: nil, completionBlock: {
                        (error:NSError!, fileId:String!) -> Void in
                        if (error == nil) {
                            
                            KCSUser.activeUser().setValue(fileId, forAttribute: "pictureId")
                            KCSUser.activeUser().saveWithCompletionBlock { (objects:[AnyObject]!, error:NSError!) -> Void in
                                if (error == nil){
                                    handler(error: nil, pictureUploadError: nil)
                                }else{
                                    handler(error: nil, pictureUploadError: error)
                                }
                            }
                            
                        }else{
                            handler(error: nil, pictureUploadError: error)
                        }
                    })
                }else{
                    handler(error: nil, pictureUploadError: nil)
                }
                
            }else{
                handler(error: error, pictureUploadError: nil)
            }
        }
    }


}
