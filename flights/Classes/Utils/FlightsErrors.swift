//
//  FlightsErrors.swift
//  flights
//
//  Created by Nathan Mattes on 12.03.17.
//  Copyright © 2017 Nathan Mattes. All rights reserved.
//

import UIKit

class FlightsErrors: NSObject {
    
    static func newErrorWith(message: String, errorCode: Int) -> Error {
        let userInfo = [NSLocalizedDescriptionKey: message]
        let error = NSError(domain: "de.bullenscheisse.flights", code: errorCode, userInfo: userInfo)
        return error
    }

}
