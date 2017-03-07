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
    
    override func initWithInput(_ input: ACInput, withParams params: ACFormParams) {
        super.initWithInput(input, withParams: params)
        
        // bind events
        contentTextField.delegate = self
        contentTextField.addTarget(self, action: #selector(self.textFieldEditingChanged), for: .editingChanged)
        contentTextField.addTarget(self, action: #selector(self.textFieldEditingChanged), for: .editingDidEnd)
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        textFieldEditingChanged(textField)
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textFieldEditingChanged(textField)
        return true
    }
    
    // Actions of Text, Password, Number and Float
    func textFieldEditingChanged(_ sender: UITextField) {
        if (params?.style == .Value1) {
            sender.text = sender.text?.replacingOccurrences(of: " ", with: "\u{00a0}")
        }
        
        // set value
        if let input = self.input {
            input.value = sender.text as AnyObject?
        }
    }
    
}

public enum ACInputTextType {
    case Text
}

public class ACInputText: ACInput {
    
    internal let type: ACInputTextType
    internal let handler: ((UITextField) -> ())?
    
    public init(type: ACInputTextType, name: String, image: UIImage?, title: String?, placeholder: String?, value: String?, handler: ((UITextField) -> ())? = nil) {
        self.type = type
        self.handler = handler
        
        super.init(name: name, image: image, title: title, placeholder: placeholder, value: value as AnyObject?)
    }
    
    override func getItems(params: ACFormParams) -> [ACTableViewItem] {
        switch type {
        case .Text:
            // use identifier to avoid unnecessary register
            return [
                ACTableViewItem(tag: name + "_ITEM", identifier: "ACText\(String(describing: params.style))", display: true) { (item, cell) in
                    
                    let _cell = cell as! ACTextTableViewCell
                    _cell.initWithInput(self, withParams: params)
                    
                    _cell.contentTextField.placeholder = self.placeholder
                    _cell.contentTextField.text = self.value as! String?
                    _cell.contentTextField.textColor = params.firstColor
                    
                    // call handler
                    self.handler?(_cell.contentTextField)
                },
            ]
        }
    }
    
}
