//
//  EasyTableViewCell.swift
//  EasyTableView
//
//  Created by AzureChen on 2016/1/7.
//  Copyright © 2016 AzureChen. All rights reserved.
//

import UIKit

class EasyTableViewCell: UITableViewCell {
    
    enum Type {
        case Custom
        case Default
    }
    
    var type: Type = .Default
    var handle: ((EasyTableViewCell) -> ())?
    var didSelect: (() -> ())?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init(handle: (cell: EasyTableViewCell) -> ()) {
        super.init(style: .Default, reuseIdentifier: NSStringFromClass(self.dynamicType))
        
        print(NSStringFromClass(self.dynamicType))
        self.type = .Custom
        self.handle = handle
    }
    
    init(style: UITableViewCellStyle, handle: (cell: EasyTableViewCell) -> ()) {
        super.init(style: style, reuseIdentifier: "\(NSStringFromClass(self.dynamicType))WithStyle\(style.rawValue)")
        
        self.handle = handle
    }
    
}
