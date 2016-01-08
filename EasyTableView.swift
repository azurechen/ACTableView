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
    
    private func getIndexPathOfCell(atIndex index: Int, inSection sectionNum: Int) -> NSIndexPath? {
        let section = sections[sectionNum]
        var count = 0
        for (var i = 0; i < section.items.count; i++) {
            let item = section.items[i]
            if (item.display) {
                if (i == index) {
                    return NSIndexPath(forRow: sectionNum, inSection: count)
                }
                count++
            }
        }
        return nil
    }
    
    func getItem(atIndex index: Int, inSection section: Int) -> EasyTableViewItem {
        return sections[section].items[index]
    }
    
    func getItemAtIndexPathOfCell(indexPath: NSIndexPath) -> EasyTableViewItem? {
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
    
    func showRow(atIndex index: Int, inSection section: Int) {
        let item = getItem(atIndex: index, inSection: section)
        if (!item.display) {
            item.display = true
            self.insertRowsAtIndexPaths([getIndexPathOfCell(atIndex: index, inSection: section)!], withRowAnimation: UITableViewRowAnimation.Fade)
        }
    }
    
    func hideRow(atIndex index: Int, inSection section: Int) {
        let item = getItem(atIndex: index, inSection: section)
        if (item.display) {
            self.deleteRowsAtIndexPaths([getIndexPathOfCell(atIndex: index, inSection: section)!], withRowAnimation: UITableViewRowAnimation.Fade)
            item.display = false
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
        let item = getItemAtIndexPathOfCell(indexPath)!
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
        
        let item = getItemAtIndexPathOfCell(indexPath)!
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
