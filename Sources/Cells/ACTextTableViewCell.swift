//
//  ACTextTableViewCell.swift
//  ACTableView
//
//  Created by Azure Chen on 3/12/16.
//  Copyright © 2016 AzureChen. All rights reserved.
//

import UIKit

class ACTextTableViewCell: ACAbstractTableViewCell {
    
    @IBOutlet weak var contentTextField: UITextField!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectionStyle = .None
    }
    
    override func initByInput(input: ACFormInput, withParams params: ACFormParams) {
        self.input = input
        self.params = params
        
        setIconImage(input.image)
        titleLabel.text = input.title
        titleLabel.textColor = params.normalColor
        contentTextField.placeholder = input.placeholder
        contentTextField.text = input.value as! String?
        contentTextField.textColor = params.normalColor
        
        updateByInput()
    }
    
    override func updateByInput() {
    }
    
}
