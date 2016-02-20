//
//  ViewController.swift
//  ACTableView
//
//  Created by Azure Chen on 2016/1/31.
//  Copyright © 2016年 AzureChen. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate {
    
    @IBOutlet weak var tableView: EasyTableView!
    
    private var _startDate = NSDate()
    private var _endDate = NSDate()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Examples"
        
        self.tableView.delegate = self
        
        self.tableView.addSection(EasyTableViewSection(
            header: "Built-in Cells",
            footer: nil,
            display: true,
            items: [
                EasyTableViewItem(style: .Value1, display: true) { (item, cell) in
                    cell.imageView?.image = UIImage(named: "home")
                    cell.textLabel?.text = "Home"
                },
                EasyTableViewItem(style: .Value1, display: true) { (item, cell) in
                    cell.imageView?.image = UIImage(named: "call")
                    cell.textLabel?.text = "Call"
                },
                EasyTableViewItem(style: .Value1, display: true) { (item, cell) in
                    cell.imageView?.image = UIImage(named: "settings")
                    cell.textLabel?.text = "Settins"
                },
            ]))
        
        
        self.tableView.addSection(EasyTableViewSection(
            header: "Expandable Section",
            footer: nil,
            display: false,
            items: [
                EasyTableViewItem(style: .Value1, display: true) { (item, cell) in
                    cell.textLabel?.text = "First"
                },
                EasyTableViewItem(style: .Value1, display: true) { (item, cell) in
                    cell.textLabel?.text = "Second"
                },
                EasyTableViewItem(style: .Value1, display: true) { (item, cell) in
                    cell.textLabel?.text = "Third"
                },
            ]))
        
        self.tableView.addSection(EasyTableViewSection(
            header: "Custom Cells on StoryBoard",
            footer: nil,
            display: true,
            items: [
                EasyTableViewItem(identifier: "CentralCell", display: true) { (item, cell) in
                    let _cell = cell as! CentralTableViewCell
                    _cell.label.text = "Show Section"
                },
                EasyTableViewItem(identifier: "CentralCell", display: true) { (item, cell) in
                    let _cell = cell as! CentralTableViewCell
                    _cell.label.text = "Hide Section"
                },
            ]))
        
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .MediumStyle
        dateFormatter.timeStyle = .ShortStyle
        self.tableView.addSection(EasyTableViewSection(
            header: "Custom Cells with Nib",
            footer: nil,
            display: true,
            items: [
                // label
                EasyTableViewItem(style: .Value1, display: true) { (item, cell) in
                    cell.textLabel?.text = "Start Date"
                    cell.detailTextLabel?.text = dateFormatter.stringFromDate(self._startDate)
                    if (item.next().display) {
                        cell.detailTextLabel!.textColor = UIColor.redColor()
                    } else {
                        cell.detailTextLabel!.textColor = UIColor.grayColor()
                    }
                },
                // DatePicker
                EasyTableViewItem(nibName: "DatePickerTableViewCell", display: false, bind: { (item) -> [EasyTableViewItem] in [item.prev()] }) { (item, cell) in
                    let _cell = cell as! DatePickerTableViewCell
                    _cell.datePicker.tag = 1
                    _cell.datePicker.date = self._startDate
                    _cell.datePicker.addTarget(self, action: "datePickerValueChanged:", forControlEvents: UIControlEvents.ValueChanged)
                },
                // label
                EasyTableViewItem(style: .Value1, display: true) { (item, cell) in
                    cell.textLabel?.text = "End Date"
                    cell.detailTextLabel?.text = dateFormatter.stringFromDate(self._endDate)
                    if (item.next().display) {
                        cell.detailTextLabel!.textColor = UIColor.redColor()
                    } else {
                        cell.detailTextLabel!.textColor = UIColor.grayColor()
                    }
                },
                EasyTableViewItem(nibName: "DatePickerTableViewCell", display: false, bind: { (item) -> [EasyTableViewItem] in [item.prev()] }) { (item, cell) in
                    let _cell = cell as! DatePickerTableViewCell
                    _cell.datePicker.tag = 2
                    _cell.datePicker.date = self._endDate
                    _cell.datePicker.addTarget(self, action: "datePickerValueChanged:", forControlEvents: UIControlEvents.ValueChanged)
                }
            ]))
    }
    
    // UITableViewDelegate
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: false)
        
        let item = self.tableView.getItem(atIndexPathInTableView: indexPath)
        
        
        if (item.section == 2) {
            let section = self.tableView.getSection(atIndex: 1)
            if (item.row == 0) {
                section.show()
            }
            if (item.row == 1) {
                section.hide()
            }
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
        if (sender.tag == 1) {
            _startDate = sender.date
            let item = self.tableView.getItem(forRow: 1, inSection: 3)
            item.updateData()
        }
        if (sender.tag == 2) {
            _endDate = sender.date
            let item = self.tableView.getItem(forRow: 3, inSection: 3)
            item.updateData()
        }
    }
    
}
