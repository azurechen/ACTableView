//
//  ExampleViewController.swift
//  ACTableView
//
//  Created by Azure Chen on 2016/1/31.
//  Copyright © 2016年 AzureChen. All rights reserved.
//

import UIKit

class ExampleViewController: UIViewController, UITableViewDelegate {
    
    @IBOutlet weak var tableView: ACTableView!
    
    // section tags
    private var SECTION_EXPANDABLE = "section_expandable"
    private var SECTION_DYNAMIC    = "section_dynamic"
    
    // item tags
    private var ITEM_EXPAND        = "item_expand"
    private var ITEM_COLLAPSE      = "item_collapse"
    private var ITEM_START_DATE    = "item_start_date"
    private var ITEM_START_PICKER  = "item_start_picker"
    private var ITEM_END_DATE      = "item_end_date"
    private var ITEM_END_PICKER    = "item_end_picker"
    private var ITEM_ADD           = "item_add"
    private var ITEM_REMOVE        = "item_remove"
    
    private var _startDate = NSDate()
    private var _endDate = NSDate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Examples"
        
        self.tableView.delegate = self
        
        self.tableView.addSection(ACTableViewSection(
            header: "Built-in Cells",
            footer: nil,
            display: true,
            items: [
                ACTableViewItem(style: .Value1, display: true) { (item, cell) in
                    cell.imageView?.image = UIImage(named: "ic_carrier")
                    cell.textLabel?.text = "Carrier"
                },
                ACTableViewItem(style: .Value1, display: true) { (item, cell) in
                    cell.imageView?.image = UIImage(named: "ic_wifi")
                    cell.textLabel?.text = "Wi-Fi"
                },
                ACTableViewItem(style: .Value1, display: true) { (item, cell) in
                    cell.imageView?.image = UIImage(named: "ic_notification")
                    cell.textLabel?.text = "Notifications"
                },
            ]))
        
        
        self.tableView.addSection(ACTableViewSection(
            tag: SECTION_EXPANDABLE,
            header: "Expandable Section",
            footer: nil,
            display: false,
            items: [
                ACTableViewItem(style: .Value1, display: true) { (item, cell) in
                    cell.textLabel?.text = "First"
                },
                ACTableViewItem(style: .Value1, display: true) { (item, cell) in
                    cell.textLabel?.text = "Second"
                },
                ACTableViewItem(style: .Value1, display: true) { (item, cell) in
                    cell.textLabel?.text = "Third"
                },
            ]))
        
        self.tableView.addSection(ACTableViewSection(
            header: "Custom Cells on Storyboard",
            footer: nil,
            display: true,
            items: [
                ACTableViewItem(tag: ITEM_EXPAND, identifier: "CentralCell", display: true) { (item, cell) in
                    let _cell = cell as! CentralTableViewCell
                    _cell.label.text = "Show Section"
                },
                ACTableViewItem(tag: ITEM_COLLAPSE, identifier: "CentralCell", display: true) { (item, cell) in
                    let _cell = cell as! CentralTableViewCell
                    _cell.label.text = "Hide Section"
                },
            ]))
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .MediumStyle
        dateFormatter.timeStyle = .NoStyle
        self.tableView.addSection(ACTableViewSection(
            header: "Custom Cells with Nib",
            footer: nil,
            display: true,
            items: [
                // Label
                ACTableViewItem(tag: ITEM_START_DATE, style: .Value1, display: true) { (item, cell) in
                    cell.textLabel?.text = "Start Date"
                    cell.detailTextLabel?.text = dateFormatter.stringFromDate(self._startDate)
                    if (item.next()!.display) {
                        cell.detailTextLabel!.textColor = UIColor.redColor()
                    } else {
                        cell.detailTextLabel!.textColor = UIColor.grayColor()
                    }
                },
                // DatePicker
                ACTableViewItem(tag: ITEM_START_PICKER, nibName: "DatePickerTableViewCell", display: false, bind: { (item) -> [ACTableViewItem] in [item.prev()!] }) { (item, cell) in
                    let _cell = cell as! DatePickerTableViewCell
                    _cell.datePicker.datePickerMode = .Date
                    _cell.datePicker.date = self._startDate
                    _cell.datePicker.addTarget(self, action: "datePickerValueChanged:", forControlEvents: UIControlEvents.ValueChanged)
                },
                // Label
                ACTableViewItem(tag: ITEM_END_DATE, style: .Value1, display: true) { (item, cell) in
                    cell.textLabel?.text = "End Date"
                    cell.detailTextLabel?.text = dateFormatter.stringFromDate(self._endDate)
                    if (item.next()!.display) {
                        cell.detailTextLabel!.textColor = UIColor.redColor()
                    } else {
                        cell.detailTextLabel!.textColor = UIColor.grayColor()
                    }
                },
                // DatePicker
                ACTableViewItem(tag: ITEM_END_PICKER, nibName: "DatePickerTableViewCell", display: false, bind: { (item) -> [ACTableViewItem] in [item.prev()!] }) { (item, cell) in
                    let _cell = cell as! DatePickerTableViewCell
                    _cell.datePicker.datePickerMode = .Date
                    _cell.datePicker.date = self._endDate
                    _cell.datePicker.addTarget(self, action: "datePickerValueChanged:", forControlEvents: UIControlEvents.ValueChanged)
                }
            ]))
        
        self.tableView.addSection(ACTableViewSection(
            tag: SECTION_DYNAMIC,
            header: "Add & Remove",
            footer: nil,
            display: true,
            items: [
                // Label
                ACTableViewItem(tag: ITEM_ADD, style: .Value1, display: true) { (item, cell) in
                    cell.textLabel?.text = "Add a Item"
                },
                ACTableViewItem(tag: ITEM_REMOVE, style: .Value1, display: true) { (item, cell) in
                    cell.textLabel?.text = "Remove a Item"
                },
            ]))
    }
    
    // UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        // get the item that related to the clicked cell
        let item = self.tableView.itemAtIndexPath(indexPath)
        let section = self.tableView.sectionAtIndex(indexPath.section)
        
        if (item.tag == ITEM_EXPAND) {
            self.tableView.sectionWithTag(SECTION_EXPANDABLE).show()
        }
        if (item.tag == ITEM_COLLAPSE) {
            section.prev()!.hide()
        }
        if (item.tag == ITEM_START_DATE || item.tag == ITEM_END_DATE) {
            let pickerItem = item.next()!
            if (pickerItem.display) {
                pickerItem.hide()
            } else {
                self.tableView.hideAllRowsIfNeeded()
                pickerItem.show()
            }
        }
        if (item.tag == ITEM_ADD) {
            self.tableView.sectionWithTag(SECTION_DYNAMIC).insertItem(
                ACTableViewItem(style: .Value1, display: true) { (item, cell) -> () in
                    cell.textLabel?.text = "New Item"
                }, atIndex: 1)
        }
        if (item.tag == ITEM_REMOVE) {
            self.tableView.sectionWithTag(SECTION_DYNAMIC).removeItemAtIndex(1)
        }
    }
    
    // UIDatePicker
    func datePickerValueChanged(sender: UIDatePicker) {
        let item = self.tableView.itemWithSubview(sender)
        
        if (item.tag == ITEM_START_PICKER) {
            _startDate = sender.date
            item.updateBoundRows()
        }
        if (item.tag == ITEM_END_PICKER) {
            _endDate = sender.date
            item.updateBoundRows()
        }
    }
    
}
