//
//  ViewController.swift
//  WorkTimeMeasurer
//
//  Created by Hodaka Suzuki on 2020/03/25.
//  Copyright © 2020 Hodaka Suzuki. All rights reserved.
//

import Cocoa

struct Record:Codable {
    let from:Date
    let to:Date
    let taskname:String
}


class ViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {

    @IBOutlet weak var tableView: NSTableView!
    override func viewDidLoad() {
        super.viewDidLoad()
            NSLog("hogehoge")
        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    let defaults = UserDefaults.standard
    
    let programs = ["Swift", "C", "Java", "JavaScript", "PHP", "Python"]
    
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return defaults.array(forKey: "tasknames")!.count
//        return programs.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        tableView.headerView = nil
        //defaults.set(programs, forKey: "tasknames")
        
        if (tableColumn == tableView.tableColumns[0]) {
            NSLog("pppppppp")
            let cellView = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "hogehogehoge"), owner: self) as! CustomCellView
            //let buttonCell = cellView.imageView
//            let cell = tableColumn?.dataCell(forRow: row)
//            (cell as AnyObject).imageView?.image = NSImage(named: NSImage.actionTemplateName)
            cellView.button.tag = row
            return cellView
        } else if (tableColumn == tableView.tableColumns[1]) {
            let cellView = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "col2"), owner: self) as! NSTableCellView
            let tasknames = defaults.object(forKey: "tasknames") as? [String]
            cellView.textField?.stringValue =  tasknames![row]
            return cellView
        } else if (tableColumn == tableView.tableColumns[2]) {
            let cellView = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "col3"), owner: self) as! DeleteButtonCellView
            cellView.button.tag = row
            return cellView
        }
        
        
//        return programs[row]
        return nil
    }
    
    @IBAction func startTimer(_ sender: NSButtonCell) {
        NSLog("fugafuga")
        let hoge = sender.tag
    }
    
    @IBAction func addNewTask(_ sender: NSTextField) {
        var tasknames = defaults.object(forKey: "tasknames") as? [String]
        tasknames!.insert(sender.stringValue, at: 0)
        defaults.set(tasknames, forKey: "tasknames")
        sender.stringValue = ""
        tableView.reloadData()
    }
    
    @IBAction func deleteTask(_ sender: NSButtonCell) {
        let row = sender.tag
        var tasknames = defaults.object(forKey: "tasknames") as? [String]
        tasknames?.remove(at: row)
        defaults.set(tasknames, forKey: "tasknames")
        tableView.reloadData()
    }
    
}

// thx. https://www.appcoda.com/macos-programming-tableview/
class CustomCellView: NSTableCellView {
    
    @IBOutlet weak var button: NSButton!
    @IBOutlet weak var buttonCell: NSButtonCell!
    
}

class DeleteButtonCellView: NSTableCellView {
    
    @IBOutlet weak var button: NSButton!
    
}
