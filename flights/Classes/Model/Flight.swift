//
//  Flight.swift
//  flights
//
//  Created by Nathan Mattes on 12.03.17.
//  Copyright © 2017 Nathan Mattes. All rights reserved.
//

import UIKit

class Flight: NSObject {
    
    /// Flight-ID from FlightRadar
    var identifier: String?
    var aircraft: String?
    var airline: String?
    
    var currentFlightPosition: FlightPosition?
    
    var destinationAirport: Airport?
    var originAirport: Airport?
}
