//
//  FlightPositionAnnotation.swift
//  flights
//
//  Created by Nathan Mattes on 11.03.17.
//  Copyright © 2017 Nathan Mattes. All rights reserved.
//

import MapKit

class FlightPositionAnnotation: NSObject, MKAnnotation {
    
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    
    init(at coordinate: CLLocationCoordinate2D, withTitle title: String) {
        self.coordinate = coordinate
        self.title = title
    }
}
