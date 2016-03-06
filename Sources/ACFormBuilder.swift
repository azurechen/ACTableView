//
//  ACFormBuilder.swift
//  ACTableView
//
//  Created by Azure Chen on 3/6/16.
//  Copyright © 2016 AzureChen. All rights reserved.
//

import UIKit

public class ACFormBuilder {
    
    var sections: [ACFormSection]?
    
    public func addSection(section: ACFormSection) -> Self {
        return self
    }
    
    public func setStyle(style: UITableViewCellStyle) -> Self {
        return self
    }
    
    public func setDefaultColor(color: UIColor) -> Self {
        return self
    }
    
    public func setTintColor(color: UIColor) -> Self {
        return self
    }
    
    public func create() -> ACForm {
        let form = ACForm()
        return form
    }
    
}

public class ACForm {
    
}

public class ACFormSection {
    
}

public class ACFormItem {
    
    public enum Type {
        case Label
        case Text
        case Radio
        case CheckBox
        case DateTimePicker
        case DatePicker
        case TimePicker
        case Stepper
        case Segment
        case Switch
    }
    
}