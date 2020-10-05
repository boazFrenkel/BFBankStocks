//
//  StockQuotesViewController.swift
//  StocksExample
//
//  Created by Boaz Frenkel on 17/01/2020.
//  Copyright © 2020 boaz. All rights reserved.
//

import UIKit

final class QuotesViewController: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var quotesTableView: UITableView!
    @IBOutlet weak var intervalSelection: UISegmentedControl!
    
    var dataLoader: QuotesDataProvider = QuotesDataLoader()
    var stockSymbol: String = ""
    var stockName: String = ""
    var quotes: [Quote] = []
    var quotesDataSource: TableViewDataSource<Quote>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = stockName
        setupQuotesTable()
        self.loadQuotes()
    }
    
    private func setupQuotesTable() {
        self.quotesDataSource = .make(for: quotes)
        self.quotesTableView.dataSource = self.quotesDataSource
        self.quotesTableView.reloadData()
        if quotes.count > 0 {
            self.quotesTableView.scrollToRow(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
        }
    }
    
    private func loadQuotes() {
        activityIndicator.startAnimating()
        
        let interval = TimeInterval(rawValue: intervalSelection.selectedSegmentIndex)?.timeIntervalString ?? ""
        
        dataLoader.getQuotesSortedByDate(for: stockSymbol, interval: interval, onSuccess: {[weak self] (quotes)  in
            guard let self = self else {return}
            self.activityIndicator.stopAnimating()
            self.quotes = quotes
            self.setupQuotesTable()
        }) { (error) in
            //Handle the error gracefully and not this simple alert
            self.activityIndicator.stopAnimating()
            self.showAlert(for:error)
        }
    }
    
    private func showAlert(for error: Error) {
        let alert = UIAlertController(title: Constants.oops, message: "\(error)", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Constants.ok, style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }

    // MARK : Actions
    @IBAction func intervalSelected(_ sender: Any) {
        loadQuotes()
    }

}

//Helper Enum for mapping time intervals
extension QuotesViewController {
    
    enum TimeInterval : Int {
        case oneMin = 0
        case fiveMin
        case fifteenMin
        case thirtyMin
        case oneHour
        
        var timeIntervalString: String {
            switch self {
            case .oneMin:
                return Constants.oneMin
            case .fiveMin:
                return Constants.fiveMin
            case .fifteenMin:
                return Constants.fifteenMin
            case .thirtyMin:
                return Constants.thirtyMin
            case .oneHour:
                return Constants.sixtyMin
                
            }
        }
    }
}

extension TableViewDataSource where T == Quote {
    
    static func make(for options: [T],
                     reuseIdentifier: String = QuoteTableCell.className) -> TableViewDataSource {
        return TableViewDataSource(
            models: options,
            reuseIdentifier: reuseIdentifier
        ) { (quote, cell) in
            guard let cell = cell as? QuoteTableCell else { return }
            cell.setup(from: quote)
        }
    }
}
