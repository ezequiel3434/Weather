//
//  CurrentWeather.swift
//  Weather
//
//  Created by Ezequiel Parada Beltran on 16/10/2020.
//  Copyright © 2020 Ezequiel Parada. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class CurrentWeather {
    
    func getCurrentWeather(location: WeatherLocation, completion: @escaping(_ success: Bool) -> Void) {
        
        var LOCATIONAPI_URL: String!
        
        if !location.isCurrentLocation {
            LOCATIONAPI_URL = String(format: "https://api.weatherbit.io/v2.0/current?city=%@,%@&key=7c1909634a1c40259418c967a63191a4", location.city.replacingOccurrences(of: " ", with: "+").toNoSmartQuotes(), location.countryCode)
        } else {
            LOCATIONAPI_URL = CURRENTLOCATION_URL
        }
        
        AF.request(LOCATIONAPI_URL).responseString { (response) in
            let result = response.result
            
            switch result {
                
            case .success(let value):
                let json = JSON(value)
                print(json)
                completion(true)
                break
            case .failure(let error):
                print("No reslust for current location with error: \(error)")
                completion(false)
                break
            }
        }
        
        
        
    }
    
}
