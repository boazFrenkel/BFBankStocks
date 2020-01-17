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
        case name = "name"
        case symbol = "stk"
        case imagePath = "img"
        case priority = "priority"
    }
}



protocol StocksDataProvider {
    func getStocks() -> [Stock]?
}

struct StocksProvider: StocksDataProvider {
    
    func getStocks() -> [Stock]? {
        
        do {
            let content = Data(banksJsonString.utf8)
            let decoder = JSONDecoder()
            let model = try decoder.decode([Stock].self,
                                           from: content)
            return model
        } catch let parsingError {
            print("Error", parsingError)
            return nil
        }
    }
    
    let banksJsonString :String =
    """
        [
        { "name":"JPMorgan", "stk":"JPM", "img":"https://www.interbrand.com/assets/00000001535.png","priority":"100" },
        { "name":"Bank of America", "stk":"BAC", "img":"https://www.charlotteobserver.com/latest-news/uiy86c/picture6131838/alternates/FREE_1140/E8VhA.So.138.jpg","priority":"99" },
        { "name":"Citigroup", "stk":"C", "img":"https://pentagram-production.imgix.net/wp/592ca89f19a1d/ps-citibank-01.jpg","priority":"80" },
        { "name":"Wells Fargo", "stk":"IIS", "img":"https://motorsportsnewswire.com/wp-content/uploads/2019/08/Wells-Fargo-Company-logo-678.jpg","priority":"15" },
        { "name":"Morgan Stanley", "stk":"MS", "img":"https://www.spglobal.com/_assets/images/leveragedloan/2012/07/morgan-stanley-logo.jpg","priority":"15"  }
        ]
        
    """
}


