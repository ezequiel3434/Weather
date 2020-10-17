//
//  Extensions.swift
//  Weather
//
//  Created by Ezequiel Parada Beltran on 17/10/2020.
//  Copyright © 2020 Ezequiel Parada. All rights reserved.
//

import Foundation

extension String {
    //MARK: - remove accents
    func toNoSmartQuotes() -> String {
        let userInput = self
        return userInput.folding(options: .diacriticInsensitive, locale: .current)
    }
}