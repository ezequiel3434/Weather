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
    @IBOutlet weak var tableView: UITableView!
    
    let allLocationsTableViewController = AllLocationsTableViewController()
    
    
    //MARK: - Vars
    var userDefaults = UserDefaults.standard
   
    var locationManager: CLLocationManager?
    var currentLocation: CLLocationCoordinate2D!
     var allLocations: [WeatherLocation] = []
    var allWeatherViews: [WeatherView] = []
    var allWeatherData: [CityTempData] = []
    
    var shouldRefresh = true
    
    
//MARK: - LifeCycle view
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManagerStart()
        self.tableView.delegate = allLocationsTableViewController
        self.tableView.dataSource = allLocationsTableViewController
        
        
        
//        let location = WeatherLocation(city: "Mendoza", country: "Argentina", countryCode: "AR", isCurrentLocation: false)
//        let currentWeather = CurrentWeather()
//
//        currentWeather.getCurrentWeather(location: location) { (success) in
//
//        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if shouldRefresh {
            allLocations = []
            allWeatherViews = []
            locationAutoCheck()
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        locationManagerStop()
    }
    
    
    @IBAction func arrowButtonAction(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(identifier: "Detail") as! DetailViewController
        vc.weatherView = allWeatherViews[0]
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        self.view.window?.layer.add(transition, forKey: kCATransition)
        present(vc,animated: false )
        
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
                getWeather()
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
        createWeatherViews()
        addWeatherToList()
    }
    
    private func createWeatherViews() {
        for _ in allLocations {
            allWeatherViews.append(WeatherView())
        }
    }
    
    private func addWeatherToList() {
        
        getForecast { [weak self] (success) in
            guard let strongSelf = self else {
                return
            }
            
               
                
                    strongSelf.allLocationsTableViewController.weatherData = strongSelf.allWeatherViews
                    strongSelf.tableView.reloadData()
                
                
            
            
        }
        
    }
    
    
    private func getForecast( comp: @escaping(_ success: Bool) ->Void){
        var done1 = false
        var done2 = false
        var done3 = false
        let last = allWeatherViews.count - 1
        for i in 0..<allWeatherViews.count {
            let weatherView = allWeatherViews[i]
            let location = allLocations[i]
            
            getCurrentWeather(weatherView: weatherView, location: location) { success in
                if i == last{
                    done1 = true
                }
            }
            getWeeklyWeather(weatherView: weatherView, location: location){ success in
                if i == last{
                    done2 = true
                }
            }
            getHourlyWeather(weather: weatherView, location: location) { success in
                if i == last{
                    done3 = true
                    comp(true)
                }
            }
            
        }
        if done1 && done2 && done3  {
            comp(true)
        }
        
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
    
    private func getCurrentWeather(weatherView: WeatherView, location: WeatherLocation, completion: @escaping(_ success: Bool) ->Void) {
        
        weatherView.currentWeather = CurrentWeather()
        
        weatherView.currentWeather.getCurrentWeather(location: location) { (success) in
            print(weatherView.currentWeather.city)
            weatherView.refreshData()
            completion(true)
        }
    }
    
    private func getWeeklyWeather(weatherView: WeatherView, location: WeatherLocation, completion: @escaping(_ success: Bool) ->Void) {
        WeeklyWeatherForecast.downloadWeeklyForecast(location: location) { (weatherForecasts) in
            weatherView.weeklyForecastData = weatherForecasts
            
            weatherView.tableView.reloadData()
            completion(true)
            
        }
    }
    private func getHourlyWeather(weather: WeatherView, location: WeatherLocation, completion: @escaping(_ success: Bool) ->Void){
        HourlyForecast.downloadHourlyForecast(location: location) { (forecasts) in
            weather.dailyWeatherForecastData = forecasts
            weather.hourlyCollectionView.reloadData()
            completion(true)
        }
    }
    
    //MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "chooseLocationSeg" {
            let vc = segue.destination as! ChooseCityViewController
            vc.delegate = self
            
            
        }
    }


}

//MARK: - CLLocationManagerDelegate
extension WeatherViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to get location, \(error.localizedDescription)")
    }
}


extension WeatherViewController: ChooseCityViewControllerDelegate {
    func didAdd() {
        print("didadd")
        shouldRefresh = true
        
        
        tableView.reloadData()
    }
    
    
}
