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
        
        self.rowHeight = UITableViewAutomaticDimension
        self.estimatedRowHeight = 44
    }
    
    func addSection(section: EasyTableViewSection) {
        sections.append(section)
        
        // set row and section of items
        for (index, item) in section.items.enumerate() {
            item.tableView = self
            item.section = sections.count - 1
            item.row = index
            
            // register nibs
            if (item.type == .Custom) {
                self.registerNib(UINib(nibName: item.reuseIdentifier, bundle: nil), forCellReuseIdentifier: item.reuseIdentifier)
            }
        }
    }
    
    func getIndexPath(forRow row: Int, inSection sectionNum: Int) -> NSIndexPath? {
        let section = sections[sectionNum]
        var count = 0
        for (var i = 0; i < section.items.count; i++) {
            let item = section.items[i]
            if (item.display) {
                if (i == row) {
                    return NSIndexPath(forRow: count, inSection: sectionNum)
                }
                count++
            }
        }
        return nil
    }
    
    func getItem(forRow row: Int, inSection section: Int) -> EasyTableViewItem {
        return sections[section].items[row]
    }
    
    func getItem(atIndexPath indexPath: NSIndexPath) -> EasyTableViewItem! {
        let section = sections[indexPath.section]
        var count = 0
        for (var i = 0; i < section.items.count; i++) {
            let item = section.items[i]
            if (item.display) {
                if (count == indexPath.row) {
                    return sections[indexPath.section].items[i]
                }
                count++
            }
        }
        return nil
    }
    
    func hideAllRowsIfNeeded() {
        for section in sections {
            for item in section.items {
                if (!item.initDisplay && item.display) {
                    item.hide()
                }
            }
        }
    }
    
    // DataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        for item in sections[section].items {
            if (item.display) {
                count++
            }
        }
        return count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let item = getItem(atIndexPath: indexPath)
        let identifier = item.reuseIdentifier
        
        // get cell
        var cell = tableView.dequeueReusableCellWithIdentifier(identifier.componentsSeparatedByString(".").first!)
        if (cell == nil) {
            cell = UITableViewCell(style: item.style, reuseIdentifier: item.reuseIdentifier)
        }
        item.handle?(cell!)
        
        cell?.clipsToBounds
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
    
    var items: [EasyTableViewItem] = []
    var header: String?
    var footer: String?
    
    init(header: String?, footer: String?, items: [EasyTableViewItem]) {
        self.items = items
        self.header = header
        self.footer = footer
    }
}
