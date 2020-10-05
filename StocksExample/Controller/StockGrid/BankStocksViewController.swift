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
    var collectionDataSource: CollectionDataSource<Stock>?
    
    @IBOutlet weak var collectionView : UICollectionView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stocks = stockProvider.getStocksSortedByPriority() ?? []
        setupCollection()
    }
    
    private func setupCollection() {
        self.setupCollectionDataSource(stocks: stocks)
        self.collectionView.dataSource = collectionDataSource
        self.collectionView.delegate = self
        let flowLayout = BFGridFlowLayout()
        self.collectionView.setCollectionViewLayout(flowLayout, animated: false)
        collectionView.reloadData()
    }
    
    func setupCollectionDataSource(stocks: [Stock]) {
        collectionDataSource = CollectionDataSource(models: stocks, reuseIdentifier: GridViewCell.className, cellConfigurator: { (stock, cell, indexPath) in
            
            guard let cell = cell as? GridViewCell else {return}
            
            cell.nameLabel.text = stock.name
            cell.symbolLabel.text = stock.symbol
            cell.imageView.sd_setImage(with: URL(string: stock.imagePath), placeholderImage: UIImage(named: "bankPlaceholder"))
        })
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
