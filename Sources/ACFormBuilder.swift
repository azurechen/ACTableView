//
//  ACFormBuilder.swift
//  ACTableView
//
//  Created by Azure Chen on 3/6/16.
//  Copyright © 2016 AzureChen. All rights reserved.
//

import UIKit

extension ACTableView {
    
    public var builder: ACFormBuilder {
        get {
            return self.builder
        }
        set {
            
        }
    }
    
    public func construct() {
        
    }
    
}

public class ACFormBuilder {
    
    var sections: [ACFormSection]?
    
    public func addSection(section: ACFormSection) -> Self {
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
    
    public func buildPart() {
    }
    
}

public class ACFormSection {
    
    public let tag: String?
    public var display: Bool
    
    internal let header: String?
    internal let footer: String?
    internal var items: [ACFormItem]
    
    public init(tag: String? = nil, header: String?, footer: String?, display: Bool, items: [ACFormItem]) {
        self.tag = tag
        self.header = header
        self.footer = footer
        self.display = display
        self.items = items
    }
}

public class ACFormItem {
    
    public enum Input {
        // Non-editable
        case Label
        // TextField
        case Text
        case Password
        case Number
        case Float
        // Disclosure
        case Radio
        case CheckBox
        // DatePicker
        case DateTimePicker
        case DatePicker
        case TimePicker
        // Stepper
        case Stepper
        // Segment
        case Segment
        // Switch
        case Switch
    }
    
    private let tag: String?
    private let input: Input
    private let title: String?
    private let placeholder: String?
    private let defaultValue: AnyObject?
    
    public init(tag: String? = nil, input: Input, title: String?, placeholder: String?, defaultValue: AnyObject?) {
        self.tag = tag
        self.input = input
        self.title = title
        self.placeholder = placeholder
        self.defaultValue = defaultValue
    }
    
}