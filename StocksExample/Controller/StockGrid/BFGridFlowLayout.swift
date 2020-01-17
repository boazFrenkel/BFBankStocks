//
//  BFGridFlowLayout.swift
//  StocksExample
//
//  Created by Boaz Frenkel on 17/01/2020.
//  Copyright © 2020 boaz. All rights reserved.
//

import UIKit

class BFGridFlowLayout: UICollectionViewFlowLayout {
    /*
     the layout can easily be changed to a different number of coloumns in a different orientations
     */
    fileprivate let columnsNumber = 2
    fileprivate let itemSpacing = CGFloat(2)
    
    override init() {
        super.init()
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupLayout()
    }
    
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
