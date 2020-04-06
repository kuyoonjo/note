//
//  UserSettings.swift
//  Note
//
//  Created by Yu Chen on 4/5/20.
//  Copyright © 2020 Yu Chen. All rights reserved.
//

import Combine
import SwiftUI

class UserSettings: ObservableObject {
    @Published var editorOn: Bool = false
    @Published var md: String = ""
    @Published var mdView: String = ""
    @Published var notes: Array<String> = []
    var selected = ""
    var filePath: String {
        get {
            let p1 = "~/.notes/" + selected
            let p = NSString(string: p1).expandingTildeInPath
            return p
        }
    }
    
    init() {
        let p = NSString("~/.notes").expandingTildeInPath
        if let arr = try? FileManager.default.contentsOfDirectory(atPath: p) {
            notes = arr
        }
    }
}
