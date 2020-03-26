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


class ViewController: NSViewController, NSTableViewDataSource {

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
    
    func tableView(_ tableView: NSTableView, objectValueFor tableColumn: NSTableColumn?, row: Int) -> Any? {
        return programs[row]
    }

}

