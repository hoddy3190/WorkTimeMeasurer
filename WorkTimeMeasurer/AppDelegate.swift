//
//  AppDelegate.swift
//  WorkTimeMeasurer
//
//  Created by Hodaka Suzuki on 2020/03/25.
//  Copyright © 2020 Hodaka Suzuki. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var menu: NSMenu!
    let statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    var button: NSStatusBarButton!
    
    let popover = NSPopover()
    var eventMonitor: EventMonitor?
    
    var nowTime: Double = Double()
    var elapsedTime: Double = Double()
    var displayTime: Double = Double()
    var savedTime: Double = Double()
    var startOrStop: Bool = false
    var timer: Timer = Timer()
    
    
    

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        //statusItem.menu = menu
        button = statusItem.button!
        button.title = "WT Measurer"
        button.image = NSImage(named: "icon")
        button.action = #selector(togglePopover(_:))
        
        let mainViewController = NSStoryboard(name: "Main", bundle: nil).instantiateController(withIdentifier: "SecondViewController") as! ViewController
        
        popover.contentViewController = mainViewController
        
        eventMonitor = EventMonitor(mask: [NSEvent.EventTypeMask.leftMouseDown, NSEvent.EventTypeMask.rightMouseDown]) { [weak self] event in
            if let popover = self?.popover {
                if popover.isShown {
                    self?.closePopover(event)
                }
            }
        }
        eventMonitor?.start()
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    @IBAction func startTimer(_ sender: Any) {
        if !startOrStop{
            nowTime = NSDate.timeIntervalSinceReferenceDate
            Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
            toggleStartOrStop()
        }
    }
    
    func toggleStartOrStop() {
        startOrStop = !startOrStop
    }
    
    @objc func updateTime() {
        elapsedTime = NSDate.timeIntervalSinceReferenceDate
        displayTime = (elapsedTime + savedTime) - nowTime
        let min = Int(displayTime / 60)
        let sec = Int(floor(displayTime)) % 60
        let minText = String(format: "%02d", min)
        let secText = String(format: "%02d", sec)
        button.title = minText + ":" + secText
    }
    
    
    @objc func togglePopover(_ sender: AnyObject?) {
        if popover.isShown {
            closePopover(sender)
        } else {
            showPopover(sender)
        }
    }
    
    func showPopover(_ sender: AnyObject?) {
        if let button = statusItem.button {
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
            eventMonitor?.start()
        }
    }
    
    func closePopover(_ sender: AnyObject?) {
        popover.performClose(sender)
        eventMonitor?.stop()
    }
}

