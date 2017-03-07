//
//  ACTableViewItem.swift
//  ACTableView
//
//  Created by AzureChen on 2016/1/7.
//  Copyright © 2016 AzureChen. All rights reserved.
//

import UIKit

public enum ACTableViewItemType {
    case storyboard
    case nib
    case native
}

public class ACTableViewItem {
    
    internal weak var tableView: ACTableView!
    internal weak var section: ACTableViewSection!
    internal var rowIndex: Int? {
        return self.section.items.index(where: { $0 === self })
    }
    internal var sectionIndex: Int? {
        return self.tableView?.sections.index(where: { $0 === self.section })
    }
    
    public let tag: String?
    public var display: Bool
    
    internal let type: ACTableViewItemType
    internal let style: UITableViewCellStyle
    internal let handler: ((ACTableViewItem, UITableViewCell) -> ())?
    internal let initDisplay: Bool
    internal let reuseIdentifier: String
    private let bind: ((ACTableViewItem) -> [ACTableViewItem])?
    
    internal func registerItem(for tableView: ACTableView, in section: ACTableViewSection) {
        self.tableView = tableView
        self.section = section
        
        // register nibs
        if (type == .nib) {
            self.tableView.register(UINib(nibName: reuseIdentifier, bundle: nil), forCellReuseIdentifier: reuseIdentifier)
        }
    }
    
    // storyboard
    public convenience init(tag: String? = nil, identifier: String, display: Bool, handler: @escaping (ACTableViewItem, UITableViewCell) -> ()) {
        self.init(tag: tag, identifier: identifier, display: display, bind: nil, handler: handler)
    }
    
    public init(tag: String? = nil, identifier: String, display: Bool, bind: ((ACTableViewItem) -> [ACTableViewItem])?, handler: @escaping (ACTableViewItem, UITableViewCell) -> ()) {
        self.tag = tag
        self.type = .storyboard
        self.style = .default
        self.handler = handler
        self.initDisplay = display
        self.display = display
        self.reuseIdentifier = identifier
        self.bind = bind
    }
    
    // nib
    public convenience init(tag: String? = nil, nibName: String, display: Bool, handler: @escaping (ACTableViewItem, UITableViewCell) -> ()) {
        self.init(tag: tag, nibName: nibName, display: display, bind: nil, handler: handler)
    }
    
    public init(tag: String? = nil, nibName: String, display: Bool, bind: ((ACTableViewItem) -> [ACTableViewItem])?, handler: @escaping (ACTableViewItem, UITableViewCell) -> ()) {
        self.tag = tag
        self.type = .nib
        self.style = .default
        self.handler = handler
        self.initDisplay = display
        self.display = display
        self.reuseIdentifier = nibName
        self.bind = bind
    }
    
    // built-in cells
    public convenience init(tag: String? = nil, style: UITableViewCellStyle, display: Bool, handler: @escaping (ACTableViewItem, UITableViewCell) -> ()) {
        self.init(tag: tag, style: style, display: display, bind: nil, handler: handler)
    }
    
    public init(tag: String? = nil, style: UITableViewCellStyle, display: Bool, bind: ((ACTableViewItem) -> [ACTableViewItem])?, handler: @escaping (ACTableViewItem, UITableViewCell) -> ()) {
        self.tag = tag
        self.type = .native
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
    
    public func show(animated: Bool = true) {
        if (!self.display) {
            self.display = true
            if let indexPath = self.tableView.indexPathFromACIndex(forRow: rowIndex!, inSection: sectionIndex!), rowIndex != nil && sectionIndex != nil {
                self.tableView.insertRows(at: [indexPath], with: animated ? .fade : .none)
            }
        }
        updateBoundRows()
    }
    
    public func hide(animated: Bool = true) {
        if (self.display) {
            if let indexPath = self.tableView.indexPathFromACIndex(forRow: rowIndex!, inSection: sectionIndex!), rowIndex != nil && sectionIndex != nil {
                self.display = false
                self.tableView.deleteRows(at: [indexPath], with: animated ? .fade : .none)
            }
        }
        updateBoundRows()
    }
    
    public func toggle(animated: Bool = true){
        if(self.display){
            self.hide(animated: animated)
        } else {
            self.show(animated: animated)
        }
    }
    
    public func reload(animated: Bool = true) {
        if let indexPath = self.tableView.indexPathFromACIndex(forRow: rowIndex!, inSection: sectionIndex!), rowIndex != nil && sectionIndex != nil {
            if (animated) {
                self.tableView.reloadRows(at: [indexPath], with: .fade)
            } else {
                self.tableView.reloadRows(at: [indexPath], with: .none)
            }
            updateBoundRows()
        }
    }
    
    public func updateBoundRows() {
        if (self.bind != nil) {
            for item in self.bind!(self) {
                if let indexPath = self.tableView.indexPathFromACIndex(forRow: item.rowIndex!, inSection: item.sectionIndex!), rowIndex != nil && sectionIndex != nil, let cell = self.tableView.cellForRow(at: indexPath) {
                    item.handler?(item, cell)
                }
            }
        }
    }
}
