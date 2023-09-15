//
//  CoinModel.swift
//  ByteCoin
//
//  Created by Koray Emre Senel on 15.09.2023.
//  Copyright © 2023 The App Brewery. All rights reserved.
//

import Foundation

struct CoinModel {
    let price : Double
    let asset : String
    
    var priceString : String {
        return String(format: "%.2f", price)
    }
}
