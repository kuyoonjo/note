//
//  WebView.swift
//  Note
//
//  Created by Yu Chen on 4/4/20.
//  Copyright © 2020 Yu Chen. All rights reserved.
//

import SwiftUI
import WebKit

struct WebView: NSViewRepresentable {
    var colorScheme: ColorScheme
    @Binding var md: String

    func makeNSView(context: Context) -> MKView {
        let view = MKView(frame: .zero)
        view.navigationDelegate = view
        view.setValue(false, forKey: "drawsBackground")
        return view
    }

    func updateNSView(_ nsView: MKView, context: Context) {
//        let md = """
//## Hi Note
//
//|  表头   | 表头  |
//|  ----  | ----  |
//| 单元格  | 单元格 |
//| 单元格  | 单元格 |
//
//
//```typescript
//console.log(\"ok\");
//
//```
//"""
        let html = Markdown(colorScheme: self.colorScheme).parse(md: md)
        nsView.loadHTMLString(html, baseURL: Bundle.main.bundleURL)
    }
}
