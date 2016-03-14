//
//  ACTextTableViewCell.swift
//  ACTableView
//
//  Created by Azure Chen on 3/12/16.
//  Copyright © 2016 AzureChen. All rights reserved.
//

import UIKit

class ACTextTableViewCell: ACValue1TableViewCell {
    
    @IBOutlet weak var placeholderLabel: UILabel!
    @IBOutlet weak var contentTextField: UITextField!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.selectionStyle = .None
    }
    
}
