//
//  Flight.swift
//  flights
//
//  Created by Nathan Mattes on 12.03.17.
//  Copyright © 2017 Nathan Mattes. All rights reserved.
//

import UIKit

class Flight: NSObject {
    var identifier: String?
    var aircraft: String?
    var airline: String?
    
    var currentFlightPosition: FlightPosition?
}
