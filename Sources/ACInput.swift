//
//  ACInput.swift
//  ACTableView
//
//  Created by Azure Chen on 3/20/16.
//  Copyright © 2016 AzureChen. All rights reserved.
//

import UIKit

public class ACInput: NSObject {
    
    internal static let placeholderColor = UIColor(red: 199.0 / 255, green: 199.0 / 255, blue: 205.0 / 255, alpha: 1.0)
    
    internal var delegate: ACInputDelegate?
    
    internal let name: String
    internal let image: UIImage?
    internal let title: String?
    internal let placeholder: String?
    internal var value: AnyObject? {
        didSet {
            self.delegate?.formInput(self, withName: self.name, didChangeValue: self.value)
        }
    }
    
    init(name: String, image: UIImage?, title: String?, placeholder: String?, value: AnyObject?) {
        self.name = name
        self.image = image
        self.title = title
        self.placeholder = placeholder
        self.value = value
    }
    
    internal func getItems(params: ACFormParams) -> [ACTableViewItem] {
        preconditionFailure("This method must be overridden.")
    }
    
}

// Non-editable Label
//  v  case Label
// Editable TextField
//  v  case Text
//     case Password
//     case Number
//     case Float
// TextView
//     case TextArea
// Button
//     case Button
// Disclosure
//     case Radio
//     case CheckBox
// DatePicker
//  v  case DateTime
//  v  case Date
//  v  case Time
// PickerView
//     case Selection
// Stepper
//     case Stepper
// Segment
//     case Segment
// Switch
//     case Switch
