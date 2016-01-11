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
        case Custom
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
    
    convenience init(nibName: String, handle: (cell: UITableViewCell) -> (), display: Bool) {
        self.init(nibName: nibName, handle: handle, display: display, bind: nil)
    }
    
    init(nibName: String, handle: (cell: UITableViewCell) -> (), display: Bool, bind: ((item: EasyTableViewItem) -> [EasyTableViewItem])?) {
        self.type = .Custom
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
}