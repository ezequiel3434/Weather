//
//  MainWeatherTableViewCell.swift
//  Weather
//
//  Created by Ezequiel Parada Beltran on 18/10/2020.
//  Copyright © 2020 Ezequiel Parada. All rights reserved.
//

import UIKit

class MainWeatherTableViewCell: UITableViewCell {

    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var weatherIconImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func generateCell(weatherData: CityTempData) {
        cityLabel.text = weatherData.city
        cityLabel.adjustsFontSizeToFitWidth = true
        tempLabel.text = String.init(format: "%0.f ºC", weatherData.temp)
        weatherIconImage.image = getWeatherIconFor(weatherData.icon)
    }

}
