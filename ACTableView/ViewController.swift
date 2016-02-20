//
//  ViewController.swift
//  ACTableView
//
//  Created by Azure Chen on 2016/1/31.
//  Copyright © 2016年 AzureChen. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate {
    
    @IBOutlet weak var tableView: ACTableView!
    
    // section tags
    private var SECTION_EXPANDABLE = "section_expandable"
    
    // item tags
    private var ITEM_EXPAND = "item_expand"
    private var ITEM_COLLAPSE = "item_collapse"
    private var ITEM_START_PICKER = "item_start_picker"
    private var ITEM_END_PICKER = "item_end_picker"
    
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
                    cell.imageView?.image = UIImage(named: "home")
                    cell.textLabel?.text = "Home"
                },
                ACTableViewItem(style: .Value1, display: true) { (item, cell) in
                    cell.imageView?.image = UIImage(named: "call")
                    cell.textLabel?.text = "Call"
                },
                ACTableViewItem(style: .Value1, display: true) { (item, cell) in
                    cell.imageView?.image = UIImage(named: "settings")
                    cell.textLabel?.text = "Settins"
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
            header: "Custom Cells on StoryBoard",
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
        dateFormatter.timeStyle = .ShortStyle
        self.tableView.addSection(ACTableViewSection(
            header: "Custom Cells with Nib",
            footer: nil,
            display: true,
            items: [
                // label
                ACTableViewItem(style: .Value1, display: true) { (item, cell) in
                    cell.textLabel?.text = "Start Date"
                    cell.detailTextLabel?.text = dateFormatter.stringFromDate(self._startDate)
                    if (item.next().display) {
                        cell.detailTextLabel!.textColor = UIColor.redColor()
                    } else {
                        cell.detailTextLabel!.textColor = UIColor.grayColor()
                    }
                },
                // DatePicker
                ACTableViewItem(tag: ITEM_START_PICKER, nibName: "DatePickerTableViewCell", display: false, bind: { (item) -> [ACTableViewItem] in [item.prev()] }) { (item, cell) in
                    let _cell = cell as! DatePickerTableViewCell
                    _cell.datePicker.date = self._startDate
                    _cell.datePicker.addTarget(self, action: "datePickerValueChanged:", forControlEvents: UIControlEvents.ValueChanged)
                },
                // label
                ACTableViewItem(style: .Value1, display: true) { (item, cell) in
                    cell.textLabel?.text = "End Date"
                    cell.detailTextLabel?.text = dateFormatter.stringFromDate(self._endDate)
                    if (item.next().display) {
                        cell.detailTextLabel!.textColor = UIColor.redColor()
                    } else {
                        cell.detailTextLabel!.textColor = UIColor.grayColor()
                    }
                },
                ACTableViewItem(tag: ITEM_END_PICKER, nibName: "DatePickerTableViewCell", display: false, bind: { (item) -> [ACTableViewItem] in [item.prev()] }) { (item, cell) in
                    let _cell = cell as! DatePickerTableViewCell
                    _cell.datePicker.date = self._endDate
                    _cell.datePicker.addTarget(self, action: "datePickerValueChanged:", forControlEvents: UIControlEvents.ValueChanged)
                }
            ]))
    }
    
    // UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: false)
        
        let item = self.tableView.itemAtIndexPath(indexPath)
        
        if (item.tag == ITEM_EXPAND) {
            self.tableView.sectionWithTag(SECTION_EXPANDABLE).show()
        }
        if (item.tag == ITEM_COLLAPSE) {
            self.tableView.sectionWithTag(SECTION_EXPANDABLE).hide()
        }
        if (item.section == 3 && item.row == 0) || (item.section == 3 && item.row == 2) {
            let pickerItem = item.next()
            if (pickerItem.display) {
                pickerItem.hide()
            } else {
                self.tableView.hideAllRowsIfNeeded()
                pickerItem.show()
            }
        }
    }
    
    // UIDatePicker
    func datePickerValueChanged(sender: UIDatePicker) {
        let item = self.tableView.itemWithSubview(sender)
        
        if (item.tag == ITEM_START_PICKER) {
            _startDate = sender.date
            item.updateData()
        }
        if (item.tag == ITEM_END_PICKER) {
            _endDate = sender.date
            item.updateData()
        }
    }
    
}
