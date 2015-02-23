//
//  loggedInViewController.swift
//  swiftLogin
//
//  Created by  -  on 27/11/2014.
//  Copyright (c) 2014 iOS-Blog. All rights reserved.
//

import Foundation

class loggedInViewController : UIViewController {
    
    let service = "Locksmith2"
    let userAccount = "LocksmithUser2"
    let key = "myKey2"
    
    //@IBOutlet var loggedInWelcome: UILabel!
    @IBOutlet var loggedInWelcome: UILabel!
    
    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var leftConstraint: NSLayoutConstraint!
    @IBOutlet weak var requestTextField: UITextField!
    
    @IBOutlet weak var sendButton: UIButton!
    
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var loader: UIActivityIndicatorView!
    @IBOutlet weak var inView: UIView!
    
    @IBOutlet weak var chatView: UIView!
    
    @IBOutlet weak var chatListView: UITableView!
    
    @IBOutlet weak var calButton: UIButton!
    
    var chatItemsArray: [AnyObject] = []
    var currentSession: AnyObject = "none"
    
    @IBAction func logOutButton(sender: AnyObject) {
        
        Locksmith.deleteData(forKey: key, inService: service, forUserAccount: userAccount)
        self.performSegueWithIdentifier("logOutSegue", sender: self)
        
        
    }
    
    
    @IBAction func viewTouched(sender: AnyObject) {
        
        returnToDefaultState()
        
    }
    
    
    @IBAction func menuCloseTouch(sender: AnyObject) {
        if self.leftConstraint.constant < -30 {
            
            self.leftConstraint.constant = -5
            self.menuView.setNeedsUpdateConstraints()
            
            UIView.animateWithDuration(0.2, animations: { () -> Void in
                self.view.layoutIfNeeded()
            })
            
        }
        else{
            self.leftConstraint.constant = -400
            self.menuView.setNeedsUpdateConstraints()
            
            UIView.animateWithDuration(0.2, animations: { () -> Void in
                self.view.layoutIfNeeded()
            })
        }
    }

