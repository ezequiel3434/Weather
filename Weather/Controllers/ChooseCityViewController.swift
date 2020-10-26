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
        tableView.tableFooterView = UIView()
        setupSearchController()
        tableView.tableHeaderView = searchController.searchBar
        setupGesture()
        
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
            <#statements#>
        }
    }
    
    private func parseCSVAt(url: URL){
        
    }

   

}

//MARK: - UISearchResultsUpdating
extension ChooseCityViewController: UISearchResultsUpdating {
    private func filterContentForSearchText(searchText: String, scope: String = "All"){
        filteredLocations = allLocations.filter({ (location) -> Bool in
            return location.city.lowercased().contains(searchText.lowercased()) ||
                location.country.lowercased().contains(searchText.lowercased())
        })
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchText: searchController.searchBar.text!)
    }
    
    
}
