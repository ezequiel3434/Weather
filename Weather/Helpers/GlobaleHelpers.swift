//
//  GlobaleHelpers.swift
//  Weather
//
//  Created by Ezequiel Parada Beltran on 17/10/2020.
//  Copyright © 2020 Ezequiel Parada. All rights reserved.
//

import Foundation

func currentDateFromUnix(unixDate: Double?) -> Date? {
    if unixDate != nil {
        return Date(timeIntervalSince1970: unixDate!)
    } else {
        return Date()
    }
}
