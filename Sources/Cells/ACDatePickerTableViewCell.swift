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

    func initWithInput(_ input: ACInputDate, withItem item: ACTableViewItem, withParams params: ACFormParams) {
        self.input = input
        self.item = item
        self.params = params
        
        // bind events
        datePicker.addTarget(self, action: #selector(self.datePickerValueChanged), for: .valueChanged)
    }
    
    // Action
    func datePickerValueChanged(sender: UIDatePicker) {
        // callback
        if let input = self.input {
            input.value = sender.date as AnyObject?
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
    internal let formatter: ((Date) -> String)?
    internal let handler: ((UIDatePicker) -> ())?
    
    private let defaultFormatter = DateFormatter()
    
    public init(type: ACInputDateType, name: String, image: UIImage?, title: String?, placeholder: String?, value: NSDate?, formatter: ((Date) -> String)? = nil, handler: ((UIDatePicker) -> ())? = nil) {
        self.type = type
        self.formatter = formatter
        self.handler = handler
        
        super.init(name: name, image: image, title: title, placeholder: placeholder, value: value)
    }
    
    override func getItems(params: ACFormParams) -> [ACTableViewItem] {
        // use identifier to avoid unnecessary register
        return [
            ACTableViewItem(tag: name + "_PICKER_LABEL_ITEM", identifier: "ACLabel\(String(describing: params.style))", display: true) { (item, cell) in
                
                let _cell = cell as! ACLabelTableViewCell
                _cell.initWithInput(self, withParams: params)
                
                if let value = self.value as? Date {
                    if (self.formatter == nil) {
                        // use the default date format
                        switch self.type {
                        case .Date:
                            self.defaultFormatter.dateStyle = .long
                            self.defaultFormatter.timeStyle = .none
                        case .Time:
                            self.defaultFormatter.dateStyle = .none
                            self.defaultFormatter.timeStyle = .short
                        case .DateAndTime:
                            self.defaultFormatter.dateStyle = .medium
                            self.defaultFormatter.timeStyle = .short
                        }
                        _cell.contentLabel.text = self.defaultFormatter.string(from: value)
                    } else {
                        _cell.contentLabel.text = self.formatter!(value)
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
                
                _cell.selectionStyle = .default
            },
            ACTableViewItem(tag: name + "_PICKER_ITEM", identifier: "ACDatePicker", display: false, bind: { (item) -> [ACTableViewItem] in [item.prev()!] }) { (item, cell) -> () in
                let _cell = cell as! ACDatePickerTableViewCell
                _cell.initWithInput(self, withItem: item, withParams: params)
                
                switch self.type {
                case .Date:
                    _cell.datePicker.datePickerMode = .date
                case .Time:
                    _cell.datePicker.datePickerMode = .time
                case .DateAndTime:
                    _cell.datePicker.datePickerMode = .dateAndTime
                }
                
                // set the default value of date picker
                _cell.datePicker.date = self.value as? Date ?? Date()
                if (item.display == true) {
                    self.value = _cell.datePicker.date as AnyObject?
                }
                
                // call handler
                self.handler?(_cell.datePicker)
            },
        ]
    }
    
}
