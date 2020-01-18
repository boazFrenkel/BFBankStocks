//
//  StockQuotesViewController.swift
//  StocksExample
//
//  Created by Boaz Frenkel on 17/01/2020.
//  Copyright © 2020 boaz. All rights reserved.
//

import UIKit

struct Quate : Codable {
    var time: String
    var open: String
    var high: String
    var low: String
    var close: String
    var volume: String
}

protocol QuatesAPI {
    func getQuates(for symbol: String, interval: String, onSuccess: @escaping (_ quates: [Quate])->(), onError: @escaping (Error) -> Void )

}

struct AlphaVantageQuatesAPIService: QuatesAPI {
    func getQuates(for symbol: String, interval: String, onSuccess: @escaping (_ quates: [Quate]) -> (), onError: @escaping (Error) -> Void) {
        
    }
    
}

protocol QuatesDataProvider {
    func getQuates(for symbol: String, interval: String, onSuccess: @escaping (_ quates: [Quate])->(), onError: @escaping (Error) -> Void )
}
struct QuatesDataLoader: QuatesDataProvider {
    func getQuates(for symbol: String, interval: String, onSuccess: @escaping ([Quate]) -> (), onError: @escaping (Error) -> Void) {
        quatesAPIService.getQuates(for: symbol, interval: interval, onSuccess: { (quates) in
            onSuccess(quates)
        }) { (error) in
            onError(error)
        }
    }
    
    var quatesAPIService: QuatesAPI = AlphaVantageQuatesAPIService()
    
    func getQuates(for symbol: String, interval: String) {
        quatesAPIService.getQuates(for: symbol, interval: interval, onSuccess: { ([Quate]) in
            
        }) { (error) in
            
        }
    }
}

final class QuatessViewController: UIViewController {
    
    var dataLoader: QuatesDataProvider = QuatesDataLoader()
    var symbol: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dataLoader.getQuates(for: "msft", interval: "5min", onSuccess: { (quates) in
            
        }) { (error) in
            print("🧣 error getting quates")
        }
    }
    
}


