//
//  EasyTableView.swift
//  EasyTableView
//
//  Created by AzureChen on 2016/1/7.
//  Copyright © 2016 AzureChen. All rights reserved.
//

import UIKit

class EasyTableView: UITableView, UITableViewDelegate, UITableViewDataSource {
    
    var sections: [EasyTableViewSection] = []
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.delegate = self
        self.dataSource = self
        
        self.rowHeight = UITableViewAutomaticDimension
        self.estimatedRowHeight = 44
    }
    
    func addSection(section: EasyTableViewSection) {
        sections.append(section)
        
        // register nibs
        for item in section.items {
            if (item.type == .Custom) {
                self.registerNib(UINib(nibName: item.reuseIdentifier, bundle: nil), forCellReuseIdentifier: item.reuseIdentifier)
            }
        }
    }
    
    func getItem(atSectionIndex sectionIndex: Int, atItemIndex itemIndex: Int) -> EasyTableViewItem {
        return sections[sectionIndex].items[itemIndex]
    }
    
    func getItemInTableView(tableView: UITableView, atIndexPath indexPath: NSIndexPath) -> EasyTableViewItem? {
        let section = sections[indexPath.section]
        var count = 0
        for item in section.items {
            if (item.display) {
                if (count == indexPath.row) {
                    return item
                }
                count++
            }
        }
        return nil
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
        let item = getItemInTableView(tableView, atIndexPath: indexPath)!
        let identifier = item.reuseIdentifier
        
        // get cell
        var cell = tableView.dequeueReusableCellWithIdentifier(identifier.componentsSeparatedByString(".").first!)
        if (cell == nil) {
            cell = UITableViewCell(style: item.style, reuseIdentifier: item.reuseIdentifier)
        }
        item.handle?(cell!)
        
        return cell!
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sections[section].header
    }
    
    func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return sections[section].footer
    }
    
    // Delegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: false)
        
        let item = getItemInTableView(tableView, atIndexPath: indexPath)!
        item.didSelect?()
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
