//
//  ACTableView.swift
//  ACTableView
//
//  Created by AzureChen on 2016/1/7.
//  Copyright © 2016 AzureChen. All rights reserved.
//

import UIKit

public class ACTableView: UITableView, UITableViewDataSource {
    
    internal var sections: [ACTableViewSection] = []
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        self.dataSource = self
        
        self.rowHeight = UITableViewAutomaticDimension
        self.estimatedRowHeight = 44
    }
    
    public func clear(){
        sections.removeAll()
    }
    
    public func addSection(_ section: ACTableViewSection) {
        sections.append(section)
        section.tableView = self
        section.registerItems()
    }
    
    // get a section by tag
    public func section(with tag: String) -> ACTableViewSection! {
        for section in sections {
            if (section.tag == tag) {
                return section
            }
        }
        return nil
    }
    
    // get a section by Section Index in TableView
    public func section(at index: Int) -> ACTableViewSection! {
        var countSection = 0
        
        for i in 0 ..< sections.count {
            let section = sections[i]
            if (section.display) {
                if (countSection == index) {
                    return sections[i]
                }
                countSection += 1
            }
        }
        
        return nil
    }
    
    // get an item by tag
    public func item(with tag: String) -> ACTableViewItem! {
        for section in sections {
            for item in section.items {
                if (item.tag == tag) {
                    return item
                }
            }
        }
        return nil
    }
    
    // get an item by IndexPath in tableView
    public func item(at indexPath: IndexPath) -> ACTableViewItem! {
        var countSection = 0
        
        for i in 0 ..< sections.count {
            let section = sections[i]
            if (section.display) {
                if (countSection == indexPath.section) {
                    var countRow = 0
                    
                    for j in 0 ..< section.items.count {
                        let item = section.items[j]
                        if (item.display) {
                            if (countRow == indexPath.row) {
                                return sections[i].items[j]
                            }
                            countRow += 1
                        }
                    }
                }
                countSection += 1
            }
        }
        
        return nil
    }
    
    // get an item by subview
    public func item(include subview: UIView) -> ACTableViewItem! {
        var view: UIView? = subview
        
        while (view != nil) {
            if let v = view as? UITableViewCell {
                if let indexPath = indexPath(for: v) {
                    return item(at: indexPath)
                } else {
                    return nil
                }
            } else {
                view = view!.superview
            }
        }
        return nil
    }
    
    // hide all rows
    public func hideAllRowsIfNeeded() {
        for section in sections {
            for item in section.items {
                if (!item.initDisplay && item.display) {
                    item.hide()
                }
            }
        }
    }
    
    // show all rows
    public func showAllRows() {
        for section in sections {
            for item in section.items {
                if (!item.display) {
                    item.show()
                }
            }
        }
    }
    
    public func insertSection(_ section: ACTableViewSection, atIndex sectionIndex: Int, animated: Bool = true) {
        sections.insert(section, at: sectionIndex)
        
        if let index = self.indexOfSectionFromACIndex(sectionIndex) {
            self.insertSections(IndexSet(integer: index), with: animated ? .fade : .none)
        }
    }
    
    public func removeSection(_ section: ACTableViewSection, animated: Bool = true) {
        if let sectionIndex = section.sectionIndex {
            removeSection(at: sectionIndex, animated: animated)
        }
    }
    
    public func removeSection(at sectionIndex: Int, animated: Bool = true) {
        let index = self.indexOfSectionFromACIndex(sectionIndex)
        sections.remove(at: sectionIndex)
        if (index != nil) {
            self.deleteSections(IndexSet(integer: index!), with: animated ? .fade : .none)
        }
    }
    
    // section index mapping
    internal func indexOfSectionFromACIndex(_ index: Int) -> Int? {
        var countSection = 0
        
        for i in 0 ..< sections.count {
            let section = sections[i]
            if (section.display) {
                if (i == index) {
                    return countSection
                }
                countSection += 1
            }
        }
        
        return nil
    }
    
    // item index mapping
    internal func indexPathFromACIndex(forRow row: Int, inSection sectionNum: Int) -> IndexPath? {
        var countSection = 0
        
        for i in 0 ..< sections.count {
            let section = sections[i]
            if (section.display) {
                if (i == sectionNum) {
                    var countRow = 0
                    
                    for j in 0 ..< section.items.count {
                        let item = section.items[j]
                        if (item.display) {
                            if (j == row) {
                                return IndexPath(row: countRow, section: countSection)
                            }
                            countRow += 1
                        }
                    }
                }
                countSection += 1
            }
        }
        
        return nil
    }
    
    // DataSource
    public func numberOfSections(in tableView: UITableView) -> Int {
        var count = 0
        for section in sections {
            if (section.display) {
                count += 1
            }
        }
        return count
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        var count = 0
        for item in self.section(at: section).items {
            if (item.display) {
                count += 1
            }
        }
        return count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = self.item(at: indexPath)!
        let identifier = item.reuseIdentifier
        
        // get cell
        var cell = tableView.dequeueReusableCell(withIdentifier: identifier.components(separatedBy: ".").first!)
        if (cell == nil) {
            cell = UITableViewCell(style: item.style, reuseIdentifier: identifier)
        }
        item.handler?(item, cell!)
        
        cell?.clipsToBounds = true
        return cell!
    }
    
    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return self.section(at: section).header
    }
    
    public func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        return self.section(at: section).footer
    }
    
    // For ACForm
    public internal(set) var form: ACForm?

}
