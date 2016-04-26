//
//  SettingsViewController.swift
//  BTWF
//
//  Created by Guntur Dharma Putra on 26/04/16.
//  Copyright © 2016 Guntur Dharma Putra. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {
    
    @IBOutlet weak var timeInterfalTextField: UITextField!
    @IBOutlet weak var detailLabel: UILabel!
    
    var method:String = "Wi-Fi" {
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

}
