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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.layer.borderColor = UIColor.gray.cgColor
        self.layer.borderWidth = 1
        self.imageView.layer.borderColor = UIColor.lightGray.cgColor
        self.imageView.layer.borderWidth = 1
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageView.image = nil
    }
    
}
