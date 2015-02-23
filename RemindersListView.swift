//
//  RemindersListView.swift
//  swiftLogin
//
//  Created by chad swenson on 1/10/15.
//  Copyright (c) 2015 iOS-Blog. All rights reserved.
//

import Foundation

class reminderListView : UIViewController {

    @IBOutlet weak var appointmentListView: UITableView!
    
    var appointmentItemsArray: [AnyObject] = []
    
    override func viewDidLoad() {
        
        self.populateListView()
        
    }
    
    @IBAction func closePressed(sender: AnyObject) {
        self.dismissViewControllerAnimated(false, completion: nil)
    }
    
    func populateListView(){
       
        var query = PFQuery(className: "Session")
        
        query.whereKey("helpy", equalTo: PFUser.currentUser())
        
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]!, error: NSError!) -> Void in
            if !(error != nil) {
                
                print("test")
                
                var query2 = PFQuery(className: "Appointment")
                query2.whereKey("sessionId", containedIn: objects)
                
                query2.findObjectsInBackgroundWithBlock {
                    (appointments: [AnyObject]!, error: NSError!) -> Void in
                    if !(error != nil) {
                        
                        print("apps:")
                        print(appointments.count)
                        self.appointmentItemsArray = appointments
                        
                        self.appointmentListView!.reloadData()
                        
                    }
                    else {
                        
                        println("%@", error)
                        
                    }
                    
                }
            }
            else {
                
                println("%@", error)
            }
            
        }

        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section:    Int) -> Int {
        println(self.appointmentItemsArray.count)
        return self.appointmentItemsArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cellIdentifier = "remCell"
        var cell: reminderCell! = tableView.dequeueReusableCellWithIdentifier(cellIdentifier) as? reminderCell
        
        cell.titleLabel?.text = self.appointmentItemsArray[indexPath.row]["title"] as? String
        
        //format date to string
        let dateFormatter = NSDateFormatter()//3
        
        var theDateFormat = NSDateFormatterStyle.ShortStyle //5
        let theTimeFormat = NSDateFormatterStyle.ShortStyle//6
        
        dateFormatter.dateStyle = theDateFormat//8
        dateFormatter.timeStyle = theTimeFormat//9
        
        cell.dateLabel?.text = "App date: " + dateFormatter.stringFromDate(self.appointmentItemsArray[indexPath.row]["date"] as NSDate)
        
        return cell
        
    }

}