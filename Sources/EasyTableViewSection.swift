//
//  EasyTableViewSection.swift
//  ACTableView
//
//  Created by AzureChen on 2016/1/11.
//  Copyright © 2016 AzureChen. All rights reserved.
//

import UIKit

class EasyTableViewSection {
    
    var header: String?
    var footer: String?
    var items: [EasyTableViewItem] = []
    
    init(header: String?, footer: String?, items: [EasyTableViewItem]) {
        self.header = header
        self.footer = footer
        self.items = items
    }
    
    init(header: String?, footer: String?) {
        self.header = header
        self.footer = footer
    }
}
