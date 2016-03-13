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
            self.registerNib(UINib(nibName: "ACTextTableViewCell", bundle: bundle), forCellReuseIdentifier: "ACTextTableViewCell")
            
            
            self.form = self.builder!.buildForm()
            self.form!.tableView = self
            
            if (builder != nil) {
                for formSection in form!.params.sections {
                    // transfer ACFormItem to ACTableItem
                    var items: [ACTableViewItem] = []
                    for formItem in formSection.items {
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
    
    public func valueOfTag(tag: String) -> AnyObject? {
        return nil
    }
    
    public struct Params {
        var sections: [ACFormSection] = []
        var style: UITableViewCellStyle = .Value1
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
        
        public func setStyle(style: UITableViewCellStyle) -> Self {
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
    
    public enum Type {
        // Non-editable Label
        case Label
        // Editable Label
        case Text
        case Password
        case Number
        case Float
        // TextField
        case TextArea
        // Button
        case Button
        // Disclosure
        case Radio
        case CheckBox
        // DatePicker
        case DateTime
        case Date
        case Time
        
        // Stepper
        case Stepper
        // Segment
        case Segment
        // Switch
        case Switch
    }
    
    private let type: Type
    internal let name: String
    internal let title: String?
    internal let placeholder: String?
    internal var value: AnyObject?
    
    internal weak var targetCell: UITableViewCell?
    
    public init(type: Type, name: String, title: String?, placeholder: String?, value: AnyObject?) {
        self.type = type
        self.name = name
        self.title = title
        self.placeholder = placeholder
        self.value = value
    }
    
    internal func getItem(style: UITableViewCellStyle, normalColor: UIColor, tintColor: UIColor, placeholderColor: UIColor) -> ACTableViewItem? {
        
        var item: ACTableViewItem?
        if (type == .Text) {
            if let _value = self.value as? String? {
                // use identifier to avoid unnecessary register
                item = ACTableViewItem(tag: name + "_ITEM", identifier: "ACTextTableViewCell", display: true) { (item, cell) in
                    self.targetCell = cell
                    
                    let _cell = cell as! ACTextTableViewCell
                    _cell.contentTextField.addTarget(self, action: Selector("textFieldDidEditingChanged:"), forControlEvents: .EditingChanged)
                    
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
            } else {
                print("The type of value is wrong.")
            }
        }
        
        return item
    }
    
    func textFieldDidEditingChanged(sender: UITextField) {
        self.value = sender.text
        
        if let _value = self.value as? String? {
            let _cell = self.targetCell as! ACTextTableViewCell
            if (_value == nil || _value == "") {
                _cell.placeholderLabel.hidden = false
            } else {
                _cell.placeholderLabel.hidden = true
            }
        }
    }
    
}