    @IBAction func menuTouched(sender: AnyObject) {
        if self.leftConstraint.constant < -30 {
            
        self.leftConstraint.constant = -16
        self.menuView.setNeedsUpdateConstraints()
        
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.view.layoutIfNeeded()
        })
            
        }
        else{
            self.leftConstraint.constant = -400
            self.menuView.setNeedsUpdateConstraints()
            
            UIView.animateWithDuration(0.2, animations: { () -> Void in
                self.view.layoutIfNeeded()
            })
        }
       /* var nibView = NSBundle.mainBundle().loadNibNamed("MenuView", owner: self, options: nil)[0] as UIView
        //nibView.frame = self.bounds;
        self.view.addSubview(nibView)*/
        
    }
    @IBAction func sendButtonPressed(sender: AnyObject) {
       
        returnToDefaultState()
        
        var query = PFQuery(className: "Session")
        query.whereKey("helpy", equalTo: PFUser.currentUser())
        query.whereKey("status", greaterThan: 0)
        
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]!, error: NSError!) -> Void in
            if !(error != nil) {
                
                if(objects.count > 0){
                    
                    var message = PFObject(className: "Message")
                    message.setObject(PFUser.currentUser(), forKey: "senderId")
                    
                    message.setObject(self.requestTextField.text, forKey: "messageContent")
                    message.setObject(objects[0], forKey: "sessionId")
                    message.saveInBackgroundWithBlock {
                        (success: Bool!, error: NSError!) -> Void in
                        if (success != nil) {
                            NSLog("Object created with id: \(message.objectId)")
                            self.populateChatView()
                            self.returnToDefaultState()
                            self.requestTextField.text = ""
                        } else {
                            NSLog("%@", error)
                        }
                    }
                }
                else{
                    var session = PFObject(className:"Session")
                    session.setObject(PFUser.currentUser(), forKey: "helpy")
                    session.setObject(1, forKey: "status")
                    
                    session.saveInBackgroundWithBlock {
                        (success: Bool!, error: NSError!) -> Void in
                        if (success != nil) {
                            
                            var message = PFObject(className: "Message")
                            message.setObject(PFUser.currentUser(), forKey: "senderId")
                            message.setObject(self.requestTextField.text, forKey: "messageContent")
                            message.setObject(session, forKey: "sessionId")
                            message.saveInBackgroundWithBlock {
                                (success: Bool!, error: NSError!) -> Void in
                                if (success != nil) {
                                    NSLog("Object created with id: \(message.objectId)")
                                    self.populateChatView()
                                    self.returnToDefaultState()
                                    self.requestTextField.text = ""
                                } else {
                                    NSLog("%@", error)
                                }
                            }
                            
                            NSLog("Object created with id: \(session.objectId)")
                            self.populateChatView()
                            self.returnToDefaultState()
                            self.requestTextField.text = ""
                        } else {
                            NSLog("%@", error)
                        }
                    }

                  
                        
                    
    
                    
                }
                
            }
            else {
                self.loader.stopAnimating()
                self.loader.hidden = true
                println("%@", error)
            }
        }

        
    }
    /*func GetColoredImage(imageName: String) -> UIImage
    {
        var image = UIImage(named:imageName)
        var imageColor = UIImage()
    
        UIGraphics.BeginImageContext(image.Size)
        
        let context = UIGraphicsGetCurrentContext()
        CGContextSaveGState(context)
        
        
    CGContextTranslateCTM(context, 0, 100)
    CGContextTranslateCTM(context, 1.0, -1.0);
    
    var rect = CGRect(x: 0, y: 0, width: 100, height: 100);
    
    
    CGContextClipToMask(context, rect, image?.CGImage)
     CGContextSetFillColor(context, CGColorGetComponents(UIColor.redColor));
    context.FillRect(rect);
    
    coloredImage = UIGraphics.GetImageFromCurrentImageContext();
    UIGraphics.EndImageContext();
    
    return coloredImage;
    }*/
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.chatListView.estimatedRowHeight = 68.0
        self.chatListView.rowHeight = UITableViewAutomaticDimension

        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWasShown:", name: UIKeyboardDidShowNotification, object: nil)
        populateChatView()
        
        self.calButton.tintColor = UIColor.orangeColor()
        self.calButton.imageView?.tintColor = UIColor.orangeColor()
        self.calButton.imageView?.tintColorDidChange()
        
       
        
    }
    func update() {
        // Something cool
        self.populateChatView()
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(Bool())
        returnToDefaultState()
         var timer = NSTimer.scheduledTimerWithTimeInterval(15, target: self, selector: Selector("update"), userInfo: nil, repeats: true)
    }
    func returnToDefaultState(){
        
        self.requestTextField.resignFirstResponder()
        
        self.bottomConstraint.constant = 0
        self.inView.setNeedsUpdateConstraints()
        self.leftConstraint.constant = -400
        self.menuView.setNeedsUpdateConstraints()
        
        UIView.animateWithDuration(0.2, animations: { () -> Void in
            self.view.layoutIfNeeded()
        })
        
        
        
    }
    func populateChatView(){
        
        self.loader.startAnimating()
        self.loader.hidden = false
        var query = PFQuery(className: "Session")
        print(PFUser.currentUser())
        query.whereKey("helpy", equalTo: PFUser.currentUser())
        query.orderByDescending("createdAt")
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]!, error: NSError!) -> Void in
            if !(error != nil) {
                var i = 0
                for object in objects {
                    
                    println(object.createdAt)
                }
                
                var query2 = PFQuery(className: "Message")
                query2.whereKey("sessionId", containedIn: objects)
                query2.orderByAscending("createdAt")
                
                query2.findObjectsInBackgroundWithBlock {
                    (messages: [AnyObject]!, error: NSError!) -> Void in
                    if !(error != nil) {
                        var i = 0
                        print(messages.count)
                        self.chatItemsArray = messages
                        
                        self.chatListView!.reloadData()
                        
                        //self.chatListView.setContentOffset(CGPoint(x:0, y:  self.chatListView.contentSize.height - (self.chatListView.frame.size.height)), animated:false)
                        
                        self.loader.stopAnimating()
                        self.loader.hidden = true
                        
                        //self.chatListView.scrollToRowAtIndexPath(NSIndexPath(forRow:self.chatItemsArray.count, inSection:0), atScrollPosition: UITableViewScrollPosition.Bottom, animated: false)
                        
                        
                        
                        let delay = 0.1  * Double(NSEC_PER_SEC)
                        let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delay))
                        
                        dispatch_after(time, dispatch_get_main_queue(), {
                            let indexPath = NSIndexPath(forRow: self.chatItemsArray.count-1, inSection: 0)
                            self.chatListView.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Bottom, animated: false)
                        })
                    }
                    else {
                        self.loader.stopAnimating()
                        self.loader.hidden = true
                        println("%@", error)
                    }
                    
                }
            }
            else {
                self.loader.stopAnimating()
                self.loader.hidden = true
                println("%@", error)
            }
            
        }
        
        
        
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section:    Int) -> Int {
        println(self.chatItemsArray.count)
        return self.chatItemsArray.count
    }
       
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell: chatTableViewCell!
        
        //declined cell
        if(self.chatItemsArray[indexPath.row]["confirmed"] !== nil && (self.chatItemsArray[indexPath.row]["confirmed"] as Bool) == false){
            let cellIdentifier = "chatConfirmedCell"
            cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? chatTableViewCell
            
            
            cell.contentLabel.text = self.chatItemsArray[indexPath.row]["messageContent"] as? String
            cell.contentLabel.sizeToFit()
            
            // print(self.chatItemsArray[indexPath.row]["acceptFlag"])
            
            
            //button.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
            
            cell.nameLabel.text = "APAP - Declined Appointment";
            cell.nameLabel.textColor  = UIColor(red:1, green:1,blue:1,alpha:1.0)
            cell.contentLabel.textColor  = UIColor(red:1, green:1,blue:1,alpha:1.0)
            cell.dateLabel.textColor  = UIColor(red:1, green:1,blue:1,alpha:1.0)
            
            (cell.viewWithTag(5) as UILabel).text = "Declined"

        }//confirmed cell
        else if((self.chatItemsArray[indexPath.row]["acceptFlag"] !== nil) && ((self.chatItemsArray[indexPath.row]["acceptFlag"] as Bool) == true) && (self.chatItemsArray[indexPath.row]["senderId"] as PFUser).objectId != PFUser.currentUser().objectId && self.chatItemsArray[indexPath.row]["confirmed"] !== nil && (self.chatItemsArray[indexPath.row]["confirmed"] as Bool) == true){
            
            let cellIdentifier = "chatConfirmedCell"
            cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? chatTableViewCell
            
            
            cell.contentLabel.text = self.chatItemsArray[indexPath.row]["messageContent"] as? String
            cell.contentLabel.sizeToFit()
            
            // print(self.chatItemsArray[indexPath.row]["acceptFlag"])
            
            
            //button.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
            
            cell.nameLabel.text = "APAP - Completed";
            cell.nameLabel.textColor  = UIColor(red:1, green:1,blue:1,alpha:1.0)
            cell.contentLabel.textColor  = UIColor(red:1, green:1,blue:1,alpha:1.0)
            cell.dateLabel.textColor  = UIColor(red:1, green:1,blue:1,alpha:1.0)
            
            (cell.viewWithTag(5) as UILabel).text = "Confirmed"
            
        }//accept decline appoint cell for ending session
        else if(self.chatItemsArray[indexPath.row]["acceptFlag"] !== nil && (self.chatItemsArray[indexPath.row]["senderId"] as PFUser).objectId != PFUser.currentUser().objectId && ((self.chatItemsArray[indexPath.row]["acceptFlag"] as Bool) == true)){
            
            let cellIdentifier = "chatAcceptCell"
            cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? chatTableViewCell
            
            
            cell.contentLabel.text = self.chatItemsArray[indexPath.row]["messageContent"] as? String
            cell.contentLabel.sizeToFit()
            
           // print(self.chatItemsArray[indexPath.row]["acceptFlag"])
            
            
            //button.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
            
            cell.nameLabel.text = "APAP - Completion?";
            cell.nameLabel.textColor  = UIColor(red:1, green:1,blue:1,alpha:1.0)
            cell.contentLabel.textColor  = UIColor(red:1, green:1,blue:1,alpha:1.0)
            cell.dateLabel.textColor  = UIColor(red:1, green:1,blue:1,alpha:1.0)
            
            if(self.chatItemsArray[indexPath.row]["confirmed"] === nil){
                currentSession = (self.chatItemsArray[indexPath.row]["sessionId"] as AnyObject!)
            }
            
            (cell.viewWithTag(2) as UIButton).addTarget(self, action:"confirmPress", forControlEvents:UIControlEvents.TouchUpInside)
            (cell.viewWithTag(3) as UIButton).addTarget(self, action:"declinePress", forControlEvents:UIControlEvents.TouchUpInside)
            
        }//Thank you cell
        else if(self.chatItemsArray[indexPath.row]["acceptFlag"] !== nil && (self.chatItemsArray[indexPath.row]["senderId"] as PFUser).objectId == PFUser.currentUser().objectId){
            
            let cellIdentifier = "chatThankYouCell"
            cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? chatTableViewCell
            
            
            cell.contentLabel.text = self.chatItemsArray[indexPath.row]["messageContent"] as? String
            cell.contentLabel.sizeToFit()
            
            // print(self.chatItemsArray[indexPath.row]["acceptFlag"])
            
            
            //button.addTarget(self, action: "buttonAction:", forControlEvents: UIControlEvents.TouchUpInside)
            
            cell.nameLabel.text = "YOU - Thank You";
            
            
            
            
            
        }//normal messages from user
        else if((self.chatItemsArray[indexPath.row]["senderId"] as PFUser).objectId == PFUser.currentUser().objectId){
            
            let cellIdentifier = "chatCell"
            cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? chatTableViewCell
            
            
            cell.contentLabel.text = self.chatItemsArray[indexPath.row]["messageContent"] as? String
            cell.contentLabel.sizeToFit()
            
            cell.nameLabel.text = "YOU";
            cell.backgroundColor = UIColor(red:255/255, green:255/255,blue:255/255,alpha:1.0)
            cell.nameLabel.textColor  = UIColor(red:0, green:0,blue:0,alpha:1.0)
            cell.contentLabel.textColor  = UIColor(red:0, green:0,blue:0,alpha:1.0)
            cell.dateLabel.textColor  = UIColor(red:0, green:0,blue:0,alpha:1.0)
            
        }//normal message from helper
        else{
            
            let cellIdentifier = "chatCell"
            cell = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? chatTableViewCell
            
            
            cell.contentLabel.text = self.chatItemsArray[indexPath.row]["messageContent"] as? String
            cell.contentLabel.sizeToFit()
            
            cell.nameLabel.text = "APAP";
            cell.backgroundColor = UIColor(red:44/255, green:84/255,blue:201/255,alpha:1.0)
            cell.nameLabel.textColor  = UIColor(red:1, green:1,blue:1,alpha:1.0)
            cell.contentLabel.textColor  = UIColor(red:1, green:1,blue:1,alpha:1.0)
            cell.dateLabel.textColor  = UIColor(red:1, green:1,blue:1,alpha:1.0)
            
          

        }
        
        //format date to string
        let dateFormatter = NSDateFormatter()//3
        
        var theDateFormat = NSDateFormatterStyle.ShortStyle //5
        let theTimeFormat = NSDateFormatterStyle.ShortStyle//6
        
        dateFormatter.dateStyle = theDateFormat//8
        dateFormatter.timeStyle = theTimeFormat//9
        
        cell.dateLabel.text = dateFormatter.stringFromDate(self.chatItemsArray[indexPath.row].createdAt)
        
        return cell
        
    }
    func declinePress(){
        
        var query = PFQuery(className: "Appointment")
        
        print(PFUser.currentUser())
        
        query.whereKey("dead", equalTo: false)
        query.whereKey("sessionId", equalTo: self.currentSession)
        query.orderByDescending("createdAt")
        
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]!, error: NSError!) -> Void in
            if !(error != nil) {
                if(objects.count > 0){
                    println(objects[0])
                    objects[0].setObject(false, forKey: "confirmed")
                    objects[0].setObject(true, forKey: "dead")
                    objects[0].saveInBackgroundWithBlock {
                        (success: Bool!, error: NSError!) -> Void in
                        if (success != nil) {
                            NSLog("Object updated with id: \(objects[0].objectId)")
                            
                        } else {
                            NSLog("%@", error)
                        }
                    }
                }
                
            }
        }
        
        var query2 = PFQuery(className: "Message")
        
        query2.whereKey("acceptFlag", equalTo: true)
        query2.whereKey("sessionId", equalTo: self.currentSession)
        query2.whereKey("senderId", notEqualTo: PFUser.currentUser())
        query2.orderByDescending("createdAt")
        
        query2.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]!, error: NSError!) -> Void in
            if !(error != nil) {
                if(objects.count > 0){
                    println(objects[0])
                    print(objects[0])
                    objects[0].setObject(false, forKey: "confirmed")
                    objects[0].saveInBackgroundWithBlock {
                        (success: Bool!, error: NSError!) -> Void in
                        if (success != nil) {
                            NSLog("Object updated with id: \(objects[0].objectId)")
                            
                        } else {
                            NSLog("%@", error)
                        }
                    }
                }
                
            }
        }
        
    }
    func confirmPress(){
        
        //confirm appointment with sessionId = current session
        
        var query = PFQuery(className: "Appointment")
        
        print(PFUser.currentUser())
        
        query.whereKey("dead", equalTo: false)
        query.whereKey("sessionId", equalTo: self.currentSession)
        query.orderByDescending("createdAt")
        
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]!, error: NSError!) -> Void in
            if !(error != nil) {
                if(objects.count > 0){
                    println(objects[0])
                    objects[0].setObject(true, forKey: "confirmed")
                    objects[0].saveInBackgroundWithBlock {
                        (success: Bool!, error: NSError!) -> Void in
                        if (success != nil) {
                            NSLog("Object updated with id: \(objects[0].objectId)")
                            
                        } else {
                            NSLog("%@", error)
                        }
                    }
                }
                
            }
        }
        
        
        //make session status = 0 "done"
        var ap = PFObject(className: "Session")
        
        ap.objectId = self.currentSession.objectId
        
        ap.setObject(0, forKey: "status")
        
        ap.saveInBackgroundWithBlock {
            (success: Bool!, error: NSError!) -> Void in
            if (success != nil) {
                NSLog("Object updated with id: \(ap.objectId)")
                
            } else {
                NSLog("%@", error)
            }
        }
        
        //send confirmation message
        var message = PFObject(className: "Message")
        message.setObject(PFUser.currentUser(), forKey: "senderId")
        
        message.setObject("Confirmed. Thank you!", forKey: "messageContent")
        message.setObject(self.currentSession, forKey: "sessionId")
        message.setObject(true, forKey: "acceptFlag")
        
        message.saveInBackgroundWithBlock {
            (success: Bool!, error: NSError!) -> Void in
            if (success != nil) {
                NSLog("Object created with id: \(message.objectId)")
                self.populateChatView()
                self.returnToDefaultState()
                self.requestTextField.text = ""
            } else {
                NSLog("%@", error)
            }
        }

        //make messages confirmed
        var query2 = PFQuery(className: "Message")
        
        query2.whereKey("acceptFlag", equalTo: true)
        query2.whereKey("sessionId", equalTo: self.currentSession)
        query2.whereKey("senderId", notEqualTo: PFUser.currentUser())
        query2.orderByDescending("createdAt")
        
        query2.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]!, error: NSError!) -> Void in
            if !(error != nil) {
                if(objects.count > 0){
                    println(objects[0])
                    print(objects[0])
                    objects[0].setObject(true, forKey: "confirmed")
                    objects[0].saveInBackgroundWithBlock {
                        (success: Bool!, error: NSError!) -> Void in
                        if (success != nil) {
                            NSLog("Object updated with id: \(objects[0].objectId)")
                            
                        } else {
                            NSLog("%@", error)
                        }
                    }
                }
                
            }
        }

    }
    func keyboardWasShown(notification: NSNotification) {
        var info = notification.userInfo!
        var keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as NSValue).CGRectValue()
        self.bottomConstraint.constant = -keyboardFrame.size.height
        self.view.setNeedsUpdateConstraints()
    
        UIView.animateWithDuration(0.05, animations: { () -> Void in
            self.view.layoutIfNeeded()
        })
        
    }
    
    @IBAction func cancelTouched(sender: AnyObject) {
        self.returnToDefaultState()
    }
}