//
//  BTComViewController.swift
//  BTWF
//
//  Created by Guntur Dharma Putra on 17/05/16.
//  Copyright © 2016 Guntur Dharma Putra. All rights reserved.
//

import UIKit
import CoreBluetooth

let TRANSFER_SERVICE_UUID        = "740efdc9-e0ce-4b30-8c18-577d8275c17f"
let TRANSFER_CHARACTERISTIC_UUID = "534b0ed7-47de-4e5a-9e3e-da4bd3b33d2e"
let NOTIFY_MTU = 20

let transferServiceUUID = CBUUID(string: TRANSFER_SERVICE_UUID)
let transferCharacteristicUUID = CBUUID(string: TRANSFER_CHARACTERISTIC_UUID)

// context data
var NEAR = 1
var FAR  = 0
var proximityDistance: [Double] = [1.8456140098254021, 3.171936276300526,3.171936276300526,3.7248832499617226,4.0058561246511655]
var rssi: [UInt8] = [81, 87, 87, 71, 91]
var major: [UInt16] = [1, 2, 1, 0, 1]
var minor: [UInt16] = [2222, 9999, 9999, 0, 1111]

class BTComViewController: UIViewController, CBPeripheralManagerDelegate{
    
    // To-Do:
    // Stop advertising when already connected to central
    
    var communicationMethod:String = ""
    var timeInterval:Int = 0
    var serverAddress:String = ""
    
    private var peripheralManager: CBPeripheralManager?
    private var transferCharacteristic: CBMutableCharacteristic?
    
    private var sendDataIndex: Int = 0
    
    private let proximityZoneData: [NSData] = [NSData(bytes: &NEAR, length: 1),
                                           NSData(bytes: &FAR , length: 1),
                                           NSData(bytes: &FAR , length: 1),
                                           NSData(bytes: &FAR , length: 1),
                                           NSData(bytes: &FAR , length: 1)]
    private let proximityDistanceData: [NSData] = [NSData(bytes: &proximityDistance[0], length: 8),
                                                   NSData(bytes: &proximityDistance[1], length: 8),
                                                   NSData(bytes: &proximityDistance[2], length: 8),
                                                   NSData(bytes: &proximityDistance[3], length: 8),
                                                   NSData(bytes: &proximityDistance[4], length: 8),]
    private let rssiData: [NSData] = [NSData(bytes: &rssi[0], length: 1),
                                      NSData(bytes: &rssi[1], length: 1),
                                      NSData(bytes: &rssi[2], length: 1),
                                      NSData(bytes: &rssi[3], length: 1),
                                      NSData(bytes: &rssi[4], length: 1),]
    private let majorData: [NSData] = [NSData(bytes: &major[0], length: 2),
                                   NSData(bytes: &major[1], length: 2),
                                   NSData(bytes: &major[2], length: 2),
                                   NSData(bytes: &major[3], length: 2),
                                   NSData(bytes: &major[4], length: 2),]
    private let minorData: [NSData] = [NSData(bytes: &minor[0], length: 2),
                                       NSData(bytes: &minor[1], length: 2),
                                       NSData(bytes: &minor[2], length: 2),
                                       NSData(bytes: &minor[3], length: 2),
                                       NSData(bytes: &minor[4], length: 2),]
    private var finalData: [NSData] = []
    
    // outlets from the storyboard
    @IBOutlet weak var stopwatchLabel: UILabel!
    @IBOutlet weak var sentPacketsLabel: UILabel!
    @IBOutlet weak var methodLabel: UILabel!
    @IBOutlet weak var timeIntervalLabel: UILabel!
    @IBOutlet weak var statusLabel: UILabel!
    
    // variables for timer
    var timer = NSTimer()
    var clockTimer = NSTimer()
    
    var packetsCounter:Int = 0
    var secondsCounter:Int = 0
    var minutesCounter:Int = 0
    var hoursCounter:Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // prepare the view
        sentPacketsLabel.text = "0"
        methodLabel.text = communicationMethod
        timeIntervalLabel.text = String(timeInterval) + " ms"

        // Do any additional setup after loading the view.
        // Start up the CBPeripheralManager
        peripheralManager = CBPeripheralManager(delegate: self, queue: nil)
        
        // start the timer
        clockTimer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: #selector(updateClock), userInfo: nil, repeats: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        // Don't keep it going while we're not showing.
        peripheralManager?.stopAdvertising()
        
