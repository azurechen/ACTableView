//
//  ACForm.swift
//  ACTableView
//
//  Created by Azure Chen on 3/6/16.
//  Copyright © 2016 AzureChen. All rights reserved.
//

import UIKit

extension ACTableView {
    
    public var form: ACForm? {
        get {
            return self.form
        }
        set {
            
        }
    }
    
    public var builder: ACForm.Builder? {
        get {
            return self.builder
        }
        set {
            
        }
    }
    
    public func construct() {
        if (self.builder != nil) {
            self.form = self.builder!.buildPart()
            self.form!.tableView = self
        }
    }
}

public class ACForm {
    
    internal weak var tableView: ACTableView?
    
    public func valueOfTag(tag: String) -> AnyObject? {
        return nil
    }
    
    public class Builder {
        
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
        
        public func setPlaceHolderColor(color: UIColor) -> Self {
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
    
    private let name: String?
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
    
}