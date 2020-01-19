//
//  quotesAPIService.swift
//  StocksExample
//
//  Created by Boaz Frenkel on 18/01/2020.
//  Copyright © 2020 boaz. All rights reserved.
//

import Foundation
import Moya

protocol QuotesAPI {
    func getQuotes(for symbol: String, interval: String, onSuccess: @escaping (_ quotes: [Quote])->(), onError: @escaping (Error) -> Void )
}

struct AlphaVantageQuotesAPIService: QuotesAPI {
    let provider = MoyaProvider<AlphaVantageService>()
    
    func test(for symbol: String, interval: String) {
        provider.request(.quotes(symbol: symbol, interval: interval)) { (result) in
            
            switch result {
            case .success(let response):
                do {
                    print(try response.mapJSON())
                } catch {
                    
                }
            case .failure:
                print(result.error?.errorDescription ?? "")
            }
        }
    }
    func getQuotes(for symbol: String, interval: String, onSuccess: @escaping (_ quotes: [Quote]) -> (), onError: @escaping (Error) -> Void) {
        
        provider.request(.quotes(symbol: symbol, interval: interval)) { (result) in
            //We don't want to do work on the main thread
            DispatchQueue.global(qos: .userInitiated).async {
                switch result {
                case .success(let response):
                    do {
                        let json = try response.mapJSON(failsOnEmptyData: true) as! Json
                        var quotes = [Quote]()
                        if let errorString = json["Error Message"] as? String {
                            onError(AlphaVantageQuoteError.errorOnApiCall(message: errorString))
                            return
                        }
                        if let errorString = json["Note"] as? String {
                            onError(AlphaVantageQuoteError.errorOnApiCall(message: errorString))
                            return
                        }
                        
                        /*
                         The array of relevent quotes is nested inside a dynamic (depends on the interval param we sent) Time Series + (xmin) key
                         */
                        if let timeSeries = json["Time Series (\(interval))"] as? NSDictionary {
                            guard let times = timeSeries as? [String: AnyObject] else {
                                onError(AlphaVantageQuoteError.parsingError)
                                return
                                
                            }
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
                            onSuccess(quotes)
                        } else {
                            onError(AlphaVantageQuoteError.parsingError)
                            return
                        }
                        
                    } catch {
                        onError(AlphaVantageQuoteError.networkError)
                        return
                    }
                case .failure(let error):
                    print(result.error?.errorDescription ?? "")
                    onError(error)
                    return
                }
            }
            
        }
    }
    
    enum AlphaVantageQuoteError: Error {
        case errorOnApiCall(message: String)
        case parsingError
        case networkError
    }
    
}
