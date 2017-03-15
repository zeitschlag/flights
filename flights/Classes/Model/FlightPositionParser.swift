//
//  FlightPositionParser.swift
//  flights
//
//  Created by Nathan Mattes on 11.03.17.
//  Copyright © 2017 Nathan Mattes. All rights reserved.
//

import UIKit

///Gets a JSON-Representation of FlightPosition and parses them into FlightPositions

enum FlightPositionJSONKeys {
    static let FullCount = "full_count"
    static let Version = "version"
}

class FlightPositionParser: NSObject {

    func parseFlightPositions(jsonData: Data) -> [FlightPosition]? {
        do {
            if let flightPositionDict = try JSONSerialization.jsonObject(with: jsonData, options: []) as? Dictionary<String, Any> {
                
                var flightPositions = [FlightPosition]()
                
                for (key, value) in flightPositionDict {
                    if key == FlightPositionJSONKeys.FullCount ||
                        key == FlightPositionJSONKeys.Version {
                        continue
                    }
                    
                    if let flightPositionData = value as? [Any],
                        let latitude = flightPositionData[1] as? Float,
                        let longitude = flightPositionData[2] as? Float,
                        // let track = flightPositionData[3] as? Int,
                        let altitude = flightPositionData[4] as? Int {
                        
                        let flightId = key
                        
                        let flightPosition = FlightPosition(longitude: longitude, latitude: latitude, altitude: altitude, flightId: flightId)
                        flightPositions.append(flightPosition)
                    }
                }
                
                return flightPositions
            }
            
        } catch {
            return nil
        }
        
        return nil
    }
    
}
