//
//  NSObjectExtension.swift
//  StocksExample
//
//  Created by Boaz Frenkel on 18/01/2020.
//  Copyright © 2020 boaz. All rights reserved.
//

import Foundation

extension NSObject {
    static var className: String {
        return String(describing: self)
    }
}
