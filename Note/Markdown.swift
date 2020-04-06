//
//  Markdown.swift
//  Note
//
//  Created by Yu Chen on 4/4/20.
//  Copyright © 2020 Yu Chen. All rights reserved.
//

import SwiftUI
import Down

struct Markdown {
    var colorScheme: ColorScheme
    var highlightjs: String
    var highlightcss: String
    var dark: String
    var light: String
    
    init(colorScheme: ColorScheme) {
        self.colorScheme = colorScheme
        self.highlightjs = ""
        self.highlightcss = ""
        self.dark = ""
        self.light = ""
        if let js = Bundle.main.path(forResource: "highlight", ofType: "js") {
            let contents = try! String(contentsOfFile: js)
            self.highlightjs = "<script>" + contents + """

hljs.initHighlightingOnLoad();
""" + "</script>"
        }
        if let css = Bundle.main.path(forResource: "highlight", ofType: "css") {
            let contents = try! String(contentsOfFile: css)
            self.highlightcss = "<style>" + contents + "</style>"
        }
        if let dark = Bundle.main.path(forResource: "dark", ofType: "css") {
            let contents = try! String(contentsOfFile: dark)
            self.dark = "<style>" + contents + "</style>"
        }
        if let light = Bundle.main.path(forResource: "light", ofType: "css") {
            let contents = try! String(contentsOfFile: light)
            self.light = "<style>" + contents + "</style>"
        }
    }

    func parse(md: String) -> String {
        let down = Down(markdownString: md)
        guard var html = try? down.toHTML() else {
            return ""
        }
        
        switch colorScheme {
        case .dark:
            html = dark + highlightcss + html + highlightjs
        default:
            html = light + highlightcss + html + highlightjs
        }
        return html
    }
}
