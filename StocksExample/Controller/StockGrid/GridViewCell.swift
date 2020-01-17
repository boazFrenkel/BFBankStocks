//
//  GridViewCell.swift
//  StocksExample
//
//  Created by Boaz Frenkel on 17/01/2020.
//  Copyright © 2020 boaz. All rights reserved.
//

import UIKit

class GridViewCell: UICollectionViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var symbolLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    var imagePath: String?
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageView.image = nil
    }
    
    func setup(imagePath: String?, name: String, symbol: String) {
        self.imagePath = imagePath
        self.nameLabel.text = name
        self.symbolLabel.text = symbol
    }
}
