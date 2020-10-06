//
//  StocksProvider.swift
//  StocksExample
//
//  Created by Boaz Frenkel on 17/01/2020.
//  Copyright © 2020 boaz. All rights reserved.
//

import Foundation

protocol StocksDataProvider {
    func getStocksSortedByPriority() -> [Stock]?
}

struct LocalStocksProvider: StocksDataProvider {
    
    let banksJson = Constants.banksJson.data(using: .utf8)!
    
    func getStocksSortedByPriority() -> [Stock]? {
        do {
            let content = banksJson
            let decoder = JSONDecoder()
            let model = try decoder.decode([Stock].self,
                                           from: content)
            return model.sorted(by: sorterForPriority)
            
        } catch let parsingError {
            //Handle the error better
            print("Error", parsingError)
            return nil
        }
    }
    
    private func sorterForPriority(this:Stock, that:Stock) -> Bool {
        let thisPriority = Int(this.priority) ?? 0
        let thatPriority = Int(that.priority) ?? 0
        return thisPriority > thatPriority
    }
    
}
