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
    
    let provider = MoyaProvider<AlphaVantageProvider>()
    
    func getQuotes(for symbol: String, interval: String, onSuccess: @escaping (_ quotes: [Quote]) -> (), onError: @escaping (Error) -> Void) {
        let queue = DispatchQueue.global(qos: .userInteractive)
        //We don't want to do this work on the main thread
        provider.request(.quotes(symbol: symbol, interval: interval),
                         callbackQueue: queue) { (result) in
            
                switch result {
                case .success(let response):
                    do {
                        let json = try response.mapJSON(failsOnEmptyData: true) as! Json
                        
                        if let errorString = json[Constants.errorMessage] as? String {
                            onError(AlphaVantageQuoteError.errorOnApiCall(message: errorString))
                            return
                        }
                        if let errorString = json[Constants.note] as? String {
                            onError(AlphaVantageQuoteError.errorOnApiCall(message: errorString))
                            return
                        }
                        
                        /*
                         The array of relevent quotes is nested inside a dynamic (depends on the interval param we sent) Time Series + (xmin) key
                         */
                        var quotes = [Quote]()
                        guard let timeSeries = json["\(Constants.timeSeries) (\(interval))"] as? NSDictionary,
                            let times = timeSeries as? [String: AnyObject]
                            else {
                                onError(AlphaVantageQuoteError.parsingError)
                                return
                                
                        }
                        /*
                         Quote Model is built with the date so we have to "flatten" the Json to add the dynamic date key for each qoute
                         */
                        for (key, value) in times {
                            guard let open = value[Constants.oneOpen] as? String,
                                let high = value[Constants.twoHigh] as? String,
                                let low = value[Constants.threeLow] as? String,
                                let close = value[Constants.fourClose] as? String,
                                let volume = value[Constants.fiveVolume] as? String
                                else {
                                    onError(AlphaVantageQuoteError.parsingError)
                                    return
                            }
                            quotes.append(Quote(date: key, open: open, high: high, low: low, close: close, volume: volume))
                        }
                        onSuccess(quotes)
                        
                    } catch {
                        onError(AlphaVantageQuoteError.networkError)
                        return
                    }
                case .failure(let error):
                    onError(error)
                    return
                }
        }
    }
    
    enum AlphaVantageQuoteError: Error {
        case errorOnApiCall(message: String)
        case parsingError
        case networkError
    }
    
}
