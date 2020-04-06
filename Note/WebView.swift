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

    func makeNSView(context: Context) -> WKWebView {
        let view = WKWebView(frame: .zero)
        view.setValue(false, forKey: "drawsBackground")
        return view
    }

    func updateNSView(_ nsView: WKWebView, context: Context) {
        let html = Markdown(colorScheme: self.colorScheme).parse(md: md)
        nsView.loadHTMLString(html, baseURL: Bundle.main.bundleURL)
    }
}
