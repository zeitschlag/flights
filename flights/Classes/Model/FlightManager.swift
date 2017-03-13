//
//  FlightManager.swift
//  flights
//
//  Created by Nathan Mattes on 11.03.17.
//  Copyright © 2017 Nathan Mattes. All rights reserved.
//

import UIKit

class FlightManager: NSObject {
    
    static let shared = FlightManager(withAPI: FlightRadarAPI.shared)
    
    var api: FlightRadarAPI
    
    init(withAPI: FlightRadarAPI) {
        self.api = withAPI
    }
    
    func flightWith(iataCode: String, success: @escaping (Flight) -> (), failure: @escaping (Error)->()) {
        self.api.getFlight(withIATACode: iataCode, success: { [weak self] (flight) in
            self?.flightPositionForFlight(withId: iataCode, success: { (flightPositions) in
                
                guard flightPositions.count == 1 else {
                    //TODO: failure(error)
                    let error = NSError(domain: "flightpositions", code: 200, userInfo: nil)
                    failure(error)
                    return
                }
                
                flight.currentFlightPosition = flightPositions[0]
                
                success(flight)
            }, failure: { (error) in
                failure(error)
            })
        }) { (error) in
            failure(error)
        }
    }
    
    func flightPositionForFlight(withId flightId: String, success: @escaping ([FlightPosition]) -> (), failure: @escaping (Error)->()) {
        self.api.flightPositionForFlight(withId: flightId, success: success, failure: failure)
    }
    
}
