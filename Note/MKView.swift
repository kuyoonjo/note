//
//  MKView.swift
//  Note
//
//  Created by Yu Chen on 4/5/20.
//  Copyright © 2020 Yu Chen. All rights reserved.
//

import WebKit

class MKView: WKWebView, WKNavigationDelegate {
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {

    }
    
    func webView(_ webView: WKWebView,
                 didStartProvisionalNavigation navigation: WKNavigation!) {
    }
}
