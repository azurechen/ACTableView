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
    var reuseIdentifier: String
    var didSelect: (() -> ())?
    
    init(nibName: String, handle: (cell: UITableViewCell) -> ()) {
        self.type = .Custom
        self.handle = handle
        self.reuseIdentifier = nibName
    }
    
    init(style: UITableViewCellStyle, handle: (cell: UITableViewCell) -> ()) {
        self.handle = handle
        self.reuseIdentifier = "UITableViewCell.WithStyle\(style.rawValue)"
    }
    
}
