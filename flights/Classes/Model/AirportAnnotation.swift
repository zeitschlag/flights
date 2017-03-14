//
//  AirportAnnotation.swift
//  flights
//
//  Created by Nathan Mattes on 13.03.17.
//  Copyright © 2017 Nathan Mattes. All rights reserved.
//

import MapKit

class AirportAnnotation: NSObject, MKAnnotation {
    
    enum AirportType {
        case Origin
        case Destination
    }
    
    var identifier: String
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    var type: AirportType
    
    init(withIdentifier identifier: String, at coordinate: CLLocationCoordinate2D, withTitle title: String, airportType: AirportType) {
        self.identifier = identifier
        self.coordinate = coordinate
        self.title = title
        self.type = airportType
    }
}
