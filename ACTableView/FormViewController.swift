//
//  FormViewController.swift
//  ACTableView
//
//  Created by Azure Chen on 3/6/16.
//  Copyright © 2016 AzureChen. All rights reserved.
//

import UIKit

class FormViewController: UIViewController, UITableViewDelegate {
    
    let TAG_NAME = "Name"
    
    @IBOutlet weak var tableView: ACTableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Form"
        
        let builder = ACForm.Builder()
            .setStyle(.Value1)
            .setNormalColor(UIColor.grayColor())
            .setTintColor(UIColor.redColor())
            .addSection(ACFormSection(
                header: "Profile",
                footer: nil,
                display: true,
                items: [
                    ACFormInput(name: TAG_NAME, type: .Text, title: "Name", placeholder: "What's your name?", value: nil),
                ]))
        self.tableView.builder = builder
        self.tableView.construct()
        
        if let form = self.tableView.form {
            let name = form.valueOfTag(TAG_NAME)
        }
    }
    
}
