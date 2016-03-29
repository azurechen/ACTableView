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
                    ACInputLabel(name: INPUT_FIRST_NAME, image: nil, title: "First Name", content: "Test"),
                    ACInputText(type: .Text, name: INPUT_LAST_NAME, image: nil, title: "Last Name", placeholder: "What's your name?", value: nil),
                    ACInputDate(type: .Date, name: INPUT_BIRTHDAY, image: nil, title: "Birtday", placeholder: "Please select", value: NSDate()),
                    ACInputSelect(name: INPUT_GENDER, image: nil, title: "Gender", placeholder: "Please select", values: nil, options: [
                            ["Male", "Female", "Others"],
                        ]),
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
