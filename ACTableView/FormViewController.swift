//
//  FormViewController.swift
//  ACTableView
//
//  Created by Azure Chen on 3/6/16.
//  Copyright © 2016 AzureChen. All rights reserved.
//

import UIKit

class FormViewController: UIViewController, ACFormDelegate {
    
    let INPUT_FIRST_NAME = "first_name"
    let INPUT_LAST_NAME = "last_name"
    
    @IBOutlet weak var tableView: ACTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Form"
        
        let builder = ACForm.Builder()
            .setStyle(.Value2)
            .setNormalColor(UIColor.blackColor())
            .setTintColor(UIColor.redColor())
            .setDelegate(self)
            .addSection(ACFormSection(
                header: "Profile",
                footer: nil,
                display: true,
                items: [
                    ACFormInput(type: .Text, name: INPUT_FIRST_NAME, image: UIImage(named: "ic_wifi"), title: "Wi-Fi", placeholder: "What's your name?", value: nil),
                    ACFormInput(type: .Text, name: INPUT_LAST_NAME, image: nil, title: "Last Name", placeholder: "What's your name?", value: nil),
                    ACFormInput(type: .Text, name: INPUT_LAST_NAME, image: nil, title: "Last Name", placeholder: "What's your name?", value: nil),
                ]))
        self.tableView.builder = builder
        self.tableView.construct()
        
        
    }
    
    func formInput(formInput: ACFormInput, withName name: String, didChangeValue value: AnyObject?) {
        print("\(name) \(value as? String)")
    }
    
    @IBAction func saveAction(sender: UIBarButtonItem) {
        if let form = self.tableView.form {
            print("\(INPUT_FIRST_NAME) \(form.valueByName(INPUT_FIRST_NAME) as? String)")
        }
    }
    
}
