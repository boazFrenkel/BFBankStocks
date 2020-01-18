//
//  QuotesDataProvider.swift
//  StocksExample
//
//  Created by Boaz Frenkel on 18/01/2020.
//  Copyright © 2020 boaz. All rights reserved.
//

import Foundation

protocol QuotesDataProvider {
    func getQuotes(for symbol: String, interval: String, onSuccess: @escaping (_ quotes: [Quote])->(), onError: @escaping (Error) -> Void )
}

struct QuotesDataLoader: QuotesDataProvider {
    
    var quotesAPIService: QuotesAPI = AlphaVantageQuotesAPIService()
    
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
    
}
