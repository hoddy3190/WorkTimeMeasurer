//
//  ViewController.swift
//  WorkTimeMeasurer
//
//  Created by Hodaka Suzuki on 2020/03/25.
//  Copyright © 2020 Hodaka Suzuki. All rights reserved.
//

import Cocoa

struct Task:Codable {
    let startTime:Date
    var endTime:Date
    let taskName:String
}

struct DayTaskData:Codable {
    var totalTime:Int
    var taskList:[Task]
}

/*
 firstTaskStartTime: {
   let totalTime:Int
   let taskList: [
     { taskName:String, startTime: xxx, endTime: yyy}
   ]
 }
 todaysStartTime:Int
 */


class ViewController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {

    
    var now: NSDate? = nil
    var nowTime: Double = Double()
    var elapsedTime: Double = Double()
    var displayTime: Double = Double()
    var savedTime: Double = Double()
    var startOrStop: Bool = false
    var timer: Timer? = Timer()
    var timeStr:String = "00:00:00"
    var targetCellView:CustomCellView? = nil
    
    var isWorkingToday = false
    
    func toggleStartOrStop() {
        startOrStop = !startOrStop
    }
    
    @objc func updateTime() {
        elapsedTime = NSDate.timeIntervalSinceReferenceDate
        displayTime = (elapsedTime + savedTime) - nowTime
        let hour = Int(displayTime / 3600)
        let d = (Int(displayTime) % 3600)
        let min = Int(d / 60)
        let sec = Int(d % 60)
        let hourText = String(format: "%02d", hour)
        let minText = String(format: "%02d", min)
        let secText = String(format: "%02d", sec)
        timeStr = hourText + ":" + minText + ":" + secText
//        let cellView = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "hogehogehoge"), owner: self) as! CustomCellView
        targetCellView!.time.stringValue = timeStr
        //AppDelegate.button.title = minText + ":" + secText
        
        
        
        let key = defaults.string(forKey: "startTimeOfToday")!
//        var initJSONStr = defaults.object(forKey: key) as? String
//        let data = initJSONStr!.data(using: .utf8)!
//        var data = defaults.data(forKey: key)
        var json = defaults.object(forKey: key)
//        let json = try? JSONSerialization.jsonObject(with: data!, options: [])
        if (json == nil) {
            return
        }
        
        let now = NSDate()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMddHHmmss"
        let end = dateFormatter.string(from: now as! Date)
        
        
        
        var array:Array<Dictionary<String,String>> = []
        if var checkArray = json as? Dictionary<String,Any> {
            array = checkArray["taskList"] as! Array<Dictionary<String, String>>
            array[array.count - 1]["endTime"] = end
            checkArray["taskList"] = array
//            let data2 = try? JSONSerialization.data(withJSONObject: checkArray, options: [])
//            defaults.set(data2, forKey: key)
            defaults.set(checkArray, forKey: key)
        }
        
        
        
        
//        var b = obj!["taskList"] as? [Dictionary<String, String>]
//        if (b == nil) {
//            return
//        }
//        var c = b!.last
//        c!["endTime"] = end
        
        
//        (obj["taskList"] as! NSMutableArray,(Dictionary<String, String>)).append(["startTime": end, "endTime": end, "taskName": "DDD"])
//
//        NSLog("hoge")
        
//        obj["taskList"] as! NSDictionary
//        defaults.set(obj, forKey: key)
        return
    }
    
    
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
    
    var doingTaskRow:Int? = nil // TODO: It stores RowNum, not ID, so when a row is added or deleted, doingTaskRow doesn't make sence. Fix it later.
    
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
            if (row == doingTaskRow) {
                cellView.time.isHidden = false
                cellView.button.isHidden = true
                targetCellView = cellView
            } else {
                cellView.time.isHidden = true
                cellView.button.isHidden = false
            }
            return cellView
        } else if (tableColumn == tableView.tableColumns[1]) {
            let cellView = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "col2"), owner: self) as! NSTableCellView
            let tasknames = defaults.object(forKey: "tasknames") as? [String]
            cellView.textField?.stringValue =  tasknames![row]
            return cellView
        } else if (tableColumn == tableView.tableColumns[2]) {
            let cellView = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "col3"), owner: self) as! DeleteButtonCellView
            cellView.button.tag = row
            if (row == doingTaskRow) {
                cellView.resetButton.isHidden = false
                cellView.button.isHidden = true
            } else {
                cellView.resetButton.isHidden = true
                cellView.button.isHidden = false
            }
            return cellView
        }
        
        
//        return programs[row]
        return nil
    }
    
    @IBAction func startTimer(_ sender: NSButtonCell) {
        NSLog("fugafuga")
        doingTaskRow = sender.tag
        tableView.reloadData()
        
        
//        if !startOrStop{
            timer?.invalidate()
            timer = nil
        now = NSDate()
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyyMMddHHmmss"
        let fmtNow = dateFormatter.string(from: now as! Date)
        
//            toggleStartOrStop()
//        }
        
        var hogef = defaults.string(forKey: "startTimeOfToday")
        if (hogef == nil) {
            hogef = fmtNow
            defaults.set(hogef, forKey: "startTimeOfToday")
        }
            
            //let ll = DayTaskData(totalTime: 0, taskList: [Task(startTime: now as! Date, endTime: now as! Date, taskName: "DDD")])
        
            
        let task = ["startTime": hogef, "endTime": hogef, "taskName": "DDD"]
        
        let hoge = defaults.object(forKey: hogef!)
        if (hoge == nil) {
            let task = ["totalTime": 0, "taskList": [task]] as [String : Any]
//            let data2 = try? JSONSerialization.data(withJSONObject: task, options: [])
//            defaults.set(data2, forKey: hogef)
            defaults.set(task, forKey: hogef!)
        } else {
            var a = hoge! as! Dictionary<String, Any>
            var b = a["taskList"] as? [Dictionary<String, String>]
            if (b == nil) {
              b = []
            }
            b!.append(["startTime": fmtNow, "endTime": fmtNow, "taskName": "DDD"])
            a["taskList"] = b
            let data2 = try? JSONSerialization.data(withJSONObject: a, options: [])
            defaults.set(a, forKey: hogef!)
//            defaults.set(data2, forKey: hogef)
        }
            
        
        
        NSLog("defaults:%@", defaults.dictionaryRepresentation())
        
        nowTime = NSDate.timeIntervalSinceReferenceDate
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
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
    
    @IBOutlet weak var time: NSTextField!
    @IBOutlet weak var button: NSButton!
    @IBOutlet weak var buttonCell: NSButtonCell!
    
}

class DeleteButtonCellView: NSTableCellView {
    
    @IBOutlet weak var resetButton: NSButton!
    @IBOutlet weak var button: NSButton!
    
}
