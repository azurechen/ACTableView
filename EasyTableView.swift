//
//  EasyTableView.swift
//  EasyTableView
//
//  Created by AzureChen on 2016/1/7.
//  Copyright © 2016 AzureChen. All rights reserved.
//

import UIKit

class EasyTableView: UITableView, UITableViewDataSource {
    
    var _items: [[EasyTableViewCell]] = []
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.dataSource = self
    }
    
    func add(item: EasyTableViewCell, inSection section: Int) {
        if (_items[safe: section] == nil) {
            for (var i = _items.count; i <= section; i++) {
                _items.append([])
            }
        }
        _items[section].append(item)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return _items.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return _items[section].count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return _items[indexPath.section][indexPath.row]
    }

}
