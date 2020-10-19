//
//  ViewController.swift
//  Weather
//
//  Created by Ezequiel Parada Beltran on 16/10/2020.
//  Copyright © 2020 Ezequiel Parada. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var weatherInfoLabel: UILabel!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let location = WeatherLocation(city: "Mendoza", country: "Argentina", countryCode: "AR", isCurrentLocation: false)
        let currentWeather = CurrentWeather()
        
        currentWeather.getCurrentWeather(location: location) { (success) in
            
        }
        
    }


}

