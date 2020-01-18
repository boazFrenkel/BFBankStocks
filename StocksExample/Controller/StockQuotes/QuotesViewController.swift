//
//  StockQuotesViewController.swift
//  StocksExample
//
//  Created by Boaz Frenkel on 17/01/2020.
//  Copyright © 2020 boaz. All rights reserved.
//

import UIKit

struct Quote : Codable {
    var time: String
    var open: String
    var high: String
    var low: String
    var close: String
    var volume: String
}

protocol QuotesAPI {
    func getQuotes(for symbol: String, interval: String, onSuccess: @escaping (_ quotes: [Quote])->(), onError: @escaping (Error) -> Void )
    
}

struct AlphaVantageQuotesAPIService: QuotesAPI {
    func getQuotes(for symbol: String, interval: String, onSuccess: @escaping (_ quotes: [Quote]) -> (), onError: @escaping (Error) -> Void) {
        let BASE_URL: String =  "https://www.alphavantage.co/"
        let API_KEY: String =  "Z8EW6CI3PHR9SUTK"
        let url = URL(string: "\(BASE_URL)query?function=TIME_SERIES_INTRADAY&symbol=\(symbol)&interval=\(interval)&apikey=\(API_KEY)")
        
        URLSession.shared.dataTask(with: url!){ (data, response, err) in
            guard let data = data else {return}
            
            do{
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as AnyObject
                var quotes = [Quote]()
                
                if let information = json["Meta Data"] as? NSDictionary{
                    print("The meta data is: \(information)")
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
            }catch let err{
                print(err)
                onError(err)
            }
        }.resume()
    }
    
}

protocol QuotesDataProvider {
    func getQuotes(for symbol: String, interval: String, onSuccess: @escaping (_ quotes: [Quote])->(), onError: @escaping (Error) -> Void )
}
struct QuotesDataLoader: QuotesDataProvider {
    func getQuotes(for symbol: String, interval: String, onSuccess: @escaping ([Quote]) -> (), onError: @escaping (Error) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            self.quotesAPIService.getQuotes(for: symbol, interval: interval, onSuccess: { (quotes) in
                DispatchQueue.main.async {
                onSuccess(quotes)
                }
            }) { (error) in
                DispatchQueue.main.async {
                onError(error)
                }
            }
        }
        
    }
    
    var quotesAPIService: QuotesAPI = AlphaVantageQuotesAPIService()
    
    func getQuotes(for symbol: String, interval: String) {
        quotesAPIService.getQuotes(for: symbol, interval: interval, onSuccess: { ([Quote]) in
            
        }) { (error) in
            
        }
    }
}

final class QuotesViewController: UIViewController {
    
    var dataLoader: QuotesDataProvider = QuotesDataLoader()
    var symbol: String = ""
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView(style:.large)
    override func viewDidLoad() {
        super.viewDidLoad()
        activityIndicator.startAnimating()
        dataLoader.getQuotes(for: symbol, interval: "5min", onSuccess: { (quotes) in
            print(quotes)
            
            self.activityIndicator.startAnimating()
        }) { (error) in
            print("🧣 error getting quotes")
            self.activityIndicator.startAnimating()
        }
    }
    
}


