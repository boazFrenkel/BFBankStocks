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
            guard let data = data else {
                onError(AlphaVantageQuoteError.errorOnApiCall(message: "No data returned from server"))
                return}
            
            do{
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as AnyObject
                var quotes = [Quote]()
                if let errorString = json["Error Message"] as? String {
                    onError(AlphaVantageQuoteError.errorOnApiCall(message: errorString))
                }
                
                /*
                 The array of relevent quotes is nested inside a dynamic (depends on the interval param we sent) Time Series + (xmin) key
                 */
                if let timeSeries = json["Time Series (\(interval))"] as? NSDictionary{
                    guard let times = timeSeries as? [String: AnyObject] else {return}
                    /*
                     Quote Model is built with the date so we have to "flatten" the Json to add the dynamic date key for each qoute
                     */
                    for (key, value) in times {
                        guard let open = value["1. open"] as? String,
                            let high = value["2. high"] as? String,
                            let low = value["3. low"] as? String,
                            let close = value["4. close"] as? String,
                            let volume = value["5. volume"] as? String
                            else {
                                onError(AlphaVantageQuoteError.parsingError)
                                return
                        }
                        quotes.append(Quote(date: key, open: open, high: high, low: low, close: close, volume: volume))
                    }
                }
                
                onSuccess(quotes)
            } catch let err {
                onError(err)
            }
        }.resume()
    }
    
    enum AlphaVantageQuoteError: Error {
        case errorOnApiCall(message: String)
        case parsingError
    }
    
}
