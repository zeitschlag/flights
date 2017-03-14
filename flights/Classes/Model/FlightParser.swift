//
//  FlightParser.swift
//  flights
//
//  Created by Nathan Mattes on 12.03.17.
//  Copyright © 2017 Nathan Mattes. All rights reserved.
//

import MapKit

enum FlightJSONKeys {
    static let result = "result"
    enum Result {
        static let response = "response"
        enum Response {
            static let data = "data"
            enum Data {
                static let aircraft = "aircraft"
                enum Aircraft {
                    static let model = "model"
                    enum Model {
                        static let text = "text"
                    }
                }
                static let identification = "identification"
                static let airport = "airport"
                
                enum Airport {
                    static let destination = "destination"
                    
                    static let origin = "origin"
                    static let position = "position"
                    static let name = "name"
                    // as destionation and origin-airport share the same elements, we only need one here.
                    enum Position {
                        static let longitude = "longitude"
                        static let latitude = "latitude"
                    }
                }
                
                enum Identification {
                    static let id = "id"
                }
            }
        }
    }
}

typealias StringDictionary = Dictionary<String, Any>

class FlightParser: NSObject {
    
    func parseFlight(jsonData: Data) -> Flight? {
        do {
            if let dict = try JSONSerialization.jsonObject(with: jsonData, options: []) as? StringDictionary {
                for (key, value) in dict {
                    if key == FlightJSONKeys.result, let resultsDict = value as? StringDictionary {
                        for (resultKey, resultValue) in resultsDict {
                            if resultKey == FlightJSONKeys.Result.response, let responseDict = resultValue as? StringDictionary {
                                
                                let flight = Flight()
                                
                                for (responseKey, responseValue) in responseDict {
                                    if responseKey == FlightJSONKeys.Result.Response.data, let dataArray = responseValue as? [StringDictionary] {
                                        for dataDict in dataArray {
                                            for (dataKey, dataValue) in dataDict {
                                                
                                                if dataKey == FlightJSONKeys.Result.Response.Data.identification, let identificationDict = dataValue as? StringDictionary {
                                                    for (identificationKey, identificationValue) in identificationDict {
                                                        if identificationKey == FlightJSONKeys.Result.Response.Data.Identification.id, let identifier = identificationValue as? String {
                                                            flight.identifier = identifier
                                                        }
                                                    }
                                                }
                                                
                                                if dataKey == FlightJSONKeys.Result.Response.Data.aircraft, let aircraftDict = dataValue as? StringDictionary {
                                                    for (aircraftKey, aircraftValue) in aircraftDict {
                                                        if aircraftKey == FlightJSONKeys.Result.Response.Data.Aircraft.model, let modelDict = aircraftValue as? StringDictionary {
                                                            if let aircraft = modelDict[FlightJSONKeys.Result.Response.Data.Aircraft.Model.text] as? String {
                                                                flight.aircraft = aircraft
                                                            }
                                                            
                                                        }
                                                    }
                                                }
                                                
                                                if dataKey == FlightJSONKeys.Result.Response.Data.airport, let airportDict = dataValue as? StringDictionary {
                                                    for (airportKey, airportValue) in airportDict {
                                                        if airportKey == FlightJSONKeys.Result.Response.Data.Airport.destination,
                                                            let destinationDict = airportValue as? StringDictionary {
                                                            let airport = Airport()

                                                            for (destinationKey, destinationValue) in destinationDict {
                                                                
                                                                if destinationKey == FlightJSONKeys.Result.Response.Data.Airport.position,
                                                                    let positionDict = destinationValue as? StringDictionary,
                                                                    let longitude = positionDict[FlightJSONKeys.Result.Response.Data.Airport.Position.longitude] as? Double,
                                                                    let latitude = positionDict[FlightJSONKeys.Result.Response.Data.Airport.Position.latitude] as? Double {
                                                                    let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                                                                    airport.coordinate = coordinate
                                                                    
                                                                }
                                                                
                                                                if destinationKey == FlightJSONKeys.Result.Response.Data.Airport.name,
                                                                    let airportName = destinationValue as? String {
                                                                    airport.name = airportName
                                                                }
                                                            }
                                                            
                                                            flight.destinationAirport = airport

                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    }
                                }
                                return flight
                            }
                        }
                    }
                }
                
                return nil
            }
            
        } catch {
            return nil
        }
        
        return nil
    }
    
}
