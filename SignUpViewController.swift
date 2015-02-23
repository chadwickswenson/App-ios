//
//  SignUpViewController.swift
//  swiftLogin
//
//  Created by chad swenson on 1/9/15.
//  Copyright (c) 2015 iOS-Blog. All rights reserved.
//

import Foundation


class signUpViewController : UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
   
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var errorTexField: UILabel!
    
    @IBAction func submitButtonPressed(sender: AnyObject) {
        
        
        var emailText = emailTextField.text
        var passwordText = passwordTextField.text
        
        if emailText != "" && passwordText != "" {
    
            userSignUp()
            
        } else {
            
            self.errorTexField.text = "All Fields Required"
            
        }
        
    }
    
    func userSignUp() {
        
        var emailText = emailTextField.text
        var passwordText = passwordTextField.text
        
        var user = PFUser()
        user.email = emailText
        user.password = passwordText
        user.username = emailText
        
        self.errorTexField.text = "Loading..."
        
        user.signUpInBackgroundWithBlock {
            
            (succeeded: Bool!, error: NSError!) -> Void in
            if error == nil {
                // Hooray! Let them use the app now.
                self.errorTexField.text = "User Signed Up"
                self.dismissViewControllerAnimated(true, completion: {});
                
            } else {
                // Show the errorString somewhere and let the user try again.
                self.errorTexField.text = "It fucked up"
            }
        }
    }
    
}
