//
//  ACTableViewSection.swift
//  ACTableView
//
//  Created by AzureChen on 2016/1/11.
//  Copyright © 2016 AzureChen. All rights reserved.
//

import UIKit

public class ACTableViewSection {
    
    internal weak var tableView: ACTableView!
    internal var sectionIndex: Int? {
        return self.tableView?.sections.indexOf({ $0 === self })
    }
    
    public let tag: String?
    public var display: Bool
    
    internal let header: String?
    internal let footer: String?
    internal var items: [ACTableViewItem]
    
    public convenience init(tag: String? = nil, header: String?, footer: String?, display: Bool) {
        self.init(tag: tag, header: header, footer: footer, display: display, items: [])
    }
    
    public init(tag: String? = nil, header: String?, footer: String?, display: Bool, items: [ACTableViewItem]) {
        self.tag = tag
        self.header = header
        self.footer = footer
        self.display = display
        self.items = items
    }
    
    internal func registerItems() {
        // set row and section of items
        for item in self.items {
            item.registerItemWithTableView(self.tableView, inSection: self)
        }
    }
    
    public func updateItems(items: [ACTableViewItem]) {
        // clear items
        self.items.removeAll()
        // reset Items
        self.items = items
        registerItems()
    }
    
    // methods
    public func prev() -> ACTableViewSection? {
        if (sectionIndex != nil) {
            return self.tableView.sections[sectionIndex! - 1]
        }
        return nil
    }
    
    public func next() -> ACTableViewSection? {
        if (sectionIndex != nil) {
            return self.tableView.sections[sectionIndex! + 1]
        }
        return nil
    }
    
    public func show(animated animated: Bool = true) {
        if (!self.display) {
            self.display = true
            
            if let index = self.tableView.indexOfSectionFromACIndex(sectionIndex!) where sectionIndex != nil {
                self.tableView.insertSections(NSIndexSet(index: index), withRowAnimation: animated ? .Fade : .None)
            }
        }
    }
    
    public func hide(animated animated: Bool = true) {
        if (self.display) {
            if let index = self.tableView.indexOfSectionFromACIndex(sectionIndex!) where sectionIndex != nil {
                self.display = false
                self.tableView.deleteSections(NSIndexSet(index: index), withRowAnimation: animated ? .Fade : .None)
            }
        }
    }
    
    public func reload(animated animated: Bool = true) {
        if let index = self.tableView.indexOfSectionFromACIndex(sectionIndex!) where sectionIndex != nil {
            if (animated) {
                self.tableView.reloadSections(NSIndexSet(index: index), withRowAnimation: UITableViewRowAnimation.Fade)
            } else {
                self.tableView.reloadSections(NSIndexSet(index: index), withRowAnimation: UITableViewRowAnimation.None)
            }
        }
    }
    
    public func insertItem(item: ACTableViewItem, atIndex rowIndex: Int, animated: Bool = true) {
        item.registerItemWithTableView(self.tableView, inSection: self)
        items.insert(item, atIndex: rowIndex)
        
        if let indexPath = self.tableView.indexPathFromACIndex(forRow: rowIndex, inSection: sectionIndex!) where sectionIndex != nil {
            self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: animated ? .Fade : .None)
        }
    }
    
    public func removeItem(item: ACTableViewItem, animated: Bool = true) {
        if let rowIndex = item.rowIndex {
            removeItemAtIndex(rowIndex, animated: animated)
        }
    }
    
    public func removeItemAtIndex(rowIndex: Int, animated: Bool = true) {
        var indexPath: NSIndexPath?
        if (sectionIndex != nil) {
            indexPath = self.tableView.indexPathFromACIndex(forRow: rowIndex, inSection: sectionIndex!)
        }
        items.removeAtIndex(rowIndex)
        if (indexPath != nil) {
            self.tableView.deleteRowsAtIndexPaths([indexPath!], withRowAnimation: animated ? .Fade : .None)
        }
    }
    
}
