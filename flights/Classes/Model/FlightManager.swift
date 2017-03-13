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
                
                guard flightPositions.count > 0 else {
                    let error = FlightsErrors.newErrorWith(message: "There is no flight in the air with IATA-code \(iataCode)", errorCode: -3000)
                    failure(error)
                    return
                }
                
                guard flightPositions.count == 1 else {
                    let error = FlightsErrors.newErrorWith(message: "There is more than one current position for flight \(iataCode)", errorCode: -3001)
                    failure(error)
                    return
                }
                
                flight.currentFlightPosition = flightPositions[0]
                
                success(flight)
                return
            }, failure: { (error) in
                failure(error)
                return
            })
        }) { (error) in
            failure(error)
            return
        }
    }
    
    func flightPositionForFlight(withId flightId: String, success: @escaping ([FlightPosition]) -> (), failure: @escaping (Error)->()) {
        self.api.flightPositionForFlight(withId: flightId, success: success, failure: failure)
    }
    
}
