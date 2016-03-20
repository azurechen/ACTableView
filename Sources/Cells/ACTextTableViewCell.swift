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
        self.selectionStyle = .None
    }
    
    func initWithInput(input: ACInputText, withParams params: ACFormParams) {
        super.initWithInput(input, withParams: params)
        
        self.input = input
        self.params = params
        
        contentTextField.placeholder = input.placeholder
        contentTextField.text = input.value as! String?
        contentTextField.textColor = params.firstColor
        
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
        
        // callback
        if let input = self.input {
            input.value = sender.text
            self.params?.delegate?.formInput(input, withName: input.name, didChangeValue: input.value)
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
                    self.targetCell = cell
                    
                    let _cell = cell as! ACTextTableViewCell
                    _cell.initWithInput(self, withParams: params)
                },
            ]
        }
    }
    
}
