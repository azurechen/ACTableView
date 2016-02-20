//
//  ACTableView.swift
//  ACTableView
//
//  Created by AzureChen on 2016/1/7.
//  Copyright © 2016 AzureChen. All rights reserved.
//

import UIKit

class ACTableView: UITableView, UITableViewDataSource {
    
    var sections: [ACTableViewSection] = []
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.dataSource = self
        
        self.rowHeight = UITableViewAutomaticDimension
        self.estimatedRowHeight = 44
    }
    
    func clear(){
        sections.removeAll()
    }
    
    func addSection(section: ACTableViewSection) {
        sections.append(section)
        section.tableView = self
        section.section = sections.count - 1
        
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
    
    func getIndexOfSectionInTableView(atIndexOfSectionInItems index: Int) -> Int? {
        var countSection = 0
        
        for (var i = 0; i < sections.count; i++) {
            let section = sections[i]
            if (section.display) {
                if (i == index) {
                    return countSection
                }
                countSection++
            }
        }
        
        return nil
    }
    
    // get a section by tag
    func sectionWithTag(tag: String) -> ACTableViewSection? {
        for section in sections {
            if (section.tag == tag) {
                return section
            }
        }
        return nil
    }

    // get a section from items, including sections that display is false
    func getSection(atIndex index: Int) -> ACTableViewSection! {
        return self.sections[index]
    }
    
    // get a section in TableView
    func getSection(atIndexOfSectionInTableView index: Int) -> ACTableViewSection! {
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
                if (i == sectionNum) {
                    var countRow = 0
                    
                    for (var j = 0; j < section.items.count; j++) {
                        let item = section.items[j]
                        if (item.display) {
                            if (j == row) {
                                return NSIndexPath(forRow: countRow, inSection: countSection)
                            }
                            countRow++
                        }
                    }
                }
                countSection++
            }
        }
        
        return nil
    }
    
    // get an item by tag
    func itemWithTag(tag: String) -> ACTableViewItem? {
        for section in sections {
            for item in section.items {
                if (item.tag == tag) {
                    return item
                }
            }
        }
        return nil
    }
    
    // get an item from items, including items that display is false
    func getItem(forRow row: Int, inSection section: Int) -> ACTableViewItem {
        return sections[section].items[row]
    }
    
    // get an item from cells in tableView
    func getItem(atIndexPathInTableView indexPath: NSIndexPath) -> ACTableViewItem! {
        var countSection = 0
        
        for (var i = 0; i < sections.count; i++) {
            let section = sections[i]
            if (section.display) {
                if (countSection == indexPath.section) {
                    var countRow = 0
                    
                    for (var j = 0; j < section.items.count; j++) {
                        let item = section.items[j]
                        if (item.display) {
                            if (countRow == indexPath.row) {
                                return sections[i].items[j]
                            }
                            countRow++
                        }
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
    
    func showAllRows() {
        for section in sections {
            for item in section.items {
                if (!item.display) {
                    item.show()
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
        let item = getItem(atIndexPathInTableView: indexPath)
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
        return getSection(atIndexOfSectionInTableView: section).header
    }
    
    func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return getSection(atIndexOfSectionInTableView: section).footer
    }
}
