//
//  ViewController.swift
//  StocksExample
//
//  Created by Boaz Frenkel on 15/01/2020.
//  Copyright © 2020 boaz. All rights reserved.
//

import UIKit

final class ViewController: UIViewController {

    private var stocks: [Stock] = [Stock(name: "some name", symbol: "some symbol", imagePath: "some url", priority: 1),
    Stock(name: "some name", symbol: "some symbol", imagePath: "some url", priority: 1),
    Stock(name: "some name", symbol: "some symbol", imagePath: "some url", priority: 1)
    ]
    @IBOutlet weak var collectionView : UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       // self.stocks = dataLoader.getStocks()
        //setting a new grid that's easyly controlled
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        let flowLayout = BFGridFlowLayout()
        self.collectionView.setCollectionViewLayout(flowLayout, animated: false)
    }


}


//MARK:- UICollectionViewDataSource
extension ViewController : UICollectionViewDataSource{
    
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
        
        //configure the cell
        cell.setup(imagePath: stock.imagePath, name: stock.name)
        return cell
    }
}

//MARK:- UICollectionViewDelegate
extension ViewController : UICollectionViewDelegate{
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        collectionView.deselectItem(at: indexPath, animated: false)
                
        //Navigate to next screen
        
    }
    
    
}




class BFGridFlowLayout: UICollectionViewFlowLayout {
    
    /*
     the layout can easily be changed to a different number of coloumns in the different orientations
     */
    fileprivate let columnsNumber = 3
    fileprivate let itemSpacing = CGFloat(10)
    
    override init() {
        super.init()
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupLayout()
    }
    
    /**
     Sets up the layout for the collectionView. distance between each cell and distance between each row plus use a vertical layout
     */
    private func setupLayout() {
        minimumInteritemSpacing = itemSpacing
        minimumLineSpacing = itemSpacing
        scrollDirection = .vertical
    }
    
    private var itemWidth :CGFloat {
        return (self.collectionView!.bounds.width)/CGFloat(integerLiteral: columnsNumber) - itemSpacing
    }
    
    //the item is a square
    override var itemSize: CGSize {
        set {
            self.itemSize = CGSize(width: self.itemWidth, height: self.itemWidth)
        }
        
        get {
            return CGSize(width: self.itemWidth, height: self.itemWidth)
        }
    }
}



class GridViewCell: UICollectionViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!

    var imagePath: String?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageView.image = nil
    }
    
    func setup(imagePath: String?, name: String) {
        self.imagePath = imagePath
        nameLabel.text = name
    }
}
