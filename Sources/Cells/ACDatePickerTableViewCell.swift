//
//  ACDatePickerTableViewCell.swift
//  ACTableView
//
//  Created by AzureChen on 2016/3/12.
//  Copyright © 2016 AzureChen. All rights reserved.
//

import UIKit

class ACDatePickerTableViewCell: UITableViewCell {

    @IBOutlet weak var datePicker: UIDatePicker!
    
    internal weak var input: ACInputDate?
    internal weak var item: ACTableViewItem?
    internal var params: ACFormParams?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func initWithInput(input: ACInputDate, withItem item: ACTableViewItem, withParams params: ACFormParams) {
        self.input = input
        self.item = item
        self.params = params
        
        // bind events
        datePicker.addTarget(self, action: Selector("datePickerValueChanged:"), forControlEvents: .ValueChanged)
    }
    
    // Action
    func datePickerValueChanged(sender: UIDatePicker) {
        // callback
        if let input = self.input {
            input.value = sender.date
            item?.updateBoundRows()
        }
    }
    
}

public enum ACInputDateType {
    case Date
    case Time
    case DateAndTime
}

public class ACInputDate: ACInput {
    
    internal let type: ACInputDateType
    internal let formatter: ((date: NSDate) -> String)?
    internal let handler: ((datePicker: UIDatePicker) -> ())?
    
    private let defaultFormatter = NSDateFormatter()
    
    public init(type: ACInputDateType, name: String, image: UIImage?, title: String?, placeholder: String?, value: NSDate?, formatter: ((date: NSDate) -> String)? = nil, handler: ((datePicker: UIDatePicker) -> ())? = nil) {
        self.type = type
        self.formatter = formatter
        self.handler = handler
        
        super.init(name: name, image: image, title: title, placeholder: placeholder, value: value)
    }
    
    override func getItems(params: ACFormParams) -> [ACTableViewItem] {
        // use identifier to avoid unnecessary register
        return [
            ACTableViewItem(tag: name + "_PICKER_LABEL_ITEM", identifier: "ACLabel\(String(params.style))", display: true) { (item, cell) in
                
                let _cell = cell as! ACLabelTableViewCell
                _cell.initWithInput(self, withParams: params)
                
                if let value = self.value as? NSDate {
                    if (self.formatter == nil) {
                        // use the default date format
                        switch self.type {
                        case .Date:
                            self.defaultFormatter.dateStyle = .LongStyle
                            self.defaultFormatter.timeStyle = .NoStyle
                        case .Time:
                            self.defaultFormatter.dateStyle = .NoStyle
                            self.defaultFormatter.timeStyle = .ShortStyle
                        case .DateAndTime:
                            self.defaultFormatter.dateStyle = .MediumStyle
                            self.defaultFormatter.timeStyle = .ShortStyle
                        }
                        _cell.contentLabel.text = self.defaultFormatter.stringFromDate(value)
                    } else {
                        _cell.contentLabel.text = self.formatter!(date: value)
                    }
                    
                    if (item.next()!.display) {
                        _cell.contentLabel.textColor = params.tintColor
                    } else {
                        _cell.contentLabel.textColor = params.firstColor
                    }
                } else {
                    _cell.contentLabel.text = self.placeholder
                    _cell.contentLabel.textColor = ACInput.placeholderColor
                }
                
                _cell.selectionStyle = .Default
            },
            ACTableViewItem(tag: name + "_PICKER_ITEM", identifier: "ACDatePicker", display: false, bind: { (item) -> [ACTableViewItem] in [item.prev()!] }) { (item, cell) -> () in
                let _cell = cell as! ACDatePickerTableViewCell
                _cell.initWithInput(self, withItem: item, withParams: params)
                
                switch self.type {
                case .Date:
                    _cell.datePicker.datePickerMode = .Date
                case .Time:
                    _cell.datePicker.datePickerMode = .Time
                case .DateAndTime:
                    _cell.datePicker.datePickerMode = .DateAndTime
                }
                
                _cell.datePicker.date = self.value as? NSDate ?? NSDate()
                if (item.display == true) {
                    self.value = _cell.datePicker.date
                }
                
                // call handler
                self.handler?(datePicker: _cell.datePicker)
            },
        ]
    }
    
}