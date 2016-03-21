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
    
    internal weak var input: ACInput?
    internal weak var item: ACTableViewItem?
    internal var params: ACFormParams?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func initWithInput(input: ACInput, withItem item: ACTableViewItem, withParams params: ACFormParams) {
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
    case DateTime
}

public class ACInputDate: ACInput {
    
    internal let type: ACInputDateType
    
    public init(type: ACInputDateType, name: String, image: UIImage?, title: String?, value: NSDate?) {
        self.type = type
        
        super.init(name: name, image: image, title: title, value: value)
    }
    
    override func getItems(params: ACFormParams) -> [ACTableViewItem] {
        // use identifier to avoid unnecessary register
        return [
            ACTableViewItem(tag: name + "_PICKER_LABEL_ITEM", identifier: "ACLabel\(String(params.style))", display: true) { (item, cell) in
                self.targetCell = cell
                
                let _cell = cell as! ACLabelTableViewCell
                _cell.initWithInput(self, withParams: params)
                
                _cell.contentLabel.text = String(self.value)
                if (item.next()!.display) {
                    _cell.contentLabel.textColor = params.tintColor
                } else {
                    _cell.contentLabel.textColor = params.firstColor
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
                case .DateTime:
                    _cell.datePicker.datePickerMode = .DateAndTime
                }
            },
        ]
    }
    
}