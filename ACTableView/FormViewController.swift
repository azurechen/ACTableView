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
        
        let builder = ACFormBuilder()
            .setStyle(.Value1)
            .setNormalColor(UIColor.grayColor())
            .setTintColor(UIColor.redColor())
            .addSection(ACFormSection(
                header: "Settings",
                footer: nil,
                display: true,
                items: [
                    ACFormItem(tag: TAG_NAME, input: .Label, title: "Name", placeholder: "What's your name?", defaultValue: nil),
                ]))
        
        self.tableView.builder = builder
        self.tableView.construct()
        
        //form.valueOf("TAG")
    }
    
}
