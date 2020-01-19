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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = stockName
        setupQuotesTable()
        self.loadQuotes()
    }
    
    private func setupQuotesTable() {
        self.quotesTableView.dataSource = self
    }
    
    private func loadQuotes() {
        activityIndicator.startAnimating()
        
        let interval = TimeInterval(rawValue: intervalSelection.selectedSegmentIndex)?.timeIntervalString ?? ""
        
        dataLoader.getQuotesSortedByDate(for: stockSymbol, interval: interval, onSuccess: {[weak self] (quotes)  in
            
            guard let self = self else {return}
            self.activityIndicator.stopAnimating()
            self.quotes = quotes
            self.quotesTableView.reloadData()
            if quotes.count > 0 {
                self.quotesTableView.scrollToRow(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
            }
        }) { (error) in
            //Handle the error gracefully and not this simple alert
            print("🧣 error getting quotes, \(error)")
            self.activityIndicator.stopAnimating()
            self.showAlert(for:error)
        }
    }
    
    @IBAction func intervalSelected(_ sender: Any) {
        loadQuotes()
    }
    
    private func showAlert(for error: Error) {
        let alert = UIAlertController(title: "Oops", message: "\(error)", preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
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
}
