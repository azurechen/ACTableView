//
//  ACTableViewItem.swift
//  ACTableView
//
//  Created by AzureChen on 2016/1/7.
//  Copyright © 2016 AzureChen. All rights reserved.
//

import UIKit

public class ACTableViewItem {
    
    public enum Type {
        case Storyboard
        case Nib
        case Default
    }
    
    internal weak var tableView: ACTableView!
    internal weak var section: ACTableViewSection!
    internal var rowIndex: Int? {
        return self.section.items.indexOf({ $0 === self })
    }
    internal var sectionIndex: Int? {
        return self.tableView?.sections.indexOf({ $0 === self.section })
    }
    
    public let tag: String?
    public var display: Bool
    
    internal let type: Type
    internal let style: UITableViewCellStyle
    internal let handler: ((item: ACTableViewItem, cell: UITableViewCell) -> ())?
    internal let initDisplay: Bool
    internal let reuseIdentifier: String
    private let bind: ((ACTableViewItem) -> [ACTableViewItem])?
    
    // storyboard
    public convenience init(tag: String? = nil, identifier: String, display: Bool, handler: (item: ACTableViewItem, cell: UITableViewCell) -> ()) {
        self.init(tag: tag, identifier: identifier, display: display, bind: nil, handler: handler)
    }
    
    public init(tag: String? = nil, identifier: String, display: Bool, bind: ((item: ACTableViewItem) -> [ACTableViewItem])?, handler: (item: ACTableViewItem, cell: UITableViewCell) -> ()) {
        self.tag = tag
        self.type = .Storyboard
        self.style = .Default
        self.handler = handler
        self.initDisplay = display
        self.display = display
        self.reuseIdentifier = identifier
        self.bind = bind
    }
    
    // nib
    public convenience init(tag: String? = nil, nibName: String, display: Bool, handler: (item: ACTableViewItem, cell: UITableViewCell) -> ()) {
        self.init(tag: tag, nibName: nibName, display: display, bind: nil, handler: handler)
    }
    
    public init(tag: String? = nil, nibName: String, display: Bool, bind: ((item: ACTableViewItem) -> [ACTableViewItem])?, handler: (item: ACTableViewItem, cell: UITableViewCell) -> ()) {
        self.tag = tag
        self.type = .Nib
        self.style = .Default
        self.handler = handler
        self.initDisplay = display
        self.display = display
        self.reuseIdentifier = nibName
        self.bind = bind
    }
    
    // built-in cells
    public convenience init(tag: String? = nil, style: UITableViewCellStyle, display: Bool, handler: (item: ACTableViewItem, cell: UITableViewCell) -> ()) {
        self.init(tag: tag, style: style, display: display, bind: nil, handler: handler)
    }
    
    public init(tag: String? = nil, style: UITableViewCellStyle, display: Bool, bind: ((item: ACTableViewItem) -> [ACTableViewItem])?, handler: (item: ACTableViewItem, cell: UITableViewCell) -> ()) {
        self.tag = tag
        self.type = .Default
        self.style = style
        self.handler = handler
        self.initDisplay = display
        self.display = display
        self.reuseIdentifier = "UITableViewCell.WithStyle\(style.rawValue)"
        self.bind = bind
    }
    
    // methods
    public func prev() -> ACTableViewItem? {
        if (rowIndex != nil) {
            return section.items[rowIndex! - 1]
        }
        return nil
    }
    
    public func next() -> ACTableViewItem? {
        if (rowIndex != nil) {
            return section.items[rowIndex! + 1]
        }
        return nil
    }
    
    public func show(animated animated: Bool = true) {
        if (!self.display) {
            self.display = true
            if let indexPath = self.tableView.indexPathFromACIndex(forRow: rowIndex!, inSection: sectionIndex!) where rowIndex != nil && sectionIndex != nil {
                self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: animated ? .Fade : .None)
            }
        }
        updateBoundRows()
    }
    
    public func hide(animated animated: Bool = true) {
        if (self.display) {
            if let indexPath = self.tableView.indexPathFromACIndex(forRow: rowIndex!, inSection: sectionIndex!) where rowIndex != nil && sectionIndex != nil {
                self.display = false
                self.tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: animated ? .Fade : .None)
            }
        }
        updateBoundRows()
    }
    
    public func toggle(animated animated: Bool = true){
        if(self.display){
            self.hide(animated: animated)
        } else {
            self.show(animated: animated)
        }
    }
    
    public func reload(animated animated: Bool = true) {
        if let indexPath = self.tableView.indexPathFromACIndex(forRow: rowIndex!, inSection: sectionIndex!) where rowIndex != nil && sectionIndex != nil {
            if (animated) {
                self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
            } else {
                self.tableView.reloadRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.None)
            }
            updateBoundRows()
        }
    }
    
    public func updateBoundRows() {
        if (self.bind != nil) {
            for item in self.bind!(self) {
                if let indexPath = self.tableView.indexPathFromACIndex(forRow: item.rowIndex!, inSection: item.sectionIndex!) where rowIndex != nil && sectionIndex != nil, let cell = self.tableView.cellForRowAtIndexPath(indexPath) {
                    item.handler?(item: item, cell: cell)
                }
            }
        }
    }
}
