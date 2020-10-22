//
//  ForecastCollectionViewCell.swift
//  Weather
//
//  Created by Ezequiel Parada Beltran on 22/10/2020.
//  Copyright © 2020 Ezequiel Parada. All rights reserved.
//

import UIKit

class ForecastCollectionViewCell: UICollectionViewCell {

    //MARK: - IBOutlets
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var tempLabel: UILabel!
    @IBOutlet weak var weatherIconImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func generateCell(weather: HourlyForecast) {
        timeLabel.text = weather.date.time()
        tempLabel.text = "\(weather.temp)"
        weatherIconImageView.image = getWeatherIconFor(weather.weatherIcon)
    }

}
