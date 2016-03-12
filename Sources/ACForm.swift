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
            
            
            self.form = self.builder!.buildPart()
            self.form!.tableView = self
            
            if (builder != nil) {
                for formSection in builder!.sections {
                    // transfer ACFormItem to ACTableItem
                    var items: [ACTableViewItem] = []
                    for formItem in formSection.items {
                        if let item = formItem.getItem(builder!.style, normalColor: builder!.normalColor, tintColor: builder!.tintColor, placeholderColor: builder!.placeholderColor) {
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
    
    public func valueOfTag(tag: String) -> AnyObject? {
        return nil
    }
    
    public class Builder {
        
        var sections: [ACFormSection] = []
        var style: UITableViewCellStyle = .Value1
        var normalColor: UIColor = UIColor.blackColor()
        var tintColor: UIColor = UIColor.blueColor()
        var placeholderColor: UIColor = UIColor.lightGrayColor()
        
        public init() {}
        
        public func addSection(section: ACFormSection) -> Self {
            self.sections.append(section)
            return self
        }
        
        public func setStyle(style: UITableViewCellStyle) -> Self {
            return self
        }
        
        public func setNormalColor(color: UIColor) -> Self {
            return self
        }
        
        public func setTintColor(color: UIColor) -> Self {
            return self
        }
        
        public func setPlaceholderColor(color: UIColor) -> Self {
            return self
        }
        
        internal func buildPart() -> ACForm {
            return ACForm()
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

public class ACFormInput {
    
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
    
    private let name: String
    private let type: Type
    private let title: String?
    private let placeholder: String?
    private let value: AnyObject?
    
    public init(name: String, type: Type, title: String?, placeholder: String?, value: AnyObject?) {
        self.name = name
        self.type = type
        self.title = title
        self.placeholder = placeholder
        self.value = value
    }
    
    internal func getItem(style: UITableViewCellStyle, normalColor: UIColor, tintColor: UIColor, placeholderColor: UIColor) -> ACTableViewItem? {
        
        var item: ACTableViewItem?
        if (type == .Text) {
            if let _value = self.value as? String? {
                item = ACTableViewItem(tag: name + "_ITEM", identifier: "ACTextTableViewCell", display: true) { (item, cell) in
                    if let _cell = cell as? ACTextTableViewCell {
                        _cell.normalColor = normalColor
                        _cell.placeholderColor = placeholderColor
                        _cell.title = self.title
                        _cell.placeholder = self.placeholder
                        _cell.value = _value
                        _cell.initCell()
                    }
                }
            } else {
                print("The type of value is wrong.")
            }
        }
        
        return item
    }
    
}