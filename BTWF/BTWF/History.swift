//
//  History.swift
//  BTWF
//
//  Created by Guntur Dharma Putra on 25/05/16.
//  Copyright © 2016 Guntur Dharma Putra. All rights reserved.
//

import UIKit

class History {
    var method: String
    var sentPackets: String
    var timestamp: String
    var duration: String
    
    init(method: String, sentPackets: String, timestamp: String, duration: String) {
        self.method = method
        self.sentPackets = sentPackets
        self.timestamp = timestamp
        self.duration = duration
    }
}
