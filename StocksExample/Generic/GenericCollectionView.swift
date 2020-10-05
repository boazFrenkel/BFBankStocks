//
//  GenericCollectionViewProtocol.swift
//  StocksExample
//
//  Created by Boaz Frenkel on 05/10/2020.
//  Copyright © 2020 boaz. All rights reserved.
//

import UIKit

protocol GenericCollectionViewProtocol: class {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath)
}

class CollectionDataSource<T>: NSObject, UICollectionViewDataSource, UICollectionViewDelegate {
    typealias CellConfigurator = (T, UICollectionViewCell, IndexPath?) -> Void
    private let reuseIdentifier: String
    private let cellConfigurator: CellConfigurator
    var models: [T]
    weak var delegate: GenericCollectionViewProtocol?
    
    init(models: [T], reuseIdentifier: String, cellConfigurator: @escaping CellConfigurator) {
        self.models = models
        self.reuseIdentifier = reuseIdentifier
        self.cellConfigurator = cellConfigurator
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return models.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = models[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        cellConfigurator(model, cell, indexPath)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.collectionView(collectionView, didSelectItemAt: indexPath)
    }
    
    func modelsAt(indexPath: IndexPath) -> T {
        return models[indexPath.row]
    }
    
}
