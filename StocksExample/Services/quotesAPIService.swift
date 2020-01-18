//
//  quotesAPIService.swift
//  StocksExample
//
//  Created by Boaz Frenkel on 18/01/2020.
//  Copyright © 2020 boaz. All rights reserved.
//

import Foundation

protocol QuotesAPI {
    func getQuotes(for symbol: String, interval: String, onSuccess: @escaping (_ quotes: [Quote])->(), onError: @escaping (Error) -> Void )
}

struct AlphaVantageQuotesAPIService: QuotesAPI {
    
    func getQuotes(for symbol: String, interval: String, onSuccess: @escaping (_ quotes: [Quote]) -> (), onError: @escaping (Error) -> Void) {
        let BASE_URL: String = "https://www.alphavantage.co/"
        let API_KEY: String = "Z8EW6CI3PHR9SUTK"
        
        let url = URL(string: "\(BASE_URL)query?function=TIME_SERIES_INTRADAY&symbol=\(symbol)&interval=\(interval)&apikey=\(API_KEY)")
        
        URLSession.shared.dataTask(with: url!){ (data, response, err) in
            guard let data = data else {return}
            
            do{
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as AnyObject
                var quotes = [Quote]()
                if let errorString = json["Error Message"] as? String {
                    onError(AlphaVantageQuoteError.invalidApiCall(message: errorString))
                }

                if let prices = json["Time Series (\(interval))"] as? NSDictionary{
                    guard let priceArray = prices as? [String: AnyObject] else {return}
                    for (key, value) in priceArray{
                        guard let open = value["1. open"] as? String else {return}
                        guard let high = value["2. high"] as? String else {return}
                        guard let low = value["3. low"] as? String else {return}
                        guard let close = value["4. close"] as? String else {return}
                        guard let volume = value["5. volume"] as? String else {return}
                        quotes.append(Quote(time: key, open: open, high: high, low: low, close: close, volume: volume))
                    }
                }
                
                onSuccess(quotes)
            } catch let err {
                onError(err)
            }
        }.resume()
    }
    
    enum AlphaVantageQuoteError: Error {
        case invalidApiCall(message: String)
    }
    
}
