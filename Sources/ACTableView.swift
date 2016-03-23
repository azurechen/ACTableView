//
//  ACTableView.swift
//  ACTableView
//
//  Created by AzureChen on 2016/1/7.
//  Copyright © 2016 AzureChen. All rights reserved.
//

import UIKit

public class ACTableView: UITableView, UITableViewDataSource {
    
    internal var sections: [ACTableViewSection] = []
    
    // For ACForm
    public internal(set) var form: ACForm?
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.dataSource = self
        
        self.rowHeight = UITableViewAutomaticDimension
        self.estimatedRowHeight = 44
    }
    
    public func clear(){
        sections.removeAll()
    }
    
    public func addSection(section: ACTableViewSection) {
        sections.append(section)
        section.tableView = self
        section.registerItems()
    }
    
    // get a section by tag
    public func sectionWithTag(tag: String) -> ACTableViewSection! {
        for section in sections {
            if (section.tag == tag) {
                return section
            }
        }
        return nil
    }
    
    // get a section by Section Index in TableView
    public func sectionAtIndex(index: Int) -> ACTableViewSection! {
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
    
    // get an item by tag
    public func itemWithTag(tag: String) -> ACTableViewItem! {
        for section in sections {
            for item in section.items {
                if (item.tag == tag) {
                    return item
                }
            }
        }
        return nil
    }
    
    // get an item by IndexPath in tableView
    public func itemAtIndexPath(indexPath: NSIndexPath) -> ACTableViewItem! {
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
    
    // get an item by subview
    public func itemWithSubview(subview: UIView) -> ACTableViewItem! {
        var view: UIView? = subview
        
        while (view != nil) {
            if let v = view as? UITableViewCell {
                if let indexPath = indexPathForCell(v) {
                    return itemAtIndexPath(indexPath)
                } else {
                    return nil
                }
            } else {
                view = view!.superview
            }
        }
        return nil
    }
    
    // hide all rows
    public func hideAllRowsIfNeeded() {
        for section in sections {
            for item in section.items {
                if (!item.initDisplay && item.display) {
                    item.hide()
                }
            }
        }
    }
    
    // show all rows
    public func showAllRows() {
        for section in sections {
            for item in section.items {
                if (!item.display) {
                    item.show()
                }
            }
        }
    }
    
    public func insertSection(section: ACTableViewSection, atIndex sectionIndex: Int, animated: Bool = true) {
        sections.insert(section, atIndex: sectionIndex)
        
        if let index = self.indexOfSectionFromACIndex(sectionIndex) {
            self.insertSections(NSIndexSet(index: index), withRowAnimation: animated ? .Fade : .None)
        }
    }
    
    public func removeSection(section: ACTableViewSection, animated: Bool = true) {
        if let sectionIndex = section.sectionIndex {
            removeSectionAtIndex(sectionIndex, animated: animated)
        }
    }
    
    public func removeSectionAtIndex(sectionIndex: Int, animated: Bool = true) {
        let index = self.indexOfSectionFromACIndex(sectionIndex)
        sections.removeAtIndex(sectionIndex)
        if (index != nil) {
            self.deleteSections(NSIndexSet(index: index!), withRowAnimation: animated ? .Fade : .None)
        }
    }
    
    // section index mapping
    internal func indexOfSectionFromACIndex(index: Int) -> Int? {
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
    
    // item index mapping
    internal func indexPathFromACIndex(forRow row: Int, inSection sectionNum: Int) -> NSIndexPath? {
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
    
    // DataSource
    public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        var count = 0
        for section in sections {
            if (section.display) {
                count++
            }
        }
        return count
    }
    
    public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        for item in self.sectionAtIndex(section).items {
            if (item.display) {
                count++
            }
        }
        return count
    }
    
    public func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let item = itemAtIndexPath(indexPath)
        let identifier = item.reuseIdentifier
        
        // get cell
        var cell = tableView.dequeueReusableCellWithIdentifier(identifier.componentsSeparatedByString(".").first!)
        if (cell == nil) {
            cell = UITableViewCell(style: item.style, reuseIdentifier: identifier)
        }
        item.handler?(item: item, cell: cell!)
        
        cell?.clipsToBounds
        return cell!
    }
    
    public func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionAtIndex(section).header
    }
    
    public func tableView(tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return sectionAtIndex(section).footer
    }
}