        // stop the timer
        timer.invalidate()
        clockTimer.invalidate()
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
        stopwatchLabel.text = String(format: "%02d", hoursCounter) + ":" + String(format: "%02d", minutesCounter) + ":" + String(format: "%02d", secondsCounter)
    }
    
    func timerFunction() {
        sendData()
        packetsCounter += 1
        sentPacketsLabel.text = String(packetsCounter)
    }
    
    /** Required protocol method.  A full app should take care of all the possible states,
     *  but we're just waiting for  to know when the CBPeripheralManager is ready
     */
    func peripheralManagerDidUpdateState(peripheral: CBPeripheralManager) {
        // Opt out from any other state
        if (peripheral.state != CBPeripheralManagerState.PoweredOn) {
            return
        }
        
        // We're in CBPeripheralManagerStatePoweredOn state...
        print("self.peripheralManager powered on.")
        statusLabel.text = "self.peripheralManager powered on."
        
        // ... so build our service.
        
        // Start with the CBMutableCharacteristic
        transferCharacteristic = CBMutableCharacteristic(
            type: transferCharacteristicUUID,
            properties: CBCharacteristicProperties.Notify,
            value: nil,
            permissions: CBAttributePermissions.Readable
        )
        
        // Then the service
        let transferService = CBMutableService(
            type: transferServiceUUID,
            primary: true
        )
        
        // Add the characteristic to the service
        transferService.characteristics = [transferCharacteristic!]
        
        // And add it to the peripheral manager
        peripheralManager!.addService(transferService)
        
        // start advertising right away
        // All we advertise is our service's UUID
        peripheralManager!.startAdvertising([
            CBAdvertisementDataServiceUUIDsKey : [transferServiceUUID]
            ])
    }
    
    /** Catch when someone subscribes to our characteristic, then start sending them data
     */
    func peripheralManager(peripheral: CBPeripheralManager, central: CBCentral, didSubscribeToCharacteristic characteristic: CBCharacteristic) {
        // notify the user through a label
        print(central.identifier.UUIDString)
        statusLabel.text = "Central subscribed to characteristic."
        
        // prepare the chunks
        // the format is (20 bytes):
        // 01 02 03 04 05 06 07 08 09 10 11 12 13 14 15 16 17 18 19 20
        // pz|     user name   |  proximity distance   |rs|major|minor
        //
        // pz: Proximity Zone
        // rs: RSSI
        //
        // the dummy data is available online: https://gist.github.com/azkario/636ddca0ff1d229df3d9667f9d905782
        
        // we're going to send 4 bursts of data
        var foo = NSMutableData()
        
        for i in 0...4 {
            foo.appendData(proximityZoneData[i])
            foo.appendData("pratam".dataUsingEncoding(NSUTF8StringEncoding)!)
            foo.appendData(proximityDistanceData[i])
            foo.appendData(rssiData[i])
            foo.appendData(majorData[i])
            foo.appendData(minorData[i])
            
            finalData.append(foo)
            foo = NSMutableData()
        }
        
        // Reset the index
        sendDataIndex = 0;
        
        // Start sending
        timer = NSTimer.scheduledTimerWithTimeInterval(Double(timeInterval)/1000, target: self, selector: #selector(timerFunction), userInfo: nil, repeats: true)
    }
    
    /** Recognise when the central unsubscribes
     */
    func peripheralManager(peripheral: CBPeripheralManager, central: CBCentral, didUnsubscribeFromCharacteristic characteristic: CBCharacteristic) {
        print("Central unsubscribed from characteristic")
        statusLabel.text = "Central unsubscribed from characteristic."
        
        // stop the timer
        timer.invalidate()
    }
    
    // First up, check if we're meant to be sending an EOM
    private var sendingEOM = false;
    
    /** Sends the next amount of data to the connected central
     */
    private func sendData() {
        var didSend = true
        
        if sendDataIndex < 5 {
            // Send it
            didSend = peripheralManager!.updateValue(
                finalData[sendDataIndex],
                forCharacteristic: transferCharacteristic!,
                onSubscribedCentrals: nil
            )
            
            // If it didn't work, drop out and wait for the callback
            if (!didSend) {
                return
            }
            
            sendDataIndex += 1
            sendData()
        } else {
            didSend = peripheralManager!.updateValue(
                "EOM".dataUsingEncoding(NSUTF8StringEncoding)!,
                forCharacteristic: transferCharacteristic!,
                onSubscribedCentrals: nil
            )
            
            // If it didn't work, drop out and wait for the callback
            if (!didSend) {
                return
            }
    
            sendDataIndex = 0
        }
    }
    
    /** This callback comes in when the PeripheralManager is ready to send the next chunk of data.
     *  This is to ensure that packets will arrive in the order they are sent
     */
    func peripheralManagerIsReadyToUpdateSubscribers(peripheral: CBPeripheralManager) {
        // Start sending again
        sendData()
    }
    
    func peripheralManagerDidStartAdvertising(peripheral: CBPeripheralManager, error: NSError?) {
        print(error)
    }

}
