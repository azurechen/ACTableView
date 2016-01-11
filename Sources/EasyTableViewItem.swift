//
//  EasyTableViewItem.swift
//  EasyTableView
//
//  Created by AzureChen on 2016/1/7.
//  Copyright © 2016 AzureChen. All rights reserved.
//

import UIKit

class EasyTableViewItem {
    
    enum Type {
        case StoryBoard
        case Nib
        case Default
    }
    
    var tableView: EasyTableView!
    var row: Int!
    var section: Int!
    
    var type: Type = .Default
    var style: UITableViewCellStyle = .Default
    var handle: ((UITableViewCell) -> ())?
    let initDisplay: Bool
    var display: Bool
    var reuseIdentifier: String
    var bind: ((EasyTableViewItem) -> [EasyTableViewItem])?
    
    convenience init(identifier: String, handle: (cell: UITableViewCell) -> (), display: Bool) {
        self.init(identifier: identifier, handle: handle, display: display, bind: nil)
    }
    
    init(identifier: String, handle: (cell: UITableViewCell) -> (), display: Bool, bind: ((item: EasyTableViewItem) -> [EasyTableViewItem])?) {
        self.type = .StoryBoard
        self.handle = handle
        self.initDisplay = display
        self.display = display
        self.reuseIdentifier = identifier
        self.bind = bind
    }
    
    convenience init(nibName: String, handle: (cell: UITableViewCell) -> (), display: Bool) {
        self.init(nibName: nibName, handle: handle, display: display, bind: nil)
    }
    
    init(nibName: String, handle: (cell: UITableViewCell) -> (), display: Bool, bind: ((item: EasyTableViewItem) -> [EasyTableViewItem])?) {
        self.type = .Nib
        self.handle = handle
        self.initDisplay = display
        self.display = display
        self.reuseIdentifier = nibName
        self.bind = bind
    }
    
    convenience init(style: UITableViewCellStyle, handle: (cell: UITableViewCell) -> (), display: Bool) {
        self.init(style: style, handle: handle, display: display, bind: nil)
    }
    
    init(style: UITableViewCellStyle, handle: (cell: UITableViewCell) -> (), display: Bool, bind: ((item: EasyTableViewItem) -> [EasyTableViewItem])?) {
        self.style = style
        self.handle = handle
        self.initDisplay = display
        self.display = display
        self.reuseIdentifier = "UITableViewCell.WithStyle\(style.rawValue)"
        self.bind = bind
    }
    
    // methods
    func prev() -> EasyTableViewItem {
        return self.tableView.getItem(forRow: self.row - 1, inSection: self.section)
    }
    
    func next() -> EasyTableViewItem {
        return self.tableView.getItem(forRow: self.row + 1, inSection: self.section)
    }
    
    func prevRow() -> (row: Int, section: Int) {
        return (row: self.row - 1, section: self.section)
    }
    
    func nextRow() -> (row: Int, section: Int) {
        return (row: self.row + 1, section: self.section)
    }
    
    func show() {
        if (!self.display) {
            self.display = true
            let indexPath = self.tableView.getIndexPath(forRow: row, inSection: section)!
            self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
        }
        updateBoundRows(self)
    }
    
    func hide() {
        if (self.display) {
            let indexPath = self.tableView.getIndexPath(forRow: row, inSection: section)!
            self.display = false
            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
        }
        updateBoundRows(self)
    }
    
    func reload(animated animated: Bool) {
        let indexPath = self.tableView.getIndexPath(forRow: row, inSection: section)
        if (indexPath != nil) {
            if (animated) {
                self.tableView.reloadRowsAtIndexPaths([indexPath!], withRowAnimation: UITableViewRowAnimation.Fade)
            } else {
                self.tableView.reloadRowsAtIndexPaths([indexPath!], withRowAnimation: UITableViewRowAnimation.None)
            }
            updateBoundRows(self)
        }
    }
    
    func updateData() {
        updateBoundRows(self)
    }
    
    private func updateBoundRows(item: EasyTableViewItem) {
        if (item.bind != nil) {
            for item in item.bind!(item) {
                let indexPath = self.tableView.getIndexPath(forRow: item.row, inSection: item.section)
                if (indexPath != nil) {
                    self.tableView.reloadRowsAtIndexPaths([indexPath!], withRowAnimation: UITableViewRowAnimation.None)
                }
            }
        }
    }
}
