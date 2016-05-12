//
//  SettingsViewController.swift
//  BTWF
//
//  Created by Guntur Dharma Putra on 26/04/16.
//  Copyright © 2016 Guntur Dharma Putra. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {
    
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var timeInterfalTextField: UITextField!
    @IBOutlet weak var serverAddressTextField: UITextField!
    
    var timeInterfal = ""
    var serverAddress = ""
    
    var method:String = "Wi-Fi (HTTP)" {
        didSet {
            detailLabel.text? = method
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func unwindWithSelectedMethod(segue:UIStoryboardSegue) {
        if let selectMethodViewController = segue.sourceViewController as? SelectMethodViewController,
            selectedMethod = selectMethodViewController.selectedMethod {
            method = selectedMethod
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "SelectMethod" {
            if let selectMethodViewController = segue.destinationViewController as? SelectMethodViewController {
                selectMethodViewController.selectedMethod = method
            }
        }
        
        if segue.identifier == "GoToStartCommunication" {
            navigationItem.title = "Stop"
            
            let svc = segue.destinationViewController as! CommunicationDisplayViewController;
            svc.communicationMethod = method
            svc.timeInterval = (timeInterfal as NSString).integerValue
            svc.serverAddress = serverAddress
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        navigationItem.title = "Settings"
    }
    
    @IBAction func startCommunication(sender: UIButton) {
        timeInterfal = (timeInterfalTextField.text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()))!
        serverAddress = (serverAddressTextField.text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet()))!
        
        if timeInterfal.isEmpty == false && serverAddress.isEmpty == false && verifyUrl(serverAddress) {
            // start the communication
            self.performSegueWithIdentifier("GoToStartCommunication", sender: nil)
            displayAlert("BTWF", content: "Communication started.")
        } else {
            displayAlert("BTWF", content: "Something goes wrong. Please fill out the form first.")
        }
    }
    
    func displayAlert(title: String, content: String) {
        let alertCon = UIAlertController(title: title, message: content, preferredStyle: UIAlertControllerStyle.Alert)
        alertCon.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alertCon, animated: true, completion: nil)
    }
    
    func verifyUrl (urlString: String?) -> Bool {
        //Check for nil
        if let urlString = urlString {
            // create NSURL instance
            if let url = NSURL(string: urlString) {
                // check if your application can open the NSURL instance
                return UIApplication.sharedApplication().canOpenURL(url)
            }
        }
        return false
    }
}