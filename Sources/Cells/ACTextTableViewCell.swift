//
//  ACTextTableViewCell.swift
//  ACTableView
//
//  Created by Azure Chen on 3/12/16.
//  Copyright © 2016 AzureChen. All rights reserved.
//

import UIKit

class ACTextTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var placeholderLabel: UILabel!
    @IBOutlet weak var contentTextField: UITextField!
    
    var normalColor: UIColor!
    var placeholderColor: UIColor!
    var title: String!
    var placeholder: String?
    var value: String?

    override func awakeFromNib() {
        super.awakeFromNib()
        
        contentTextField.addTarget(self, action: Selector("textFieldDidEditingChanged:"), forControlEvents: .EditingChanged)
    }
    
    func initCell() {
        titleLabel.text = title
        titleLabel.textColor = normalColor
        placeholderLabel.text = placeholder
        placeholderLabel.textColor = placeholderColor
        contentTextField.text = value
        contentTextField.textColor = normalColor
        
        updateCell()
    }
    
    func updateCell() {
        if (value == nil || value == "") {
            placeholderLabel.hidden = false
        } else {
            placeholderLabel.hidden = true
        }
    }

    func textFieldDidEditingChanged(sender: UITextField) {
        value = sender.text
        updateCell()
    }
    
}
