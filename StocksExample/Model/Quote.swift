//
//  Quote.swift
//  StocksExample
//
//  Created by Boaz Frenkel on 18/01/2020.
//  Copyright © 2020 boaz. All rights reserved.
//

import Foundation

struct Quote : Codable {
    var time: String
    var open: String
    var high: String
    var low: String
    var close: String
    var volume: String
}
