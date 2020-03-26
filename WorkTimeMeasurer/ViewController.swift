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
    
    let programs = ["Swift", "C", "Java", "JavaScript", "PHP", "Python"]
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return programs.count
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        tableView.headerView = nil
        
        if (tableColumn == tableView.tableColumns[0]) {
            NSLog("pppppppp")
            let cellView = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "hogehogehoge"), owner: self) as! CustomCellView
            //let buttonCell = cellView.imageView
//            let cell = tableColumn?.dataCell(forRow: row)
//            (cell as AnyObject).imageView?.image = NSImage(named: NSImage.actionTemplateName)
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
}

// thx. https://www.appcoda.com/macos-programming-tableview/
class CustomCellView: NSTableCellView {
    
    @IBOutlet weak var button: NSButton!
    @IBOutlet weak var buttonCell: NSButtonCell!
    
}
