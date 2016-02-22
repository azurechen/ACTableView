//
//  ACTableViewSection.swift
//  ACTableView
//
//  Created by AzureChen on 2016/1/11.
//  Copyright © 2016 AzureChen. All rights reserved.
//

import UIKit

public class ACTableViewSection {
    
    weak var tableView: ACTableView!
    var section: Int!
    
    public let tag: String?
    var header: String?
    var footer: String?
    var items: [ACTableViewItem]
    public var display: Bool
    
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
    
    public func show(animated animated: Bool = true) {
        if (!self.display) {
            self.display = true
            let index = self.tableView.indexOfSectionFromACIndex(section)
            if (index != nil) {
                self.tableView.insertSections(NSIndexSet(index: index!), withRowAnimation: animated ? .Fade : .None)
            }
        }
    }
    
    public func hide(animated animated: Bool = true) {
        if (self.display) {
            let index = self.tableView.indexOfSectionFromACIndex(section)
            self.display = false
            if (index != nil) {
                self.tableView.deleteSections(NSIndexSet(index: index!), withRowAnimation: animated ? .Fade : .None)
            }
        }
    }
}
