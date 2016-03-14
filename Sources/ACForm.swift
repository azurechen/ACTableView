//
//  ACForm.swift
//  ACTableView
//
//  Created by Azure Chen on 3/6/16.
//  Copyright © 2016 AzureChen. All rights reserved.
//

import UIKit

extension ACTableView {
    
    public func construct() {
        if (self.builder != nil) {
            
            // CocoaPods Support, bundle is nil if not a library of CocoaPods
            var bundle: NSBundle?
            if let bundleURL = NSBundle(forClass: self.classForCoder).URLForResource("ACTableView", withExtension: "bundle") {
                bundle = NSBundle(URL: bundleURL)
            }
            // Register all nibs
            self.registerNib(UINib(nibName: "ACTextValue1TableViewCell", bundle: bundle), forCellReuseIdentifier: "ACTextValue1")
            
            
            self.form = self.builder!.buildForm()
            self.form!.tableView = self
            
            if (builder != nil) {
                for formSection in form!.params.sections {
                    // transfer ACFormItem to ACTableItem
                    var items: [ACTableViewItem] = []
                    for formItem in formSection.items {
                        // set delegate
                        formItem.delegate = form!.params.delegate
                        if let item = formItem.getItem(form!.params.style, normalColor: form!.params.normalColor, tintColor: form!.params.tintColor, placeholderColor: form!.params.placeholderColor) {
                            items.append(item)
                        }
                    }
                    // transfer ACFormSection to ACTableViewSection
                    self.addSection(ACTableViewSection(
                        header: formSection.header,
                        footer: formSection.footer,
                        display: formSection.display,
                        items: items))
                }
            }
        }
    }
}

public class ACForm {
    
    internal weak var tableView: ACTableView?
    internal var params = Params()
    
    public func valueByName(name: String) -> AnyObject? {
        for formSection in params.sections {
            for formItem in formSection.items {
                if (formItem.name == name) {
                    return formItem.value
                }
            }
        }
        return nil
    }
    
    public struct Params {
        var delegate: ACFormDelegate?
        var sections: [ACFormSection] = []
        var style: ACFormStyle = .Value1
        var normalColor: UIColor = UIColor.blackColor()
        var tintColor: UIColor = UIColor.blueColor()
        var placeholderColor: UIColor = UIColor.lightGrayColor()
    }
    
    public class Builder {
        
        internal var params = Params()
        
        public init() {}
        
        public func addSection(section: ACFormSection) -> Self {
            self.params.sections.append(section)
            return self
        }
        
        public func setDelegate(delegate: ACFormDelegate) -> Self {
            self.params.delegate = delegate
            return self
        }
        
        public func setStyle(style: ACFormStyle) -> Self {
            self.params.style = style
            return self
        }
        
        public func setNormalColor(color: UIColor) -> Self {
            self.params.normalColor = color
            return self
        }
        
        public func setTintColor(color: UIColor) -> Self {
            self.params.tintColor = color
            return self
        }
        
        public func setPlaceholderColor(color: UIColor) -> Self {
            self.params.placeholderColor = color
            return self
        }
        
        internal func buildForm() -> ACForm {
            let form = ACForm()
            form.params = params
            return form
        }
    }
}

public class ACFormSection {
    
    public let tag: String?
    public var display: Bool
    
    internal let header: String?
    internal let footer: String?
    internal var items: [ACFormInput]
    
    public init(tag: String? = nil, header: String?, footer: String?, display: Bool, items: [ACFormInput]) {
        self.tag = tag
        self.header = header
        self.footer = footer
        self.display = display
        self.items = items
    }
}

public class ACFormInput: NSObject {
    
    private var delegate: ACFormDelegate?
    
    private let type: ACFormInputType
    internal let name: String
    internal let image: UIImage?
    internal let title: String?
    internal let placeholder: String?
    internal var value: AnyObject?
    
    internal weak var targetCell: UITableViewCell?
    
    public init(type: ACFormInputType, name: String, image: UIImage?, title: String?, placeholder: String?, value: AnyObject?) {
        self.type = type
        self.name = name
        self.image = image
        self.title = title
        self.placeholder = placeholder
        self.value = value
    }
    
    internal func getItem(style: ACFormStyle, normalColor: UIColor, tintColor: UIColor, placeholderColor: UIColor) -> ACTableViewItem? {
        
        if (verifyValueType()) {
            switch type {
            case .Text:
                let _value = self.value as! String?
                // use identifier to avoid unnecessary register
                return ACTableViewItem(tag: name + "_ITEM", identifier: "ACTextValue1", display: true) { (item, cell) in
                    self.targetCell = cell
                    
                    let _cell = cell as! ACTextTableViewCell
                    _cell.contentTextField.addTarget(self, action: Selector("textFieldDidEditingChanged:"), forControlEvents: .EditingChanged)
                    
                    _cell.setIconImage(self.image)
                    _cell.titleLabel.text = self.title
                    _cell.titleLabel.textColor = normalColor
                    _cell.placeholderLabel.text = self.placeholder
                    _cell.placeholderLabel.textColor = placeholderColor
                    _cell.contentTextField.text = _value
                    _cell.contentTextField.textColor = normalColor
                    
                    if (_value == nil || _value == "") {
                        _cell.placeholderLabel.hidden = false
                    } else {
                        _cell.placeholderLabel.hidden = true
                    }
                }
            }
        }
        
        return nil
    }
    
    // Actions of Text, Password, Number and Float
    func textFieldDidEditingChanged(sender: UITextField) {
        self.value = sender.text
        self.delegate?.formInput(self, withName: self.name, didChangeValue: self.value)
        
        if let _value = self.value as? String? {
            let _cell = self.targetCell as! ACTextTableViewCell
            if (_value == nil || _value == "") {
                _cell.placeholderLabel.hidden = false
            } else {
                _cell.placeholderLabel.hidden = true
            }
        }
    }
    
    func verifyValueType() -> Bool {
        switch type {
        case .Text:
            if let _ = value as? String? {
                return true
            }
        }
        
        print("The type of value is wrong.")
        return false
    }
    
}

public enum ACFormStyle {
    case Value1
}

public enum ACFormInputType {
    // Non-editable Label
//    case Label
    // Editable TextField
    case Text
//    case Password
//    case Number
//    case Float
    // TextView
//    case TextArea
    // Button
//    case Button
    // Disclosure
//    case Radio
//    case CheckBox
    // DatePicker
//    case DateTime
//    case Date
//    case Time
    
    // Stepper
//    case Stepper
    // Segment
//    case Segment
    // Switch
//    case Switch
}

public protocol ACFormDelegate {
    
    func formInput(formInput: ACFormInput, withName name: String, didChangeValue value: AnyObject?)
}
