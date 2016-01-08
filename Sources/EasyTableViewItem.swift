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
    
    var type: Type = .Default
    var style: UITableViewCellStyle = .Default
    var handle: ((UITableViewCell) -> ())?
    let initDisplay: Bool
    var display: Bool
    var reuseIdentifier: String
    var boundItems: [(index: Int, section: Int)] = []
    
    convenience init(nibName: String, handle: (cell: UITableViewCell) -> (), display: Bool) {
        self.init(nibName: nibName, handle: handle, display: display, bind: [])
    }
    
    init(nibName: String, handle: (cell: UITableViewCell) -> (), display: Bool, bind boundItems: [(index: Int, section: Int)]) {
        self.type = .Custom
        self.handle = handle
        self.initDisplay = display
        self.display = display
        self.reuseIdentifier = nibName
        self.boundItems = boundItems
    }
    
    convenience init(style: UITableViewCellStyle, handle: (cell: UITableViewCell) -> (), display: Bool) {
        self.init(style: style, handle: handle, display: display, bind: [])
    }
    
    init(style: UITableViewCellStyle, handle: (cell: UITableViewCell) -> (), display: Bool, bind boundItems: [(index: Int, section: Int)]) {
        self.style = style
        self.handle = handle
        self.initDisplay = display
        self.display = display
        self.reuseIdentifier = "UITableViewCell.WithStyle\(style.rawValue)"
        self.boundItems = boundItems
    }
}
