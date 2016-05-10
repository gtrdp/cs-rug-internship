//
//  SettingsViewController.swift
//  BTWF
//
//  Created by Guntur Dharma Putra on 26/04/16.
//  Copyright © 2016 Guntur Dharma Putra. All rights reserved.
//

import UIKit
import Alamofire

class SettingsViewController: UITableViewController {
    
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var timeInterfalTextField: UITextField!
    @IBOutlet weak var serverAddressTextField: UITextField!
    
    
    
    var method:String = "Wi-Fi (HTTP)" {
        didSet {
            detailLabel.text? = method
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

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
    }
    
    @IBAction func startCommunication(sender: UIButton) {
        let timeInterfal = timeInterfalTextField.text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        let serverAddress = serverAddressTextField.text?.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
        
        if timeInterfal?.isEmpty == false && serverAddress?.isEmpty == false {
            displayAlert("BTWF", content: "Communication started.")
            
            // start the communication
            
        } else {
            displayAlert("BTWF", content: "Please fill out the form first.")
        }
    }
    
    func displayAlert(title: String, content: String) {
        let alertCon = UIAlertController(title: title, message: content, preferredStyle: UIAlertControllerStyle.Alert)
        alertCon.addAction(UIAlertAction(title: "Dismiss", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alertCon, animated: true, completion: nil)
    }

    func httpConnection() {
        // Send HTTP GET Request
        
        // Define server side script URL
        let scriptUrl = "http://swiftdeveloperblog.com/my-http-get-example-script/"
        
        // Add one parameter
        let urlWithParams = scriptUrl + "?userName="
        
        // Create NSURL Ibject
        let myUrl = NSURL(string: urlWithParams);
        
        // Creaste URL Request
        let request = NSMutableURLRequest(URL:myUrl!);
        
        // Set request HTTP method to GET. It could be POST as well
        request.HTTPMethod = "GET"
        
        // If needed you could add Authorization header value
        // Add Basic Authorization
        /*
         let username = "myUserName"
         let password = "myPassword"
         let loginString = NSString(format: "%@:%@", username, password)
         let loginData: NSData = loginString.dataUsingEncoding(NSUTF8StringEncoding)!
         let base64LoginString = loginData.base64EncodedStringWithOptions(NSDataBase64EncodingOptions())
         request.setValue(base64LoginString, forHTTPHeaderField: "Authorization")
         */
        
        // Or it could be a single Authorization Token value
        //request.addValue("Token token=884288bae150b9f2f68d8dc3a932071d", forHTTPHeaderField: "Authorization")
        
        // Excute HTTP Request
        let task = NSURLSession.sharedSession().dataTaskWithRequest(request) {
            data, response, error in
            
            // Check for error
            if error != nil
            {
                print("error=\(error)")
                return
            }
            
            // Print out response string
            let responseString = NSString(data: data!, encoding: NSUTF8StringEncoding)
            print("responseString = \(responseString)")
            
            
            // Convert server json response to NSDictionary
            do {
                if let convertedJsonIntoDict = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as? NSDictionary {
                    
                    // Print out dictionary
                    print(convertedJsonIntoDict)
                    
                    // Get value by key
                    let firstNameValue = convertedJsonIntoDict["userName"] as? String
                    print(firstNameValue!)
                    
                }
            } catch let error as NSError {
                print(error.localizedDescription)
            }
            
        }
        
        task.resume()
    }
}
