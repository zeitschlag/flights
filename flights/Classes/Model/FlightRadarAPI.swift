//
//  FlightRadarAPI.swift
//  flights
//
//  Created by Nathan Mattes on 11.03.17.
//  Copyright © 2017 Nathan Mattes. All rights reserved.
//

import UIKit

class FlightRadarAPI: NSObject {
    
    static let shared = FlightRadarAPI()
    
    func getFlight(withIATACode iataCode: String, success: @escaping (Flight) -> (), failure: @escaping (Error)->()) {
        let currentUnixTimestamp = Int(Date().timeIntervalSince1970)
        if let url = URL(string: "https://api.flightradar24.com/common/v1/flight/list.json?fetchBy=flight&filterBy=historic&timestamp=\(currentUnixTimestamp)&query=\(iataCode)") {
           
            let urlRequest = URLRequest(url: url, cachePolicy: URLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 60.0)
            let dataTask = URLSession.shared.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
                if let error = error {
                    failure(error)
                }
                
                if let httpResponse = response as? HTTPURLResponse, let data = data {
                    if httpResponse.statusCode == 200 {
                        let parser = FlightParser()
                        if let flight = parser.parseFlight(jsonData: data) {
                            success(flight)
                        }
                    } else {
                        //TODO: Create an appropriate error and call failure(error)
                    }
                } else {
                    //TODO: Create an appropriate error and call failure(error)
                }
            })
            
            dataTask.resume()
        }
    }
    
    /// Asks the API for the flight position of the flight with IATA-code flightId
    func flightPositionForFlight(withId iataFlightId: String, success: @escaping ([FlightPosition]) -> (), failure: @escaping (Error)->()) {        
        if let url = URL(string: "https://data-live.flightradar24.com/zones/fcgi/feed.js?maxage=3600&flight=\(iataFlightId)") {
            let urlRequest = URLRequest(url: url, cachePolicy: URLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 60.0)
            let dataTask = URLSession.shared.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
                if let error = error {
                    failure(error)
                }
                
                if let httpResponse = response as? HTTPURLResponse, let data = data {
                    if httpResponse.statusCode == 200 {
                        let parser = FlightPositionParser()
                        if let flightPositions = parser.parseFlightPositions(jsonData: data) {
                            success(flightPositions)
                        }
                    } else {
                        //TODO: Create an appropriate error and call failure(error)
                        let error = NSError(domain: "flights", code: 100, userInfo: nil)
                        //error.description = "Response Code was \(httpResponse.statusCode)"
                        failure(error)
                    }
                } else {
                    //TODO: Create an appropriate error and call failure(error)
                    let error = NSError(domain: "flights", code: 100, userInfo: nil)
                    failure(error)
                }
            })
            
            dataTask.resume()
        }
        
        
    }
}
