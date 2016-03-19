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
            self.registerNib(UINib(nibName: "ACTextValue2TableViewCell", bundle: bundle), forCellReuseIdentifier: "ACTextValue2")
            
            
            self.form = self.builder!.buildForm()
            self.form!.tableView = self
            
            if (builder != nil) {
                for formSection in form!.params.sections {
                    // transfer ACFormItem to ACTableItem
                    var items: [ACTableViewItem] = []
                    for formItem in formSection.items {
                        items += formItem.getItems(form!.params)
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
    internal var params = ACFormParams()
    
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
    
    public class Builder {
        
        internal var params = ACFormParams()
        
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
    internal var items: [ACInput]
    
    public init(tag: String? = nil, header: String?, footer: String?, display: Bool, items: [ACInput]) {
        self.tag = tag
        self.header = header
        self.footer = footer
        self.display = display
        self.items = items
    }
}

public class ACInput: NSObject {
    
    internal let name: String
    internal let image: UIImage?
    internal let title: String?
    internal var value: AnyObject?
    
    internal weak var targetCell: UITableViewCell?
    
    init(name: String, image: UIImage?, title: String?, value: AnyObject?) {
        self.name = name
        self.image = image
        self.title = title
        self.value = value
    }
    
    internal func getItems(params: ACFormParams) -> [ACTableViewItem] {
        preconditionFailure("This method must be overridden.")
    }
    
}

public struct ACFormParams {
    var delegate: ACFormDelegate?
    var sections: [ACFormSection] = []
    var style: ACFormStyle = .Value1
    var normalColor: UIColor = UIColor.blackColor()
    var tintColor: UIColor = UIColor.blueColor()
}

public enum ACFormStyle {
    case Value1
    case Value2
}

public protocol ACFormDelegate {
    
    func formInput(formInput: ACInput, withName name: String, didChangeValue value: AnyObject?)
}

// Non-editable Label
//    case Label
// Editable TextField
//    case Text
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
