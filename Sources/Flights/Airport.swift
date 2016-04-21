//
//  Airport.swift
//  Flights
//
//  Created by Raul Ferreira on 4/11/16.
//  Copyright © 2016 FCUP. All rights reserved.
//

import Foundation

class Airport {
    let city: String
    var flights: [FlightInfo]

    init(city: String) {
        self.city = city
        self.flights = []
    }

}

extension Airport: CustomStringConvertible {

    var description: String {
        return "City: \(city) --- Flights: \(flights)"
    }

}

extension Airport: Hashable {

    var hashValue: Int {
        return self.city.hashValue
    }
    
}
