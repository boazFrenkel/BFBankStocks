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
    var symbol: String = ""
    var quotes: [Quote] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupQuotesTable()
        self.loadQuotes()
    }
    
    private func setupQuotesTable() {
        self.quotesTableView.dataSource = self
    }
    private func loadQuotes() {
        activityIndicator.startAnimating()
        
        let interval = TimeInterval(rawValue: intervalSelection.selectedSegmentIndex)?.timeIntervalString ?? ""
        
        dataLoader.getQuotes(for: symbol, interval: interval, onSuccess: { (quotes) in
            print(quotes)
            
            self.activityIndicator.stopAnimating()
            self.quotes = quotes
            self.quotesTableView.reloadData()
            if quotes.count > 0 {
                self.quotesTableView.scrollToRow(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
            }
        }) { (error) in
            print("🧣 error getting quotes")
            self.activityIndicator.stopAnimating()
        }
    }
    
    @IBAction func intervalSelected(_ sender: Any) {
        loadQuotes()
    }
}

extension QuotesViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quotes.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let quote = quotes[indexPath.row]
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: QuoteTableCell.self), for: indexPath) as? QuoteTableCell
        else { fatalError("unexpected cell in collection view") }
        
        cell.setup(from: quote)
        return cell
    }
    
    
}

enum TimeInterval : Int {
    case oneMin = 0
    case fiveMin
    case fifteenMin
    case thirtyMin
    case oneHour
    
    var timeIntervalString: String {
        switch self {
        case .oneMin:
            return "1min"
        case .fiveMin:
            return "5min"
        case .fifteenMin:
            return "15min"
        case .thirtyMin:
            return "30min"
        case .oneHour:
            return "60min"
            
        }
    }
    
}


class QuoteTableCell : UITableViewCell {
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var openLabel: UILabel!
    @IBOutlet weak var highLabel: UILabel!
    @IBOutlet weak var lowLabel: UILabel!
    @IBOutlet weak var closeLabel: UILabel!
    @IBOutlet weak var volumeLabel: UILabel!

    func setup(from quote: Quote) {
        self.timeLabel.text = quote.time
        self.openLabel.text = quote.open
        self.highLabel.text = quote.high
        self.lowLabel.text = quote.low
        self.closeLabel.text = quote.close
        self.volumeLabel.text = quote.volume
    }
}
