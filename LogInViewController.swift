//
//  LogInViewController.swift
//  swiftLogin
//
//  Created by  -  on 27/11/2014.
//  Copyright (c) 2014 iOS-Blog. All rights reserved.
//

import Foundation

class logInViewController : UIViewController {
    
    let service = "Locksmith2"
    let userAccount = "LocksmithUser2"
    let key = "myKey2"
    
    @IBOutlet var LogInLabel: UILabel!
    
    @IBOutlet var logInUsername: UITextField!
    
    @IBOutlet var logInPassword: UITextField!
    
    @IBOutlet var logInSavePasswordLabel: UILabel!
    
    @IBOutlet var logInsavePasswordSwitch: UISwitch!
    
    @IBAction func logInActionButton(sender: AnyObject) {
        
        if logInUsername.text != "" && logInPassword.text != "" {
            if logInsavePasswordSwitch.on {
                PFUser.logInWithUsernameInBackground(logInUsername.text, password:logInPassword.text) {
                    (user: PFUser!, error: NSError!) -> Void in
                    if user != nil {
                        Locksmith.saveData(["some key": "\(NSDate())"], forKey: self.key, inService: self.service, forUserAccount: self.userAccount)
                        self.performSegueWithIdentifier("LogInSegue", sender: self)
                    } else {
                        // The login failed. Check error to see why.
                    }
                }
                
            } else {
                self.performSegueWithIdentifier("LogInSegue", sender: self)
            }
        } else {
            self.LogInLabel.text = "All Fields Required"
        }
        
    }

    
}