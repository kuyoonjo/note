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
        if settings.selected.count > 0 {
            try! settings.md.write(to: URL(fileURLWithPath: settings.filePath), atomically: true, encoding: .utf8)
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
                let p1 = "~/.notes/" + txt.stringValue + ".md"
                let p = NSString(string: p1).expandingTildeInPath
                do {
                    try txt.stringValue.write(to: URL(fileURLWithPath: p), atomically: true, encoding: .utf8)
                    settings.notes.append(txt.stringValue + ".md")
                } catch {
                    print("Failed to create")
                }
            }
        }
    }
    
    @IBAction func remove(_ sender: Any) {
        if settings.selected.count > 0 {
            let alert = NSAlert()
            alert.messageText = "Are you sure what you are doing?"
            alert.alertStyle = .critical
            alert.addButton(withTitle: "Sure")
            alert.addButton(withTitle: "Cancel")
            let response: NSApplication.ModalResponse = alert.runModal()

            if response == NSApplication.ModalResponse.alertFirstButtonReturn {
                do {
                    try FileManager.default.removeItem(atPath: settings.filePath)
                    settings.notes.removeAll { $0 == settings.selected }
                    settings.md = ""
                    settings.mdView = ""
                    settings.selected = ""
                } catch {
                    print("Failed to remove")
                }
            }
        }
    }

}

