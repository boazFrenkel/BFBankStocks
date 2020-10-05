//
//  Constants.swift
//  StocksExample
//
//  Created by Boaz Frenkel on 05/10/2020.
//  Copyright © 2020 boaz. All rights reserved.
//

import Foundation

struct Constants {
    
    static let note = "Note"
    static let timeSeries = "Time Series"
    static let oneOpen = "1. open"
    static let twoHigh = "2. high"
    static let threeLow = "3. low"
    static let fourClose = "4. close"
    static let fiveVolume = "5. volume"
    static let oneMin = "1min"
    static let fiveMin = "5min"
    static let fifteenMin = "15min"
    static let thirtyMin = "30min"
    static let sixtyMin = "60min"
    
    // MARK: API
    static let alphavantageAPIBase = "https://www.alphavantage.co"
    static let query = "/query"
    static let functionParam = "function"
    static let timeSeriesIntrday = "TIME_SERIES_INTRADAY"
    static let symbolParam = "symbol"
    static let intervalParam = "interval"
    static let apiKeyParam = "apikey"
    static let contentType = "Content-Type"
    static let applicationJSON = "application/json"
    
    //Error
    static let errorMessage = "Error Message"
    static let oops = "Oops"
    static let ok = "OK"
    
    static let banksJson =
        """
        [
        { "name":"JPMorgan", "stk":"JPM", "img":"https://www.interbrand.com/assets/00000001535.png","priority":"100" },
        { "name":"Bank of America", "stk":"BAC", "img":"https://www.charlotteobserver.com/latest-news/uiy86c/picture6131838/alternates/FREE_1140/E8VhA.So.138.jpg","priority":"99" },
        { "name":"Citigroup", "stk":"C", "img":"https://pentagram-production.imgix.net/wp/592ca89f19a1d/ps-citibank-01.jpg","priority":"80" },
        { "name":"Wells Fargo", "stk":"WFC", "img":"https://motorsportsnewswire.com/wp-content/uploads/2019/08/Wells-Fargo-Company-logo-678.jpg","priority":"15" },
        { "name":"Morgan Stanley", "stk":"MS", "img":"https://www.spglobal.com/_assets/images/leveragedloan/2012/07/morgan-stanley-logo.jpg","priority":"15"  }
        ]
        
    """
}


