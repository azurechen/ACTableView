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
        return self.tableView?.sections.index(where: { $0 === self })
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
            item.registerItem(for: self.tableView, in: self)
        }
    }
    
    public func updateItems(_ items: [ACTableViewItem]) {
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
    
    public func show(animated: Bool = true) {
        if (!self.display) {
            self.display = true
            
            if let index = self.tableView.indexOfSectionFromACIndex(sectionIndex!), sectionIndex != nil {
                self.tableView.insertSections(IndexSet(integer: index), with: animated ? .fade : .none)
            }
        }
    }
    
    public func hide(animated: Bool = true) {
        if (self.display) {
            if let index = self.tableView.indexOfSectionFromACIndex(sectionIndex!), sectionIndex != nil {
                self.display = false
                self.tableView.deleteSections(IndexSet(integer: index), with: animated ? .fade : .none)
            }
        }
    }
    
    public func reload(animated: Bool = true) {
        if let index = self.tableView.indexOfSectionFromACIndex(sectionIndex!), sectionIndex != nil {
            if (animated) {
                self.tableView.reloadSections(IndexSet(integer: index), with: .fade)
            } else {
                self.tableView.reloadSections(IndexSet(integer: index), with: .none)
            }
        }
    }
    
    public func insertItem(_ item: ACTableViewItem, atIndex rowIndex: Int, animated: Bool = true) {
        item.registerItem(for: self.tableView, in: self)
        items.insert(item, at: rowIndex)
        
        if let indexPath = self.tableView.indexPathFromACIndex(forRow: rowIndex, inSection: sectionIndex!), sectionIndex != nil {
            self.tableView.insertRows(at: [indexPath], with: animated ? .fade : .none)
        }
    }
    
    public func removeItem(_ item: ACTableViewItem, animated: Bool = true) {
        if let rowIndex = item.rowIndex {
            removeItem(at: rowIndex, animated: animated)
        }
    }
    
    public func removeItem(at rowIndex: Int, animated: Bool = true) {
        var indexPath: IndexPath?
        if (sectionIndex != nil) {
            indexPath = self.tableView.indexPathFromACIndex(forRow: rowIndex, inSection: sectionIndex!)
        }
        items.remove(at: rowIndex)
        if (indexPath != nil) {
            self.tableView.deleteRows(at: [indexPath!], with: animated ? .fade : .none)
        }
    }
    
}
