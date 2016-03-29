//
//  ACSelectPickerTableViewCell.swift
//  ACTableView
//
//  Created by AzureChen on 2016/3/27.
//  Copyright © 2016 AzureChen. All rights reserved.
//

import UIKit

class ACSelectPickerTableViewCell: UITableViewCell, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var pickerView: UIPickerView!
    
    internal weak var input: ACInputSelect?
    internal weak var item: ACTableViewItem?
    internal var params: ACFormParams?
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func initWithInput(input: ACInputSelect, withItem item: ACTableViewItem, withParams params: ACFormParams) {
        self.input = input
        self.item = item
        self.params = params
        
        // bind events
        pickerView.dataSource = self
        pickerView.delegate = self
    }
    
    func currentSelections() -> [String] {
        if let input = self.input {
            let count = input.options.count
            var selections: [String] = []
            for i in 0 ..< count {
                selections.append(input.options[i][pickerView.selectedRowInComponent(i)])
            }
            return selections
        }
        return []
    }
    
    // UIPickerViewDataSource
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return input!.options.count
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return input!.options[component].count
    }
    
    // UIPickerViewDelegate
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return input!.options[component][row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // callback
        if let input = self.input {
            input.value = currentSelections()
            item?.updateBoundRows()
        }
    }
    
}

public class ACInputSelect: ACInput {
    
    internal let options: [[String]]
    internal let formatter: ((strings: [String]) -> String)?
    internal let handler: ((pickerView: UIPickerView) -> ())?
    
    public init(name: String, image: UIImage?, title: String?, placeholder: String?, values: [String]?, options: [[String]], formatter: ((strings: [String]) -> String)? = nil, handler: ((pickerView: UIPickerView) -> ())? = nil) {
        self.options = options
        self.formatter = formatter
        self.handler = handler
        
        super.init(name: name, image: image, title: title, placeholder: placeholder, value: values)
    }
    
    override func getItems(params: ACFormParams) -> [ACTableViewItem] {
        // use identifier to avoid unnecessary register
        return [
            ACTableViewItem(tag: name + "_PICKER_LABEL_ITEM", identifier: "ACLabel\(String(params.style))", display: true) { (item, cell) in
                
                let _cell = cell as! ACLabelTableViewCell
                _cell.initWithInput(self, withParams: params)
                
                if let value = self.value as? [String] {
                    if (value.count != self.options.count) {
                        _cell.contentLabel.text = "Incorrect default values"
                        _cell.contentLabel.textColor = ACInput.placeholderColor
                    } else {
                        if (self.formatter == nil) {
                            // use the default format
                            _cell.contentLabel.text = value.joinWithSeparator(", ")
                        } else {
                            _cell.contentLabel.text = self.formatter!(strings: value)
                        }
                        
                        if (item.next()!.display) {
                            _cell.contentLabel.textColor = params.tintColor
                        } else {
                            _cell.contentLabel.textColor = params.secondColor
                        }
                    }
                } else {
                    _cell.contentLabel.text = self.placeholder
                    _cell.contentLabel.textColor = ACInput.placeholderColor
                }
                
                _cell.selectionStyle = .Default
            },
            ACTableViewItem(tag: name + "_PICKER_ITEM", identifier: "ACSelectPicker", display: false, bind: { (item) -> [ACTableViewItem] in [item.prev()!] }) { (item, cell) -> () in
                let _cell = cell as! ACSelectPickerTableViewCell
                _cell.initWithInput(self, withItem: item, withParams: params)
                
                // set the default values of picker view
                if let value = self.value as? [String] {
                    for (component, selection) in value.enumerate() {
                        for (row, oqtion) in self.options[component].enumerate() {
                            if (oqtion == selection) {
                                _cell.pickerView.selectRow(row, inComponent: component, animated: false)
                                break
                            }
                        }
                    }
                }
                if (item.display == true) {
                    self.value = _cell.currentSelections()
                }
                
                // call handler
                self.handler?(pickerView: _cell.pickerView)
            },
        ]
    }
    
}