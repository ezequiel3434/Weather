//
//  WeeklyWeatherForecast.swift
//  Weather
//
//  Created by Ezequiel Parada Beltran on 18/10/2020.
//  Copyright © 2020 Ezequiel Parada. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class WeeklyWeatherForecast {
    //MARK: - Vars
    private var _temp: Double!
    private var _date: Date!
    private var _weatherIcon: String!
    
    //MARK: - Getters
    var temp: Double {
        if _temp == nil {
            _temp = 0.0
        }
        return _temp
    }
    
    var date: Date {
        if _date == nil {
            _date = Date()
        }
        return _date
    }
    
    var weatherIcon: String {
        if _weatherIcon == nil {
            _weatherIcon = ""
        }
        return _weatherIcon
    }
    
    init(weatherDictionary: Dictionary<String, AnyObject>) {
        let json = JSON(weatherDictionary)
        self._date = currentDateFromUnix(unixDate: json["data"]["ts"].double!)
        self._temp = json["data"]["temp"].double ?? 0.0
        self._weatherIcon = json["data"]["weather"]["icon"].stringValue
    }
    
    static func downloadWeeklyForecast(location: WeatherLocation, completion: @escaping(_ weeklyForecast: [WeeklyWeatherForecast]) -> Void ){
        
        var WEEKLYFORECAST_URL: String!
        
        if !location.isCurrentLocation {
            WEEKLYFORECAST_URL = String(format: "https://api.weatherbit.io/v2.0/forecast/daily?city=%@,%@&days=7&key=7c1909634a1c40259418c967a63191a4", location.city.replacingOccurrences(of: " ", with: "+").toNoSmartQuotes(), location.countryCode)
        } else {
            WEEKLYFORECAST_URL = CURRENTLOCATIONWEEKLYFORECAST_URL
        }
        
        AF.request(WEEKLYFORECAST_URL).responseJSON { (response) in
            let result = response.result
            var forecastArray: [WeeklyWeatherForecast] = []
            
            switch result {
                
            case .success(let value):
                if let dictionary = value as? Dictionary<String, AnyObject> {
                    if let list = dictionary["data"] as? [Dictionary<String, AnyObject>] {
                        for item in list {
                            let forecast = WeeklyWeatherForecast(weatherDictionary: item)
                            forecastArray.append(forecast)
                        }
                    }
                }
                completion(forecastArray)
                break
            case .failure(let error):
                print("No forecast data with error: \(error)")
                completion(forecastArray)
                break
            }
        }
        
    }
    
}
