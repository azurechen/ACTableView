ACTableView
===========

Using `ACTableView` to create a table in `Swift` is faster and easier way to maintain your code. Save more time and effort if you only need a table with static data.

Usage
-----

###Create a Table

Create a tableView that extends `ACTableView` in `XIB` or `Storyboard` and declare the `IBOutlet`

```swift
@IBOutlet weak var tableView: ACTableView!
```

###Set the Contents of Table

Set `sections` and `items` by using appropriate method. Using `style`, `identifier` or `nibName` depeneds on the source of your `UITableViewCell`.

1. <b>Built-in Cells</b> use `style` to initialize

	```swift
	self.tableView.addSection(ACTableViewSection(
        header: "Built-in Cells",
        footer: nil,
        display: true,
        items: [
            ACTableViewItem(style: .Value1, display: true, handler: { (item, cell) in
                cell.imageView?.image = UIImage(named: "home")
                cell.textLabel?.text = "Home"
            }),
            ACTableViewItem(style: .Value1, display: true) { (item, cell) in
                cell.imageView?.image = UIImage(named: "call")
                cell.textLabel?.text = "Call"
            }
        ]))
	```
	
2. <b>Custom Cells on Storyboard</b> use `identifier` to initialize

	```Swift
	self.tableView.addSection(ACTableViewSection(
        header: "Custom Cells on StoryBoard",
        footer: nil,
        display: true,
        items: [
            ACTableViewItem(tag: ITEM_HOME, identifier: "CentralCell", display: true, handler: { (item, cell) in
                let _cell = cell as! CentralTableViewCell
                _cell.label.text = "Home"
            }),
            ACTableViewItem(tag: ITEM_CALL, identifier: "CentralCell", display: true) { (item, cell) in
                let _cell = cell as! CentralTableViewCell
                _cell.label.text = "Call"
            },
        ]))
	```	

3. <b>Custom Cells with Nib</b> use `nibName` to initialize

	```Swift
	self.tableView.addSection(ACTableViewSection(
        header: "Custom Cells with Nib",
        footer: nil,
        display: true,
        items: [
            ACTableViewItem(tag: ITEM_HOME, nibName: "CentralCell", display: true, handler: { (item, cell) in
                let _cell = cell as! CentralTableViewCell
                _cell.label.text = "Home"
            }),
            ACTableViewItem(tag: ITEM_CALL, nibName: "CentralCell", display: true) { (item, cell) in
                let _cell = cell as! CentralTableViewCell
                _cell.label.text = "Call"
            },
        ]))
	```

`tag` is a `string`, `display` is a `bool` means this cell is hidden or shown.

* <b>Important</b>: Notice that the `tag` parameter of `ACTableViewItem` is optional, but if you need to know which cell is clicked later. You must give them a `tag`.

And you can write anything that the cell should be modified in `handler`, the closure is the code that originally be executed in `tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath)`

```Swift
ACTableViewItem(tag: TAG, style: .Value1, display: true, handler: { (item, cell) in
}),
```

Use the abbreviated form is also a good idea.

```Swift
ACTableViewItem(tag: TAG, style: .Value1, display: true) { (item, cell) in
}
```
	
In addition, You can append items later and just create a `ACTableSection` first

```Swift
let section = ACTableViewSection(
    header: "Built-in Cells",
    footer: nil,
    display: true)
section.items = items
self.tableView.addSection(section)
```

Another details please build this project and see the example.

###Event Delegation

If you want to know which cell is clicked, you can still use `UITableViewDelegate`. But the way of handling anythings become easier now.

```Swift
// UITableViewDelegate
func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    self.tableView.deselectRowAtIndexPath(indexPath, animated: false)
    
    // get the item that related to the clicked cell
    let item = self.tableView.itemAtIndexPath(indexPath)
    
    if (item.tag == ITEM_START_DATE || item.tag == ITEM_END_DATE) {
        let pickerItem = item.next()!
        if (pickerItem.display) {
            pickerItem.hide()
        } else {
            self.tableView.hideAllRowsIfNeeded()
            pickerItem.show()
        }
    }
}
```

Remember the `display` parameter of `ACTableViewSection` or `ACTableViewItem`? You can `hide` or `show` any section or item with just one line.

It make you create a form with `Date Picker` quickly. The following is an example:

```Swift
// item tags
private var ITEM_START_DATE   = "item_start_date"
private var ITEM_START_PICKER = "item_start_picker"

private var _startDate = NSDate()
```
```Swift
let dateFormatter = NSDateFormatter()
dateFormatter.dateStyle = .MediumStyle
dateFormatter.timeStyle = .NoStyle
self.tableView.addSection(ACTableViewSection(
    header: "Date Picker Example",
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
    ]))
```

Listening the value changed event of `Date Picker` is easier too:

```Swift
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
```

I guess you notice some methods like `item.next()`, `item.prev()` or some closures like `bind: { (item) -> [ACTableViewItem] in [item.prev()!] }`. It will be mentioned in next chapters.

###Item Traversing

Finding another item by `next()` or `prev()` methods of `ACTableViewItem` is similar to `jQuery`

`item.next()`: get the next item of current item

`item.prev()`: get the previous item of current item


###Binding

In the `Date Picker` example, a cell with `datePicker` is related to a cell with `textLabel`, and the content of `textLabel` should be modified by the value of `datePicker`.

Use the following way to bind the two items together.

```Swift
let items = [
    // Label
    ACTableViewItem(tag: ITEM_START_DATE, style: .Value1, display: true) { (item, cell) in
        // update the text or color
    },
    // DatePicker
    ACTableViewItem(tag: ITEM_START_PICKER, nibName: "DatePickerTableViewCell", display: false, 
        bind: { (item) -> [ACTableViewItem] in [item.prev()!] }) { (item, cell) in
        
        // set the datePicker
    },
]
```

The bound item will be updated when the cell with `datePicker` show or hide, and you can call `updateBoundRows()` when the value of `datePicker` is changed.

How to Install
--------------

If you didn't use [CocoaPods](http://cocoapods.org) before, install it first

```bash
$ gem install cocoapods
```

And append the following line into your `Podfile`

```Swift
pod 'ACTableView', :git => 'https://github.com/azurechen/ACTableView.git'
```

Then, run this command

```bash
$ pod install
```