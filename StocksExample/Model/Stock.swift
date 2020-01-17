//
//  Stock.swift
//  StocksExample
//
//  Created by Boaz Frenkel on 15/01/2020.
//  Copyright © 2020 boaz. All rights reserved.
//

import Foundation

typealias Json = [String : Any]

struct Stock: Decodable {
    var name : String
    var symbol : String
    var imagePath : String
    var priority : String
    
    private enum CodingKeys: String, CodingKey {
        case name
        case symbol = "stk"
        case imagePath = "img"
        case priority
    }
}
