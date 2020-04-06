//
//  UserSettings.swift
//  Note
//
//  Created by Yu Chen on 4/5/20.
//  Copyright © 2020 Yu Chen. All rights reserved.
//

import Combine
import SwiftUI

struct Note {
    var name: String
    var changed: Bool
}

enum USError: Error {
    case NoSelection
}

class UserSettings: ObservableObject {
    @Published var editorOn: Bool = false
    @Published var md: String = ""
    @Published var mdView: String = ""
    @Published var notes: Array<Note> = []
    
    var selected: Int? {
        didSet {
            if selected != nil && selected != oldValue {
                try! select(i: selected!)
            }
        }
    }

    let listFilePath = NSString(string: Constants.root + "/" + Constants.listFile).expandingTildeInPath

    var currentNotePath: String {
        get {
            return NSString(string: Constants.root + "/" + notes[selected!].name + Constants.noteExt).expandingTildeInPath
        }
    }
    
    init() {
        let root = NSString(string: Constants.root).expandingTildeInPath
        let exists = FileManager.default.fileExists(atPath: root)
        if(!exists) {
            do {
                print("mkdir \(root)")
                try FileManager.default.createDirectory(atPath: root, withIntermediateDirectories: true)
            } catch {
                print("Failed to mkdir")
            }
            
        }
        if let str = try? String(contentsOfFile: listFilePath) {
            notes = str.components(separatedBy: "\n")
                .filter({ $0.count > 0 })
                .map({ Note(name: $0, changed: false) })
        } else {
            do {
                try saveList()
            } catch {
                print("failed to init")
            }
        }
    }
    
    func saveList() throws {
        let str = notes.map({ $0.name }).joined(separator: "\n")
        print(listFilePath)
        try str.write(toFile: listFilePath, atomically: true, encoding: .utf8)
    }
    
    func createNote(name: String) throws {
        let p1 = Constants.root + "/" + name + Constants.noteExt
        let p = NSString(string: p1).expandingTildeInPath
        try name.write(to: URL(fileURLWithPath: p), atomically: true, encoding: .utf8)
        notes.insert(Note(name: name, changed: false), at: 0)
        try saveList()
        try select(i: 0)
    }
    
    func removeNote() throws {
        if selected == nil {
            throw USError.NoSelection
        }
        try FileManager.default.removeItem(atPath: currentNotePath)
        notes.removeAll { $0.name == notes[selected!].name }
        try saveList()
        if notes.count > 0 {
            try select(i: 0)
        } else {
            md = ""
            mdView = ""
            selected = -1
        }
    }
    
    func updateNote(name: String) throws {
        if selected == nil {
            throw USError.NoSelection
        }
        let originalPath = currentNotePath
        notes[selected!].name = name
        try saveList()
        try FileManager.default.moveItem(atPath: originalPath, toPath: currentNotePath)
    }
    
    func saveNote() throws {
        if selected == nil {
            throw USError.NoSelection
        }
        try md.write(toFile: currentNotePath, atomically: true, encoding: .utf8)
        notes[selected!].changed = false
    }
    
    func select(i: Int) throws {
        selected = i
        let str = try String(contentsOfFile: currentNotePath, encoding: String.Encoding.utf8)
        md = str
        mdView = str
    }
    
    func orderUp() throws {
        if let i = selected {
            if i > 0 {
                let note = notes[i]
                notes[i] = notes[i - 1]
                notes[i - 1] = note
                try saveList()
                selected = i - 1
            }
        }
    }
    
    func orderDown() throws {
        if let i = selected {
            if i >= 0 && i < notes.count - 1 {
                let note = notes[i]
                notes[i] = notes[i + 1]
                notes[i + 1] = note
                try saveList()
                selected = i + 1
            }
        }
    }
    
    func orderTop() throws {
        if let i = selected {
            if i > 0 {
                let note = notes[i]
                notes.removeAll { $0.name == note.name }
                notes.insert(note, at: 0)
                try saveList()
                selected = 0
            }
        }
    }
    
    func orderBottom() throws {
        if let i = selected {
            if i >= 0 && i < notes.count - 1 {
                let note = notes[i]
                notes.removeAll { $0.name == note.name }
                notes.append(note)
                try saveList()
                selected = notes.count - 1
            }
        }
    }
    
    func emitChanged() {
        if let i = selected {
            notes[i].changed = true
        }
    }
}
