//
//  ACTableViewItem.swift
//  ACTableView
//
//  Created by AzureChen on 2016/1/7.
//  Copyright © 2016 AzureChen. All rights reserved.
//

import UIKit

class ACTableViewItem {
    
    enum Type {
        case StoryBoard
        case Nib
        case Default
    }
    
    weak var tableView: ACTableView!
    var row: Int!
    var section: Int!
    
    let tag: String?
    var type: Type = .Default
    var style: UITableViewCellStyle = .Default
    var handle: ((item: ACTableViewItem, cell: UITableViewCell) -> ())?
    let initDisplay: Bool
    var display: Bool
    var reuseIdentifier: String
    private var bind: ((ACTableViewItem) -> [ACTableViewItem])?
    
    // storyboard
    convenience init(tag: String? = nil, identifier: String, display: Bool, handle: (item: ACTableViewItem, cell: UITableViewCell) -> ()) {
        self.init(tag: tag, identifier: identifier, display: display, bind: nil, handle: handle)
    }
    
    init(tag: String? = nil, identifier: String, display: Bool, bind: ((item: ACTableViewItem) -> [ACTableViewItem])?, handle: (item: ACTableViewItem, cell: UITableViewCell) -> ()) {
        self.tag = tag
        self.type = .StoryBoard
        self.handle = handle
        self.initDisplay = display
        self.display = display
        self.reuseIdentifier = identifier
        self.bind = bind
    }
    
    // nib
    convenience init(tag: String? = nil, nibName: String, display: Bool, handle: (item: ACTableViewItem, cell: UITableViewCell) -> ()) {
        self.init(tag: tag, nibName: nibName, display: display, bind: nil, handle: handle)
    }
    
    init(tag: String? = nil, nibName: String, display: Bool, bind: ((item: ACTableViewItem) -> [ACTableViewItem])?, handle: (item: ACTableViewItem, cell: UITableViewCell) -> ()) {
        self.tag = tag
        self.type = .Nib
        self.handle = handle
        self.initDisplay = display
        self.display = display
        self.reuseIdentifier = nibName
        self.bind = bind
    }
    
    // built-in cells
    convenience init(tag: String? = nil, style: UITableViewCellStyle, display: Bool, handle: (item: ACTableViewItem, cell: UITableViewCell) -> ()) {
        self.init(tag: tag, style: style, display: display, bind: nil, handle: handle)
    }
    
    init(tag: String? = nil, style: UITableViewCellStyle, display: Bool, bind: ((item: ACTableViewItem) -> [ACTableViewItem])?, handle: (item: ACTableViewItem, cell: UITableViewCell) -> ()) {
        self.tag = tag
        self.style = style
        self.handle = handle
        self.initDisplay = display
        self.display = display
        self.reuseIdentifier = "UITableViewCell.WithStyle\(style.rawValue)"
        self.bind = bind
    }
    
    // methods
    func prev() -> ACTableViewItem {
        return self.tableView.sections[section].items[row - 1]
    }
    
    func next() -> ACTableViewItem {
        return self.tableView.sections[section].items[row + 1]
    }
    
    func prevRow() -> (row: Int, section: Int) {
        return (row: self.row - 1, section: self.section)
    }
    
    func nextRow() -> (row: Int, section: Int) {
        return (row: self.row + 1, section: self.section)
    }
    
    func show(animated animated: Bool = true) {
        if (!self.display) {
            self.display = true
            let indexPath = self.tableView.indexPathFromItemPath(forRow: row, inSection: section)!
            self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: animated ? .Fade : .None)
        }
        updateBoundRows(self)
    }
    
    func hide(animated animated: Bool = true, updateBoundRows update:Bool = true) {
        if (self.display) {
            let indexPath = self.tableView.indexPathFromItemPath(forRow: row, inSection: section)!
            self.display = false
            self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: animated ? .Fade : .None)
        }
        if(update){
            updateBoundRows(self)
        }
    }
    
    
    func toggle(){
        if(self.display){
            self.hide()
        } else {
            self.show()
        }
    }
    
    func reload(animated animated: Bool = true) {
        let indexPath = self.tableView.indexPathFromItemPath(forRow: row, inSection: section)
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
    
    private func updateBoundRows(item: ACTableViewItem) {
        if (item.bind != nil) {
            for item in item.bind!(item) {
                if let indexPath = self.tableView.indexPathFromItemPath(forRow: item.row, inSection: item.section), let cell = self.tableView.cellForRowAtIndexPath(indexPath) {
                    item.handle?(item: item, cell: cell)
                }
            }
        }
    }
}
