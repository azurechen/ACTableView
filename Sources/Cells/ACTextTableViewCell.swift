//
//  ACTextTableViewCell.swift
//  ACTableView
//
//  Created by Azure Chen on 3/12/16.
//  Copyright © 2016 AzureChen. All rights reserved.
//

import UIKit

class ACTextTableViewCell: ACAbstractTableViewCell, UITextFieldDelegate {
    
    @IBOutlet weak var contentTextField: UITextField!

    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func initWithInput(input: ACInput, withParams params: ACFormParams) {
        super.initWithInput(input, withParams: params)
        
        // bind events
        contentTextField.delegate = self
        contentTextField.addTarget(self, action: Selector("textFieldEditingChanged:"), forControlEvents: .EditingChanged)
        contentTextField.addTarget(self, action: Selector("textFieldEditingChanged:"), forControlEvents: .EditingDidEnd)
    }
    
    func textFieldShouldClear(textField: UITextField) -> Bool {
        textFieldEditingChanged(textField)
        return true
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textFieldEditingChanged(textField)
        return true
    }
    
    // Actions of Text, Password, Number and Float
    func textFieldEditingChanged(sender: UITextField) {
        if (params?.style == .Value1) {
            sender.text = sender.text?.stringByReplacingOccurrencesOfString(" ", withString: "\u{00a0}")
        }
        
        // set value
        if let input = self.input {
            input.value = sender.text
        }
    }
    
}

public enum ACInputTextType {
    case Text
}

public class ACInputText: ACInput {
    
    internal let type: ACInputTextType
    internal let placeholder: String?
    
    public init(type: ACInputTextType, name: String, image: UIImage?, title: String?, placeholder: String?, value: String?) {
        self.type = type
        self.placeholder = placeholder
        
        super.init(name: name, image: image, title: title, value: value)
    }
    
    override func getItems(params: ACFormParams) -> [ACTableViewItem] {
        switch type {
        case .Text:
            // use identifier to avoid unnecessary register
            return [
                ACTableViewItem(tag: name + "_ITEM", identifier: "ACText\(String(params.style))", display: true) { (item, cell) in
                    
                    let _cell = cell as! ACTextTableViewCell
                    _cell.initWithInput(self, withParams: params)
                    
                    _cell.contentTextField.placeholder = self.placeholder
                    _cell.contentTextField.text = self.value as! String?
                    _cell.contentTextField.textColor = params.firstColor
                },
            ]
        }
    }
    
}
