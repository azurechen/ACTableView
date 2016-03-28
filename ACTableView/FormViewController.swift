//
//  FormViewController.swift
//  ACTableView
//
//  Created by Azure Chen on 3/6/16.
//  Copyright © 2016 AzureChen. All rights reserved.
//

import UIKit

class FormViewController: UIViewController, ACInputDelegate {
    
    let INPUT_FIRST_NAME = "first_name"
    let INPUT_LAST_NAME = "last_name"
    let INPUT_BIRTHDAY = "birthday"
    let INPUT_GENDER = "gender"
    
    @IBOutlet weak var tableView: ACTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Form"
        
        let builder = ACForm.Builder()
            .setStyle(.Value1)
            .setDelegate(self)
            .addSection(ACFormSection(
                header: "Profile",
                footer: nil,
                display: true,
                inputs: [
                    ACInputLabel(name: INPUT_LAST_NAME, image: nil, title: "Last Name", content: "Test"),
                    ACInputDate(type: .Date, name: INPUT_BIRTHDAY, image: nil, title: "Last Name", placeholder: "Please select", value: NSDate()),
                    ACInputDate(type: .Date, name: INPUT_BIRTHDAY, image: nil, title: "Last Name",placeholder: "Please select", value: nil, formatter: { (date) in
                            let dateFormatter = NSDateFormatter()
                            dateFormatter.dateStyle = .LongStyle
                            dateFormatter.timeStyle = .NoStyle
                            return "Hi \(dateFormatter.stringFromDate(date))"
                        }) { (datePicker) in
                            datePicker.maximumDate = NSDate()
                    },
                    ACInputSelect(name: INPUT_GENDER, image: nil, title: "Last Name", placeholder: "Please select", values: ["Orange", "MRT", "Pinao"], options: [
                            ["Apple", "Orange", "Pitch"],
                            ["Car", "Bike", "MRT", "Airplane"],
                            ["Guitar", "Pinao"]
                        ], formatter: { (strings) in
                            return strings.joinWithSeparator("!! ")
                    }),
                    ACInputText(type: .Text, name: INPUT_LAST_NAME, image: nil, title: "Last Name", placeholder: "What's your name?", value: nil),
                ]))
        let form = builder.create()
        self.tableView.buildWithForm(form)
    }
    
    func formInput(formInput: ACInput, withName name: String, didChangeValue value: AnyObject?) {
        print("\(name) \(String(value))")
    }
    
    @IBAction func saveAction(sender: UIBarButtonItem) {
        if let form = self.tableView.form {
            print("\(INPUT_GENDER) \(form.valueByName(INPUT_GENDER))")
        }
    }
    
}
