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
    
    internal func setItems() {
        // set row and section of items
        for item in self.items {
            item.tableView = self.tableView
            item.section = self
            
            // register nibs
            if (item.type == .Nib) {
                self.tableView.registerNib(UINib(nibName: item.reuseIdentifier, bundle: nil), forCellReuseIdentifier: item.reuseIdentifier)
            }
        }
    }
    
    public func updateItems(items: [ACTableViewItem]) {
        // clear items
        self.items.removeAll()
        // reset Items
        self.items = items
        setItems()
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
}
