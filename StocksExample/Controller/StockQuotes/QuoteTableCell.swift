//
//  QuoteTableCell.swift
//  StocksExample
//
//  Created by Boaz Frenkel on 18/01/2020.
//  Copyright © 2020 boaz. All rights reserved.
//

import UIKit

class QuoteTableCell : UITableViewCell {
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var openLabel: UILabel!
    @IBOutlet weak var highLabel: UILabel!
    @IBOutlet weak var lowLabel: UILabel!
    @IBOutlet weak var closeLabel: UILabel!
    @IBOutlet weak var volumeLabel: UILabel!
    
    func setup(from quote: Quote) {
        self.timeLabel.text = quote.timeWithoutDate
        self.openLabel.text = quote.open
        self.highLabel.text = quote.high
        self.lowLabel.text = quote.low
        self.closeLabel.text = quote.close
        self.volumeLabel.text = quote.volume
    }
}
