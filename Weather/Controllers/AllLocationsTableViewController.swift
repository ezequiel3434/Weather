//
//  AllLocationsTableViewController.swift
//  Weather
//
//  Created by Ezequiel Parada Beltran on 26/10/2020.
//  Copyright © 2020 Ezequiel Parada. All rights reserved.
//

import UIKit

protocol AllLocationsTableViewControllerDelegate {
    func didDeleteLocation(locationsLenght: Int)
    func didChoseLocation(index: Int)
}

class AllLocationsTableViewController: UITableViewController {
    
    //MARK: - Vars
    var savedLocations: [WeatherLocation]?
    let userDefaults = UserDefaults.standard
    var weatherData: [WeatherView]?
    
    
    var delegate: AllLocationsTableViewControllerDelegate?
    
    var shouldRefresh = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
    }
    
    init() {
        super.init(style: .plain)
        
        self.loadLocationsFromUserDefaults()
        
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        self.loadLocationsFromUserDefaults()
    }
    
    
    
   
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadLocationsFromUserDefaults()
    }
    
    //MARK: - UserDefaults
    func loadLocationsFromUserDefaults(){
        if let data = try? userDefaults.value(forKey: "Locations") as? Data {
            savedLocations = try? PropertyListDecoder().decode(Array<WeatherLocation>.self, from: data)
        }
    }
    private func saveNewLocationsToUserDefaults(){
        shouldRefresh = true
        userDefaults.set(try? PropertyListEncoder().encode(savedLocations!), forKey: "Locations")
        userDefaults.synchronize()
    }
    

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return weatherData?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! MainWeatherTableViewCell
        if weatherData != nil {
            cell.generateCell(weatherData: weatherData![indexPath.row])
        }
        return cell
    }
    
    //MARK: - TableViewDelegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        
        
        delegate?.didChoseLocation(index: indexPath.row)
        
        self.dismiss(animated: false, completion: nil)

        
        
        
        

    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let locationToDelete = weatherData?[indexPath.row]
            weatherData?.remove(at: indexPath.row)
            removeLocationFromSavedLocation(location: (locationToDelete?.currentWeather.city)!)
            tableView.reloadData()
        }
    }
    
    private func removeLocationFromSavedLocation(location: String){
        
        if savedLocations != nil {
            
            for i in 0..<savedLocations!.count {
                let tempLocation = savedLocations![i]
                if tempLocation.city == location {
                    savedLocations?.remove(at: i)
                    
                    
                    saveNewLocationsToUserDefaults()
                    delegate?.didDeleteLocation(locationsLenght: savedLocations!.count)
                    return
                }
            }
        }
    }

   }


