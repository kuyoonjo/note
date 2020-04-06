//
//  AppDelegate.swift
//  Note
//
//  Created by Yu Chen on 4/3/20.
//  Copyright © 2020 Yu Chen. All rights reserved.
//

import Cocoa
import SwiftUI

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {
    @IBOutlet var mbSave: NSMenuItem!
    @IBOutlet var mbUpdate: NSMenuItem!
    @IBOutlet var mbRemove: NSMenuItem!
    @IBOutlet var mbOrderUp: NSMenuItem!
    @IBOutlet var mbOrderDown: NSMenuItem!
    @IBOutlet var mbOrderTop: NSMenuItem!
    @IBOutlet var mbOrderBottom: NSMenuItem!
    @IBOutlet var mbRevealInFinder: NSMenuItem!

    var window: NSWindow!
    var settings = UserSettings()

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        NSWindow.allowsAutomaticWindowTabbing = false
        // Create the SwiftUI view that provides the window contents.
        let contentView = ContentView()

        // Create the window and set the content view. 
        window = NSWindow(
            contentRect: NSRect(x: 0, y: 0, width: 480, height: 300),
            styleMask: [.titled, .closable, .miniaturizable, .resizable, .fullSizeContentView],
            backing: .buffered, defer: false)
        window.center()
        window.setFrameAutosaveName("Main Window")
        window.contentView = NSHostingView(rootView: contentView.environmentObject(settings))
        window.makeKeyAndOrderFront(nil)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }

    
    @IBAction func toggleEditor(_ sender: Any) {
        let item = sender as! NSMenuItem
        if item.state == .on {
            item.state = .off
            settings.editorOn = false;
        } else {
            item.state = .on
            settings.editorOn = true;
        }
    }
    
    @IBAction func save(_ sender: Any) {
        if settings.selected != nil {
            do {
                try settings.saveNote()
            } catch {
                print("Failed to save note")
            }
        }
    }
    
    @IBAction func new(_ sender: Any) {
        let alert = NSAlert()
        alert.messageText = "Note Name"
        alert.alertStyle = .informational
        alert.addButton(withTitle: "OK")
        alert.addButton(withTitle: "Cancel")
        let txt = NSTextField(frame: NSRect(x: 0, y: 0, width: 200, height: 24))
        txt.stringValue = ""
        alert.accessoryView = txt
        let response: NSApplication.ModalResponse = alert.runModal()

        if response == NSApplication.ModalResponse.alertFirstButtonReturn {
            if txt.stringValue.count > 0 {
                do {
                    try settings.createNote(name: txt.stringValue)
                } catch {
                    print("Failed to create note")
                }
            }
        }
    }
    
    @IBAction func update(_ sender: Any) {
        let alert = NSAlert()
        alert.messageText = "Note Name"
        alert.alertStyle = .informational
        alert.addButton(withTitle: "OK")
        alert.addButton(withTitle: "Cancel")
        let txt = NSTextField(frame: NSRect(x: 0, y: 0, width: 200, height: 24))
        txt.stringValue = settings.notes[settings.selected!].name
        alert.accessoryView = txt
        let response: NSApplication.ModalResponse = alert.runModal()

        if response == NSApplication.ModalResponse.alertFirstButtonReturn {
            if txt.stringValue.count > 0 {
                do {
                    try settings.updateNote(name: txt.stringValue)
                } catch {
                    print("Failed to update note")
                }
            }
        }
    }
    
    @IBAction func remove(_ sender: Any) {
        if settings.selected != nil {
            let alert = NSAlert()
            alert.messageText = "Are you sure what you are doing?"
            alert.alertStyle = .critical
            alert.addButton(withTitle: "Sure")
            alert.addButton(withTitle: "Cancel")
            let response: NSApplication.ModalResponse = alert.runModal()

            if response == NSApplication.ModalResponse.alertFirstButtonReturn {
                do {
                    try settings.removeNote()
                } catch {
                    print("Failed to remove note")
                }
            }
        }
    }
    
    @IBAction func orderTop(_ sender: Any) {
        if settings.selected != nil {
            do {
                try settings.orderTop()
            } catch {
                print("Failed to order top")
            }
        }
    }
    
    @IBAction func orderUp(_ sender: Any) {
        if settings.selected != nil {
            do {
                try settings.orderUp()
            } catch {
                print("Failed to order up")
            }
        }
    }
    
    @IBAction func orderBottom(_ sender: Any) {
        if settings.selected != nil {
            do {
                try settings.orderBottom()
            } catch {
                print("Failed to order bottom")
            }
        }
    }
    
    @IBAction func orderDown(_ sender: Any) {
        if settings.selected != nil {
            do {
                try settings.orderDown()
            } catch {
                print("Failed to order down")
            }
        }
    }
    
    @IBAction func revealInFinder(_ sender: Any) {
        if settings.selected != nil {
            NSWorkspace.shared.activateFileViewerSelecting([URL(fileURLWithPath: settings.currentNotePath)])
        }
    }
    
    @IBAction func openInITerm(_ sender: Any) {
        if let script = Bundle.main.path(forResource: "iTerm", ofType: "scpt") {
            let task = Process()
            task.launchPath = "/usr/bin/osascript"
            task.arguments = [script, "cd", NSString(string: Constants.root).expandingTildeInPath]
            task.launch()
        }
    }

}

