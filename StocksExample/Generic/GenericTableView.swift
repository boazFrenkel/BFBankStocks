//
//  GenericTableViewProtocol.swift
//  StocksExample
//
//  Created by Boaz Frenkel on 05/10/2020.
//  Copyright © 2020 boaz. All rights reserved.
//
import UIKit

protocol GenericTableViewProtocol: class {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
}

class TableViewDataSource<T>: NSObject, UITableViewDataSource, UITableViewDelegate {
    typealias CellConfigurator = (T, UITableViewCell) -> Void
    weak var delegate: GenericTableViewProtocol?
    
    var models: [T]
    
    private let reuseIdentifier: String
    private let cellConfigurator: CellConfigurator
    
    init(models: [T], reuseIdentifier: String, cellConfigurator: @escaping CellConfigurator) {
        self.models = models
        self.reuseIdentifier = reuseIdentifier
        self.cellConfigurator = cellConfigurator
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.row]
        let cell = tableView.dequeueReusableCell( withIdentifier: reuseIdentifier, for: indexPath)
        
        cellConfigurator(model, cell)
        
        return cell
    }
    
    // MARK: Delegate methods
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        delegate?.tableView(tableView, didSelectRowAt: indexPath)
    }

}
