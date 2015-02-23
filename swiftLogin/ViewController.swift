//
//  ViewController.swift
//  swiftLogin
//
//  Created by  -  on 27/11/2014.
//  Copyright (c) 2014 iOS-Blog. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    
    let service = "Locksmith2"
    let userAccount = "LocksmithUser2"
    let key = "myKey2"
    
    @IBOutlet var connectionCheckLabel: UILabel!
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
       
            let (dictionary, error) = Locksmith.loadData(forKey: key, inService: service, forUserAccount: userAccount)
            
            if let dictionary = dictionary {
                //self.labelMessage.text = "Yes, You're logged in."
                self.performSegueWithIdentifier("loggedInSegue", sender: self)
            } else {
                self.performSegueWithIdentifier("logInSegue", sender: self)
            }
            
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

