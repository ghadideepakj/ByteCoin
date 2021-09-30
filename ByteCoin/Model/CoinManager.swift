//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

protocol CoinManagerDelegate {
    
    func didUpdateRate(_ coinmanger: CoinManager, coinData: CoinModel)
    func didFailWithError(error: Error)
}


struct CoinManager {
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "3BFAC79B-CB8F-4A45-BE8D-EE156396A747"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]

    var delegate : CoinManagerDelegate?
    
    
    func getCoinPrice(for currency: String) {
        
        let urlString = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        //print(urlString)
        performRequest(with: urlString)
        
    }
    
    func performRequest(with urlString: String) {
        
        //1.  Create a URL
        if let url = URL(string: urlString){
        
        //2.  Create a URLsession
            let session = URLSession(configuration: .default)
            
        //3.  Give the session a task
            let task = session.dataTask(with: url) { (data, responce, error) in
                
                if error != nil{
                    //self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data{
                    
                    let dataString = String(data: safeData, encoding: .utf8)
                    print(dataString!)
                    
                    
                    
                    if let weather = self.parseJSON(safeData)
                    {self.delegate?.didUpdateRate(self, coinData: weather)}
                    
                    
                   //self.parseJSON(safeData)
                }

            }
            
        //4.  Start the task
            task.resume()
        }
    }
    
    
    func parseJSON(_ coinData: Data) -> CoinModel? {
        
        let decoder = JSONDecoder()
        
                do
                {
                    let decodedData = try decoder.decode(CoinData.self, from: coinData)
                    let rate = decodedData.rate
                    print(rate)
        
                    let parsewWeather = CoinModel(currencyRateInModel: rate)
        
                    return parsewWeather
                    }catch{
                    print(error)
        
                        self.delegate?.didFailWithError(error: error)
                        return nil
                    }

        
        
        
    }
    

}
