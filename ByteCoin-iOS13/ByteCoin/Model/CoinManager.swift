//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate {
    func didUpdatePrice(coin : CoinModel)
    func didFailWithError(error : Error)
}

struct CoinManager {
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "C52E1943-FA80-43EF-B701-EE9B203706CF"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR","TRY"]
    
    var delegate : CoinManagerDelegate?

    func getCoinPrice(for currency : String) {
        let url = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        performRequest(with: url)
    }
    
    func performRequest(with urlString : String) {
        if let url = URL(string: urlString){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) {(data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data {
                    if let coin = self.parseJSON(safeData){
                        self.delegate?.didUpdatePrice(coin: coin)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ data:Data) -> CoinModel? {
        let decoder = JSONDecoder()
        
        do{
            let decodedData = try decoder.decode(CoinData.self, from: data)
            let lastPrice = decodedData.rate
            let assetID = decodedData.asset_id_quote
            let coin = CoinModel(price: lastPrice, asset : assetID)
            return coin
        } catch {
            //delegate?.didFailWithError(self, error: error)
            return nil
        }
    }
}
