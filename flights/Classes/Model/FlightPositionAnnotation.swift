//
//  FlightPositionAnnotation.swift
//  flights
//
//  Created by Nathan Mattes on 11.03.17.
//  Copyright © 2017 Nathan Mattes. All rights reserved.
//

import MapKit

class FlightPositionAnnotation: NSObject, MKAnnotation {
    
    var identifier: String
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    init(withIdentifier identifier: String, at coordinate: CLLocationCoordinate2D, withTitle title: String) {
        self.identifier = identifier
        self.coordinate = coordinate
        self.title = title
    }
}
