//
//  EasyTableView.swift
//  EasyTableView
//
//  Created by AzureChen on 2016/1/7.
//  Copyright © 2016 AzureChen. All rights reserved.
//

import UIKit

class EasyTableView: UITableView, UITableViewDataSource {
    
    var sections: [EasyTableViewSection] = []
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.dataSource = self
    }
    
    func addSection(section: EasyTableViewSection) {
        sections.append(section)
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].items.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let identifier = sections[indexPath.section].items[indexPath.row].reuseIdentifier!
        var cell = tableView.dequeueReusableCellWithIdentifier(identifier) as? EasyTableViewCell
        if (cell == nil) {
            cell = sections[indexPath.section].items[indexPath.row]
        }
        
        return cell!
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].header
    }
    
    func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return sections[section].footer
    }
}

class EasyTableViewSection {
    
    var items: [EasyTableViewCell] = []
    var header: String?
    var footer: String?
    
    init(items: [EasyTableViewCell], header: String?, footer: String?) {
        self.items = items
        self.header = header
        self.footer = footer
    }
}
