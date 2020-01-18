//
//  ViewController.swift
//  StocksExample
//
//  Created by Boaz Frenkel on 15/01/2020.
//  Copyright © 2020 boaz. All rights reserved.
//

import UIKit
import SDWebImage

final class BankStocksViewController: UIViewController {
    
    private var stocks = [Stock]()
    var stockProvider: StocksDataProvider = LocalStocksProvider()
    @IBOutlet weak var collectionView : UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stocks = stockProvider.getStocksSortedByPriority() ?? []
        setupCollection()
    }
    
    private func setupCollection() {
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        let flowLayout = BFGridFlowLayout()
        self.collectionView.setCollectionViewLayout(flowLayout, animated: false)
        collectionView.reloadData()
    }
}

extension BankStocksViewController : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return stocks.count
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let stock = self.stocks[indexPath.row]
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: GridViewCell.self), for: indexPath) as? GridViewCell
            else { fatalError("unexpected cell in collection view") }
        
        cell.nameLabel.text = stock.name
        cell.symbolLabel.text = stock.symbol
        cell.imageView.sd_setImage(with: URL(string: stock.imagePath), placeholderImage: UIImage(named: "bankPlaceholder"))
        
        return cell
    }
}

extension BankStocksViewController : UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let stock = stocks[indexPath.row]
        let vc: QuotesViewController = QuotesViewController.create(storyboard:"StockQuotes")
        vc.stockSymbol = stock.symbol
        vc.stockName = stock.name
        self.navigationController?.pushViewController(vc, animated: true)
        collectionView.deselectItem(at: indexPath, animated: false)
    }
}
