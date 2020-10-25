//
//  WeatherView.swift
//  Weather
//
//  Created by Ezequiel Parada Beltran on 21/10/2020.
//  Copyright © 2020 Ezequiel Parada. All rights reserved.
//

import UIKit

class WeatherView: UIView{

    //MARK: - IBOutlets
    @IBOutlet var mainView: UIView!
    @IBOutlet weak var cityNameLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var weatherInfoLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var bottomContainer: UIView!
    @IBOutlet weak var hourlyCollectionView: UICollectionView!
    @IBOutlet weak var infoCollectionView: UICollectionView!
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Vars
    var currentWeather: CurrentWeather!
    var weeklyForecastData: [WeeklyWeatherForecast] = []
    var dailyWeatherForecastData: [HourlyForecast] = []
    var weatherInfoData: [WeatherInfo] = []
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        mainInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        mainInit()
    }
    
    private func mainInit(){
        Bundle.main.loadNibNamed("WeatherView", owner: self, options: nil)
        addSubview(mainView)
        mainView.frame = self.bounds
        mainView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        
        setupTableView()
        setupHourlyCollectionView()
        setupInfoCollectionView()
        
    }
    
    private func setupTableView(){
        tableView.register(UINib(nibName: "WeatherTableViewCell", bundle: Bundle.main), forCellReuseIdentifier: "Cell")
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.tableFooterView = UIView()
        
    }
    
    private func setupHourlyCollectionView(){
        hourlyCollectionView.register(UINib(nibName: "ForecastCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "Cell")
        hourlyCollectionView.dataSource = self
    }
    
    private func setupInfoCollectionView(){
        infoCollectionView.register(UINib(nibName: "InfoCollectionViewCell", bundle: Bundle.main), forCellWithReuseIdentifier: "Cell")
    }
    
    func refreshData(){
        setupCurrentWeather()
    }
    

    private func setupCurrentWeather(){
        
        cityNameLabel.text = currentWeather.city
        dateLabel.text = currentWeather.date.shortDate()
        weatherInfoLabel.text = currentWeather.weatherType
        tempLabel.text = String(format: "%0.f ºC", currentWeather.currentTemp)
    }
}


//MARK: - UITableViewDelegate, UITableViewDataSource
extension WeatherView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return weeklyForecastData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! WeatherTableViewCell
        cell.generateCell(forecast: weeklyForecastData[indexPath.row])
        return cell
    }
    
    
}


extension WeatherView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == hourlyCollectionView {
            return dailyWeatherForecastData.count
        } else {
            return weatherInfoData.count
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == hourlyCollectionView {
            let cell = hourlyCollectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ForecastCollectionViewCell
            cell.generateCell(weather: dailyWeatherForecastData[indexPath.row])
            return cell
        } else {
            let cell = infoCollectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! InfoCollectionViewCell
            cell.generateCell(weatherInfo: weatherInfoData[indexPath.row])
            return cell
        }
        
       
        
    }
    
    
}
