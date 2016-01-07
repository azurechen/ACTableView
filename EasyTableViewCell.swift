//
//  EasyTableViewCell.swift
//  EasyTableView
//
//  Created by Azure_Chen on 2016/1/7.
//  Copyright © 2016 AzureChen. All rights reserved.
//

import UIKit

class EasyTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    init() {
        super.init(style: .Default, reuseIdentifier: "test")
    }
    
    init(style: UITableViewCellStyle) {
        super.init(style: style, reuseIdentifier: "test")
    }

}
