//
//  ChooseCityViewController.swift
//  Weather
//
//  Created by Ezequiel Parada Beltran on 18/10/2020.
//  Copyright © 2020 Ezequiel Parada. All rights reserved.
//

import UIKit

class ChooseCityViewController: UIViewController {

    //MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - Vars
    var allLocations: [WeatherLocation] = []
    var filteredLocations: [WeatherLocation] = []
    let searchController = UISearchController(searchResultsController: nil)
    var savedLocations: [WeatherLocation]?
    let userDefaults = UserDefaults.standard
    
    //MARK: - View Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        setupSearchController()
        tableView.tableHeaderView = searchController.searchBar
        setupGesture()
        loadLocationsFromCSV()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadFromUserDefaults()
    }
    
    
    
    private func setupSearchController(){
        searchController.searchBar.placeholder = "City or Country"
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        searchController.searchBar.searchTextField.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        searchController.searchBar.searchTextField.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        searchController.searchBar.searchBarStyle = .prominent
        searchController.searchBar.sizeToFit()
        searchController.searchBar.backgroundImage = UIImage()
    }
    
    private func setupGesture(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(tableTapped))
        self.tableView.backgroundView = UIView()
        self.tableView.backgroundView?.addGestureRecognizer(tap)
    }
    
    @objc func tableTapped(){
        dismissView()
    }
    
    private func dismissView(){
        if searchController.isActive {
            searchController.dismiss(animated: true) {
                self.dismiss(animated: true)
            }
        } else {
            self.dismiss(animated: true)
        }
    }
    
    
    //MARK: - Get Locations
    private func loadLocationsFromCSV(){
        if let path = Bundle.main.path(forResource: "location", ofType: ".csv") {
            parseCSVAt(url: URL(fileURLWithPath: path))
        }
    }
    
    private func parseCSVAt(url: URL){
        do {
            let data = try Data(contentsOf: url)
            let dataEncoded = String(data: data, encoding: .utf8)
            if let dataArr = dataEncoded?.components(separatedBy: "\n").map({$0.components(separatedBy: ",")}){
                var i = 0
                for line in dataArr {
                    if line.count > 2 && i != 0 {
                        createLocation(line: line)
                    }
                    i += 1
                }
                
            }
            
        } catch {
            print("Error reading CSV file, ", error.localizedDescription)
        }
    }
    
    private func createLocation(line: [String]){
        allLocations.append(WeatherLocation(city: line.first!, country: line.last!, countryCode: line[1], isCurrentLocation: false))
    }
    
    
    //MARK: - UserDefaults
    private func loadFromUserDefaults(){
        if let data = userDefaults.value(forKey: "Locations") as? Data {
            savedLocations = try? PropertyListDecoder().decode(Array<WeatherLocation>.self, from: data)
        }
    }
    
    private func saveLocations(location: WeatherLocation){
        
    }

   

}



//MARK: - UISearchResultsUpdating
extension ChooseCityViewController: UISearchResultsUpdating {
    private func filterContentForSearchText(searchText: String, scope: String = "All"){
        
        filteredLocations = allLocations.filter({ (location) -> Bool in
            
            return location.city.lowercased().contains(searchText.lowercased()) ||
                location.country.lowercased().contains(searchText.lowercased())
        })
        tableView.reloadData()
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }
    
    
}

//MARK: - UITableViewDelegate, UITableViewDataSource
extension ChooseCityViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredLocations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let location = filteredLocations[indexPath.row]
        cell.textLabel?.text = location.city
        cell.detailTextLabel?.text = location.country
        return cell
    }
    
    
}
