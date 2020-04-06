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
    
    init(colorScheme: ColorScheme) {
        self.colorScheme = colorScheme
        self.highlightjs = ""
        self.highlightcss = ""
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
    }

    func parse(md: String) -> String {
        let down = Down(markdownString: md)
        guard var html = try? down.toHTML() else {
            return ""
        }
        
        switch colorScheme {
        case .dark:
            html = MdTheme.Dark.rawValue + highlightcss + html + highlightjs
        default:
            html = MdTheme.Light.rawValue + highlightcss + html + highlightjs
        }
        return html
    }
}
