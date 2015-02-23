//
//  PhoneNumbersViewController.swift
//  swiftLogin
//
//  Created by chad swenson on 1/11/15.
//  Copyright (c) 2015 iOS-Blog. All rights reserved.
//

import Foundation


class phoneNumbersViewController : UIViewController {
    
    var numberItemArray: [AnyObject] = []
    
    @IBOutlet weak var addButton: UIButton!
    
    @IBOutlet weak var addNumberView: UIView!
    @IBOutlet weak var addNumberConstraint: NSLayoutConstraint!
    @IBOutlet weak var numbersListView: UITableView!
    
    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var numberTextField: UITextField!
    var currentEdit = "none"
    
    @IBAction func addTouched(sender: AnyObject) {
        
        toggleForm()
     
    }
    
    
    @IBAction func cancelTouched(sender: AnyObject) {
        
        self.currentEdit = "none"
        toggleForm()
        
    }
    func toggleForm(){
        
        self.titleTextField.text = ""
        self.numberTextField.text = ""
        
        if self.addNumberConstraint.constant < 0 {
            
            self.addNumberConstraint.constant = 50
            self.addNumberView.setNeedsUpdateConstraints()
            
            UIView.animateWithDuration(0.2, animations: { () -> Void in
                self.view.layoutIfNeeded()
            })
            
        }
        else{
            self.addNumberConstraint.constant = -400
            self.addNumberView.setNeedsUpdateConstraints()
            
            UIView.animateWithDuration(0.2, animations: { () -> Void in
                self.view.layoutIfNeeded()
            })
            
            self.numberTextField.resignFirstResponder()
            self.titleTextField.resignFirstResponder()
        }

    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        populateListView()
        self.currentEdit = "none"
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(Bool())
        self.currentEdit = "none"
    }
    @IBAction func backTouched(sender: AnyObject) {
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    @IBAction func submitNumberTouched(sender: AnyObject) {
        
        if self.titleTextField.text != "" && self.numberTextField.text != ""{
            var num = PFObject(className: "Number")
            
            if(currentEdit != "none"){
                num.objectId = self.currentEdit
            }
            
            num.setObject(PFUser.currentUser(), forKey: "client")
            
            num.setObject(self.titleTextField.text, forKey: "title")
            num.setObject(self.numberTextField.text, forKey: "num")
            num.saveInBackgroundWithBlock {
                (success: Bool!, error: NSError!) -> Void in
                if (success != nil) {
                    NSLog("Object created with id: \(num.objectId)")
                    self.populateListView()
                    self.titleTextField.text = ""
                    self.numberTextField.text = ""
                    self.currentEdit = "none"
                    self.toggleForm()
                } else {
                    NSLog("%@", error)
                }
            }
           
        }
        else{
            
        }
        
    }
    func populateListView(){
        
        var query = PFQuery(className: "Number")
        query.whereKey("client", equalTo: PFUser.currentUser())
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]!, error: NSError!) -> Void in
            if !(error != nil) {
                var i = 0
                for object in objects {
                    //self.chatItemsArray[i] = object
                    //println(object["createdAt"])
                    println(object.createdAt)
                }
                self.numberItemArray = objects
                
                self.numbersListView!.reloadData()
            }
            else {
                println("%@", error)
            }
        }
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section:    Int) -> Int {
        println(self.numberItemArray.count)
        return self.numberItemArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier = "numberCell"
        var cell: numberTableViewCell! = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? numberTableViewCell
        
        cell.numberTitleTextField.text = self.numberItemArray[indexPath.row]["title"] as? String
        
        cell.numberNumTextField.text = self.numberItemArray[indexPath.row]["num"] as? String
        
        cell.editButton.addTarget(self, action: "editAction:", forControlEvents: UIControlEvents.TouchUpInside)
        
        cell.editButton.tag = indexPath.row
        
        return cell
        
    }
    func editAction(sender:UIButton!)
    {
        self.numberItemArray[sender.tag].objectId
        self.titleTextField.text = self.numberItemArray[sender.tag]["title"] as? String
        self.numberTextField.text = self.numberItemArray[sender.tag]["num"] as? String
        self.currentEdit = self.numberItemArray[sender.tag].objectId
        toggleForm()
    }
}