//
//  Quote.swift
//  StocksExample
//
//  Created by Boaz Frenkel on 18/01/2020.
//  Copyright © 2020 boaz. All rights reserved.
//

import Foundation

struct Quote : Codable {
    var date: String
    var open: String
    var high: String
    var low: String
    var close: String
    var volume: String
    
    var timeWithoutDate: String {
        let dateFormatterFull = DateFormatter()
        dateFormatterFull.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let dateFormatterTimeOnly = DateFormatter()
        dateFormatterTimeOnly.dateFormat = "HH:mm:ss"
        
        guard let date = dateFormatterFull.date(from: self.date) else {
            return self.date
        }
        return dateFormatterTimeOnly.string(from: date)
    }
}

//Sort by date helper - the date format of qoute is specific: yyyy-MM-dd HH:mm:ss
extension Quote {
    
    static func sorterForQuoteDate(this:Quote, that:Quote) -> Bool {
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd HH:mm:ss"
        guard let thisDate = dateFormatterGet.date(from: this.date),
            let thatTime = dateFormatterGet.date(from: that.date) else { return false}
        return thisDate > thatTime
    }
    
}
