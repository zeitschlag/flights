//
//  FlightPosition.swift
//  flights
//
//  Created by Nathan Mattes on 11.03.17.
//  Copyright © 2017 Nathan Mattes. All rights reserved.
//

import UIKit

class FlightPosition: NSObject {
    var longitude: Float
    var latitude: Float
    var altitude: Int
    var flightId: String

    
    init(longitude: Float, latitude: Float, altitude: Int, flightId: String) {
        self.longitude = longitude
        self.latitude = latitude
        self.altitude = altitude
        self.flightId = flightId
        
        super.init()
    }
    
    override var description: String {
        get {
            return "<FlightPosition for Flight \(self.flightId)  latitude: \(self.latitude), longitude: \(self.longitude)>"
        }
    }
}
