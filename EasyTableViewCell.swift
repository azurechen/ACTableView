//
//  EasyTableViewCell.swift
//  EasyTableView
//
//  Created by AzureChen on 2016/1/7.
//  Copyright © 2016 AzureChen. All rights reserved.
//

import UIKit

class EasyTableViewCell: UITableViewCell {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init() {
        super.init(style: .Default, reuseIdentifier: NSStringFromClass(self.dynamicType))
    }
    
    init(style: UITableViewCellStyle) {
        super.init(style: style, reuseIdentifier: "\(NSStringFromClass(self.dynamicType))WithStyle\(style.rawValue)")
    }
    
}
