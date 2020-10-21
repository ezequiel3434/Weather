//
//  ViewController.swift
//  Weather
//
//  Created by Ezequiel Parada Beltran on 16/10/2020.
//  Copyright © 2020 Ezequiel Parada. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController {
    
    //MARK: - IBOutlets
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var weatherInfoLabel: UILabel!
    
    //MARK: - Vars
    var userDefaults = UserDefaults.standard
    var allLocations: [WeatherLocation] = []
    var locationManager: CLLocationManager?
    var currentLocation: CLLocationCoordinate2D!
    
//MARK: - LifeCycle view
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let location = WeatherLocation(city: "Mendoza", country: "Argentina", countryCode: "AR", isCurrentLocation: false)
        let currentWeather = CurrentWeather()
        
        currentWeather.getCurrentWeather(location: location) { (success) in
            
        }
        
    }
    
    //MARK: - Location Manager
    private func locationManagerStart(){
        if locationManager == nil {
            locationManager = CLLocationManager()
            locationManager!.desiredAccuracy = kCLLocationAccuracyBest
            locationManager!.requestWhenInUseAuthorization()
            locationManager!.delegate = self
            
        }
        locationManager!.startMonitoringSignificantLocationChanges()
    }
    private func locationManagerStop(){
        if locationManager != nil {
            locationManager!.stopMonitoringSignificantLocationChanges()
        }
    }
    private func locationAutoCheck(){
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            currentLocation = locationManager!.location?.coordinate
            if currentLocation != nil {
                LocationService.shared.latitude = currentLocation.latitude
                LocationService.shared.longitude = currentLocation.longitude
            } else {
                locationAutoCheck()
            }
        } else {
            locationManager?.requestWhenInUseAuthorization()
            locationAutoCheck()
        }
    }
    
    //MARK: - DownloadWeather
    private func getWeather() {
        loadLocationsFromUserDefaults()
    }
    
    //MARK: - UserDefaults
    
    private func loadLocationsFromUserDefaults(){
        let currentLocation = WeatherLocation(city: "", country: "", countryCode: "", isCurrentLocation: true)
        
        if let data = userDefaults.value(forKey: "Locations") as? Data {
            allLocations = try! PropertyListDecoder().decode(Array<WeatherLocation>.self, from: data)
        } else {
            print("No data in userDefaults")
            allLocations.append(currentLocation)
        }
        
    }
    

    //MARK: - Download Data
    
    private func getCurrentWeather(location: WeatherLocation) {
        for i in 0..<allLocations.count {
            
            if i == 0 {
                
            }
        }
    }


}

//MARK: - CLLocationManagerDelegate
extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get location, \(error.localizedDescription)")
    }
}
