protocol CoinManagerDelegate {
    func didUpdatePrice(_ coinManager: CoinManager, price: Double)
    func didFailWithError(error: Error)
}

import Foundation
struct CoinManager {
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "9B2EF526-1068-460E-872B-40D7EA3DDE36"
    let currencyArray = ["AUD","BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    var delegate: CoinManagerDelegate?
    
    func makeURL(currency: String) {
        let url = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        performRequest(url: url)
    }
    
    func performRequest(url: String) {
        if let url = URL (string: url) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let price = self.parseJSON(safeData) {
                        self.delegate?.didUpdatePrice(self, price: price)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ data: Data) -> Double? {
        let decoder = JSONDecoder()
        do {
            let returnedData = try decoder.decode(CoinData.self, from: data)
            
            let price = returnedData.rate
            return price
        }
        catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
