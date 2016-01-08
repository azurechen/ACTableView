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
    
    var didSelect: (() -> ())?
    
    init(nibName: String, handle: (cell: UITableViewCell) -> (), display: Bool) {
        self.type = .Custom
        self.handle = handle
        self.initDisplay = display
        self.display = display
        self.reuseIdentifier = nibName
    }
    
    init(style: UITableViewCellStyle, handle: (cell: UITableViewCell) -> (), display: Bool) {
        self.style = style
        self.handle = handle
        self.initDisplay = display
        self.display = display
        self.reuseIdentifier = "UITableViewCell.WithStyle\(style.rawValue)"
    }
}
