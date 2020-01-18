//
//  UIViewControllerExtension .swift
//  StocksExample
//
//  Created by Boaz Frenkel on 18/01/2020.
//  Copyright © 2020 boaz. All rights reserved.
//

import UIKit

extension UIViewController {
    
    static func create<T: UIViewController>(storyboard: String) -> T {
        let sb = UIStoryboard(name: storyboard, bundle: nil)
        let vc = sb.instantiateViewController(withIdentifier: self.className)
        return vc as! T
    }
}
