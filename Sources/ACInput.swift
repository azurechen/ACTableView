//
//  ACInput.swift
//  ACTableView
//
//  Created by Azure Chen on 3/20/16.
//  Copyright © 2016 AzureChen. All rights reserved.
//

import UIKit

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
