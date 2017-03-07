//
//  ACForm.swift
//  ACTableView
//
//  Created by Azure Chen on 3/6/16.
//  Copyright © 2016 AzureChen. All rights reserved.
//

import UIKit

extension ACTableView {
    
    public func build(with form: ACForm) {
        self.form = form
        
        // CocoaPods Support, bundle is nil if not a library of CocoaPods
        var bundle: Bundle?
        if let bundleURL = Bundle(for: self.classForCoder).url(forResource: "ACTableView", withExtension: "bundle") {
            bundle = Bundle(url: bundleURL)
        }
        // Register all nibs
        self.register(UINib(nibName: "ACLabelValue1TableViewCell", bundle: bundle), forCellReuseIdentifier: "ACLabelValue1")
        self.register(UINib(nibName: "ACLabelValue2TableViewCell", bundle: bundle), forCellReuseIdentifier: "ACLabelValue2")
        self.register(UINib(nibName: "ACTextValue1TableViewCell", bundle: bundle), forCellReuseIdentifier: "ACTextValue1")
        self.register(UINib(nibName: "ACTextValue2TableViewCell", bundle: bundle), forCellReuseIdentifier: "ACTextValue2")
        self.register(UINib(nibName: "ACDatePickerTableViewCell", bundle: bundle), forCellReuseIdentifier: "ACDatePicker")
        self.register(UINib(nibName: "ACSelectPickerTableViewCell", bundle: bundle), forCellReuseIdentifier: "ACSelectPicker")
        
        // A COMPLICATED love triangle
        form.tableView = self
        self.delegate = form
        
        for formSection in form.params.sections {
            // transfer ACInput to ACTableItem
            var items: [ACTableViewItem] = []
            for formInput in formSection.inputs {
                items += formInput.getItems(params: form.params)
                // set the ACInputDelegate
                formInput.delegate = form.params.delegate
            }
            // transfer ACFormSection to ACTableViewSection
            self.addSection(ACTableViewSection(
                header: formSection.header,
                footer: formSection.footer,
                display: formSection.display,
                items: items))
        }
        
        // set the keyboard dismiss mode
        self.keyboardDismissMode = .onDrag
    }
    
    func dismissKeyboard() {
        self.endEditing(true)
    }
}

public class ACForm: NSObject, UITableViewDelegate {
    
    internal weak var tableView: ACTableView?
    internal var params = ACFormParams()
    
    public func value(with name: String) -> AnyObject? {
        for formSection in params.sections {
            for formInput in formSection.inputs {
                if (formInput.name == name) {
                    return formInput.value
                }
            }
        }
        return nil
    }
    
    public class Builder {
        
        internal var params = ACFormParams()
        
        public init() {}
        
        public func addSection(_ section: ACFormSection) -> Self {
            self.params.sections.append(section)
            return self
        }
        
        public func setDelegate(_ delegate: ACInputDelegate) -> Self {
            self.params.delegate = delegate
            return self
        }
        
        public func setStyle(_ style: ACFormStyle) -> Self {
            self.params.style = style
            return self
        }
        
        public func setTitleColor(_ color: UIColor) -> Self {
            self.params.titleColor = color
            return self
        }
        
        public func setFirstColor(_ color: UIColor) -> Self {
            self.params.firstColor = color
            return self
        }
        
        public func setSecondColor(_ color: UIColor) -> Self {
            self.params.secondColor = color
            return self
        }
        
        public func setTintColor(_ color: UIColor) -> Self {
            self.params.tintColor = color
            return self
        }
        
        public func create() -> ACForm {
            let form = ACForm()
            
            form.params = params.copy()
            return form
        }
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.tableView?.deselectRow(at: indexPath, animated: true)
        
        // get the item that related to the clicked cell
        if let item = self.tableView?.item(at: indexPath) {
            if (item.tag != nil && item.tag!.contains("_PICKER_LABEL_ITEM")) {
                let pickerItem = item.next()!
                if (pickerItem.display) {
                    pickerItem.hide()
                } else {
                    self.tableView?.hideAllRowsIfNeeded()
                    pickerItem.show()
                }
            }
        }
        
        // handle the keyboard for textField
        if let textCell = tableView.cellForRow(at: indexPath) as? ACTextTableViewCell {
            textCell.contentTextField.becomeFirstResponder()
        } else {
            self.tableView?.dismissKeyboard()
        }
    }
    
}

public class ACFormSection {
    
    public let tag: String?
    public var display: Bool
    
    internal let header: String?
    internal let footer: String?
    internal var inputs: [ACInput]
    
    public init(tag: String? = nil, header: String?, footer: String?, display: Bool, inputs: [ACInput]) {
        self.tag = tag
        self.header = header
        self.footer = footer
        self.display = display
        self.inputs = inputs
    }
}

public class ACFormParams {
    var delegate: ACInputDelegate?
    var sections: [ACFormSection] = []
    var style: ACFormStyle = .Value1
    var titleColor: UIColor = UIColor.black
    var firstColor: UIColor = UIColor.black
    var secondColor: UIColor = UIColor(red: 142.0 / 255, green: 142.0 / 255, blue: 147.0 / 255, alpha: 1.0)
    var tintColor: UIColor = UIColor(red: 0.0 / 255, green: 122.0 / 255, blue: 255.0 / 255, alpha: 1.0)
    
    public func copy() -> ACFormParams {
        let params = ACFormParams()
        params.delegate = self.delegate
        params.sections = self.sections
        params.style = self.style
        params.titleColor = self.titleColor
        params.firstColor = self.firstColor
        params.secondColor = self.secondColor
        params.tintColor = self.tintColor
        
        return params
    }
}

public enum ACFormStyle {
    case Value1
    case Value2
}

public protocol ACInputDelegate {
    
    func formInput(_ formInput: ACInput, withName name: String, didChangeValue value: AnyObject?)
}

