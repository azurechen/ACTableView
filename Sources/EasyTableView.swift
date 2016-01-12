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
    
    func clear(){
        sections.removeAll()
    }
    
    func addSection(section: EasyTableViewSection) {
        section.tableView = self
        section.section = sections.count - 1
        sections.append(section)
        
        // set row and section of items
        for (index, item) in section.items.enumerate() {
            item.tableView = self
            item.section = sections.count - 1
            item.row = index
            
            // register nibs
            if (item.type == .Nib) {
                self.registerNib(UINib(nibName: item.reuseIdentifier, bundle: nil), forCellReuseIdentifier: item.reuseIdentifier)
            }
        }
    }
    
    func getSection(atIndexOfSectionInTableView index: Int) -> EasyTableViewSection! {
        var countSection = 0
        
        for (var i = 0; i < sections.count; i++) {
            let section = sections[i]
            if (section.display) {
                if (countSection == index) {
                    return sections[i]
                }
                countSection++
            }
        }
        
        return nil
    }
    
    func getIndexPath(forRow row: Int, inSection sectionNum: Int) -> NSIndexPath? {
        var countSection = 0
        
        for (var i = 0; i < sections.count; i++) {
            let section = sections[i]
            if (section.display) {
                var countRow = 0
                
                for (var j = 0; j < section.items.count; j++) {
                    let item = section.items[j]
                    if (item.display) {
                        if (i == sectionNum && j == row) {
                            return NSIndexPath(forRow: countRow, inSection: countSection)
                        }
                        countRow++
                    }
                }
                countSection++
            }
        }
        
        return nil
    }
    
    func getItem(forRow row: Int, inSection section: Int) -> EasyTableViewItem {
        return sections[section].items[row]
    }
    
    func getItem(indexPath: NSIndexPath) -> EasyTableViewItem {
        return getItem(forRow: indexPath.row, inSection: indexPath.section)
    }
    
    func getItem(atIndexPath indexPath: NSIndexPath) -> EasyTableViewItem! {
        var countSection = 0
        
        for (var i = 0; i < sections.count; i++) {
            let section = sections[i]
            if (section.display) {
                var countRow = 0
                
                for (var j = 0; j < section.items.count; j++) {
                    let item = section.items[j]
                    if (item.display) {
                        if (countSection == indexPath.section && countRow == indexPath.row) {
                            return sections[i].items[j]
                        }
                        countRow++
                    }
                }
                countSection++
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
        var count = 0
        for section in sections {
            if (section.display) {
                count++
            }
        }
        return count
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        for item in self.getSection(atIndexOfSectionInTableView: section).items {
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
            cell = UITableViewCell(style: item.style, reuseIdentifier: identifier)
        }
        item.handle?(item: item, cell: cell!)
        
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
