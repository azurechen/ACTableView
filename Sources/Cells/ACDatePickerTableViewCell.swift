//
//  ACDatePickerTableViewCell.swift
//  ACTableView
//
//  Created by AzureChen on 2016/3/12.
//  Copyright © 2016 AzureChen. All rights reserved.
//

import UIKit

class ACDatePickerTableViewCell: ACAbstractTableViewCell {

    @IBOutlet weak var datePicker: UIDatePicker!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func initWithInput(input: ACInput, withParams params: ACFormParams) {
        super.initWithInput(input, withParams: params)
        
        // bind events
        datePicker.addTarget(self, action: Selector("datePickerValueChanged:"), forControlEvents: .ValueChanged)
    }
    
    // Action
    func datePickerValueChanged(sender: UIDatePicker) {
        // callback
        if let input = self.input {
            input.value = sender.date
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
            ACTableViewItem(tag: name + "_ITEM", identifier: "ACLabel\(String(params.style))", display: true) { (item, cell) in
                self.targetCell = cell
                
                let _cell = cell as! ACLabelTableViewCell
                _cell.initWithInput(self, withParams: params)
                
                _cell.contentLabel.text = String(self.value)
                if (item.next()!.display) {
                    _cell.contentLabel.textColor = params.tintColor
                } else {
                    _cell.contentLabel.textColor = params.firstColor
                }
            },
            ACTableViewItem(tag: name + "_PICKER_ITEM", identifier: "ACDatePickerTableViewCell", display: false, bind: { (item) -> [ACTableViewItem] in [item.prev()!] }) { (item, cell) -> () in
                let _cell = cell as! ACDatePickerTableViewCell
                _cell.initWithInput(self, withParams: params)
                
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