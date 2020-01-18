//
//  StockQuotesViewController.swift
//  StocksExample
//
//  Created by Boaz Frenkel on 17/01/2020.
//  Copyright © 2020 boaz. All rights reserved.
//

import UIKit

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


