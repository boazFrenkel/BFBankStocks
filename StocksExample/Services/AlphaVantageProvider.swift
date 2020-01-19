//
//  AlphaVantageProvider.swift
//  StocksExample
//
//  Created by Boaz Frenkel on 19/01/2020.
//  Copyright © 2020 boaz. All rights reserved.
//

import Foundation

import Moya

public enum AlphaVantageProvider {
    
    static private let apiKey = "Z8EW6CI3PHR9SUTK"
    
    case quotes(symbol: String, interval: String)
}

extension AlphaVantageProvider: TargetType {
    
    public var baseURL: URL {
        return URL(string: "https://www.alphavantage.co")!
    }
    
    public var path: String {
        switch self {
        case .quotes: return "/query"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .quotes: return .get
        }
    }
    
    //for testing
    public var sampleData: Data {
        return Data()
    }
    
    public var task: Task {
        
        switch self {
        case .quotes(let symbol,let interval):
            let parameters: [String : Any] = [
                "function": "TIME_SERIES_INTRADAY",
                "symbol": symbol,
                "interval": interval,
                "apikey": AlphaVantageProvider.apiKey
            ]
            return .requestParameters(parameters: parameters, encoding: URLEncoding.queryString)
        }
    }
    
    public var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }
    
    public var validationType: ValidationType {
        return .successCodes
    }
}
