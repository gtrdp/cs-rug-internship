//
//  CommunicationDisplayViewController.swift
//  BTWF
//
//  Created by Guntur Dharma Putra on 10/05/16.
//  Copyright © 2016 Guntur Dharma Putra. All rights reserved.
//

import UIKit
import Alamofire

class CommunicationDisplayViewController: UIViewController {
    
    var communicationMethod:String = ""
    var timeInterval:Int = 0
    var serverAddress:String = ""
    
    @IBOutlet weak var sentPacketsLabel: UILabel!
    @IBOutlet weak var communicationMethodLabel: UILabel!
    @IBOutlet weak var timeIntervalLabel: UILabel!
    @IBOutlet weak var serverAddressLabel: UILabel!
    @IBOutlet weak var counterLabel: UILabel!
    
    var timer = NSTimer()
    var clockTimer = NSTimer()
    
    var packetsCounter:Int = 0
    var secondsCounter:Int = 0
    var minutesCounter:Int = 0
    var hoursCounter:Int = 0
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()

        // Do any additional setup after loading the view.
        sentPacketsLabel.text = String(packetsCounter)
        communicationMethodLabel.text = communicationMethod
        timeIntervalLabel.text = String(timeInterval) + " ms"
        serverAddressLabel.text = serverAddress
        
        // start the timer
        timer = NSTimer.scheduledTimerWithTimeInterval(Double(timeInterval)/1000, target: self, selector: #selector(timerFunction), userInfo: nil, repeats: true)
        clockTimer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(updateClock), userInfo: nil, repeats: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(animated : Bool) {
        super.viewWillDisappear(animated)
        
        if (self.isMovingFromParentViewController()){
            timer.invalidate()
            clockTimer.invalidate()
        }
    }
    
    func updateClock() {
        secondsCounter += 1
        
        if secondsCounter == 60 {
            secondsCounter = 0
            minutesCounter += 1
        }
        if minutesCounter == 60 {
            minutesCounter = 0
            hoursCounter += 1
        }
        
        // set the counter label
        counterLabel.text = String(format: "%02d", hoursCounter) + ":" + String(format: "%02d", minutesCounter) + ":" + String(format: "%02d", secondsCounter)
    }
    
    func timerFunction() {
        sendData()
        packetsCounter += 1
        sentPacketsLabel.text = String(packetsCounter)
    }
    
    func sendData() {
        let occupancyData = ["nearby_data": ["proximity_zone": "NEAR","proximity_distance": 1.8456140098254021,"rssi":-81], "userId": "pratama"]
        let url: NSURL = NSURL(string: serverAddress)!
        
        let request = NSMutableURLRequest(URL: url)
        
        request.HTTPMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.HTTPBody = try! NSJSONSerialization.dataWithJSONObject(occupancyData, options: [])
        
        Alamofire.request(request)
            .validate()
            .responseString {response in
                print(response.request)
                print(response.response)
                print(response.result.value)
                print(response.result)
        }
    }

}