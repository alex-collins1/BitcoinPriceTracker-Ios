


import Foundation

protocol CoinManagerDelegate {
    //Create the method stubs wihtout implementation in the protocol.
    //It's usually a good idea to also pass along a reference to the current class.
    //e.g. func didUpdatePrice(_ coinManager: CoinManager, price: String, currency: String)
    //Check the Clima module for more info on this.
    func priceUpdating(price: String, currency: String)
    func catchAnyErrors(error: Error)

}

struct CoinManager {
    var delegate: CoinManagerDelegate?
    
  let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "F0CE3C9E-75DF-4527-B135-BB0180528820"
    
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    
    func getCoinPrice(for currency: String) {
   let urlString = "\(baseURL)/\(currency)?apikey=\(apiKey)"
        
        
        
        // create a url: \\
        // if let is used so it will not be optional
        
        if  let url = URL(string: urlString) {
            
            
            // create a URl session:
            let session = URLSession(configuration: .default)
            
            
            // give session a task //
            let task =  session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    // just a return will exit out of the function //
                    return
                }
                if let safeData = data {
                    let bitcoinPrice = self.parseJSON(data: safeData)
                    // round the price down to 2 decimal places.
                    let priceToTwoDeciamls = String(format: "%.0f", bitcoinPrice!)
                    
                    
                    //Call the delegate method in the delegate (ViewController) and
                                          //pass along the necessary data.
                    self.delegate?.priceUpdating(price: priceToTwoDeciamls, currency: currency)
                    
                }
                
            }
            // starts the task //
            task.resume()
            
            
            
            
            
        }
    }
    
    
    
    func parseJSON(data: Data) -> Double? {
        
    let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CoinData.self, from: data)
            
            let lastPrice = decodedData.rate
            print(lastPrice)
            return lastPrice
            
        } catch {
        print(error)
            return nil 
        }
    }
}

    
   


