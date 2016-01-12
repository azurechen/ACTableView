//
//  EasyTableViewSection.swift
//  ACTableView
//
//  Created by AzureChen on 2016/1/11.
//  Copyright © 2016 AzureChen. All rights reserved.
//

import UIKit

class EasyTableViewSection {
    
    var tableView: EasyTableView!
    var section: Int!
    
    var header: String?
    var footer: String?
    var items: [EasyTableViewItem]
    var display: Bool
    
    convenience init(header: String?, footer: String?, display: Bool) {
        self.init(header: header, footer: footer, display: display, items: [])
    }
    
    init(header: String?, footer: String?, display: Bool, items: [EasyTableViewItem]) {
        self.header = header
        self.footer = footer
        self.display = display
        self.items = items
    }
    
    func show() {
        if (!self.display) {
            self.display = true
            //let indexPath = self.tableView.getIndexPath(forRow: row, inSection: section)!
            //self.tableView.deleteSections(NSIndexSet(index: 1), withRowAnimation: UITableViewRowAnimation.Fade)
        }
    }
    
    func hide() {
        if (self.display) {
            //let indexPath = self.tableView.getIndexPath(forRow: row, inSection: section)!
            self.display = false
            //self.tableView.deleteSections(NSIndexSet(index: 1), withRowAnimation: UITableViewRowAnimation.Fade)
        }
    }
}
