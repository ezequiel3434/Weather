//
//  GlobaleHelpers.swift
//  Weather
//
//  Created by Ezequiel Parada Beltran on 17/10/2020.
//  Copyright © 2020 Ezequiel Parada. All rights reserved.
//

import Foundation
import UIKit

func currentDateFromUnix(unixDate: Double?) -> Date? {
    if unixDate != nil {
        return Date(timeIntervalSince1970: unixDate!)
    } else {
        return Date()
    }
}


func getWeatherIconFor(_ type: String) -> UIImage? {
    return UIImage(named: type)
}

func rightTransition() -> CATransition {
    let transition = CATransition()
    transition.duration = 0.3
    transition.type = CATransitionType.push
    transition.subtype = CATransitionSubtype.fromRight
    return transition
}


func leftTransition() -> CATransition {
    let transition = CATransition()
    transition.duration = 0.3
    transition.type = CATransitionType.push
    transition.subtype = CATransitionSubtype.fromLeft
    return transition
}
