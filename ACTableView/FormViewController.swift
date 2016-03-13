//
//  FormViewController.swift
//  ACTableView
//
//  Created by Azure Chen on 3/6/16.
//  Copyright © 2016 AzureChen. All rights reserved.
//

import UIKit

class FormViewController: UIViewController, ACFormDelegate {
    
    let INPUT_NAME = "Name"
    
    @IBOutlet weak var tableView: ACTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Form"
        
        let builder = ACForm.Builder()
            .setStyle(.Value1)
            .setNormalColor(UIColor.blackColor())
            .setTintColor(UIColor.redColor())
            .setDelegate(self)
            .addSection(ACFormSection(
                header: "Profile",
                footer: nil,
                display: true,
                items: [
                    ACFormInput(type: .Text, name: INPUT_NAME, title: "Name", placeholder: "What's your name?", value: nil),
                ]))
        self.tableView.builder = builder
        self.tableView.construct()
        
        
    }
    
    func formInput(formInput: ACFormInput, withName name: String, didChangeValue value: AnyObject?) {
        print("\(name) \(value as? String)")
    }
    
    @IBAction func saveAction(sender: UIBarButtonItem) {
        if let form = self.tableView.form {
            print("\(INPUT_NAME) \(form.valueByName(INPUT_NAME) as? String)")
        }
    }
    
}
